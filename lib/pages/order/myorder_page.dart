import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:dotted_line/dotted_line.dart';

import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';

import '../models/myorder_page_model.dart';
import '../rating/add_rating_page.dart';
import 'cancel_booking_page.dart';
import 'order_preview_page.dart';

class MyorderPage extends StatefulWidget {
  @override
  _MyorderPageState createState() => _MyorderPageState();
}

class _MyorderPageState extends State<MyorderPage>
    with SingleTickerProviderStateMixin {
  final NamFoodApiService apiService = NamFoodApiService();

  @override
  void initState() {
    super.initState();

    getmyorderpage();
  }

  //Myorder
  List<MyOrders> myorderpage = [];
  List<MyOrders> myorderpageAll = [];
  bool isLoading = false;

  Future getmyorderpage() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getmyorderpage();
      var response = myorderpageFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          myorderpage = response.list;
          myorderpageAll = myorderpage;
          isLoading = false;
        });
      } else {
        setState(() {
          myorderpage = [];
          myorderpageAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        myorderpage = [];
        myorderpageAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  late TabController _tabController;
  int _expandedIndex = -1;
  int all_expandedIndex = -1;

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 3, vsync: this);
  // }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> orders = [
    {'id': '0012345', 'items': 12, 'status': 'On Delivery'},
    {'id': '0012345', 'items': 12, 'status': 'Completed'},
    {'id': '0012345', 'items': 12, 'status': 'Cancelled'},
    {'id': '0012345', 'items': 12, 'status': 'On Delivery'},
  ];

  Widget getStatusIcon(String status) {
    switch (status) {
      case 'On Delivery':
        return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightred,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 32,
              color: AppColors.red,
            ));

      case 'Completed':
        return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightred,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 32,
              color: AppColors.red,
            ));
      case 'Cancelled':
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightred,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 32,
            color: AppColors.red,
          ),
        );
      default:
        return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightred,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 32,
              color: AppColors.red,
            ));
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'On Delivery':
        return Colors.yellow.shade900;
      case 'Completed':
        return Colors.white;
      case 'Cancelled':
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  Color circleColor(String status) {
    switch (status) {
      case 'On Delivery':
        return AppColors.darkGreen;
      case 'Completed':
        return AppColors.red;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.lightGrey3,
        title: Text(
          'My Order',
          style: TextStyle(
            color: AppColors.n_black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: screenHeight * 0),
            child: CustomeTextField(
                borderColor: AppColors.grey1,
                width: screenWidth,
                hint: 'Search Beverage or Foods',
                hintColor: AppColors.grey,
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: AppColors.grey,
                )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: myorderpage.length,
              itemBuilder: (context, index) {
                // final order = orders[index];
                final e = myorderpage[index];

                final status = e.orderstatus as String;
                final color = getStatusColor(status);
                final icon = getStatusIcon(status);
                final circlecolor = circleColor(status);

                if (status == 'On Delivery')
                  return Container(
                      margin: EdgeInsets.all(0),
                      child: Column(children: [
                        ListTile(
                          leading: getStatusIcon(status),
                          title: HeadingWidget(
                              title: 'Order ID#${e.orderid.toString()}'
                              // 'Order ID#${order['id']}'

                              ),
                          subtitle: Row(
                            children: [
                              SubHeadingWidget(
                                title: '${e.items} Items',
                                // '${order['items']} Items',

                                color: AppColors.n_black,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.circle,
                                size: 11,
                                color: circlecolor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SubHeadingWidget(
                                title: e.orderstatus,
                                color: AppColors.n_black,
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              all_expandedIndex == index
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                            onPressed: () {
                              setState(() {
                                all_expandedIndex =
                                    all_expandedIndex == index ? -1 : index;
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              all_expandedIndex =
                                  all_expandedIndex == index ? -1 : index;
                            });
                          },
                        ),
                        if (all_expandedIndex == index)
                          ...e.orderdetails.map((order) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: AppColors.blue,
                                                    width: 3,
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: AppColors.blue,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                              const DottedLine(
                                                direction: Axis.vertical,
                                                dashColor: AppColors.blue,
                                                lineLength: 50,
                                                dashLength: 2,
                                                dashGapLength: 2,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Order Placed',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                order.OrderPlacedTime
                                                    .toString(),
                                                style: TextStyle(
                                                    color: AppColors.n_black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: AppColors.blue,
                                                    width: 3,
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: AppColors.blue,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                              const DottedLine(
                                                direction: Axis.vertical,
                                                dashColor: AppColors.blue,
                                                lineLength: 50,
                                                dashLength: 2,
                                                dashGapLength: 2,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Order Confirmed',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                order.OrderConfirmedTime
                                                    .toString(),
                                                style: TextStyle(
                                                    color: AppColors.n_black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color: AppColors.bluetone,
                                                size: 18,
                                              ),
                                              const DottedLine(
                                                direction: Axis.vertical,
                                                dashColor: AppColors.blue,
                                                lineLength: 50,
                                                dashLength: 2,
                                                dashGapLength: 2,
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Preparing',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                order.PreparingTime.toString(),
                                                style: TextStyle(
                                                    color: AppColors.n_black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: AppColors.bluetone,
                                            size: 18,
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Your Order On Delivery',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                order.DeliveryTime.toString(),
                                                style: TextStyle(
                                                    color: AppColors.n_black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 18),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderPreviewPage(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'View More',
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: AppColors.black),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CancelBookingPage(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Order Cancel',
                                            style: TextStyle(
                                                color: AppColors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: AppColors.red),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        Divider(
                          color: AppColors.grey1,
                        ),
                      ]));
                else
                  return Container(
                      margin: EdgeInsets.all(0),
                      child: Column(children: [
                        ListTile(
                          leading: getStatusIcon(status),
                          title: HeadingWidget(
                              title: 'Order ID#${e.orderid.toString()}'),
                          subtitle: Row(
                            children: [
                              SubHeadingWidget(
                                title: '20-Oct-2024',
                                color: AppColors.n_black,
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.circle,
                                  size: 11, color: circleColor(status)),
                              SizedBox(width: 5),
                              SubHeadingWidget(
                                title: status,
                                color: AppColors.n_black,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 18),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.n_black,
                                            width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderPreviewPage(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'View More',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.n_black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  )),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddRatingPage(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.red, width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                        'Rate your order',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.red,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Divider(
                          color: AppColors.grey1,
                        ),
                      ]));
              },
            ),
          ),
        ],
      ),
    );
  }
}

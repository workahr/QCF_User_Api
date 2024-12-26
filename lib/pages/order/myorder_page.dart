import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';

import '../models/myorder_page_model.dart';
import '../rating/add_rating_page.dart';
import 'cancel_booking_page.dart';
import 'cancel_order_preview_page.dart';
import 'order_list_model.dart';
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
  List<OrderListData> myorderpage = [];
  List<OrderListData> myorderpageAll = [];
  bool isLoading = false;

  Future getmyorderpage() async {
    await apiService.getBearerToken();
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getMyOrderList();
      var response = orderListModelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        print(result);
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
        // showInSnackBar(context, response.message.toString());
        print(response.message.toString());
      }
    } catch (e) {
      setState(() {
        myorderpage = [];
        myorderpageAll = [];
        isLoading = false;
      });
      // showInSnackBar(context, 'Error occurred: $e');
      print('Error occurred: $e');
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
      case 'Order Placed':
        return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 240, 248, 240),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 32,
              color: AppColors.darkGreen,
            ));

      case 'Order Confirmed':
        return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 244, 251),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 32,
              color: Colors.blue,
            ));
      case 'Cancelled':
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 250, 239, 240),
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
      case 'Order Placed':
        return Colors.lightGreen;
      case 'Order Confirmed':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13), // Add border radius
              child: Container(
                width: double.infinity,
                height: 113,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
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
      body: isLoading
          ? ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                return _buildShimmerPlaceholder();
              },
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0),
                  child: CustomeTextField(
                    borderColor: AppColors.grey1,
                    width: screenWidth,
                    hint: 'Search Beverage or Foods',
                    hintColor: AppColors.grey,
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: AppColors.grey,
                    ),
                    onChanged: (value) {
                      if (value != '') {
                        print('value $value');
                        value = value.toString().toLowerCase();
                        myorderpage = myorderpageAll!
                            .where((OrderListData e) => e.invoiceNumber
                                .toString()
                                .toLowerCase()
                                .contains(value))
                            .toList();
                      } else {
                        myorderpage = myorderpageAll;
                      }
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: myorderpage.length,
                    itemBuilder: (context, index) {
                      // final order = orders[index];
                      final e = myorderpage[index];

                      final status = e.orderStatus as String;
                      final color = getStatusColor(status);
                      final icon = getStatusIcon(status);
                      final circlecolor = circleColor(status);
                      String formattedDate = DateFormat('dd-MMM-yyyy')
                          .format(DateTime.parse(e.createdDate.toString()));

                      if (status == 'Order Placed' ||
                          // status == 'Order Picked' ||
                          status == 'Order Confirmed' ||
                          status == 'Ready to Pickup')
                        return Container(
                            margin: EdgeInsets.all(0),
                            child: Column(children: [
                              ListTile(
                                leading: getStatusIcon(status),
                                title: HeadingWidget(
                                    title:
                                        'Order ID#${e.invoiceNumber.toString()}'
                                    // 'Order ID#${order['id']}'

                                    ),
                                subtitle: Column(children: [
                                  Row(
                                    children: [
                                      SubHeadingWidget(
                                        title:
                                            '${e.totalProduct.toString()} Items',
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
                                        title: e.orderStatus,
                                        color: AppColors.n_black,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SubHeadingWidget(
                                        title: "Date : ",
                                        color: AppColors.n_black,
                                      ),
                                      SubHeadingWidget(
                                        title: formattedDate,
                                        color: AppColors.n_black,
                                      ),
                                    ],
                                  )
                                ]),
                                trailing: IconButton(
                                  icon: Icon(
                                    all_expandedIndex == index
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      all_expandedIndex =
                                          all_expandedIndex == index
                                              ? -1
                                              : index;
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
                                Column(
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
                                                  // Text(
                                                  //   order.OrderPlacedTime
                                                  //       .toString(),
                                                  //   style: TextStyle(
                                                  //       color: AppColors.n_black),
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          status == 'Order Confirmed' ||
                                                  status == 'Ready to Pickup'
                                              ? Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: AppColors
                                                                  .blue,
                                                              width: 3,
                                                            ),
                                                          ),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.circle,
                                                              color: AppColors
                                                                  .blue,
                                                              size: 12,
                                                            ),
                                                          ),
                                                        ),
                                                        const DottedLine(
                                                          direction:
                                                              Axis.vertical,
                                                          dashColor:
                                                              AppColors.blue,
                                                          lineLength: 50,
                                                          dashLength: 2,
                                                          dashGapLength: 2,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Order Confirmed',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        // Text(
                                                        //   e.OrderConfirmedTime
                                                        //       .toString(),
                                                        //   style: TextStyle(
                                                        //       color: AppColors.n_black),
                                                        // ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          color: AppColors
                                                              .bluetone,
                                                          size: 18,
                                                        ),
                                                        const DottedLine(
                                                          direction:
                                                              Axis.vertical,
                                                          dashColor:
                                                              AppColors.blue,
                                                          lineLength: 50,
                                                          dashLength: 2,
                                                          dashGapLength: 2,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Order Confirmed',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        // Text(
                                                        //   e.OrderConfirmedTime
                                                        //       .toString(),
                                                        //   style: TextStyle(
                                                        //       color: AppColors.n_black),
                                                        // ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                          status != 'Ready to Pickup'
                                              ? Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          color: AppColors
                                                              .bluetone,
                                                          size: 18,
                                                        ),
                                                        const DottedLine(
                                                          direction:
                                                              Axis.vertical,
                                                          dashColor:
                                                              AppColors.blue,
                                                          lineLength: 50,
                                                          dashLength: 2,
                                                          dashGapLength: 2,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(width: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Preparing',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        if (e.prepareMin != 0)
                                                          Text(
                                                            "${e.prepareMin.toString()} Mins",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .n_black),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: AppColors
                                                                  .blue,
                                                              width: 3,
                                                            ),
                                                          ),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.circle,
                                                              color: AppColors
                                                                  .blue,
                                                              size: 12,
                                                            ),
                                                          ),
                                                        ),
                                                        const DottedLine(
                                                          direction:
                                                              Axis.vertical,
                                                          dashColor:
                                                              AppColors.blue,
                                                          lineLength: 50,
                                                          dashLength: 2,
                                                          dashGapLength: 2,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(width: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Preparing',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        if (e.prepareMin != 0)
                                                          Text(
                                                            "${e.prepareMin.toString()} Mins",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .n_black),
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
                                                  // Text(
                                                  //   e.prepareMin.toString(),
                                                  //   style: TextStyle(
                                                  //       color: AppColors.n_black),
                                                  // ),
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
                                                        OrderPreviewPage(
                                                            orderid: e.id),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'View More',
                                                style: TextStyle(
                                                    color: AppColors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                          if (status == 'Order Placed')
                                            Expanded(
                                              flex: 2,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CancelBookingPage(
                                                                cancelId: e.id,
                                                              ))).then(
                                                      (value) {});
                                                },
                                                child: Text(
                                                  'Order Cancel',
                                                  style: TextStyle(
                                                      color: AppColors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: AppColors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                      title:
                                          'Order ID#${e.invoiceNumber.toString()}'),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SubHeadingWidget(
                                            title:
                                                '${e.totalProduct.toString()} Items',
                                            color: AppColors.n_black,
                                          ),
                                          SizedBox(width: 10),
                                          e.orderStatus == "Cancelled"
                                              ? Icon(
                                                  Icons.circle,
                                                  size: 11,
                                                  color: circlecolor,
                                                )
                                              : Icon(
                                                  Icons.circle,
                                                  size: 11,
                                                  color: circlecolor,
                                                ),
                                          SizedBox(width: 5),
                                          SubHeadingWidget(
                                            title: status,
                                            color: AppColors.n_black,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SubHeadingWidget(
                                            title: "Date : ",
                                            color: AppColors.n_black,
                                          ),
                                          SubHeadingWidget(
                                            title: formattedDate,
                                            color: AppColors.n_black,
                                          ),
                                        ],
                                      ),
                                      if (status != 'Cancelled')
                                        Row(
                                          children: [
                                            SubHeadingWidget(
                                              title: "Delivery Code : ",
                                              color: AppColors.n_black,
                                            ),
                                            SubHeadingWidget(
                                              title: e.customer_code == null
                                                  ? ''
                                                  : e.customer_code,
                                              color: AppColors.n_black,
                                            ),
                                          ],
                                        )
                                    ],
                                  )),
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
                                                          OrderPreviewPage(
                                                              orderid: e.id),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'View More',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors.n_black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ),
                                        )),
                                    // SizedBox(
                                    //   width: 8,
                                    // ),
                                    // Expanded(
                                    //     flex: 2,
                                    //     child: GestureDetector(
                                    //       onTap: () {
                                    //         Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //             builder: (context) => AddRatingPage(),
                                    //           ),
                                    //         );
                                    //       },
                                    //       child: Container(
                                    //         height: 35,
                                    //         decoration: BoxDecoration(
                                    //             border: Border.all(
                                    //                 color: AppColors.red, width: 1.5),
                                    //             borderRadius:
                                    //                 BorderRadius.circular(10)),
                                    //         child: Center(
                                    //             child: Text(
                                    //           'Rate your order',
                                    //           style: TextStyle(
                                    //               fontSize: 14,
                                    //               color: AppColors.red,
                                    //               fontWeight: FontWeight.bold),
                                    //         )),
                                    //       ),
                                    //     )),
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

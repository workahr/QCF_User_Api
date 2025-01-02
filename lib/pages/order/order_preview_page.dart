import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:namfood/widgets/heading_widget.dart';
import 'package:namfood/widgets/sub_heading_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../models/order_preview_model.dart';
import 'order_preview_model.dart';

class OrderPreviewPage extends StatefulWidget {
  int? orderid;
  OrderPreviewPage({super.key, this.orderid});

  @override
  _OrderPreviewPageState createState() => _OrderPreviewPageState();
}

class _OrderPreviewPageState extends State<OrderPreviewPage> {
  final NamFoodApiService apiService = NamFoodApiService();

  @override
  void initState() {
    super.initState();

    getOrderPreviewlist();
    print(widget.orderid);
  }

  List<Item> orderPreviewList = [];
  List<Address> addressList = [];
  List<Item> orderPreviewListAll = [];
  ListClass? orderDetailsList;
  StoreAddress? storeAddress;
  Address? customerAddress;
  Customer? CustomerDetails;

  bool isLoading = false;

  Future getOrderPreviewlist() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getstoredetailbyidList(widget.orderid);
      print("API Response: $result");

      var response = orderPreviewmodelFromJson(result);

      print("hi");
      if (response.status?.toUpperCase() == 'SUCCESS') {
        setState(() {
          orderDetailsList = response.list;
          print(response.list);
          orderPreviewList = response.items ?? [];
          orderPreviewListAll = orderPreviewList;
          storeAddress = response.storeAddress;
          customerAddress = (response.address?.isNotEmpty ?? false)
              ? response.address![0]
              : null;
          CustomerDetails = response.customer;
          isLoading = false;
        });
      } else {
        setState(() {
          orderDetailsList = null;
          orderPreviewList = [];
          addressList = [];
          orderPreviewListAll = [];
          storeAddress = null;
          customerAddress = null;
          CustomerDetails = null;
          isLoading = false;
        });
        print("Error: ${response.message}");
      }
    } catch (e) {
      setState(() {
        orderDetailsList = null;
        orderPreviewList = [];
        addressList = [];
        orderPreviewListAll = [];
        storeAddress = null;
        customerAddress = null;
        CustomerDetails = null;
        isLoading = false;
      });
      print('Error occurred: $e');
      showInSnackBar(context, 'Error occurred: $e');
    }
  }

  String dateFormat(dynamic date) {
    try {
      DateTime dateTime = date is DateTime ? date : DateTime.parse(date);
      String formattedTime =
          DateFormat('h:mm a').format(dateTime).toLowerCase();
      String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime);
      return "$formattedTime | $formattedDate";
    } catch (e) {
      return "Invalid date";
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
    }
  }

  Widget _buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            ClipRRect(
                borderRadius: BorderRadius.circular(13), // Add border radius
                child: Container(
                  width: double.infinity,
                  height: 106,
                  color: Colors.white,
                )),
            SizedBox(height: 26),
            ClipRRect(
                borderRadius: BorderRadius.circular(13), // Add border radius
                child: Container(
                  width: double.infinity,
                  height: 246,
                  color: Colors.white,
                )),
            SizedBox(height: 46),
            ClipRRect(
                borderRadius: BorderRadius.circular(13), // Add border radius
                child: Container(
                  width: double.infinity,
                  height: 216,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey3,
        elevation: 0,
        title: HeadingWidget(
          title: "Back",
        ),
      ),
      body: isLoading
          ? ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                return _buildShimmerPlaceholder();
              },
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeadingWidget(
                            title: storeAddress?.name ?? 'Default Store Name',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          GestureDetector(
                              onTap: () async {
                                _makePhoneCall("9361616063");
                              },
                              child: Image.asset(
                                AppAssets.call_icon,
                                width: 30,
                                height: 30,
                                // color: AppColors.red,
                              )),
                        ]),
                    if (orderDetailsList != null) ...[
                      Row(
                        children: [
                          SubHeadingWidget(
                            title: "Order Id #",
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                          SubHeadingWidget(
                            title: orderDetailsList!.id ?? "Unknown",
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SubHeadingWidget(
                            title:
                                "${orderDetailsList!.totalProduct} ${orderDetailsList!.totalProduct! > 1 ? 'items' : 'item'}",
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          SubHeadingWidget(
                            title: " | ",
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          SubHeadingWidget(
                            title: dateFormat(orderDetailsList!.createdDate),
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 8),
                    Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orderPreviewList.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                          itemBuilder: (context, index) {
                            final item = orderPreviewList[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  item.imageUrl == null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.asset(
                                              AppAssets.storeBiriyaniImg,
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover, errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                AppConstants.imgBaseUrl +
                                                    item.imageUrl.toString(),
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            AppConstants.imgBaseUrl +
                                                item.imageUrl.toString(),
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // const SizedBox(height: 5),
                                              Flexible(
                                                child: HeadingWidget(
                                                  title: item.productName![0]
                                                          .toUpperCase() +
                                                      item.productName!
                                                          .substring(1),
                                                  //item.productName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // HeadingWidget(
                                              //   title: "₹${item.totalPrice}",
                                              // )
                                            ]),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SubHeadingWidget(
                                                    title: item.quantity,
                                                    color: AppColors.black,
                                                  ),
                                                  SubHeadingWidget(
                                                    title: " x ",
                                                    color: AppColors.black,
                                                  ),
                                                  SubHeadingWidget(
                                                    title: "₹${item.price}",
                                                    color: AppColors.black,
                                                  )
                                                ]),
                                            HeadingWidget(
                                              title: "₹${item.totalPrice}",
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                    SizedBox(height: 20),
                    HeadingWidget(
                      title: "Bill Details",
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 5),

                    //Bill container details
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Item total",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  orderDetailsList?.totalPrice == null
                                      ? ''
                                      : "₹${(double.tryParse(orderDetailsList?.totalPrice?.toString() ?? "0") ?? 0) - (double.tryParse(orderDetailsList?.deliveryCharges?.toString() ?? "0") ?? 0)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                )
                              ]),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery Fee ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  orderDetailsList?.deliveryCharges == null
                                      ? ''
                                      : "₹${orderDetailsList?.deliveryCharges?.toString() ?? '0'}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                )
                              ]),
                          Divider(color: Colors.grey[300]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Platform fee",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "₹0.00",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       "GST & Restaurant Charges",
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.normal,
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //     Text(
                          //       "₹0.00",
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.normal,
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Divider(color: Colors.grey[300]),
                          BillRow(
                            label: "Total Amount",
                            value: orderDetailsList?.totalPrice == null
                                ? '0'
                                : "₹${orderDetailsList?.totalPrice?.toString() ?? '0'}",
                            isTotal: true,
                          ),
                          Divider(color: Colors.grey[300]),
                          BillRow(
                            label: "Payment Method",
                            value: orderDetailsList?.paymentMethod == null
                                ? ''
                                : orderDetailsList?.paymentMethod?.toString() ==
                                        "Cash"
                                    ? " Cash On Delivery"
                                    : "Online Payment",
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    HeadingWidget(
                      title: "Address",
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.all(16.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   width: 100.0,
                          //   padding: EdgeInsets.all(8.0),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //         color: AppColors.red,
                          //       ),
                          //       borderRadius: BorderRadius.circular(10.0),
                          //       color: AppColors.light),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         AppAssets.cart_home_icon,
                          //         height: 18,
                          //         width: 18,
                          //         color: AppColors.red,
                          //       ),
                          //       SizedBox(width: 8),
                          //       // Text(
                          //       //   "Home",
                          //       //   style: TextStyle(
                          //       //       fontWeight: FontWeight.bold,
                          //       //       color: AppColors.red),
                          //       // ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(height: 8),
                          Text(
                              "${customerAddress!.address},${customerAddress!.city},${customerAddress!.state},"
                              //"No 37 Paranjothi Nagar Thylakoid, velour Nagar\nTrichy-620005",
                              ),
                          SizedBox(height: 8),
                          Text("${customerAddress!.pincode}"
                              //  "No 37 Paranjothi Nagar Thylakoid, velour Nagar\nTrichy-620005",
                              ),
                          SizedBox(height: 8),
                          Text("Contact : ${CustomerDetails!.mobile.toString()}"
                              // "Contact : 1234567890"
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  const BillRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

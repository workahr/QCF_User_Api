import 'package:flutter/material.dart';
import 'package:namfood/widgets/heading_widget.dart';
import 'package:namfood/widgets/sub_heading_widget.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../models/order_preview_model.dart';

class OrderPreviewPage extends StatefulWidget {
  const OrderPreviewPage({super.key});

  @override
  _OrderPreviewPageState createState() => _OrderPreviewPageState();
}

class _OrderPreviewPageState extends State<OrderPreviewPage> {
  final NamFoodApiService apiService = NamFoodApiService();

  @override
  void initState() {
    super.initState();

    getOrderPreviewlist();
  }

  List<OrderPreviewList> orderPreviewList = [];
  List<OrderPreviewList> orderPreviewListAll = [];
  bool isLoading = false;
  double totalDiscountPrice = 0.0;

  Future getOrderPreviewlist() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getOrderPreviewlist();
      var response = OrderPreviewmodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          orderPreviewList = response.list;
          orderPreviewListAll = orderPreviewList;
          isLoading = false;
          calculateTotalDiscount();
        });
      } else {
        setState(() {
          orderPreviewList = [];
          orderPreviewListAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        orderPreviewList = [];
        orderPreviewListAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  void calculateTotalDiscount() {
    totalDiscountPrice = orderPreviewList.fold(
      0.0,
      (sum, item) => sum + (double.parse(item.discountprice.toString()) ?? 0.0),
    );

    setState(() {
      totalDiscountPrice = double.parse(totalDiscountPrice.toStringAsFixed(2));
    });
  }

  final List<Map<String, dynamic>> items = [
    {
      "name": "Chicken Biryani",
      "type": "Non-Veg",
      "quantity": "5",
      "price": "₹50.00",
      "image": AppAssets.cartBiriyani
    },
    {
      "name": "Chicken Biryani",
      "type": "Non-Veg",
      "quantity": "5",
      "price": "₹50.00",
      "image": AppAssets.cartBiriyani
    },
  ];

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingWidget(
                title: 'Grill Chicken Arabian Restaurant',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              //SizedBox(height: 2),
              Row(
                children: [
                  SubHeadingWidget(
                    title: "Order Id #",
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                  SubHeadingWidget(
                    title: "233352633356",
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ],
              ),
              // SizedBox(height: 2),
              Row(
                children: [
                  SubHeadingWidget(
                    title: "12.30",
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  SubHeadingWidget(
                    title: " | ",
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  SubHeadingWidget(
                    title: "3 items",
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  SubHeadingWidget(
                    title: " | ",
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  SubHeadingWidget(
                    title: "20-Oct-2024",
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ],
              ),
              SizedBox(height: 8),
              //list the product and details
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
                            Image.asset(
                              item.dishimage.toString(),
                              width: 70,
                              height: 70,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // const SizedBox(height: 5),
                                        HeadingWidget(
                                          title: item.dishname,
                                        ),
                                        HeadingWidget(
                                          title: "₹${item.discountprice}.00",
                                        )
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
                                              title: item.qty,
                                              color: AppColors.black,
                                            ),
                                            SubHeadingWidget(
                                              title: " x ",
                                              color: AppColors.black,
                                            ),
                                            SubHeadingWidget(
                                              title:
                                                  "₹${item.discountprice}.00",
                                              color: AppColors.black,
                                            )
                                          ]),
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
                            "₹${totalDiscountPrice.toString()}0",
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
                            "Delivery Fee | 9.8 km",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "₹30.00",
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
                          "₹2.00",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GST & Restaurant Charges",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "₹35.00",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey[300]),
                    BillRow(
                      label: "Total Amount",
                      value: "₹${totalDiscountPrice.toString()}0",
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

              //Address container
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
                    Container(
                      width: 100.0,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.red,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppColors.light),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.cart_home_icon,
                            height: 18,
                            width: 18,
                            color: AppColors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Home",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.red),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "No 37 Paranjothi Nagar Thylakoid, velour Nagar\nTrichy-620005",
                    ),
                    SizedBox(height: 8),
                    Text("Contact : 1234567890"),
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

// 2. Order Items List Widget
// class OrderItemList extends StatelessWidget {
//   final List<Map<String, dynamic>> items = [
//     {
//       "name": "Chicken Biryani",
//       "type": "Non-Veg",
//       "quantity": "Qty-5",
//       "price": "₹50.00",
//       "image": AppAssets.cartBiriyani // Replace with your image path
//     },
//     {
//       "name": "Chicken Biryani",
//       "type": "Non-Veg",
//       "quantity": "Qty-5",
//       "price": "₹50.00",
//       "image": AppAssets.cartBiriyani // Replace with your image path
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: items.length,
//       separatorBuilder: (context, index) => Divider(
//         color: Colors.grey.shade300,
//         thickness: 1,
//       ),
//       itemBuilder: (context, index) {
//         final item = items[index];
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset(
//                 item['image'],
//                 width: 70,
//                 height: 70,
//                 fit: BoxFit.fill,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Image.asset(
//                           AppAssets.nonveg_icon,
//                           width: 20,
//                           height: 20,
//                         ),
//                         const SizedBox(width: 5.0),
//                         HeadingWidget(
//                           title: item['type'],
//                           vMargin: 1.0,
//                           fontSize: 13.0,
//                         ),
//                       ],
//                     ),
//                    // const SizedBox(height: 5),
//                     HeadingWidget(
//                       title: item['name'],
//                     ),
//                     //const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SubHeadingWidget(
//                           title: item['quantity'],
//                           color: AppColors.black,
//                         ),
//                         HeadingWidget(
//                           title: item['price'],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// 3. Bill Details Widget
// class BillDetails extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return    Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15.0),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child:
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             BillRow(label: "Item total", value: "₹27.00"),
//             BillRow(label: "Delivery Fee | 9.8 km", value: "₹27.00"),
//             Text(
//               "Enjoy Discounted Delivery!",
//               style: TextStyle(color: Colors.black),
//             ),
//            Divider(color: Colors.grey[300]),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                   Text(
//               "Delivery Trip",
//               style: TextStyle(color: Colors.black),
//             ),

//             Text(
//               "Add Trip",
//               style: TextStyle(color: Colors.red),
//             ),

//               ],
//             ),
//             BillRow(label: "Platform fee", value: "₹27.00"),
//             BillRow(label: "GST and Restaurant Charges", value: "₹27.00"),
//             Divider(color: Colors.grey[300]),
//             BillRow(
//               label: "To Amount",
//               value: "₹27.00",
//               isTotal: true,
//             ),
//           ],
//         ),
//     );
//   }
// }

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

// 4. Address Section Widget
// class AddressSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15.0),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
              
//               width: 100.0,
//               padding: EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppColors.red,
//                         ),
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: AppColors.light),
//                     child:    Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                Image.asset(
//                       AppAssets.homeicon,
//                       height: 18,
//                       width: 18,
//                       color: AppColors.red,
//                     ),
//                 SizedBox(width: 8),
//                 Text(
//                   "Home",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "No 37 Paranjothi Nagar Thylakoid, velour Nagar\nTrichy-620005",
//             ),
//             SizedBox(height: 8),
//             Text("Contact : 1234567890"),
//           ],
//         ),
//     );
//   }
// }

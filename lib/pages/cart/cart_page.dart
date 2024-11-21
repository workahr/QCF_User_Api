import 'package:flutter/material.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../models/cart_list_model.dart';
import '../store/store_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final NamFoodApiService apiService = NamFoodApiService();

  @override
  void initState() {
    super.initState();

    getOrderPreviewlist();
  }

  List<CartList> cartList = [];
  List<CartList> cartListAll = [];
  bool isLoading = false;
  double totalDiscountPrice = 0.0;

  Future getOrderPreviewlist() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getCartList();
      var response = CartListmodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          cartList = response.list;
          cartListAll = cartList;
          isLoading = false;
          calculateTotalDiscount();
        });
      } else {
        setState(() {
          cartList = [];
          cartListAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        cartList = [];
        cartListAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  void calculateTotalDiscount() {
    totalDiscountPrice = cartList.fold(
      0.0,
      (sum, item) => sum + (int.parse(item.quantityPrice.toString()) ?? 0.0),
    );

    finalTotal =
        totalDiscountPrice + deliveryFee + platformFee + gstFee - discount;

    setState(() {});
  }

  int quantity = 3;
  double itemPrice = 15.50;
  double deliveryFee = 44.0;
  double platformFee = 5.0;
  double gstFee = 2.0;
  double discount = 0.0;
  bool isTripAdded = false;
  double finalTotal = 0.0;

  int selectedOption =
      0; // 0 for no selection, 1 for first option, 2 for second option

  void _selectOption(int option) {
    setState(() {
      selectedOption = option;
    });
  }

  int _quantity = 1;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  String? selectedValue = 'cash_on_delivery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        appBar: AppBar(
          title: HeadingWidget(
            title: "Cart",
            fontSize: 20.0,
          ),
          backgroundColor: AppColors.lightGrey3,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Row(children: [
                          SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            AppAssets.cart_home_icon,
                            height: 25,
                            width: 25,
                            color: AppColors.black,
                          ),
                          HeadingWidget(
                            title: " Home",
                            fontSize: 16.0,
                          ),
                        ]),
                        SubHeadingWidget(
                          title: " | ",
                        ),
                        SubHeadingWidget(
                          title: "No 3 ThillaiNagar, 5 cross, Trichy, 638001",
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                        Icon(Icons.expand_more)
                      ],
                    )),
                SizedBox(height: 10),
                HeadingWidget(
                  title: " Grill Chicken Arabian Restaurant",
                  fontSize: 18.0,
                ),
                SizedBox(height: 10),
                if (cartList.isNotEmpty)
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cartList.length,
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                          itemBuilder: (context, index) {
                            final item = cartList[index];
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset(
                                              item.dishimage.toString(),
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.fill,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 150,
                                                  child: HeadingWidget(
                                                    overflow:
                                                        TextOverflow.visible,
                                                    maxLines: 2,
                                                    title: item.dishname
                                                        .toString(),
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                SubHeadingWidget(
                                                    title:
                                                        '₹${item.discountprice.toString()}',
                                                    color: AppColors.black),
                                              ],
                                            ),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          GestureDetector(
                                                            onTap:
                                                                _decrement, // Call _decrement directly without =>
                                                            child: Container(
                                                              height: 25,
                                                              width: 30,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          2.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        0xFFE23744)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .remove, // Change this to 'remove' since it's for decrement
                                                                color:
                                                                    Colors.red,
                                                                size: 25,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                            child: Text(
                                                              '$_quantity',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap:
                                                                _increment, // Call _increment directly without =>
                                                            child: Container(
                                                              height: 25,
                                                              width: 30,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          2.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        0xFFE23744)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .add, // Change this to 'add' since it's for increment
                                                                color:
                                                                    Colors.red,
                                                                size: 25,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  HeadingWidget(
                                                      title:
                                                          '₹${item.quantityPrice.toString()}.00',
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ])
                                          ])),
                                ]);
                          })),
                SizedBox(
                  height: 10,
                ),
                SizedBox(height: 16),
                HeadingWidget(
                  title: "Bill Details",
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubHeadingWidget(
                              title: "Item total", color: AppColors.black),
                          SubHeadingWidget(
                              title:
                                  "₹${totalDiscountPrice.toStringAsFixed(2)}",
                              color: AppColors.black),
                        ],
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubHeadingWidget(
                                  title: "Delivery Fee | 9.8 km",
                                  color: AppColors.black),
                              SubHeadingWidget(
                                  title: "₹${deliveryFee.toStringAsFixed(2)}",
                                  color: AppColors.black),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubHeadingWidget(
                              title: "Delivery Trip", color: AppColors.black),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isTripAdded = !isTripAdded;
                              });
                            },
                            child: HeadingWidget(
                                title:
                                    isTripAdded ? "Remove Trip" : "+ Add Trip",
                                color: Colors.red,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubHeadingWidget(
                              title: "Platform fee", color: AppColors.black),
                          SubHeadingWidget(
                              title: "₹${platformFee.toStringAsFixed(2)}",
                              color: AppColors.black),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubHeadingWidget(
                              title: "GST and Restaurant Charges",
                              color: AppColors.black),
                          SubHeadingWidget(
                              title: "₹${gstFee.toStringAsFixed(2)}",
                              color: AppColors.black),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeadingWidget(title: "To Pay", fontSize: 16.0),
                          HeadingWidget(
                              title: "₹${finalTotal.toStringAsFixed(2)}",
                              fontSize: 16.0),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingWidget(
                      title: "Delivery Type",
                    ),
                    // SubHeadingWidget(
                    //   title: "Your Product is Always Fresh",
                    //   color: Colors.grey,
                    // ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _selectOption(1),
                          child: Container(
                            width: 170,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: selectedOption == 1
                                    ? Color(0xFFE23744)
                                    : Colors.grey.shade300,
                                width: selectedOption == 1 ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeadingWidget(
                                  title: 'Fast delivery',
                                  color: Color.fromARGB(255, 95, 95, 95),
                                ),
                                Row(
                                  children: [
                                    HeadingWidget(
                                      title: "30-35 Mins",
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    Spacer(),
                                    if (selectedOption == 1)
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.red,
                                        size: 20,
                                      ),
                                  ],
                                ),
                                Row(children: [
                                  HeadingWidget(
                                    title: "₹44",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ]),
                                SubHeadingWidget(
                                  title: "Delivery Charges",
                                  color: Colors.black,
                                ),
                                SizedBox(height: 8.0),
                                SubHeadingWidget(
                                  title: "Recommended If You are in a hurry",
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _selectOption(2),
                          child: Container(
                            width: 170,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: selectedOption == 2
                                    ? Color(0xFFE23744)
                                    : Colors.grey.shade300,
                                width: selectedOption == 2 ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeadingWidget(
                                  title: 'Normal',
                                  color: Color.fromARGB(255, 95, 95, 95),
                                  fontWeight: FontWeight.bold,
                                ),
                                Row(
                                  children: [
                                    HeadingWidget(
                                      title: "40-45 Mins",
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    Spacer(),
                                    if (selectedOption == 2)
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.red,
                                        size: 20,
                                      ),
                                  ],
                                ),
                                HeadingWidget(
                                  title: "₹60",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                SubHeadingWidget(
                                  title: "Delivery Charges",
                                  color: Colors.black,
                                ),
                                SizedBox(height: 8.0),
                                SubHeadingWidget(
                                  title: "Recommended If You are in a hurry",
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                HeadingWidget(
                  title: "Select your payment Method",
                ),
                SizedBox(height: 8),
                Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(AppAssets.moneyIcon,
                                    height: 25, width: 25, color: Colors.black),
                                SizedBox(width: 12),
                                HeadingWidget(
                                  title: 'Cash on Delivery',
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            Radio(
                              value: 'cash_on_delivery',
                              groupValue: selectedValue,
                              activeColor: AppColors.red,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  AppAssets.onlinePaymentIcon,
                                  height: 25,
                                  width: 25,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 12),
                                HeadingWidget(
                                  title: 'Online Payment',
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ],
                            ),
                            Radio(
                              value: 'Online Payment',
                              groupValue: selectedValue,
                              activeColor: AppColors.red,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            height: 80.0,
            elevation: 0,
            color: AppColors.light,
            child: SafeArea(
                child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubHeadingWidget(
                        title: "Total Amount",
                        color: AppColors.black,
                      ),
                      HeadingWidget(
                        title: "₹1400.00",
                        color: AppColors.red,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StorePage(),
                        ),
                      );
                    },
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          children: [
                            SubHeadingWidget(
                              title: "Pay now   ",
                              color: Colors.white,
                            ),
                            Icon(Icons.arrow_forward)
                          ],
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ))));
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 25,
        width: 30,
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE23744)),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        // Container(
        //   width: 27,
        //   height: 27,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(4),
        //   ),
        child: Icon(icon, size: 15, color: Color(0xFFE23744)),
      ),
    );
  }

  Widget _buildPaymentMethod(Image image, String method) {
    return ListTile(
      leading: image,
      title: Text(method),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}

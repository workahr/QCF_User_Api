import 'package:flutter/material.dart';
import 'package:namfood/pages/maincontainer.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/constants.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../HomeScreen/home_screen.dart';
import '../address/address_list_model.dart';
import '../address/addresspage.dart';
import '../models/cart_list_model.dart';
import '../store/store_page.dart';
import 'add_quantity_model.dart';
import 'cart_list_model.dart';
import 'create_order_model.dart';

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

    getAllCartList();
    getalladdressList();
  }

  String? cartdetails;
  List<CartListData> cartList = [];
  List<CartListData> cartListAll = [];
  bool isLoading = false;
  double totalDiscountPrice = 0.0;
  String storeName = '';

  Future getAllCartList() async {
    await apiService.getBearerToken();
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getCartList();
      var response = cartListModelFromJson(result);
      print("Cart list status: ${response.status}");
      cartdetails = response.status;
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          cartList = response.list;
          cartListAll = cartList;
          isLoading = false;
          storeName =
              cartList.isNotEmpty ? cartList.first.store_name ?? '' : '';
          calculateTotalDiscount();
        });
        if (cartList.isEmpty) {
          showInSnackBar(context, 'Your cart is empty');
        }
      } else {
        setState(() {
          cartList = [];
          cartListAll = [];
          isLoading = false;
        });
        // showInSnackBar(context, response.message.toString());
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

  // void calculateTotalDiscount() {
  //   totalDiscountPrice = cartList.fold(
  //     0.0,
  //     (sum, item) => sum + (double.tryParse(item.quantityPrice) ?? 0.0),
  //   );

  //   finalTotal =
  //       totalDiscountPrice + deliverycharge + platformFee + gstFee - discount;

  //   setState(() {});
  // }

  void calculateTotalDiscount() {
    totalDiscountPrice = cartList.fold(
      0.0,
      (sum, item) => sum + (double.tryParse(item.quantityPrice) ?? 0.0),
    );

    // Parse the nullable strings to double, defaulting to 0.0 if null or invalid
    double deliveryChargeValue = double.tryParse(deliverycharge ?? '') ?? 0.0;

    finalTotal = totalDiscountPrice + deliveryChargeValue;

    setState(() {});
  }

  int quantity = 3;
  double itemPrice = 15.50;
  double deliveryFee = 0.0;
  double platformFee = 0.0;
  double gstFee = 0.0;
  double discount = 0.0;
  bool isTripAdded = false;
  double finalTotal = 0.00;

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

  String? selectedValue = 'Cash';

  Future addQuantity(int productId, int? storeId) async {
    Map<String, dynamic> postData = {
      "store_id": storeId,
      "product_id": productId
    };

    var result = await apiService.addQuantity(postData);
    var response = addQuantityModelFromJson(result);
    if (response.status.toString() == 'SUCCESS') {
      //showInSnackBar(context, response.message.toString());
      getAllCartList();
      //Navigator.of(context).pop();
    } else {
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  Future removeQuantity(int productId, int? storeId) async {
    Map<String, dynamic> postData = {
      "store_id": storeId,
      "product_id": productId
    };

    var result = await apiService.removeQuantity(postData);
    var response = addQuantityModelFromJson(result);
    if (response.status.toString() == 'SUCCESS') {
      // showInSnackBar(context, response.message.toString());
      getAllCartList();
      //Navigator.of(context).pop();
    } else {
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  int? selectedaddressid;
  Future createorder() async {
    Map<String, dynamic> postData = {
      "delivery_charges": deliverycharge,
      "payment_method": selectedValue,
      "address_id": selectedaddressid
    };
    print(postData);

    try {
      var result = await apiService.createorder(postData);
      Createordermodel response = createordermodelFromJson(result);

      if (response.status == 'SUCCESS') {
        // Navigator.pushNamedAndRemoveUntil(
        //     context, '/home', ModalRoute.withName('/home'));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainContainer(initialPage: 1),
          ),
        );
        showInSnackBar(context, "Order Created");
      } else {
        showInSnackBar(context, response.message);
      }
    } catch (error) {
      print('Error create order: $error');
      //  showInSnackBar(context, 'Failed to create order. Please try again.');
    }
  }

  Future deleteCart(int productId, int? storeId) async {
    final dialogBoxResult = await showAlertDialogInfo(
        context: context,
        title: 'Are you sure?',
        msg: 'You want to delete this data',
        status: 'danger',
        okBtn: false);
    if (dialogBoxResult == 'OK') {
      Map<String, dynamic> postData = {
        "store_id": storeId,
        "product_id": productId
      };

      var result = await apiService.deleteCart(postData);
      var response = addQuantityModelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        showInSnackBar(context, response.message.toString());
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        // String rawJson = prefs.getString('cartList') ?? '[]';
        // List<dynamic> jsonList = jsonDecode(rawJson);
        // List<dynamic> updatedList = jsonList.where((item) => item['item_id'] != itemId).toList();
        // String updatedJson = jsonEncode(updatedList);
        // await prefs.setString('cartList', updatedJson);
        getAllCartList();
        //Navigator.of(context).pop();
      } else {
        showInSnackBar(context, response.message.toString());
      }
      setState(() {});
    }
  }

  List<AddressList> myprofilepage = [];
  List<AddressList> myprofilepageAll = [];

  Future getalladdressList() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getalladdressList();
      var response = addressListmodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          myprofilepage = response.list;
          myprofilepageAll = myprofilepage;
          isLoading = false;

          if (myprofilepage.isNotEmpty) {
            // Find the default address or fallback to the first address
            selectedAddress = myprofilepage.firstWhere(
              (address) => address.defaultAddress == 1,
              orElse: () => myprofilepage.first,
            );
            // Assign the ID of the selected address
            selectedaddressid = selectedAddress?.id;
            deliverycharge = selectedAddress?.price;
          } else {
            selectedAddress = null;
            selectedaddressid = null;
          }
          calculateTotalDiscount();
          print("Selected Address ID: $selectedaddressid");
        });
      } else {
        setState(() {
          myprofilepage = [];
          myprofilepageAll = [];
          isLoading = false;
        });
        // showInSnackBar(context, response.message.toString());
        print(response.message.toString());
      }
    } catch (e) {
      setState(() {
        myprofilepage = [];
        myprofilepageAll = [];
        isLoading = false;
      });
      // showInSnackBar(context, 'Error occurred: $e');
      print('Error occurred: $e');
    }
  }

  AddressList? selectedAddress;

  Widget _buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                height: 63,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(13), // Add border radius
              child: Container(
                width: double.infinity,
                height: 103,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(13), // Add border radius
              child: Container(
                width: double.infinity,
                height: 123,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(13), // Add border radius
              child: Container(
                width: double.infinity,
                height: 63,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? deliverycharge;

  Future<bool> _onWillPop() async {
    Navigator.pop(context, true);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
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
                onPressed: () => Navigator.pop(context, true),
              ),
            ),
            body: isLoading
                ? ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _buildShimmerPlaceholder();
                    },
                  )
                : cartdetails == "FAILED"
                    ? Center(child: Text('No Product in  the Cart'))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              myprofilepage.isEmpty
                                  ? ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Addresspage(),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 12),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SubHeadingWidget(
                                                title: "Add New Address",
                                                color: Colors.white,
                                              ),
                                              Icon(Icons.arrow_forward)
                                            ],
                                          )),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1.5),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child: SizedBox(
                                        height: 50,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<AddressList>(
                                            isExpanded: true,
                                            value: selectedAddress,
                                            hint: Text('Select Address'),
                                            onChanged:
                                                (AddressList? newAddress) {
                                              setState(() {
                                                selectedAddress = newAddress;
                                                print(
                                                    "Selected Address ID: ${newAddress?.id}");
                                                print(
                                                    "Selected Address ID: ${newAddress?.price}");
                                                deliverycharge =
                                                    newAddress?.price;
                                              });
                                            },
                                            items: myprofilepage.map<
                                                DropdownMenuItem<AddressList>>(
                                              (AddressList e) {
                                                return DropdownMenuItem<
                                                    AddressList>(
                                                  value: e,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Container(
                                                      height: 50,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 5,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 5),
                                                          e.type == "Home"
                                                              ? Image.asset(
                                                                  AppAssets
                                                                      .cart_home_icon,
                                                                  height: 25,
                                                                  width: 25,
                                                                  color:
                                                                      AppColors
                                                                          .red,
                                                                )
                                                              : Image.asset(
                                                                  AppAssets
                                                                      .work_red,
                                                                  height: 25,
                                                                  width: 25,
                                                                  color:
                                                                      AppColors
                                                                          .red,
                                                                ),
                                                          SizedBox(width: 5),
                                                          HeadingWidget(
                                                            title: e.type,
                                                            fontSize: 16.0,
                                                          ),
                                                          SubHeadingWidget(
                                                            title: " | ",
                                                          ),
                                                          Expanded(
                                                            child:
                                                                SubHeadingWidget(
                                                              title:
                                                                  "${e.address}, ${e.city}, ${e.landmark}, ${e.postcode} .",
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          if (e.defaultAddress ==
                                                              1)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          8.0),
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical:
                                                                        2),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                ),
                                                                child: Text(
                                                                  'Default',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                              SizedBox(height: 10),
                              HeadingWidget(
                                title: storeName,
                                // " Grill Chicken Arabian Restaurant",
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
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              color: Colors.grey.shade300,
                                              thickness: 1,
                                            ),
                                        itemBuilder: (context, index) {
                                          final item = cartList[index];
                                          return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          item.itemImageUrl ==
                                                                  null
                                                              ? ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child: Image
                                                                      .asset(
                                                                    AppAssets
                                                                        .cartBiriyani,
                                                                    height: 60,
                                                                    width: 60,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                )
                                                              : ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child: Image
                                                                      .network(
                                                                    AppConstants
                                                                            .imgBaseUrl +
                                                                        item.itemImageUrl
                                                                            .toString(),
                                                                    height: 60,
                                                                    width: 60,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: 150,
                                                                child:
                                                                    HeadingWidget(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  maxLines: 2,
                                                                  title: item
                                                                          .itemName
                                                                          .toString()![
                                                                              0]
                                                                          .toUpperCase() +
                                                                      item.itemName
                                                                          .toString()!
                                                                          .substring(
                                                                              1),
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 8.0),
                                                              SubHeadingWidget(
                                                                  title: curFormatWithDecimal(
                                                                          value: emptyToZero(item
                                                                              .price))
                                                                      .toString(),
                                                                  color: AppColors
                                                                      .black),
                                                            ],
                                                          ),
                                                          Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
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
                                                                              () {
                                                                            setState(() {
                                                                              item.quantity = (item.quantity ?? 0) > 0 ? item.quantity - 1 : 0;

                                                                              if (item.quantity > 0) {
                                                                                removeQuantity(item.productId, item.storeId);
                                                                              } else {
                                                                                deleteCart(item.productId, item.storeId);
                                                                              }
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                30,
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 2.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(color: Color(0xFFE23744)),
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: Colors.white,
                                                                            ),
                                                                            child:
                                                                                Icon(
                                                                              Icons.remove, // Change this to 'remove' since it's for decrement
                                                                              color: Colors.red,
                                                                              size: 25,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 10.0),
                                                                          child:
                                                                              Text(
                                                                            item.quantity.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              item.quantity = (item.quantity ?? 0) + 1;

                                                                              addQuantity(item.productId, item.storeId);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                30,
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 2.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(color: Color(0xFFE23744)),
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: Colors.white,
                                                                            ),
                                                                            child:
                                                                                Icon(
                                                                              Icons.add, // Change this to 'add' since it's for increment
                                                                              color: Colors.red,
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
                                                                    title: curFormatWithDecimal(
                                                                            value: emptyToZero(item
                                                                                .quantityPrice))
                                                                        .toString(),
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
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
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SubHeadingWidget(
                                            title: "Item total",
                                            color: AppColors.black),
                                        SubHeadingWidget(
                                            title:
                                                "₹${totalDiscountPrice.toStringAsFixed(2)}",
                                            color: AppColors.black),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SubHeadingWidget(
                                                title:
                                                    "Delivery Fee ", // "Delivery Fee | 9.8 km",
                                                color: AppColors.black),
                                            SubHeadingWidget(
                                                title: deliverycharge == null
                                                    ? 0
                                                    : "₹${deliverycharge}",
                                                color: AppColors.black),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    // SizedBox(height: 8),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     SubHeadingWidget(
                                    //         title: "Delivery Tip",
                                    //         color: AppColors.black),
                                    //     GestureDetector(
                                    //       onTap: () {
                                    //         setState(() {
                                    //           isTripAdded = !isTripAdded;
                                    //         });
                                    //       },
                                    //       child: HeadingWidget(
                                    //           title: isTripAdded
                                    //               ? "Remove Tip"
                                    //               : "+ Add Tip",
                                    //           color: Colors.red,
                                    //           fontSize: 14.0),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: 8),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     SubHeadingWidget(
                                    //         title: "Platform fee",
                                    //         color: AppColors.black),
                                    //     SubHeadingWidget(
                                    //         title:
                                    //             "₹${platformFee.toStringAsFixed(2)}",
                                    //         color: AppColors.black),
                                    //   ],
                                    // ),
                                    // SizedBox(height: 8),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     SubHeadingWidget(
                                    //         title: "GST and Restaurant Charges",
                                    //         color: AppColors.black),
                                    //     SubHeadingWidget(
                                    //         title:
                                    //             "₹${gstFee.toStringAsFixed(2)}",
                                    //         color: AppColors.black),
                                    //   ],
                                    // ),
                                    // Divider(
                                    //   color: Colors.grey,
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        HeadingWidget(
                                            title: "To Pay", fontSize: 16.0),
                                        HeadingWidget(
                                            title:
                                                "₹${finalTotal.toStringAsFixed(2)}",
                                            fontSize: 16.0),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     HeadingWidget(
                              //       title: "Delivery Type",
                              //     ),
                              //     // SubHeadingWidget(
                              //     //   title: "Your Product is Always Fresh",
                              //     //   color: Colors.grey,
                              //     // ),
                              //     SizedBox(height: 8),
                              //     Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         GestureDetector(
                              //           onTap: () => _selectOption(1),
                              //           child: Container(
                              //             width: 170,
                              //             padding: EdgeInsets.all(12.0),
                              //             decoration: BoxDecoration(
                              //               color: Colors.white,
                              //               borderRadius:
                              //                   BorderRadius.circular(12.0),
                              //               border: Border.all(
                              //                 color: selectedOption == 1
                              //                     ? Color(0xFFE23744)
                              //                     : Colors.grey.shade300,
                              //                 width:
                              //                     selectedOption == 1 ? 2 : 1,
                              //               ),
                              //             ),
                              //             child: Column(
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.start,
                              //               children: [
                              //                 HeadingWidget(
                              //                   title: 'Fast delivery',
                              //                   color: Color.fromARGB(
                              //                       255, 95, 95, 95),
                              //                 ),
                              //                 Row(
                              //                   children: [
                              //                     HeadingWidget(
                              //                       title: "30-35 Mins",
                              //                       fontSize: 18.0,
                              //                       fontWeight: FontWeight.bold,
                              //                       color: Colors.black,
                              //                     ),
                              //                     Spacer(),
                              //                     if (selectedOption == 1)
                              //                       Icon(
                              //                         Icons.check_circle,
                              //                         color: AppColors.red,
                              //                         size: 20,
                              //                       ),
                              //                   ],
                              //                 ),
                              //                 Row(children: [
                              //                   HeadingWidget(
                              //                     title: "₹44",
                              //                     color: Colors.black,
                              //                     fontWeight: FontWeight.bold,
                              //                   ),
                              //                 ]),
                              //                 SubHeadingWidget(
                              //                   title: "Delivery Charges",
                              //                   color: Colors.black,
                              //                 ),
                              //                 SizedBox(height: 8.0),
                              //                 SubHeadingWidget(
                              //                   title:
                              //                       "Recommended If You are in a hurry",
                              //                   color: Colors.black,
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         GestureDetector(
                              //           onTap: () => _selectOption(2),
                              //           child: Container(
                              //             width: 170,
                              //             padding: EdgeInsets.all(12.0),
                              //             decoration: BoxDecoration(
                              //               color: Colors.white,
                              //               borderRadius:
                              //                   BorderRadius.circular(12.0),
                              //               border: Border.all(
                              //                 color: selectedOption == 2
                              //                     ? Color(0xFFE23744)
                              //                     : Colors.grey.shade300,
                              //                 width:
                              //                     selectedOption == 2 ? 2 : 1,
                              //               ),
                              //             ),
                              //             child: Column(
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.start,
                              //               children: [
                              //                 HeadingWidget(
                              //                   title: 'Normal',
                              //                   color: Color.fromARGB(
                              //                       255, 95, 95, 95),
                              //                   fontWeight: FontWeight.bold,
                              //                 ),
                              //                 Row(
                              //                   children: [
                              //                     HeadingWidget(
                              //                       title: "40-45 Mins",
                              //                       fontSize: 18.0,
                              //                       fontWeight: FontWeight.bold,
                              //                       color: Colors.black,
                              //                     ),
                              //                     Spacer(),
                              //                     if (selectedOption == 2)
                              //                       Icon(
                              //                         Icons.check_circle,
                              //                         color: AppColors.red,
                              //                         size: 20,
                              //                       ),
                              //                   ],
                              //                 ),
                              //                 HeadingWidget(
                              //                   title: "₹60",
                              //                   color: Colors.black,
                              //                   fontWeight: FontWeight.bold,
                              //                 ),
                              //                 SubHeadingWidget(
                              //                   title: "Delivery Charges",
                              //                   color: Colors.black,
                              //                 ),
                              //                 SizedBox(height: 8.0),
                              //                 SubHeadingWidget(
                              //                   title:
                              //                       "Recommended If You are in a hurry",
                              //                   color: Colors.black,
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: 15.0),
                              HeadingWidget(
                                title: "Select your payment Method",
                              ),
                              SizedBox(height: 8),
                              Container(
                                  padding: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Image.asset(AppAssets.moneyIcon,
                                                  height: 25,
                                                  width: 25,
                                                  color: Colors.black),
                                              SizedBox(width: 12),
                                              HeadingWidget(
                                                title: 'Cash on Delivery',
                                                fontSize: 15.0,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                          Radio(
                                            value: 'Cash',
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
                                      // SizedBox(
                                      //   height: 8.0,
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Row(
                                      //       children: [
                                      //         SizedBox(
                                      //           width: 10,
                                      //         ),
                                      //         Image.asset(
                                      //           AppAssets.onlinePaymentIcon,
                                      //           height: 25,
                                      //           width: 25,
                                      //           color: Colors.black,
                                      //         ),
                                      //         SizedBox(width: 12),
                                      //         HeadingWidget(
                                      //           title: 'Online Payment',
                                      //           color: Colors.black,
                                      //           fontSize: 15.0,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     Radio(
                                      //       value: 'Online',
                                      //       groupValue: selectedValue,
                                      //       activeColor: AppColors.red,
                                      //       onChanged: (value) {
                                      //         setState(() {
                                      //           selectedValue = value;
                                      //         });
                                      //       },
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
            bottomNavigationBar: isLoading
                ? SizedBox(
                    height: 1,
                  )
                : cartdetails != "FAILED"
                    ? BottomAppBar(
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
                                    title: '₹${finalTotal.toStringAsFixed(2)}',
                                    color: AppColors.red,
                                    fontSize: 18.0,
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (cartdetails == "FAILED") {
                                    showInSnackBar(context,
                                        "Please Add Any One of the Item ");
                                  } else if (selectedValue == '' ||
                                      selectedValue == null ||
                                      selectedValue == "cash_on_delivery") {
                                    showInSnackBar(context,
                                        "Select the Payment Method Field ");
                                    print("Select the Payment Method Field ");
                                  } else if (selectedaddressid == '' ||
                                      selectedaddressid == null) {
                                    showInSnackBar(
                                        context, "Select the Address Field ");
                                  } else {
                                    // if (cartdetails == "FAILED") {
                                    //   showInSnackBar(
                                    //       context, "Please Add Any One of the Item ");
                                    //   // createorder();
                                    // }
                                    //  else {
                                    createorder();
                                  }
                                },
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 12),
                                    child: Row(
                                      children: [
                                        SubHeadingWidget(
                                          title: "Confirm Order   ",
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
                              )
                            ],
                          ),
                        )))
                    : null));
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

// Before Address Selection

// import 'package:flutter/material.dart';
// import 'package:namfood/pages/maincontainer.dart';

// import '../../constants/app_assets.dart';
// import '../../constants/app_colors.dart';
// import '../../constants/constants.dart';
// import '../../services/comFuncService.dart';
// import '../../services/nam_food_api_service.dart';
// import '../../widgets/heading_widget.dart';
// import '../../widgets/sub_heading_widget.dart';
// import '../HomeScreen/home_screen.dart';
// import '../address/address_list_model.dart';
// import '../models/cart_list_model.dart';
// import '../store/store_page.dart';
// import 'add_quantity_model.dart';
// import 'cart_list_model.dart';
// import 'create_order_model.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   _CartPageState createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   final NamFoodApiService apiService = NamFoodApiService();

//   @override
//   void initState() {
//     super.initState();

//     getAllCartList();
//     getalladdressList();
//   }

//   List<CartListData> cartList = [];
//   List<CartListData> cartListAll = [];
//   bool isLoading = false;
//   double totalDiscountPrice = 0.0;

//   Future getAllCartList() async {
//     await apiService.getBearerToken();
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getCartList();
//       var response = cartListModelFromJson(result);
//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {
//           cartList = response.list;
//           cartListAll = cartList;
//           isLoading = false;
//           calculateTotalDiscount();
//         });
//       } else {
//         setState(() {
//           cartList = [];
//           cartListAll = [];
//           isLoading = false;
//         });
//         // showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         cartList = [];
//         cartListAll = [];
//         isLoading = false;
//       });
//       showInSnackBar(context, 'Error occurred: $e');
//     }

//     setState(() {});
//   }

//   void calculateTotalDiscount() {
//     totalDiscountPrice = cartList.fold(
//       0.0,
//       (sum, item) => sum + (double.tryParse(item.quantityPrice) ?? 0.0),
//     );

//     finalTotal =
//         totalDiscountPrice + deliveryFee + platformFee + gstFee - discount;

//     setState(() {});
//   }

//   int quantity = 3;
//   double itemPrice = 15.50;
//   double deliveryFee = 0.0;
//   double platformFee = 0.0;
//   double gstFee = 0.0;
//   double discount = 0.0;
//   bool isTripAdded = false;
//   double finalTotal = 0.0;

//   int selectedOption =
//       0; // 0 for no selection, 1 for first option, 2 for second option

//   void _selectOption(int option) {
//     setState(() {
//       selectedOption = option;
//     });
//   }

//   int _quantity = 1;

//   void _increment() {
//     setState(() {
//       _quantity++;
//     });
//   }

//   void _decrement() {
//     if (_quantity > 1) {
//       setState(() {
//         _quantity--;
//       });
//     }
//   }

//   String? selectedValue = 'cash_on_delivery';

//   Future addQuantity(int productId, int? storeId) async {
//     Map<String, dynamic> postData = {
//       "store_id": storeId,
//       "product_id": productId
//     };

//     var result = await apiService.addQuantity(postData);
//     var response = addQuantityModelFromJson(result);
//     if (response.status.toString() == 'SUCCESS') {
//       showInSnackBar(context, response.message.toString());
//       getAllCartList();
//       //Navigator.of(context).pop();
//     } else {
//       showInSnackBar(context, response.message.toString());
//     }
//     setState(() {});
//   }

//   Future removeQuantity(int productId, int? storeId) async {
//     Map<String, dynamic> postData = {
//       "store_id": storeId,
//       "product_id": productId
//     };

//     var result = await apiService.removeQuantity(postData);
//     var response = addQuantityModelFromJson(result);
//     if (response.status.toString() == 'SUCCESS') {
//       showInSnackBar(context, response.message.toString());
//       getAllCartList();
//       //Navigator.of(context).pop();
//     } else {
//       showInSnackBar(context, response.message.toString());
//     }
//     setState(() {});
//   }

//   Future createorder() async {
//     Map<String, dynamic> postData = {
//       "delivery_charges": 0,
//       "payment_method": selectedValue,
//       "address_id": "1"
//     };
//     print(postData);

//     try {
//       var result = await apiService.createorder(postData);
//       Createordermodel response = createordermodelFromJson(result);

//       if (response.status == 'SUCCESS') {
//         Navigator.pushNamedAndRemoveUntil(
//             context, '/home', ModalRoute.withName('/home'));
//         //       Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => MainContainer(),
//         //   ),
//         // );
//         showInSnackBar(context, response.message);
//       } else {
//         showInSnackBar(context, response.message);
//       }
//     } catch (error) {
//       print('Error create order: $error');
//       showInSnackBar(context, 'Failed to create order. Please try again.');
//     }
//   }

//   Future deleteCart(int productId, int? storeId) async {
//     Map<String, dynamic> postData = {
//       "store_id": storeId,
//       "product_id": productId
//     };

//     var result = await apiService.deleteCart(postData);
//     var response = addQuantityModelFromJson(result);
//     if (response.status.toString() == 'SUCCESS') {
//       showInSnackBar(context, response.message.toString());
//       //   SharedPreferences prefs = await SharedPreferences.getInstance();
//       // String rawJson = prefs.getString('cartList') ?? '[]';
//       // List<dynamic> jsonList = jsonDecode(rawJson);
//       // List<dynamic> updatedList = jsonList.where((item) => item['item_id'] != itemId).toList();
//       // String updatedJson = jsonEncode(updatedList);
//       // await prefs.setString('cartList', updatedJson);
//       getAllCartList();
//       //Navigator.of(context).pop();
//     } else {
//       showInSnackBar(context, response.message.toString());
//     }
//     setState(() {});
//   }

//   List<AddressList> myprofilepage = [];
//   List<AddressList> myprofilepageAll = [];

//   Future getalladdressList() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getalladdressList();
//       var response = addressListmodelFromJson(result);
//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {
//           myprofilepage = response.list;
//           myprofilepageAll = myprofilepage;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           myprofilepage = [];
//           myprofilepageAll = [];
//           isLoading = false;
//         });
//         // showInSnackBar(context, response.message.toString());
//         print(response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         myprofilepage = [];
//         myprofilepageAll = [];
//         isLoading = false;
//       });
//       // showInSnackBar(context, 'Error occurred: $e');
//       print('Error occurred: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           // Perform any action before navigating back
//           return true; // Allow back navigation
//         },
//         child: Scaffold(
//             backgroundColor: Color(0xFFF6F6F6),
//             appBar: AppBar(
//               title: HeadingWidget(
//                 title: "Cart",
//                 fontSize: 20.0,
//               ),
//               backgroundColor: AppColors.lightGrey3,
//               foregroundColor: Colors.black,
//               elevation: 0,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//             body: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     myprofilepage.isEmpty
//                         ? Center(child: Text('No address found'))
//                         : SizedBox(
//                             height: 60,
//                             child: ListView.builder(
//                                 itemCount: myprofilepage.length,
//                                 itemBuilder: (context, index) {
//                                   final e = myprofilepage[index];
//                                   return Container(
//                                       height: 50,
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(8),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey.withOpacity(0.2),
//                                             spreadRadius: 1,
//                                             blurRadius: 5,
//                                           ),
//                                         ],
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Row(children: [
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                             Image.asset(
//                                               AppAssets.cart_home_icon,
//                                               height: 25,
//                                               width: 25,
//                                               color: AppColors.black,
//                                             ),
//                                             HeadingWidget(
//                                               title: e.type, //" Home",
//                                               fontSize: 16.0,
//                                             ),
//                                           ]),
//                                           SubHeadingWidget(
//                                             title: " | ",
//                                           ),
//                                           SubHeadingWidget(
//                                             title:
//                                                 "${e.address},${e.city},${e.landmark},${e.postcode}",
//                                             //   "No 3 ThillaiNagar, 5 cross, Trichy, 638001",
//                                             fontSize: 12.0,
//                                             color: Colors.black,
//                                           ),
//                                           Icon(Icons.expand_more)
//                                         ],
//                                       ));
//                                 })),
//                     SizedBox(height: 10),
//                     HeadingWidget(
//                       title: " Grill Chicken Arabian Restaurant",
//                       fontSize: 18.0,
//                     ),
//                     SizedBox(height: 10),
//                     if (cartList.isNotEmpty)
//                       Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.2),
//                                 spreadRadius: 1,
//                                 blurRadius: 5,
//                               ),
//                             ],
//                           ),
//                           child: ListView.separated(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: cartList.length,
//                               separatorBuilder: (context, index) => Divider(
//                                     color: Colors.grey.shade300,
//                                     thickness: 1,
//                                   ),
//                               itemBuilder: (context, index) {
//                                 final item = cartList[index];
//                                 return Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                           padding: const EdgeInsets.all(15.0),
//                                           child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 item.itemImageUrl == null
//                                                     ? ClipRRect(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(12),
//                                                         child: Image.asset(
//                                                           AppAssets
//                                                               .cartBiriyani,
//                                                           height: 60,
//                                                           width: 60,
//                                                           fit: BoxFit.fill,
//                                                         ),
//                                                       )
//                                                     : ClipRRect(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(12),
//                                                         child: Image.network(
//                                                           AppConstants
//                                                                   .imgBaseUrl +
//                                                               item.itemImageUrl
//                                                                   .toString(),
//                                                           height: 60,
//                                                           width: 60,
//                                                           fit: BoxFit.cover,
//                                                         ),
//                                                       ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     SizedBox(
//                                                       width: 150,
//                                                       child: HeadingWidget(
//                                                         overflow: TextOverflow
//                                                             .visible,
//                                                         maxLines: 2,
//                                                         title: item.itemName
//                                                             .toString(),
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                     SizedBox(height: 8.0),
//                                                     SubHeadingWidget(
//                                                         title: curFormatWithDecimal(
//                                                                 value: emptyToZero(
//                                                                     item.price))
//                                                             .toString(),
//                                                         color: AppColors.black),
//                                                   ],
//                                                 ),
//                                                 Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment.end,
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               GestureDetector(
//                                                                 onTap: () {
//                                                                   setState(() {
//                                                                     item.quantity =
//                                                                         (item.quantity ?? 0) >
//                                                                                 0
//                                                                             ? item.quantity -
//                                                                                 1
//                                                                             : 0;

//                                                                     if (item.quantity >
//                                                                         0) {
//                                                                       removeQuantity(
//                                                                           item.productId,
//                                                                           item.storeId);
//                                                                     } else {
//                                                                       deleteCart(
//                                                                           item.productId,
//                                                                           item.storeId);
//                                                                     }
//                                                                   });
//                                                                 },
//                                                                 child:
//                                                                     Container(
//                                                                   height: 25,
//                                                                   width: 30,
//                                                                   padding: EdgeInsets
//                                                                       .symmetric(
//                                                                           horizontal:
//                                                                               2.0),
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     border: Border.all(
//                                                                         color: Color(
//                                                                             0xFFE23744)),
//                                                                     borderRadius:
//                                                                         BorderRadius
//                                                                             .circular(5),
//                                                                     color: Colors
//                                                                         .white,
//                                                                   ),
//                                                                   child: Icon(
//                                                                     Icons
//                                                                         .remove, // Change this to 'remove' since it's for decrement
//                                                                     color: Colors
//                                                                         .red,
//                                                                     size: 25,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               Padding(
//                                                                 padding: EdgeInsets
//                                                                     .symmetric(
//                                                                         horizontal:
//                                                                             10.0),
//                                                                 child: Text(
//                                                                   item.quantity
//                                                                       .toString(),
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: Colors
//                                                                         .black,
//                                                                     fontSize:
//                                                                         20,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               GestureDetector(
//                                                                 onTap: () {
//                                                                   setState(() {
//                                                                     item.quantity =
//                                                                         (item.quantity ??
//                                                                                 0) +
//                                                                             1;

//                                                                     addQuantity(
//                                                                         item.productId,
//                                                                         item.storeId);
//                                                                   });
//                                                                 },
//                                                                 child:
//                                                                     Container(
//                                                                   height: 25,
//                                                                   width: 30,
//                                                                   padding: EdgeInsets
//                                                                       .symmetric(
//                                                                           horizontal:
//                                                                               2.0),
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     border: Border.all(
//                                                                         color: Color(
//                                                                             0xFFE23744)),
//                                                                     borderRadius:
//                                                                         BorderRadius
//                                                                             .circular(5),
//                                                                     color: Colors
//                                                                         .white,
//                                                                   ),
//                                                                   child: Icon(
//                                                                     Icons
//                                                                         .add, // Change this to 'add' since it's for increment
//                                                                     color: Colors
//                                                                         .red,
//                                                                     size: 25,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           )
//                                                         ],
//                                                       ),
//                                                       SizedBox(
//                                                         height: 8.0,
//                                                       ),
//                                                       HeadingWidget(
//                                                           title: curFormatWithDecimal(
//                                                                   value: emptyToZero(item
//                                                                       .quantityPrice))
//                                                               .toString(),
//                                                           fontSize: 16.0,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ])
//                                               ])),
//                                     ]);
//                               })),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(height: 16),
//                     HeadingWidget(
//                       title: "Bill Details",
//                     ),
//                     SizedBox(height: 16),
//                     Container(
//                       padding: EdgeInsets.all(16.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8.0),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SubHeadingWidget(
//                                   title: "Item total", color: AppColors.black),
//                               SubHeadingWidget(
//                                   title:
//                                       "₹${totalDiscountPrice.toStringAsFixed(2)}",
//                                   color: AppColors.black),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   SubHeadingWidget(
//                                       title: "Delivery Fee | 9.8 km",
//                                       color: AppColors.black),
//                                   SubHeadingWidget(
//                                       title:
//                                           "₹${deliveryFee.toStringAsFixed(2)}",
//                                       color: AppColors.black),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           SizedBox(height: 8),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SubHeadingWidget(
//                                   title: "Delivery Tip",
//                                   color: AppColors.black),
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     isTripAdded = !isTripAdded;
//                                   });
//                                 },
//                                 child: HeadingWidget(
//                                     title: isTripAdded
//                                         ? "Remove Tip"
//                                         : "+ Add Tip",
//                                     color: Colors.red,
//                                     fontSize: 14.0),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SubHeadingWidget(
//                                   title: "Platform fee",
//                                   color: AppColors.black),
//                               SubHeadingWidget(
//                                   title: "₹${platformFee.toStringAsFixed(2)}",
//                                   color: AppColors.black),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SubHeadingWidget(
//                                   title: "GST and Restaurant Charges",
//                                   color: AppColors.black),
//                               SubHeadingWidget(
//                                   title: "₹${gstFee.toStringAsFixed(2)}",
//                                   color: AppColors.black),
//                             ],
//                           ),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               HeadingWidget(title: "To Pay", fontSize: 16.0),
//                               HeadingWidget(
//                                   title: "₹${finalTotal.toStringAsFixed(2)}",
//                                   fontSize: 16.0),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         HeadingWidget(
//                           title: "Delivery Type",
//                         ),
//                         // SubHeadingWidget(
//                         //   title: "Your Product is Always Fresh",
//                         //   color: Colors.grey,
//                         // ),
//                         SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             GestureDetector(
//                               onTap: () => _selectOption(1),
//                               child: Container(
//                                 width: 170,
//                                 padding: EdgeInsets.all(12.0),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12.0),
//                                   border: Border.all(
//                                     color: selectedOption == 1
//                                         ? Color(0xFFE23744)
//                                         : Colors.grey.shade300,
//                                     width: selectedOption == 1 ? 2 : 1,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     HeadingWidget(
//                                       title: 'Fast delivery',
//                                       color: Color.fromARGB(255, 95, 95, 95),
//                                     ),
//                                     Row(
//                                       children: [
//                                         HeadingWidget(
//                                           title: "30-35 Mins",
//                                           fontSize: 18.0,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black,
//                                         ),
//                                         Spacer(),
//                                         if (selectedOption == 1)
//                                           Icon(
//                                             Icons.check_circle,
//                                             color: AppColors.red,
//                                             size: 20,
//                                           ),
//                                       ],
//                                     ),
//                                     Row(children: [
//                                       HeadingWidget(
//                                         title: "₹44",
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ]),
//                                     SubHeadingWidget(
//                                       title: "Delivery Charges",
//                                       color: Colors.black,
//                                     ),
//                                     SizedBox(height: 8.0),
//                                     SubHeadingWidget(
//                                       title:
//                                           "Recommended If You are in a hurry",
//                                       color: Colors.black,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () => _selectOption(2),
//                               child: Container(
//                                 width: 170,
//                                 padding: EdgeInsets.all(12.0),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12.0),
//                                   border: Border.all(
//                                     color: selectedOption == 2
//                                         ? Color(0xFFE23744)
//                                         : Colors.grey.shade300,
//                                     width: selectedOption == 2 ? 2 : 1,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     HeadingWidget(
//                                       title: 'Normal',
//                                       color: Color.fromARGB(255, 95, 95, 95),
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     Row(
//                                       children: [
//                                         HeadingWidget(
//                                           title: "40-45 Mins",
//                                           fontSize: 18.0,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black,
//                                         ),
//                                         Spacer(),
//                                         if (selectedOption == 2)
//                                           Icon(
//                                             Icons.check_circle,
//                                             color: AppColors.red,
//                                             size: 20,
//                                           ),
//                                       ],
//                                     ),
//                                     HeadingWidget(
//                                       title: "₹60",
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     SubHeadingWidget(
//                                       title: "Delivery Charges",
//                                       color: Colors.black,
//                                     ),
//                                     SizedBox(height: 8.0),
//                                     SubHeadingWidget(
//                                       title:
//                                           "Recommended If You are in a hurry",
//                                       color: Colors.black,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 15.0),
//                     HeadingWidget(
//                       title: "Select your payment Method",
//                     ),
//                     SizedBox(height: 8),
//                     Container(
//                         padding: EdgeInsets.all(6.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8.0),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Image.asset(AppAssets.moneyIcon,
//                                         height: 25,
//                                         width: 25,
//                                         color: Colors.black),
//                                     SizedBox(width: 12),
//                                     HeadingWidget(
//                                       title: 'Cash on Delivery',
//                                       fontSize: 15.0,
//                                       color: Colors.black,
//                                     ),
//                                   ],
//                                 ),
//                                 Radio(
//                                   value: 'Cash',
//                                   groupValue: selectedValue,
//                                   activeColor: AppColors.red,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedValue = value;
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 8.0,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Image.asset(
//                                       AppAssets.onlinePaymentIcon,
//                                       height: 25,
//                                       width: 25,
//                                       color: Colors.black,
//                                     ),
//                                     SizedBox(width: 12),
//                                     HeadingWidget(
//                                       title: 'Online Payment',
//                                       color: Colors.black,
//                                       fontSize: 15.0,
//                                     ),
//                                   ],
//                                 ),
//                                 Radio(
//                                   value: 'Online',
//                                   groupValue: selectedValue,
//                                   activeColor: AppColors.red,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedValue = value;
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//             bottomNavigationBar: BottomAppBar(
//                 height: 80.0,
//                 elevation: 0,
//                 color: AppColors.light,
//                 child: SafeArea(
//                     child: Padding(
//                   padding: EdgeInsets.all(5.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SubHeadingWidget(
//                             title: "Total Amount",
//                             color: AppColors.black,
//                           ),
//                           HeadingWidget(
//                             title: '₹${finalTotal.toString()}',
//                             color: AppColors.red,
//                             fontSize: 18.0,
//                           ),
//                         ],
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (selectedValue == '' ||
//                               selectedValue == null ||
//                               selectedValue == "cash_on_delivery") {
//                             showInSnackBar(context,
//                                 "Please Enter the all Mandatory Field ");
//                             print("Please Enter the all Mandatory Field ");
//                           } else {
//                             createorder();
//                           }
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //     builder: (context) => StorePage(),
//                           //   ),
//                           // );
//                         },
//                         child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 12),
//                             child: Row(
//                               children: [
//                                 SubHeadingWidget(
//                                   title: "Pay now   ",
//                                   color: Colors.white,
//                                 ),
//                                 Icon(Icons.arrow_forward)
//                               ],
//                             )),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.red,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )))));
//   }

//   Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         height: 25,
//         width: 30,
//         padding: EdgeInsets.symmetric(horizontal: 2.0),
//         decoration: BoxDecoration(
//           border: Border.all(color: Color(0xFFE23744)),
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.white,
//         ),
//         // Container(
//         //   width: 27,
//         //   height: 27,
//         //   decoration: BoxDecoration(
//         //     color: Colors.white,
//         //     borderRadius: BorderRadius.circular(4),
//         //   ),
//         child: Icon(icon, size: 15, color: Color(0xFFE23744)),
//       ),
//     );
//   }

//   Widget _buildPaymentMethod(Image image, String method) {
//     return ListTile(
//       leading: image,
//       title: Text(method),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: () {},
//     );
//   }
// }

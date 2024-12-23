import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../store/store_detailsmenu_model.dart';
import '../store/storepage_addqty_model.dart';
import '../store/storepage_removeqty_model.dart';
import 'cart_list_model.dart';
import 'stores_list_model.dart';

class TabSearchApp extends StatefulWidget {
  @override
  _TabSearchAppState createState() => _TabSearchAppState();
}

class _TabSearchAppState extends State<TabSearchApp>
    with SingleTickerProviderStateMixin {
  final NamFoodApiService apiService = NamFoodApiService();
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getdashbordlist();
    getstoredetailmenuList();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  //AddtoCart
  List<StoreListData> dashlistpage = [];
  List<StoreListData> dashlistpageAll = [];
  bool isLoading = false;

  Future getdashbordlist() async {
    await apiService.getBearerToken();
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getdashStoreList();
      var response = storeListModelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          dashlistpage = response.list;
          dashlistpageAll = dashlistpage;
          isLoading = false;
        });
      } else {
        setState(() {
          dashlistpage = [];
          dashlistpageAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        dashlistpage = [];
        dashlistpageAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  List<CategoryProductList> storedetailslistpage = [];
  List<CategoryProductList> storedetailslistpageAll = [];
  Map<String, Map<String, int>> categoryProductQuantities = {};

  Future<void> addquantity(
      String storeid, String productid, categoryIndex, productIndex) async {
    Map<String, dynamic> postData = {
      "store_id": storeid,
      "product_id": productid,
    };

    try {
      var result = await apiService.addquantity(postData);
      AddQtymodel response = addQtymodelFromJson(result);

      if (response.status == 'SUCCESS') {
        setState(() {});
        // showInSnackBar(context, response.message);
        setState(() {
          _increment(categoryIndex, productIndex);
        });
      } else {
        print(response.code);
        if (response.code == '113') {
          setState(() {
            _decrement(categoryIndex, productIndex);
            showInSnackBar(
                context, "Need to delete your Cart and Add this Menu");
          });
        }
        // showInSnackBar(context, response.message);
      }
    } catch (error) {
      print('Error adding quantity: $error');
      showInSnackBar(context, 'Failed to add quantity. Please try again.');
    }
  }

  Future<void> removequantity(String storeid, String productid) async {
    Map<String, dynamic> postData = {
      "store_id": storeid,
      "product_id": productid,
    };

    try {
      var result = await apiService.removequantity(postData);
      RemoveQtymodel response = removeQtymodelFromJson(result);

      if (response.status.toString() == 'SUCCESS') {
        setState(() {});
        //  showInSnackBar(context, response.message.toString());
      } else {
        showInSnackBar(context, response.message.toString());
      }
    } catch (error) {
      print('Error removing quantity: $error');
      showInSnackBar(context, 'Failed to remove quantity. Please try again.');
    }
  }

  Future<void> deletequantity(String storeid, String productid) async {
    Map<String, dynamic> postData = {
      "store_id": storeid,
      "product_id": productid,
    };

    try {
      var result = await apiService.deletequantity(postData);
      RemoveQtymodel response = removeQtymodelFromJson(result);

      if (response.status.toString() == 'SUCCESS') {
        setState(() {});
        showInSnackBar(context, response.message.toString());
      } else {
        showInSnackBar(context, response.message.toString());
      }
    } catch (error) {
      print('Error removing quantity: $error');
      showInSnackBar(context, 'Failed to remove quantity. Please try again.');
    }
  }

  int cartItemCount = 0;
  double totalPrice = 0.0;
  int totalQuantity = 0;
  bool _showCounter = false;

  Set<String> selectedItems = {};
  Map<int, List<int>> dishQuantities =
      {}; // Map to store quantities for each category

  void _increment(int categoryIndex, int dishIndex) {
    if (isLoading) return;

    setState(() {
      // Use a unique identifier for the selected item
      selectedItems.add('${categoryIndex}_$dishIndex');

      // Ensure dishQuantities for the category is initialized
      if (dishQuantities[categoryIndex] == null) {
        if (storedetailslistpage[categoryIndex]?.products == null) return;

        dishQuantities[categoryIndex] =
            List.filled(storedetailslistpage[categoryIndex].products.length, 0);
      }

      var category = storedetailslistpage[categoryIndex];
      if (category.products == null || dishIndex >= category.products.length) {
        return;
      }

      var priceString = category.products[dishIndex].itemOfferPrice;

      if (priceString != null) {
        double price = double.tryParse(priceString) ?? 0.0;

        // Increment quantity
        dishQuantities[categoryIndex]?[dishIndex] =
            (dishQuantities[categoryIndex]?[dishIndex] ?? 0) + 1;

        totalQuantity++;
        totalPrice += price;
      }
    });
  }

  void _decrement(int categoryIndex, int dishIndex) {
    if (isLoading) return;

    setState(() {
      // Ensure dishQuantities for the category is initialized
      if (dishQuantities[categoryIndex] == null) return;

      var category = storedetailslistpage[categoryIndex];
      if (category.products == null || dishIndex >= category.products.length) {
        return;
      }

      var priceString = category.products[dishIndex].itemOfferPrice;
      var quantity = dishQuantities[categoryIndex]?[dishIndex] ?? 0;

      if (priceString != null && quantity > 0) {
        double price = double.tryParse(priceString) ?? 0.0;

        // Decrement quantity
        dishQuantities[categoryIndex]?[dishIndex] = quantity - 1;
        totalQuantity--;
        totalPrice -= price;

        // Remove item from selectedItems if quantity is 0
        if (dishQuantities[categoryIndex]?[dishIndex] == 0) {
          selectedItems.remove('${categoryIndex}_$dishIndex');
        }
      }
    });
  }

  Future<void> getstoredetailmenuList() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getstoredetailmenuList("17");
      var response = storedetailmenulistmodelFromJson(result);

      if (response.status.toString().toUpperCase() == 'SUCCESS') {
        print("print");
        setState(() {
          storedetailslistpage = response.categoryProductList;
          storedetailslistpageAll = storedetailslistpage;
          print(storedetailslistpage);
          isLoading = false;
        });
      } else {
        setState(() {
          storedetailslistpage = [];
          storedetailslistpageAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
        print(response.message.toString());
      }
    } catch (e) {
      setState(() {
        storedetailslistpage = [];
        storedetailslistpageAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
      print(e);
    }
  }

  String? cartdetails;
  List<CartListData> cartList = [];
  List<CartListData> cartListAll = [];
  bool isLoadingcart = false;
  int? cartstoreid;
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
          isLoadingcart = false;
          cartstoreid = cartList.isNotEmpty ? cartList.first.storeId ?? 0 : 0;
          print("cart store id $cartstoreid");
          // calculateTotalDiscount();
        });
        if (cartList.isEmpty) {
          showInSnackBar(context, 'Your cart is empty');
        }
      } else {
        setState(() {
          cartList = [];
          cartListAll = [];
          isLoadingcart = false;
        });
        // showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        cartList = [];
        cartListAll = [];
        isLoadingcart = false;
      });
      //  showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFE23744),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          toolbarHeight: 100,
          title: Column(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomeTextField(
                      hint: "Restaurant name",
                      prefixIcon: Image.asset(AppAssets.search_icon),
                      boxColor: Colors.white,
                      borderColor: Colors.white,
                      focusBorderColor: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      boxRadius: BorderRadius.circular(10),
                      hintColor: const Color.fromARGB(255, 94, 93, 93),
                      labelColor: const Color.fromARGB(255, 103, 103, 103),
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            dashlistpage = dashlistpageAll
                                .where((store) => store.name!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();

                            storedetailslistpage = storedetailslistpageAll
                                .map((category) {
                                  final filteredProducts =
                                      category.products.where((product) {
                                    return product.itemName != null &&
                                        product.itemName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase());
                                  }).toList();

                                  return CategoryProductList(
                                    categoryId: category.categoryId,
                                    categoryName: category.categoryName,
                                    description: category.description,
                                    slug: category.slug,
                                    serial: category.serial,
                                    imageUrl: category.imageUrl,
                                    products: filteredProducts,
                                    createdDate: category.createdDate,
                                  );
                                })
                                .where(
                                    (category) => category.products.isNotEmpty)
                                .toList();

                            int targetIndex;
                            if (dashlistpage.isNotEmpty) {
                              targetIndex = 0;
                            } else if (storedetailslistpage.isNotEmpty) {
                              targetIndex = 1;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("No matching results found!")),
                              );
                              return; // No need to animate if no matches
                            }

                            // Validate and animate to target index
                            if (targetIndex >= 0 &&
                                targetIndex < _tabController.length) {
                              _tabController.animateTo(targetIndex);
                            } else {
                              debugPrint('Invalid target index: $targetIndex');
                            }
                          } else {
                            dashlistpage = List.from(dashlistpageAll);
                            storedetailslistpage =
                                List.from(storedetailslistpageAll);
                          }
                        });

                        _searchController.clear();
                      })),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white, // Tab indicator color matching AppBar
            labelColor: Colors.white, // Tab text color matching AppBar
            unselectedLabelColor: Colors.white
                .withOpacity(0.7), // Optional for unselected tab text
            tabs: [
              Tab(text: "Store"),
              Tab(text: "Menu"),
            ],
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.only(top: 20),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Store Tab
                    ListView.builder(
                      itemCount: dashlistpage.length,
                      itemBuilder: (context, index) {
                        final e = dashlistpage[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 18, 5),
                          child: e.storeStatus == 1
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xFFEEEEEE),
                                      width: 0.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 196, 195, 195)
                                                .withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Handle tap action here
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              e.frontImg == null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.asset(
                                                        AppAssets.foodimg,
                                                        height: 150,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        AppConstants
                                                                .imgBaseUrl +
                                                            e.frontImg
                                                                .toString(),
                                                        height: 150,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.name.toString(),
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "${e.address}, ${e.city}, ${e.state}, ${e.zipcode}",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        );
                      },
                    ),
                    // Menu Tab
                    ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: storedetailslistpage.length,
                      itemBuilder: (context, categoryIndex) {
                        final category = storedetailslistpage[categoryIndex];

                        if (category.products.isEmpty) {
                          return SizedBox.shrink();
                        }

                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  category.categoryName!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: category.products.length,
                                itemBuilder: (context, productIndex) {
                                  final product =
                                      category.products[productIndex];

                                  int productId =
                                      int.tryParse(product.itemId.toString()) ??
                                          0;
                                  int storeId = int.tryParse(
                                          product.storeId.toString()) ??
                                      0;
                                  int quantity =
                                      categoryProductQuantities[storeId]
                                              ?[productId] ??
                                          0;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      if (product.itemStock == 1)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  if (product.itemImageUrl
                                                          .toString() !=
                                                      null)
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: SizedBox(
                                                        width: 100,
                                                        height: 100,
                                                        child: Image.network(
                                                          AppConstants
                                                                  .imgBaseUrl +
                                                              product
                                                                  .itemImageUrl
                                                                  .toString(),
                                                          fit: BoxFit.contain,
                                                          height: 60.0,
                                                          errorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                            return Image.asset(
                                                                AppAssets
                                                                    .storeBiriyaniImg,
                                                                width: 120.0,
                                                                height: 120.0,
                                                                fit: BoxFit
                                                                    .cover);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  Positioned(
                                                    bottom: -13,
                                                    left: 8,
                                                    right: 8,
                                                    child: dishQuantities[
                                                                        categoryIndex]
                                                                    ?[
                                                                    productIndex] !=
                                                                null &&
                                                            dishQuantities[
                                                                        categoryIndex]
                                                                    ?[
                                                                    productIndex] !=
                                                                0
                                                        ? Container(
                                                            height: 35,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        2.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .red),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () =>
                                                                      setState(
                                                                          () {
                                                                    _decrement(
                                                                        categoryIndex,
                                                                        productIndex);

                                                                    if (dishQuantities[categoryIndex]![
                                                                            productIndex] >
                                                                        0) {
                                                                      removequantity(
                                                                          storeId
                                                                              .toString(),
                                                                          productId
                                                                              .toString());
                                                                    } else {
                                                                      deletequantity(
                                                                          storeId
                                                                              .toString(),
                                                                          productId
                                                                              .toString());
                                                                    }
                                                                  }),
                                                                  child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 22),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5.0),
                                                                  child: Text(
                                                                    '${dishQuantities[categoryIndex]?[productIndex]}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () =>
                                                                      setState(
                                                                          () {
                                                                    addquantity(
                                                                        storeId
                                                                            .toString(),
                                                                        productId
                                                                            .toString(),
                                                                        categoryIndex,
                                                                        productIndex);
                                                                    // _increment(
                                                                    // categoryIndex,
                                                                    // productIndex);
                                                                  }),
                                                                  child: Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 22),
                                                                ),
                                                              ],
                                                            ))
                                                        : GestureDetector(
                                                            onTap: () =>
                                                                setState(() {
                                                              print(
                                                                  "cart test $cartdetails");
                                                              addquantity(
                                                                  product
                                                                      .storeId
                                                                      .toString(),
                                                                  product.itemId
                                                                      .toString(),
                                                                  categoryIndex,
                                                                  productIndex);
                                                              // print(
                                                              //     "storeid $StoreIddetails");
                                                              // print(
                                                              //     "cartstoreid $cartstoreid");
                                                              // StoreIddetails != cartstoreid ||
                                                              //         cartstoreid !=
                                                              //             0 ||
                                                              //         cartstoreid !=
                                                              //             null
                                                              //     ? _increment(
                                                              //         categoryIndex,
                                                              //         productIndex)
                                                              //     : showInSnackBar(
                                                              //         context,
                                                              //         "Need To Clear Your Old Cart and Add this Hotel Menu");
                                                            }),
                                                            child: Container(
                                                              height: 33,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .red),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          5.0),
                                                                  Text(
                                                                    "Add",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 16),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        product.itemType == 1
                                                            ? Image.asset(
                                                                AppAssets
                                                                    .nonveg_icon,
                                                                width: 20,
                                                                height: 20,
                                                              )
                                                            : Image.asset(
                                                                AppAssets
                                                                    .veg_icon,
                                                                width: 20,
                                                                height: 20,
                                                              ),
                                                        SizedBox(
                                                          width: 3.0,
                                                        ),
                                                        HeadingWidget(
                                                          title: product
                                                                      .itemType ==
                                                                  1
                                                              ? "Non Veg"
                                                              : "Veg", // 'Non-Veg',
                                                          vMargin: 1.0,
                                                          fontSize: 13.0,
                                                        ),
                                                      ],
                                                    ),
                                                    HeadingWidget(
                                                      title: product.itemName,
                                                      // e.dishname, // "Chicken Biryani",
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      vMargin: 1.0,
                                                    ),
                                                    Row(children: [
                                                      Text(
                                                        "₹${product.itemPrice.toString()}",
                                                        //'₹150.0',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      HeadingWidget(
                                                        title:
                                                            "₹${product.itemOfferPrice}", // '₹100.0',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        vMargin: 1.0,
                                                      ),
                                                    ]),
                                                    // Row(
                                                    //   children: [
                                                    //     Flexible(
                                                    //         child:
                                                    //             SubHeadingWidget(
                                                    //       title: product
                                                    //                   .itemDesc ==
                                                    //               null
                                                    //           ? ''
                                                    //           : product
                                                    //               .itemDesc
                                                    //               .toString(),
                                                    //       color:
                                                    //           AppColors.black,
                                                    //       vMargin: 1.0,
                                                    //     )),
                                                    //   ],
                                                    // )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      // Out Of Stock

                                      if (product.itemStock == 0)
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 194, 194, 194),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                              color: Color.fromARGB(
                                                  255, 213, 212, 212)),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                child: Row(
                                                  children: [
                                                    Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        if (product
                                                                .itemImageUrl !=
                                                            null)
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: SizedBox(
                                                              width: 100,
                                                              height: 100,
                                                              child:
                                                                  Image.network(
                                                                AppConstants
                                                                        .imgBaseUrl +
                                                                    product
                                                                        .itemImageUrl
                                                                        .toString(),
                                                                fit: BoxFit
                                                                    .contain,
                                                                height: 60.0,
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                    AppAssets
                                                                        .storeBiriyaniImg,
                                                                    width:
                                                                        120.0,
                                                                    height:
                                                                        120.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    SizedBox(width: 16),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              product.itemType ==
                                                                      1
                                                                  ? Image.asset(
                                                                      AppAssets
                                                                          .nonveg_icon,
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                    )
                                                                  : Image.asset(
                                                                      AppAssets
                                                                          .veg_icon,
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                    ),
                                                              SizedBox(
                                                                  width: 3.0),
                                                              HeadingWidget(
                                                                title: product
                                                                            .itemType ==
                                                                        1
                                                                    ? "Non Veg"
                                                                    : "Veg",
                                                                vMargin: 1.0,
                                                                fontSize: 13.0,
                                                              ),
                                                            ],
                                                          ),
                                                          HeadingWidget(
                                                            title: product
                                                                .itemName,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            vMargin: 1.0,
                                                            color: Colors.black,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "₹${product.itemPrice.toString()}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                              HeadingWidget(
                                                                title:
                                                                    "₹${product.itemOfferPrice}",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                vMargin: 1.0,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Flexible(
                                                                child:
                                                                    SubHeadingWidget(
                                                                  title: product
                                                                              .itemDesc ==
                                                                          null
                                                                      ? ''
                                                                      : "",
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  vMargin: 1.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (product.itemStock == 0)
                                                Positioned.fill(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    color: const Color.fromARGB(
                                                            255, 112, 112, 112)
                                                        .withOpacity(0.3),
                                                    child: Text(
                                                      "     Out of Stock",
                                                      style: TextStyle(
                                                        color: AppColors.red,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),

                                      SizedBox(
                                        height: 20,
                                      ),
                                      Divider(
                                          height: 1,
                                          thickness: 0.5,
                                          color: AppColors.grey),
                                    ],
                                  );
                                },
                              ),
                              // ],
                            ]);
                      },
                    )
                  ],
                ),
              ));
  }
}

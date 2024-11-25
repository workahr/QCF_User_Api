import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:namfood/pages/HomeScreen/home_screen.dart';
import 'package:namfood/pages/cart/cart_page.dart';
import 'package:namfood/widgets/custom_text_field.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../models/homescreen_model.dart';
import '../models/store_list_model.dart';
import '../rating/add_rating_page.dart';
import '../rating/rating_list_page.dart';
import 'store_detailsmenu_model.dart';
import 'storepage_addqty_model.dart';
import 'storepage_removeqty_model.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final NamFoodApiService apiService = NamFoodApiService();

  int cartItemCount = 0;
  double totalPrice = 0.0;
  int totalQuantity = 0;
  bool _showCounter = false;

  void _toggleCounter() {
    setState(() {
      _showCounter = true;
    });
  }

  StoreDetails storeDetails = StoreDetails(
    storeId: 0,
    userId: 0,
    name: '',
    mobile: '',
    email: '',
    address: '',
    city: '',
    state: '',
    country: '',
    logo: '',
    gstNo: '',
    panNo: '',
    terms: '',
    zipcode: '',
    frontImg: '',
    onlineVisibility: '',
    tags: '',
    status: 0,
    createdBy: '',
    createdDate: '',
    updatedBy: '',
    updatedDate: '',
    slug: '',
    storeStatus: 0,
  );

  bool isLoading = true;
  List<CategoryProductList> storedetailslistpage = [];
  List<CategoryProductList> storedetailslistpageAll = [];
  //List<StoreDetails> storeDetails = [];

  @override
  void initState() {
    super.initState();
    getstoredetailmenuList();
    getStoreDetails();
  }

  Future<void> getStoreDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Make the API call
      var result = await apiService.getstoredetailmenuList(1);
      // Parse the JSON response into a Storedetailmenulistmodel
      var response = storedetailmenulistmodelFromJson(result);

      // Check the status and update the state
      if (response.status.toString().toUpperCase() == 'SUCCESS') {
        setState(() {
          storeDetails = response.details; // Store details here
          isLoading = false;
        });

        // Access the store name after fetching the details
        String storeName = response.details.name;
        print('Store Name: $storeName'); // Now you have the store name
      } else {
        setState(() {
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }
  }

  Future<void> getstoredetailmenuList() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getstoredetailmenuList(1);
      var response = storedetailmenulistmodelFromJson(result);

      if (response.status.toString().toUpperCase() == 'SUCCESS') {
        setState(() {
          storedetailslistpage = response.categoryProductList;
          storedetailslistpageAll = storedetailslistpage;

          isLoading = false;
        });
      } else {
        setState(() {
          storedetailslistpage = [];
          storedetailslistpageAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        storedetailslistpage = [];
        storedetailslistpageAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }
  }

  Map<String, Map<String, int>> categoryProductQuantities = {};

  Future<void> addquantity(String storeid, String productid) async {
    Map<String, dynamic> postData = {
      "store_id": storeid,
      "product_id": productid,
    };

    try {
      var result = await apiService.addquantity(postData);
      AddQtymodel response = addQtymodelFromJson(result);

      if (response.status == 'SUCCESS') {
        setState(() {});
        showInSnackBar(context, response.message);
      } else {
        showInSnackBar(context, response.message);
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
        showInSnackBar(context, response.message.toString());
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

  OverlayEntry? _overlayEntry;
  bool isOverlayVisible = false;

  void _showOverlay(BuildContext context) async {
    if (_overlayEntry == null) {
      // Show loading overlay while fetching data
      OverlayEntry loadingOverlay = OverlayEntry(
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );
      Overlay.of(context)?.insert(loadingOverlay);

      // Fetch data from API
      await getstoredetailmenuList();

      // Remove loading overlay
      loadingOverlay.remove();

      // Check if there are categories to display
      if (storedetailslistpage.isEmpty) {
        showInSnackBar(context, "No categories available.");
        return;
      }

      // Create the overlay with data
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: 170.0,
          right: 20.0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 250,
              padding: EdgeInsets.only(
                  top: 1.0, left: 20.0, right: 25.0, bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: storedetailslistpage.length,
                itemBuilder: (context, categoryIndex) {
                  final category = storedetailslistpage[categoryIndex];
                  final String categoryName = category.categoryName;
                  final List<Product> products = category.products;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            categoryName,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            '${products.length}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Insert the overlay
      Overlay.of(context)?.insert(_overlayEntry!);

      // Update the overlay visibility state
      setState(() {
        isOverlayVisible = true;
      });
    }
  }

  void _removeOverlay() {
    // Remove the overlay if it exists
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      isOverlayVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (isOverlayVisible) {
            _removeOverlay();
            return false;
          }
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.lightGrey3,
              title: HeadingWidget(title: "Back"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: HeadingWidget(
                                            title: storeDetails
                                                .name, // 'Grill Chicken Arabian Restaurant',
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RatingListPage(),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: AppColors.light,
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        '4.5',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.light,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                SubHeadingWidget(
                                                  title: '252K Rating',
                                                  fontSize: 12.0,
                                                  color: AppColors.red,
                                                ),
                                                SizedBox(
                                                    width: 60,
                                                    child: DottedLine(
                                                      direction:
                                                          Axis.horizontal,
                                                      dashColor: AppColors.red,
                                                      lineLength: 80,
                                                      dashLength: 2,
                                                      dashGapLength: 2,
                                                    )),
                                              ],
                                            ))
                                      ],
                                    ),
                                    // SizedBox(height: 4),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     SubHeadingWidget(
                                    //       title: '2.5km • 10mins',
                                    //       fontSize: 14.0,
                                    //       color: AppColors.black,
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: 4),
                                    SubHeadingWidget(
                                      title: 'South Indian Foods',
                                      fontSize: 14.0,
                                      color: AppColors.black,
                                    ),
                                  ])),
                          Column(
                            children: [
                              DottedLine(
                                direction: Axis.horizontal,
                                dashColor: Color(0xFFE23744),
                                lineLength: MediaQuery.of(context).size.width,
                                dashLength: 2,
                                dashGapLength: 2,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      AppAssets.offerimg,
                                      height: 25,
                                      width: 25,
                                    ),
                                    SizedBox(width: 8),
                                    // Text(
                                    //   '40% Off • Upto ₹90',
                                    //   style: TextStyle(
                                    //     fontSize: 14,
                                    //     color: Colors.red,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    CustomeTextField(
                      width: MediaQuery.of(context).size.width - 10.0,
                      hint: 'Find your dish',
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.red,
                      ),
                      labelColor: Colors.grey[900],
                      focusBorderColor: AppColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderColor: AppColors.lightGrey3,
                    ),
                    SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: storedetailslistpage.length,
                      itemBuilder: (context, categoryIndex) {
                        final category = storedetailslistpage[categoryIndex];
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  category.categoryName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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

                                  // Check if the quantity exists, otherwise default to 0
                                  int quantity =
                                      categoryProductQuantities[storeId]
                                              ?[productId] ??
                                          0;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
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
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        AppConstants
                                                                .imgBaseUrl +
                                                            product.itemImageUrl
                                                                .toString(),
                                                        width: double.infinity,
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
                                                              fit:
                                                                  BoxFit.cover);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                Positioned(
                                                  bottom: -13,
                                                  left: 10,
                                                  right: 10,
                                                  child: dishQuantities[
                                                                      categoryIndex]?[
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
                                                                color:
                                                                    Colors.red),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.white,
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
                                                                  _increment(
                                                                      categoryIndex,
                                                                      productIndex);

                                                                  addquantity(
                                                                      storeId
                                                                          .toString(),
                                                                      productId
                                                                          .toString());
                                                                }),
                                                                child: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 25),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10.0),
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
                                                                  _decrement(
                                                                      categoryIndex,
                                                                      productIndex);

                                                                  if (dishQuantities[
                                                                              categoryIndex]![
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
                                                                    size: 25),
                                                              ),
                                                            ],
                                                          ))
                                                      : GestureDetector(
                                                          onTap: () =>
                                                              setState(() {
                                                            addquantity(
                                                                product.storeId
                                                                    .toString(),
                                                                product.itemId
                                                                    .toString());
                                                            _increment(
                                                                categoryIndex,
                                                                productIndex);
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
                                                              color:
                                                                  Colors.white,
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
                                                                    width: 5.0),
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
                                            Expanded(
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
                                                    fontWeight: FontWeight.bold,
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
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child:
                                                              SubHeadingWidget(
                                                        title: product
                                                                    .itemDesc ==
                                                                null
                                                            ? ''
                                                            : product.itemDesc
                                                                .toString(),
                                                        color: AppColors.black,
                                                        vMargin: 1.0,
                                                      )),
                                                    ],
                                                  )
                                                ],
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
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              height: 80.0,
              elevation: 0,
              color: AppColors.light,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SubHeadingWidget(
                            title:
                                "${selectedItems.length} item${selectedItems.length == 1 ? '' : 's'}",
                            color: AppColors.black,
                            fontSize: 15.0,
                          ),
                          HeadingWidget(
                            title: "Price: ₹${totalPrice.toStringAsFixed(2)}",
                            color: AppColors.red,
                            fontSize: 18.0,
                          ),
                        ],
                      ),
                      SizedBox(
                          width: 140,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to cart
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CartPage(),
                                        ),
                                      );
                                    },
                                    child: SubHeadingWidget(
                                      title: "Go to cart",
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: GestureDetector(
              onTap: () {
                if (isOverlayVisible) {
                  _removeOverlay();
                } else {
                  _showOverlay(context);
                }
              },
              child: isOverlayVisible
                  ? Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            Text(
                              "Close",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.noteBookImg,
                              width: 20,
                              height: 20,
                              color: AppColors.light,
                            ),
                            Text(
                              "Menu",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            )));
  }
}













// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:namfood/pages/HomeScreen/home_screen.dart';
// import 'package:namfood/pages/cart/cart_page.dart';
// import 'package:namfood/widgets/custom_text_field.dart';

// import '../../constants/app_assets.dart';
// import '../../constants/app_colors.dart';
// import '../../constants/app_constants.dart';
// import '../../services/comFuncService.dart';
// import '../../services/nam_food_api_service.dart';
// import '../../widgets/heading_widget.dart';
// import '../../widgets/sub_heading_widget.dart';
// import '../models/homescreen_model.dart';
// import '../models/store_list_model.dart';
// import '../rating/add_rating_page.dart';
// import '../rating/rating_list_page.dart';
// import 'store_detailsmenu_model.dart';

// class StorePage extends StatefulWidget {
//   const StorePage({super.key});

//   @override
//   _StorePageState createState() => _StorePageState();
// }

// class _StorePageState extends State<StorePage> {
//   final NamFoodApiService apiService = NamFoodApiService();

//   int cartItemCount = 0;
//   double totalPrice = 0.0;
//   int totalQuantity = 0;
//   bool _showCounter = false;

//   void _toggleCounter() {
//     setState(() {
//       _showCounter = true;
//     });
//   }

//   StoreDetails storeDetails = StoreDetails(
//     storeId: 0,
//     userId: 0,
//     name: '',
//     mobile: '',
//     email: '',
//     address: '',
//     city: '',
//     state: '',
//     country: '',
//     logo: '',
//     gstNo: '',
//     panNo: '',
//     terms: '',
//     zipcode: '',
//     frontImg: '',
//     onlineVisibility: '',
//     tags: '',
//     status: 0,
//     createdBy: '',
//     createdDate: '',
//     updatedBy: '',
//     updatedDate: '',
//     slug: '',
//     storeStatus: 0,
//   );

//   bool isLoading = true;
//   List<CategoryProductList> storedetailslistpage = [];
//   List<CategoryProductList> storedetailslistpageAll = [];
//   //List<StoreDetails> storeDetails = [];

//   @override
//   void initState() {
//     super.initState();
//     getstoredetailmenuList();
//     getStoreDetails();
//   }


//   Future<void> getStoreDetails() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       // Make the API call
//       var result = await apiService.getstoredetailmenuList(1);
//       // Parse the JSON response into a Storedetailmenulistmodel
//       var response = storedetailmenulistmodelFromJson(result);

//       // Check the status and update the state
//       if (response.status.toString().toUpperCase() == 'SUCCESS') {
//         setState(() {
//           storeDetails = response.details; // Store details here
//           isLoading = false;
//         });

//         // Access the store name after fetching the details
//         String storeName = response.details.name;
//         print('Store Name: $storeName'); // Now you have the store name
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       showInSnackBar(context, 'Error occurred: $e');
//     }
//   }

//   Future<void> getstoredetailmenuList() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getstoredetailmenuList(1);
//       var response = storedetailmenulistmodelFromJson(result);

//       if (response.status.toString().toUpperCase() == 'SUCCESS') {
//         setState(() {
//           storedetailslistpage = response.categoryProductList;
//           storedetailslistpageAll = storedetailslistpage;

//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           storedetailslistpage = [];
//           storedetailslistpageAll = [];
//           isLoading = false;
//         });
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         storedetailslistpage = [];
//         storedetailslistpageAll = [];
//         isLoading = false;
//       });
//       showInSnackBar(context, 'Error occurred: $e');
//     }
//   }

//   Set<String> selectedItems = {};
//   Map<int, List<int>> dishQuantities =
//       {}; // Map to store quantities for each category

//   void _increment(int categoryIndex, int dishIndex) {
//     if (isLoading) return;

//     setState(() {
//       // Use a unique identifier for the selected item
//       selectedItems.add('${categoryIndex}_$dishIndex');

//       // Ensure dishQuantities for the category is initialized
//       if (dishQuantities[categoryIndex] == null) {
//         if (storedetailslistpage[categoryIndex]?.products == null) return;

//         dishQuantities[categoryIndex] =
//             List.filled(storedetailslistpage[categoryIndex].products.length, 0);
//       }

//       var category = storedetailslistpage[categoryIndex];
//       if (category.products == null || dishIndex >= category.products.length) {
//         return;
//       }

//       var priceString = category.products[dishIndex].itemOfferPrice;

//       if (priceString != null) {
//         double price = double.tryParse(priceString) ?? 0.0;

//         // Increment quantity
//         dishQuantities[categoryIndex]?[dishIndex] =
//             (dishQuantities[categoryIndex]?[dishIndex] ?? 0) + 1;

//         totalQuantity++;
//         totalPrice += price;
//       }
//     });
//   }

//   void _decrement(int categoryIndex, int dishIndex) {
//     if (isLoading) return;

//     setState(() {
//       // Ensure dishQuantities for the category is initialized
//       if (dishQuantities[categoryIndex] == null) return;

//       var category = storedetailslistpage[categoryIndex];
//       if (category.products == null || dishIndex >= category.products.length) {
//         return;
//       }

//       var priceString = category.products[dishIndex].itemOfferPrice;
//       var quantity = dishQuantities[categoryIndex]?[dishIndex] ?? 0;

//       if (priceString != null && quantity > 0) {
//         double price = double.tryParse(priceString) ?? 0.0;

//         // Decrement quantity
//         dishQuantities[categoryIndex]?[dishIndex] = quantity - 1;
//         totalQuantity--;
//         totalPrice -= price;

//         // Remove item from selectedItems if quantity is 0
//         if (dishQuantities[categoryIndex]?[dishIndex] == 0) {
//           selectedItems.remove('${categoryIndex}_$dishIndex');
//         }
//       }
//     });
//   }

//   // OverlayEntry? _overlayEntry;
//   // bool isOverlayVisible = false;

//   // void _showOverlay(BuildContext context) {
//   //   if (_overlayEntry == null) {
//   //     _overlayEntry = OverlayEntry(
//   //       builder: (context) => Positioned(
//   //         bottom: 170.0,
//   //         right: 20.0,
//   //         child: Material(
//   //           color: Colors.transparent,
//   //           child: Container(
//   //             width: 250,
//   //             padding: EdgeInsets.only(
//   //                 top: 1.0, left: 20.0, right: 25.0, bottom: 10.0),
//   //             decoration: BoxDecoration(
//   //               color: Colors.black,
//   //               borderRadius: BorderRadius.circular(16.0),
//   //             ),
//   //             child: ListView.builder(
//   //               shrinkWrap: true,
//   //               physics: NeverScrollableScrollPhysics(),
//   //               itemCount: storedetailslistpage.length,
//   //               itemBuilder: (context, categoryIndex) {
//   //                 String category = storedetailslistpage.keys.elementAt(categoryIndex);
//   //                 List<StoreDish> dishes = storedetailslistpage.category!;

//   //                 return Column(
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //                   children: [
//   //                     Row(
//   //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                       children: [
//   //                         Text(
//   //                           category,
//   //                           style: TextStyle(color: Colors.white, fontSize: 16),
//   //                         ),
//   //                         Text(
//   //                           '${dishes.length}',
//   //                           style: TextStyle(color: Colors.white, fontSize: 16),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                     SizedBox(height: 15),
//   //                   ],
//   //                 );
//   //               },
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     );

//   //     Overlay.of(context)?.insert(_overlayEntry!);
//   //     setState(() {
//   //       isOverlayVisible = true;
//   //     });
//   //   }
//   // }

//   // void _removeOverlay() {
//   //   _overlayEntry?.remove();
//   //   _overlayEntry = null;
//   //   setState(() {
//   //     isOverlayVisible = false;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.lightGrey3,
//         title: HeadingWidget(title: "Back"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15.0),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: HeadingWidget(
//                                       title: storeDetails
//                                           .name, // 'Grill Chicken Arabian Restaurant',
//                                       fontSize: 22.0,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 RatingListPage(),
//                                           ),
//                                         );
//                                       },
//                                       child: Column(
//                                         children: [
//                                           Container(
//                                             padding: EdgeInsets.symmetric(
//                                               vertical: 4.0,
//                                               horizontal: 8.0,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: AppColors.red,
//                                               borderRadius:
//                                                   BorderRadius.circular(12.0),
//                                             ),
//                                             child: Row(
//                                               children: [
//                                                 Icon(
//                                                   Icons.star,
//                                                   color: AppColors.light,
//                                                   size: 16,
//                                                 ),
//                                                 SizedBox(width: 4),
//                                                 Text(
//                                                   '4.5',
//                                                   style: TextStyle(
//                                                     color: AppColors.light,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 5.0,
//                                           ),
//                                           SubHeadingWidget(
//                                             title: '252K Rating',
//                                             fontSize: 12.0,
//                                             color: AppColors.red,
//                                           ),
//                                           SizedBox(
//                                               width: 60,
//                                               child: DottedLine(
//                                                 direction: Axis.horizontal,
//                                                 dashColor: AppColors.red,
//                                                 lineLength: 80,
//                                                 dashLength: 2,
//                                                 dashGapLength: 2,
//                                               )),
//                                         ],
//                                       ))
//                                 ],
//                               ),
//                               // SizedBox(height: 4),
//                               // Row(
//                               //   mainAxisAlignment:
//                               //       MainAxisAlignment.spaceBetween,
//                               //   children: [
//                               //     SubHeadingWidget(
//                               //       title: '2.5km • 10mins',
//                               //       fontSize: 14.0,
//                               //       color: AppColors.black,
//                               //     ),
//                               //   ],
//                               // ),
//                               SizedBox(height: 4),
//                               SubHeadingWidget(
//                                 title: 'South Indian Foods',
//                                 fontSize: 14.0,
//                                 color: AppColors.black,
//                               ),
//                             ])),
//                     Column(
//                       children: [
//                         DottedLine(
//                           direction: Axis.horizontal,
//                           dashColor: Color(0xFFE23744),
//                           lineLength: MediaQuery.of(context).size.width,
//                           dashLength: 2,
//                           dashGapLength: 2,
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                               vertical: 8.0, horizontal: 8.0),
//                           decoration: BoxDecoration(
//                             color: Colors.red[50],
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(8.0),
//                               bottomRight: Radius.circular(8.0),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Image.asset(
//                                 AppAssets.offerimg,
//                                 height: 25,
//                                 width: 25,
//                               ),
//                               SizedBox(width: 8),
//                               // Text(
//                               //   '40% Off • Upto ₹90',
//                               //   style: TextStyle(
//                               //     fontSize: 14,
//                               //     color: Colors.red,
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               CustomeTextField(
//                 width: MediaQuery.of(context).size.width - 10.0,
//                 hint: 'Find your dish',
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: AppColors.red,
//                 ),
//                 labelColor: Colors.grey[900],
//                 focusBorderColor: AppColors.primary,
//                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                 borderColor: AppColors.lightGrey3,
//               ),
//               SizedBox(height: 5),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: storedetailslistpage.length,
//                 itemBuilder: (context, categoryIndex) {
//                   final category = storedetailslistpage[categoryIndex];
//                   return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8.0, horizontal: 16.0),
//                           child: Text(
//                             category.categoryName,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: category.products.length,
//                           itemBuilder: (context, productIndex) {
//                             final product = category.products[productIndex];
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: 10),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16.0, vertical: 8.0),
//                                   child: Row(
//                                     children: [
//                                       Stack(
//                                         clipBehavior: Clip.none,
//                                         children: [
//                                           if (product.itemImageUrl.toString() !=
//                                               null)
//                                             Expanded(
//                                                 child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               child: Image.network(
//                                                 AppConstants.imgBaseUrl +
//                                                     product.itemImageUrl
//                                                         .toString(),
//                                                 width: double.infinity,
//                                                 fit: BoxFit.contain,
//                                                 height: 60.0,
//                                                 // height: 100.0,
//                                                 errorBuilder: (BuildContext
//                                                         context,
//                                                     Object exception,
//                                                     StackTrace? stackTrace) {
//                                                   return Image.asset(
//                                                       AppAssets
//                                                           .storeBiriyaniImg,
//                                                       width: 120.0,
//                                                       height: 120.0,
//                                                       fit: BoxFit.cover);
//                                                 },
//                                               ),
//                                             )),
//                                           Positioned(
//                                             bottom: -13,
//                                             left: 10,
//                                             right: 10,
//                                             child: Container(
//                                               child: dishQuantities[
//                                                                   categoryIndex]
//                                                               ?[productIndex] !=
//                                                           null &&
//                                                       dishQuantities[
//                                                                   categoryIndex]
//                                                               ?[productIndex] !=
//                                                           0
//                                                   ? Container(
//                                                       height: 35,
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                               horizontal: 2.0),
//                                                       decoration: BoxDecoration(
//                                                         border: Border.all(
//                                                             color: Colors.red),
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10),
//                                                         color: Colors.white,
//                                                       ),
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           GestureDetector(
//                                                             onTap: () => _increment(
//                                                                 categoryIndex,
//                                                                 productIndex),
//                                                             child: Icon(
//                                                               Icons.add,
//                                                               color: Colors.red,
//                                                               size: 25,
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets
//                                                                 .symmetric(
//                                                                     horizontal:
//                                                                         10.0),
//                                                             child: Text(
//                                                               '${dishQuantities[categoryIndex]?[productIndex]}',
//                                                               style: TextStyle(
//                                                                 color:
//                                                                     Colors.red,
//                                                                 fontSize: 20,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           GestureDetector(
//                                                             onTap: () => _decrement(
//                                                                 categoryIndex,
//                                                                 productIndex),
//                                                             child: Icon(
//                                                               Icons.remove,
//                                                               color: Colors.red,
//                                                               size: 25,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )
//                                                   : GestureDetector(
//                                                       onTap: () => _increment(
//                                                           categoryIndex,
//                                                           productIndex),
//                                                       child: Container(
//                                                         height: 33,
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           border: Border.all(
//                                                               color:
//                                                                   Colors.red),
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       10.0),
//                                                           color: Colors.white,
//                                                         ),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             Icon(
//                                                               Icons.add,
//                                                               color: Colors.red,
//                                                             ),
//                                                             SizedBox(
//                                                                 width: 5.0),
//                                                             Text(
//                                                               "Add",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .red,
//                                                                   fontSize: 18),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(width: 16),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 product.itemType == 1
//                                                     ? Image.asset(
//                                                         AppAssets.nonveg_icon,
//                                                         width: 20,
//                                                         height: 20,
//                                                       )
//                                                     : Image.asset(
//                                                         AppAssets.veg_icon,
//                                                         width: 20,
//                                                         height: 20,
//                                                       ),
//                                                 SizedBox(
//                                                   width: 3.0,
//                                                 ),
//                                                 HeadingWidget(
//                                                   title: product.itemType == 1
//                                                       ? "Non Veg"
//                                                       : "Veg", // 'Non-Veg',
//                                                   vMargin: 1.0,
//                                                   fontSize: 13.0,
//                                                 ),
//                                               ],
//                                             ),
//                                             HeadingWidget(
//                                               title: product.itemName,
//                                               // e.dishname, // "Chicken Biryani",
//                                               fontSize: 16.0,
//                                               fontWeight: FontWeight.bold,
//                                               vMargin: 1.0,
//                                             ),
//                                             Row(children: [
//                                               Text(
//                                                 "₹${product.itemPrice.toString()}",
//                                                 //'₹150.0',
//                                                 style: TextStyle(
//                                                   fontSize: 14,
//                                                   decoration: TextDecoration
//                                                       .lineThrough,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 10,
//                                               ),
//                                               HeadingWidget(
//                                                 title:
//                                                     "₹${product.itemOfferPrice}", // '₹100.0',
//                                                 fontWeight: FontWeight.bold,
//                                                 vMargin: 1.0,
//                                               ),
//                                             ]),
//                                             Row(
//                                               children: [
//                                                 Expanded(
//                                                     child: SubHeadingWidget(
//                                                   title:
//                                                       product.itemDesc == null
//                                                           ? ''
//                                                           : product.itemDesc
//                                                               .toString(),
//                                                   color: AppColors.black,
//                                                   vMargin: 1.0,
//                                                 )),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Divider(
//                                     height: 1,
//                                     thickness: 0.5,
//                                     color: AppColors.grey),
//                               ],
//                             );
//                           },
//                         ),
//                         // ],
//                       ]);
//                 },
//               )
//             ],
//           ),
//         ),
//       ),

//       bottomNavigationBar: BottomAppBar(
//         height: 80.0,
//         elevation: 0,
//         color: AppColors.light,
//         child: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.all(4.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SubHeadingWidget(
//                       title:
//                           "${selectedItems.length} item${selectedItems.length == 1 ? '' : 's'}",
//                       color: AppColors.black,
//                       fontSize: 15.0,
//                     ),
//                     HeadingWidget(
//                       title: "Price: ₹${totalPrice.toStringAsFixed(2)}",
//                       color: AppColors.red,
//                       fontSize: 18.0,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                     width: 140,
//                     height: 75,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Navigate to cart
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.red,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                         child: Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => CartPage(),
//                                   ),
//                                 );
//                               },
//                               child: SubHeadingWidget(
//                                 title: "Go to cart",
//                                 color: Colors.white,
//                                 fontSize: 16.0,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ),
//       // floatingActionButton: GestureDetector(
//       //   onTap: () {
//       //     if (isOverlayVisible) {
//       //       _removeOverlay(); // Close the overlay if visible
//       //     } else {
//       //       _showOverlay(context); // Show the overlay if not visible
//       //     }
//       //   },
//       //   child: isOverlayVisible
//       //       ? Container(
//       //           width: 70,
//       //           height: 70,
//       //           decoration: BoxDecoration(
//       //             color: AppColors.black,
//       //             shape: BoxShape.circle,
//       //           ),
//       //           child: Padding(
//       //             padding: const EdgeInsets.all(1.0),
//       //             child: Column(
//       //               mainAxisAlignment: MainAxisAlignment.center,
//       //               crossAxisAlignment: CrossAxisAlignment.center,
//       //               children: [
//       //                 Icon(
//       //                   Icons.close,
//       //                   color: Colors.white,
//       //                 ),
//       //                 Text(
//       //                   "Close",
//       //                   style: TextStyle(
//       //                     color: Colors.white,
//       //                   ),
//       //                 ),
//       //               ],
//       //             ),
//       //           ),
//       //         )
//       //       : Container(
//       //           width: 70,
//       //           height: 70,
//       //           decoration: BoxDecoration(
//       //             color: AppColors.black,
//       //             shape: BoxShape.circle,
//       //           ),
//       //           child: Padding(
//       //             padding: const EdgeInsets.all(1.0),
//       //             child: Column(
//       //               mainAxisAlignment: MainAxisAlignment.center,
//       //               crossAxisAlignment: CrossAxisAlignment.center,
//       //               children: [
//       //                 Image.asset(
//       //                   AppAssets.noteBookImg,
//       //                   width: 20,
//       //                   height: 20,
//       //                   color: AppColors.light,
//       //                 ),
//       //                 Text(
//       //                   "Menu",
//       //                   style: TextStyle(
//       //                     color: Colors.white,
//       //                   ),
//       //                 ),
//       //               ],
//       //             ),
//       //           ),
//       //         ),
//       //  )
//     );
//   }
// }

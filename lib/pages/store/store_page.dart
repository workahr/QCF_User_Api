import 'dart:typed_data';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:namfood/pages/HomeScreen/home_screen.dart';
import 'package:namfood/pages/cart/cart_page.dart';
import 'package:namfood/widgets/custom_text_field.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../HomeScreen/cart_list_model.dart';
import '../models/homescreen_model.dart';
import '../models/store_list_model.dart';
import '../rating/add_rating_page.dart';
import '../rating/rating_list_page.dart';
import 'store_detailsmenu_model.dart';
import 'storepage_addqty_model.dart';
import 'storepage_removeqty_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'save_file_mobile.dart' if (dart.library.html) 'save_file_web.dart';

class StorePage extends StatefulWidget {
  int? storeid;
  StorePage({super.key, this.storeid});

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
  int? StoreIddetails;
  @override
  void initState() {
    super.initState();
    getAllCartList();
    getstoredetailmenuList();
    getStoreDetails();
    getAllCartListforitemvalue();
  }

  Future<void> getStoreDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Make the API call
      var result = await apiService.getstoredetailmenuList(widget.storeid);
      // Parse the JSON response into a Storedetailmenulistmodel
      var response = storedetailmenulistmodelFromJson(result);

      // Check the status and update the state
      if (response.status.toString().toUpperCase() == 'SUCCESS') {
        print("print");
        setState(() {
          storeDetails = response.details; // Store details here
          isLoading = false;
        });

        // Access the store name after fetching the details
        String storeName = response.details.name.toString();
        StoreIddetails = response.details.storeId;
        print('Store Name: $storeName'); // Now you have the store name
      } else {
        setState(() {
          isLoading = false;
        });
        //  showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      //  showInSnackBar(context, 'Error occurred: $e');
    }
  }

  Future<void> getstoredetailmenuList() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getstoredetailmenuList(widget.storeid);
      var response = storedetailmenulistmodelFromJson(result);

      if (response.status.toString().toUpperCase() == 'SUCCESS') {
        print("print");
        setState(() {
          storedetailslistpage = response.categoryProductList;
          storedetailslistpageAll = storedetailslistpage;
          print(storedetailslistpage);
          print(storedetailslistpage);
          isLoading = false;
        });
      } else {
        setState(() {
          storedetailslistpage = [];
          storedetailslistpageAll = [];
          isLoading = false;
        });
        // showInSnackBar(context, response.message.toString());
        print(response.message.toString());
      }
    } catch (e) {
      setState(() {
        storedetailslistpage = [];
        storedetailslistpageAll = [];
        isLoading = false;
      });
      // showInSnackBar(context, 'Error occurred: $e');
      print(e);
    }
  }

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
          getAllCartListforitemvalue();
        });
      } else {
        print(response.code);
        if (response.code == '113') {
          setState(() {
            _decrement(categoryIndex, productIndex);
            getAllCartListforitemvalue();
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
        setState(() {
          getAllCartListforitemvalue();
        });
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
        setState(() {
          getAllCartListforitemvalue();
        });
        showInSnackBar(context, response.message.toString());
      } else {
        showInSnackBar(context, response.message.toString());
        setState(() {
          getAllCartListforitemvalue();
        });
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
    // Prevent duplicate overlays
    if (_overlayEntry != null) return;

    // Show loading overlay while fetching data only if not already fetched
    if (storedetailslistpage.isEmpty) {
      OverlayEntry loadingOverlay = OverlayEntry(
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );
      Overlay.of(context)?.insert(loadingOverlay);

      await getstoredetailmenuList(); // Fetch data from API

      loadingOverlay.remove(); // Remove loading overlay
    }

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
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 500, // Set a maximum height for the list
                  ),
                  child: SingleChildScrollView(
                    // Enable scrolling
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: storedetailslistpage
                          .where((category) => category.products
                              .isNotEmpty) // Filter out empty categories
                          .length,
                      itemBuilder: (context, categoryIndex) {
                        final category = storedetailslistpage
                                .where((category) => category.products
                                    .isNotEmpty) // Filter out empty categories
                                .toList()[
                            categoryIndex]; // Convert filtered categories into a list

                        final String? categoryName = category.categoryName;

                        return GestureDetector(
                          onTap: () {
                            _reorderCategories(
                                categoryIndex); // Move selected to top
                            _removeOverlay(); // Close overlay
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      categoryName![0].toUpperCase() +
                                          categoryName!.substring(1),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Text(
                                    '${category.products.length}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ))),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);

    // Update the overlay visibility state
    setState(() {
      isOverlayVisible = true;
    });
  }

  void _reorderCategories(int selectedIndex) {
    if (selectedIndex < storedetailslistpage.length) {
      final selectedCategory = storedetailslistpage.removeAt(selectedIndex);
      storedetailslistpage.insert(0, selectedCategory);
      // No need for setState here as ListView.builder will reflect changes
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      isOverlayVisible = false;
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, true);
    _removeOverlay();
    return false;
  }

  Future<void> generateInvoice() async {
    // Load custom font
    ByteData byte =
        await rootBundle.load('assets/fonts/custom_Anand_MuktaMalar.ttf');
    PdfTrueTypeFont font = PdfTrueTypeFont(byte.buffer.asUint8List(), 9);
    PdfTrueTypeFont headerFont = PdfTrueTypeFont(byte.buffer.asUint8List(), 13,
        style: PdfFontStyle.bold);

    // Create a new PDF document
    final PdfDocument document = PdfDocument();

    // Add a page to the document
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    // Draw header section with store details
    drawPDFHeader(page, pageSize, headerFont);

    // Prepare and draw category-wise product grid
    final PdfGrid grid = createCategoryProductGrid(font);
    drawGrid(page, grid);

    // Save the document
    final List<int> bytes = await document.save();

    document.dispose();

    // Save and launch PDF
    final uniqueKey = UniqueKey();
    await saveAndLaunchFile(bytes, uniqueKey.toString() + 'CategoryMenu.pdf');
  }

  void drawPDFHeader(PdfPage page, Size pageSize, PdfTrueTypeFont font) {
    String storeName = storeDetails?.name ?? 'Store Name';
    String storeId = StoreIddetails?.toString() ?? 'Unknown ID';

    String headerContent = 'Store: $storeName';

    PdfTextElement headerElement = PdfTextElement(
        text: headerContent, font: font, brush: PdfBrushes.black);

    // Draw header
    headerElement.draw(
        page: page, bounds: Rect.fromLTWH(30, 30, pageSize.width - 60, 60));
  }

  PdfGrid createCategoryProductGrid(PdfTrueTypeFont font) {
    final PdfGrid grid = PdfGrid();

    // Define grid columns
    grid.columns.add(count: 4);
    grid.columns[0].width = 40;

    grid.headers.add(1);

    // Define header row
    final PdfGridRow headerRow = grid.headers[0];
    headerRow.cells[0].value = 'S.No';
    headerRow.cells[1].value = 'Category';
    headerRow.cells[2].value = 'Product';
    headerRow.cells[3].value = 'Price';
    // headerRow.cells[4].value = 'Quantity';

    for (int i = 0; i < headerRow.cells.count; i++) {
      var cell = headerRow.cells[i];
      cell.style.font = font;
      cell.style.backgroundBrush = PdfBrushes.lightGray;
      cell.style.textBrush = PdfBrushes.white;
      cell.stringFormat = PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle);
    }

    int serialNo = 1;

    for (int i = 0; i < storedetailslistpage.length; i++) {
      final category = storedetailslistpage[i];
      for (int j = 0; j < category.products.length; j++) {
        final product = category.products[j];
        final PdfGridRow row = grid.rows.add();

        row.cells[0].value = serialNo.toString();
        row.cells[1].value = category.categoryName;
        row.cells[2].value = product.itemName;
        row.cells[3].value = product.itemOfferPrice ?? '0.0';
        // row.cells[4].value = dishQuantities[i]?[j]?.toString() ?? '0';

        // Corrected cell iteration
        for (int k = 0; k < row.cells.count; k++) {
          var cell = row.cells[k];
          cell.style.font = font;
          cell.stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle);
        }

        serialNo++;
      }
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.gridTable5DarkAccent3);
    return grid;
  }

  void drawGrid(PdfPage page, PdfGrid grid) {
    grid.draw(page: page, bounds: Rect.fromLTWH(0, 100, 0, 0));
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
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

  Future getAllCartListforitemvalue() async {
    await apiService.getBearerToken();
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getCartList();
      var response = cartListModelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          cartList = response.list;
          cartListAll = cartList;
          isLoading = false;
          if (widget.storeid == cartList.first.storeId) {
            calculateTotalDiscount();
          }
        });
      } else {
        setState(() {
          cartList = [];
          cartListAll = [];
          isLoading = false;
          resetCalculations();
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        cartList = [];
        cartListAll = [];
        isLoading = false;
        resetCalculations();
      });
      // showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  double totalDiscountPrice = 0.0;

  void calculateTotalDiscount() {
    totalDiscountPrice = cartList.fold(
      0.0,
      (sum, item) => sum + (double.tryParse(item.quantityPrice) ?? 0.0),
    );
    totalCartItems = cartList.fold(
      0,
      (sum, item) => sum + item.quantity,
    );

    finalTotal =
        totalDiscountPrice + deliveryFee + platformFee + gstFee - discount;
    setState(() {});
  }

  int totalCartItems = 0;
  double deliveryFee = 0.0;
  double platformFee = 0.0;
  double gstFee = 0.0;
  double discount = 0.0;
  bool isTripAdded = false;
  double finalTotal = 0.0;

  void resetCalculations() {
    totalDiscountPrice = 0.0;
    totalCartItems = 0;
    finalTotal = 0.0;
    deliveryFee = 0.0;
    platformFee = 0.0;
    gstFee = 0.0;
    discount = 0.0;
    isTripAdded = false;
    setState(() {});
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
            ClipRRect(
              borderRadius: BorderRadius.circular(13), // Add border radius
              child: Container(
                width: double.infinity,
                height: 183,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToMenus() async {
    // Navigate to Menus and await the result
    final updatedCartItems = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(),
      ),
    );

    if (updatedCartItems == true) {
      setState(() {
        getAllCartListforitemvalue();
        //  cartItems = updatedCartItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.lightGrey3,
              title: HeadingWidget(title: "Back"),
            ),
            body: isLoading
                ? ListView.builder(
                    itemCount: 5,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              // Padding(
                                              //     padding:
                                              //         const EdgeInsets.fromLTRB(
                                              //             0, 0, 15.0, 0),
                                              //     child: GestureDetector(
                                              //         onTap: () async {
                                              //           _makePhoneCall(
                                              //               storeDetails.mobile
                                              //                   .toString());
                                              //         },
                                              //         child: Image.asset(
                                              //           AppAssets.call_icon,
                                              //           width: 40,
                                              //           height: 40,
                                              //           // color: AppColors.red,
                                              //         ))),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 10.0, 0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      generateInvoice();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          AppColors.red,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child: Text("PDF"),
                                                  )),
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
                                          // SizedBox(height: 8),
                                          Row(children: [
                                            // Expanded(
                                            //     child: SubHeadingWidget(
                                            //   title: 'South Indian Foods',
                                            //   fontSize: 14.0,
                                            //   color: AppColors.black,
                                            // )),
                                            // GestureDetector(
                                            //     onTap: () {
                                            // _removeOverlay();
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         RatingListPage(),
                                            //   ),
                                            // );
                                            // },
                                            // child: Column(
                                            //   children: [
                                            //     Container(
                                            //       padding:
                                            //           EdgeInsets.symmetric(
                                            //         vertical: 4.0,
                                            //         horizontal: 8.0,
                                            //       ),
                                            //       decoration: BoxDecoration(
                                            //         color: AppColors.red,
                                            //         borderRadius:
                                            //             BorderRadius
                                            //                 .circular(12.0),
                                            //       ),
                                            //       child: Row(
                                            //         children: [
                                            //           Icon(
                                            //             Icons.star,
                                            //             color:
                                            //                 AppColors.light,
                                            //             size: 16,
                                            //           ),
                                            //           SizedBox(width: 4),
                                            //           Text(
                                            //             '4.5',
                                            //             style: TextStyle(
                                            //               color: AppColors
                                            //                   .light,
                                            //               fontWeight:
                                            //                   FontWeight
                                            //                       .bold,
                                            //             ),
                                            //           ),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //     SizedBox(
                                            //       height: 5.0,
                                            //     ),
                                            //     SubHeadingWidget(
                                            //       title: '252K Rating',
                                            //       fontSize: 12.0,
                                            //       color: AppColors.red,
                                            //     ),
                                            //     SizedBox(
                                            //         width: 60,
                                            //         child: DottedLine(
                                            //           direction:
                                            //               Axis.horizontal,
                                            //           dashColor:
                                            //               AppColors.red,
                                            //           lineLength: 80,
                                            //           dashLength: 2,
                                            //           dashGapLength: 2,
                                            //         )),
                                            //   ],
                                            // ))
                                          ]),
                                          SizedBox(height: 5),
                                          SubHeadingWidget(
                                            title:
                                                "${storeDetails.address},${storeDetails.city},${storeDetails.state}",
                                            fontSize: 14.0,
                                            color: AppColors.black,
                                          ),
                                          SubHeadingWidget(
                                            title: "${storeDetails.zipcode}",
                                            fontSize: 14.0,
                                            color: AppColors.black,
                                          ),
                                        ])),
                                Column(
                                  children: [
                                    DottedLine(
                                      direction: Axis.horizontal,
                                      dashColor: Color(0xFFE23744),
                                      lineLength:
                                          MediaQuery.of(context).size.width,
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
                                          HeadingWidget(
                                            title:
                                                "Customer Care: ", // 'Grill Chicken Arabian Restaurant',
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SubHeadingWidget(
                                            title:
                                                "9361616063", //storeDetails.mobile,
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            //fontWeight: FontWeight.bold,
                                          ),
                                          // Image.asset(
                                          //   AppAssets.offerimg,
                                          //   height: 25,
                                          //   width: 25,
                                          // ),
                                          // SizedBox(width: 8),
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
                          // CustomeTextField(
                          //   width: MediaQuery.of(context).size.width - 10.0,
                          //   hint: 'Find your dish',
                          //   prefixIcon: Icon(
                          //     Icons.search,
                          //     color: AppColors.red,
                          //   ),
                          //   labelColor: Colors.grey[900],
                          //   focusBorderColor: AppColors.primary,
                          //   borderRadius:
                          //       BorderRadius.all(Radius.circular(20.0)),
                          //   borderColor: AppColors.lightGrey3,
                          //   onChanged: (value) {
                          //     if (value.isNotEmpty) {
                          //       storedetailslistpage = storedetailslistpageAll
                          //           .map((category) {
                          //             final filteredProducts =
                          //                 category.products.where((product) {
                          //               return product.itemName != null &&
                          //                   product.itemName!
                          //                       .toLowerCase()
                          //                       .contains(value.toLowerCase());
                          //             }).toList();

                          //             return CategoryProductList(
                          //               categoryId: category.categoryId,
                          //               categoryName: category.categoryName,
                          //               description: category.description,
                          //               slug: category.slug,
                          //               serial: category.serial,
                          //               imageUrl: category.imageUrl,
                          //               products: filteredProducts,
                          //               createdDate: category.createdDate,
                          //             );
                          //           })
                          //           .where((category) =>
                          //               category.products.isNotEmpty)
                          //           .toList();
                          //     } else {
                          //       storedetailslistpage = storedetailslistpageAll;
                          //     }
                          //     print(
                          //         'Filtered categories count: ${storedetailslistpage.length}');
                          //     setState(() {});
                          //   },
                          // ),
                          // SizedBox(height: 5),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: storedetailslistpage.length,
                            itemBuilder: (context, categoryIndex) {
                              final category =
                                  storedetailslistpage[categoryIndex];

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
                                        category.categoryName![0]
                                                .toUpperCase() +
                                            category.categoryName!.substring(1),
                                        // category.categoryName!,
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

                                        int productId = int.tryParse(
                                                product.itemId.toString()) ??
                                            0;
                                        int storeId = int.tryParse(
                                                product.storeId.toString()) ??
                                            0;
                                        int quantity =
                                            categoryProductQuantities[storeId]
                                                    ?[productId] ??
                                                0;

                                        int cartQuantity = 0;
                                        for (var item in cartList) {
                                          if (item.productId == productId &&
                                              item.storeId == storeId) {
                                            cartQuantity = item.quantity;
                                            break;
                                          }
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            if (product.itemStock == 1)
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
                                                        if (product.itemImageUrl
                                                                .toString() !=
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
                                                                  return Image.asset(
                                                                      AppAssets
                                                                          .storeBiriyaniImg,
                                                                      width:
                                                                          120.0,
                                                                      height:
                                                                          120.0,
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
                                                          child: cartQuantity >
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
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () =>
                                                                            setState(() {
                                                                          _decrement(
                                                                              categoryIndex,
                                                                              productIndex);

                                                                          if (cartQuantity >
                                                                              0) {
                                                                            removequantity(storeId.toString(),
                                                                                productId.toString());
                                                                          } else {
                                                                            deletequantity(storeId.toString(),
                                                                                productId.toString());
                                                                          }
                                                                        }),
                                                                        child: Icon(
                                                                            Icons
                                                                                .remove,
                                                                            color:
                                                                                Colors.red,
                                                                            size: 22),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 5.0),
                                                                        child:
                                                                            Text(
                                                                          '$cartQuantity',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap: () =>
                                                                            setState(() {
                                                                          addquantity(
                                                                              storeId.toString(),
                                                                              productId.toString(),
                                                                              categoryIndex,
                                                                              productIndex);
                                                                          // _increment(
                                                                          // categoryIndex,
                                                                          // productIndex);
                                                                        }),
                                                                        child: Icon(
                                                                            Icons
                                                                                .add,
                                                                            color:
                                                                                Colors.red,
                                                                            size: 22),
                                                                      ),
                                                                    ],
                                                                  ))
                                                              : GestureDetector(
                                                                  onTap: () =>
                                                                      setState(
                                                                          () {
                                                                    print(
                                                                        "cart test $cartdetails");
                                                                    addquantity(
                                                                        product
                                                                            .storeId
                                                                            .toString(),
                                                                        product
                                                                            .itemId
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
                                                                  child:
                                                                      Container(
                                                                    height: 33,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.red),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
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
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                5.0),
                                                                        Text(
                                                                          "Add",
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 18),
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
                                                            title: product
                                                                    .itemName![
                                                                        0]
                                                                    .toUpperCase() +
                                                                product
                                                                    .itemName!
                                                                    .substring(
                                                                        1),
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
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            HeadingWidget(
                                                              title:
                                                                  "₹${product.itemOfferPrice}", // '₹100.0',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              194,
                                                              194,
                                                              194),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    color: Color.fromARGB(
                                                        255, 213, 212, 212)),
                                                child: Stack(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 8.0),
                                                      child: Row(
                                                        children: [
                                                          Stack(
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: [
                                                              if (product
                                                                      .itemImageUrl !=
                                                                  null)
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child:
                                                                      SizedBox(
                                                                    width: 100,
                                                                    height: 100,
                                                                    child: Image
                                                                        .network(
                                                                      AppConstants
                                                                              .imgBaseUrl +
                                                                          product
                                                                              .itemImageUrl
                                                                              .toString(),
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      height:
                                                                          60.0,
                                                                      errorBuilder: (BuildContext context,
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
                                                                        ? Image
                                                                            .asset(
                                                                            AppAssets.nonveg_icon,
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                20,
                                                                          )
                                                                        : Image
                                                                            .asset(
                                                                            AppAssets.veg_icon,
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                20,
                                                                          ),
                                                                    SizedBox(
                                                                        width:
                                                                            3.0),
                                                                    HeadingWidget(
                                                                      title: product.itemType ==
                                                                              1
                                                                          ? "Non Veg"
                                                                          : "Veg",
                                                                      vMargin:
                                                                          1.0,
                                                                      fontSize:
                                                                          13.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                                HeadingWidget(
                                                                  title: product
                                                                      .itemName,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  vMargin: 1.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "₹${product.itemPrice.toString()}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    HeadingWidget(
                                                                      title:
                                                                          "₹${product.itemOfferPrice}",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      vMargin:
                                                                          1.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          SubHeadingWidget(
                                                                        title: product.itemDesc ==
                                                                                null
                                                                            ? ''
                                                                            : "",
                                                                        color: AppColors
                                                                            .black,
                                                                        vMargin:
                                                                            1.0,
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
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          color: const Color
                                                                  .fromARGB(255,
                                                                  112, 112, 112)
                                                              .withOpacity(0.3),
                                                          child: Text(
                                                            "     Out of Stock",
                                                            style: TextStyle(
                                                              color:
                                                                  AppColors.red,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                "${totalCartItems.toString()} item${totalCartItems.toString() == 1 ? '' : 's'}",
                            //  "${selectedItems.length} item${selectedItems.length == 1 ? '' : 's'}",
                            color: AppColors.black,
                            fontSize: 15.0,
                          ),
                          HeadingWidget(
                            title: "Price: ₹${finalTotal.toStringAsFixed(2)}",
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
                                      _removeOverlay();
                                      _navigateToMenus();
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => CartPage(),
                                      //   ),
                                      // );
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

// import 'dart:typed_data';

// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:namfood/pages/HomeScreen/home_screen.dart';
// import 'package:namfood/pages/cart/cart_page.dart';
// import 'package:namfood/widgets/custom_text_field.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../constants/app_assets.dart';
// import '../../constants/app_colors.dart';
// import '../../constants/app_constants.dart';
// import '../../services/comFuncService.dart';
// import '../../services/nam_food_api_service.dart';
// import '../../widgets/heading_widget.dart';
// import '../../widgets/sub_heading_widget.dart';
// import '../HomeScreen/cart_list_model.dart';
// import '../models/homescreen_model.dart';
// import '../models/store_list_model.dart';
// import '../rating/add_rating_page.dart';
// import '../rating/rating_list_page.dart';
// import 'store_detailsmenu_model.dart';
// import 'storepage_addqty_model.dart';
// import 'storepage_removeqty_model.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'save_file_mobile.dart' if (dart.library.html) 'save_file_web.dart';

// class StorePage extends StatefulWidget {
//   int? storeid;
//   StorePage({super.key, this.storeid});

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
//   int? StoreIddetails;
//   @override
//   void initState() {
//     super.initState();
//     getAllCartList();
//     getstoredetailmenuList();
//     getStoreDetails();
//   }

//   Future<void> getStoreDetails() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       // Make the API call
//       var result = await apiService.getstoredetailmenuList(widget.storeid);
//       // Parse the JSON response into a Storedetailmenulistmodel
//       var response = storedetailmenulistmodelFromJson(result);

//       // Check the status and update the state
//       if (response.status.toString().toUpperCase() == 'SUCCESS') {
//         print("print");
//         setState(() {
//           storeDetails = response.details; // Store details here
//           isLoading = false;
//         });

//         // Access the store name after fetching the details
//         String storeName = response.details.name.toString();
//         StoreIddetails = response.details.storeId;
//         print('Store Name: $storeName'); // Now you have the store name
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         //  showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       //  showInSnackBar(context, 'Error occurred: $e');
//     }
//   }

//   Future<void> getstoredetailmenuList() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getstoredetailmenuList(widget.storeid);
//       var response = storedetailmenulistmodelFromJson(result);

//       if (response.status.toString().toUpperCase() == 'SUCCESS') {
//         print("print");
//         setState(() {
//           storedetailslistpage = response.categoryProductList;
//           storedetailslistpageAll = storedetailslistpage;
//           print(storedetailslistpage);
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           storedetailslistpage = [];
//           storedetailslistpageAll = [];
//           isLoading = false;
//         });
//         // showInSnackBar(context, response.message.toString());
//         print(response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         storedetailslistpage = [];
//         storedetailslistpageAll = [];
//         isLoading = false;
//       });
//       // showInSnackBar(context, 'Error occurred: $e');
//       print(e);
//     }
//   }

//   Map<String, Map<String, int>> categoryProductQuantities = {};

//   Future<void> addquantity(
//       String storeid, String productid, categoryIndex, productIndex) async {
//     Map<String, dynamic> postData = {
//       "store_id": storeid,
//       "product_id": productid,
//     };

//     try {
//       var result = await apiService.addquantity(postData);
//       AddQtymodel response = addQtymodelFromJson(result);

//       if (response.status == 'SUCCESS') {
//         setState(() {});
//         // showInSnackBar(context, response.message);
//         setState(() {
//           _increment(categoryIndex, productIndex);
//         });
//       } else {
//         print(response.code);
//         if (response.code == '113') {
//           setState(() {
//             _decrement(categoryIndex, productIndex);
//             showInSnackBar(
//                 context, "Need to delete your Cart and Add this Menu");
//           });
//         }
//         // showInSnackBar(context, response.message);
//       }
//     } catch (error) {
//       print('Error adding quantity: $error');
//       showInSnackBar(context, 'Failed to add quantity. Please try again.');
//     }
//   }

//   Future<void> removequantity(String storeid, String productid) async {
//     Map<String, dynamic> postData = {
//       "store_id": storeid,
//       "product_id": productid,
//     };

//     try {
//       var result = await apiService.removequantity(postData);
//       RemoveQtymodel response = removeQtymodelFromJson(result);

//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {});
//         //  showInSnackBar(context, response.message.toString());
//       } else {
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (error) {
//       print('Error removing quantity: $error');
//       showInSnackBar(context, 'Failed to remove quantity. Please try again.');
//     }
//   }

//   Future<void> deletequantity(String storeid, String productid) async {
//     Map<String, dynamic> postData = {
//       "store_id": storeid,
//       "product_id": productid,
//     };

//     try {
//       var result = await apiService.deletequantity(postData);
//       RemoveQtymodel response = removeQtymodelFromJson(result);

//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {});
//         showInSnackBar(context, response.message.toString());
//       } else {
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (error) {
//       print('Error removing quantity: $error');
//       showInSnackBar(context, 'Failed to remove quantity. Please try again.');
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

//   OverlayEntry? _overlayEntry;
//   bool isOverlayVisible = false;

//   void _showOverlay(BuildContext context) async {
//     // Prevent duplicate overlays
//     if (_overlayEntry != null) return;

//     // Show loading overlay while fetching data only if not already fetched
//     if (storedetailslistpage.isEmpty) {
//       OverlayEntry loadingOverlay = OverlayEntry(
//         builder: (context) => Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//       Overlay.of(context)?.insert(loadingOverlay);

//       await getstoredetailmenuList(); // Fetch data from API

//       loadingOverlay.remove(); // Remove loading overlay
//     }

//     if (storedetailslistpage.isEmpty) {
//       showInSnackBar(context, "No categories available.");
//       return;
//     }

//     // Create the overlay with data
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         bottom: 170.0,
//         right: 20.0,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             width: 250,
//             padding: EdgeInsets.only(
//                 top: 1.0, left: 20.0, right: 25.0, bottom: 10.0),
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(16.0),
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: storedetailslistpage.length,
//               itemBuilder: (context, categoryIndex) {
//                 final category = storedetailslistpage[categoryIndex];
//                 final String? categoryName = category.categoryName;

//                 return GestureDetector(
//                   onTap: () {
//                     _reorderCategories(categoryIndex); // Move selected to top
//                     _removeOverlay(); // Close overlay
//                   },
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             categoryName!,
//                             style: TextStyle(color: Colors.white, fontSize: 16),
//                           ),
//                           Text(
//                             '${category.products.length}',
//                             style: TextStyle(color: Colors.white, fontSize: 16),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 15),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context)?.insert(_overlayEntry!);

//     // Update the overlay visibility state
//     setState(() {
//       isOverlayVisible = true;
//     });
//   }

//   void _reorderCategories(int selectedIndex) {
//     if (selectedIndex < storedetailslistpage.length) {
//       final selectedCategory = storedetailslistpage.removeAt(selectedIndex);
//       storedetailslistpage.insert(0, selectedCategory);
//       // No need for setState here as ListView.builder will reflect changes
//     }
//   }

//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//     setState(() {
//       isOverlayVisible = false;
//     });
//   }

//   Future<bool> _onWillPop() async {
//     Navigator.pop(context, true);
//     _removeOverlay();
//     return false;
//   }

//   Future<void> generateInvoice() async {
//     // Load custom font
//     ByteData byte =
//         await rootBundle.load('assets/fonts/custom_Anand_MuktaMalar.ttf');
//     PdfTrueTypeFont font = PdfTrueTypeFont(byte.buffer.asUint8List(), 9);
//     PdfTrueTypeFont headerFont = PdfTrueTypeFont(byte.buffer.asUint8List(), 13,
//         style: PdfFontStyle.bold);

//     // Create a new PDF document
//     final PdfDocument document = PdfDocument();

//     // Add a page to the document
//     final PdfPage page = document.pages.add();
//     final Size pageSize = page.getClientSize();

//     // Draw header section with store details
//     drawPDFHeader(page, pageSize, headerFont);

//     // Prepare and draw category-wise product grid
//     final PdfGrid grid = createCategoryProductGrid(font);
//     drawGrid(page, grid);

//     // Save the document
//     final List<int> bytes = await document.save();

//     document.dispose();

//     // Save and launch PDF
//     final uniqueKey = UniqueKey();
//     await saveAndLaunchFile(bytes, uniqueKey.toString() + 'CategoryMenu.pdf');
//   }

//   void drawPDFHeader(PdfPage page, Size pageSize, PdfTrueTypeFont font) {
//     String storeName = storeDetails?.name ?? 'Store Name';
//     String storeId = StoreIddetails?.toString() ?? 'Unknown ID';

//     String headerContent = 'Store: $storeName';

//     PdfTextElement headerElement = PdfTextElement(
//         text: headerContent, font: font, brush: PdfBrushes.black);

//     // Draw header
//     headerElement.draw(
//         page: page, bounds: Rect.fromLTWH(30, 30, pageSize.width - 60, 60));
//   }

//   PdfGrid createCategoryProductGrid(PdfTrueTypeFont font) {
//     final PdfGrid grid = PdfGrid();

//     // Define grid columns
//     grid.columns.add(count: 4);
//     grid.columns[0].width = 40;

//     grid.headers.add(1);

//     // Define header row
//     final PdfGridRow headerRow = grid.headers[0];
//     headerRow.cells[0].value = 'S.No';
//     headerRow.cells[1].value = 'Category';
//     headerRow.cells[2].value = 'Product';
//     headerRow.cells[3].value = 'Price';
//     // headerRow.cells[4].value = 'Quantity';

//     for (int i = 0; i < headerRow.cells.count; i++) {
//       var cell = headerRow.cells[i];
//       cell.style.font = font;
//       cell.style.backgroundBrush = PdfBrushes.lightGray;
//       cell.style.textBrush = PdfBrushes.white;
//       cell.stringFormat = PdfStringFormat(
//           alignment: PdfTextAlignment.center,
//           lineAlignment: PdfVerticalAlignment.middle);
//     }

//     int serialNo = 1;

//     for (int i = 0; i < storedetailslistpage.length; i++) {
//       final category = storedetailslistpage[i];
//       for (int j = 0; j < category.products.length; j++) {
//         final product = category.products[j];
//         final PdfGridRow row = grid.rows.add();

//         row.cells[0].value = serialNo.toString();
//         row.cells[1].value = category.categoryName;
//         row.cells[2].value = product.itemName;
//         row.cells[3].value = product.itemOfferPrice ?? '0.0';
//         // row.cells[4].value = dishQuantities[i]?[j]?.toString() ?? '0';

//         // Corrected cell iteration
//         for (int k = 0; k < row.cells.count; k++) {
//           var cell = row.cells[k];
//           cell.style.font = font;
//           cell.stringFormat = PdfStringFormat(
//               alignment: PdfTextAlignment.center,
//               lineAlignment: PdfVerticalAlignment.middle);
//         }

//         serialNo++;
//       }
//     }

//     grid.applyBuiltInStyle(PdfGridBuiltInStyle.gridTable5DarkAccent3);
//     return grid;
//   }

//   void drawGrid(PdfPage page, PdfGrid grid) {
//     grid.draw(page: page, bounds: Rect.fromLTWH(0, 100, 0, 0));
//   }

//   void _makePhoneCall(String phoneNumber) async {
//     final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(telUri)) {
//       await launchUrl(telUri);
//     } else {
//       throw 'Could not launch $telUri';
//     }
//   }

//   String? cartdetails;
//   List<CartListData> cartList = [];
//   List<CartListData> cartListAll = [];
//   bool isLoadingcart = false;
//   int? cartstoreid;
//   Future getAllCartList() async {
//     await apiService.getBearerToken();
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getCartList();
//       var response = cartListModelFromJson(result);
//       print("Cart list status: ${response.status}");
//       cartdetails = response.status;
//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {
//           cartList = response.list;
//           cartListAll = cartList;
//           isLoadingcart = false;
//           cartstoreid = cartList.isNotEmpty ? cartList.first.storeId ?? 0 : 0;
//           print("cart store id $cartstoreid");
//           // calculateTotalDiscount();
//         });
//         if (cartList.isEmpty) {
//           showInSnackBar(context, 'Your cart is empty');
//         }
//       } else {
//         setState(() {
//           cartList = [];
//           cartListAll = [];
//           isLoadingcart = false;
//         });
//         // showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         cartList = [];
//         cartListAll = [];
//         isLoadingcart = false;
//       });
//       //  showInSnackBar(context, 'Error occurred: $e');
//     }

//     setState(() {});
//   }

//   Widget _buildShimmerPlaceholder() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade100,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(13), // Add border radius
//               child: Container(
//                 width: double.infinity,
//                 height: 183,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: _onWillPop,
//         child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: AppColors.lightGrey3,
//               title: HeadingWidget(title: "Back"),
//             ),
//             body: isLoading
//                 ? ListView.builder(
//                     itemCount: 5,
//                     itemBuilder: (context, index) {
//                       return _buildShimmerPlaceholder();
//                     },
//                   )
//                 : SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(15.0),
//                               border: Border.all(color: Colors.grey.shade300),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 child: HeadingWidget(
//                                                   title: storeDetails
//                                                       .name, // 'Grill Chicken Arabian Restaurant',
//                                                   fontSize: 22.0,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                               Padding(
//                                                   padding:
//                                                       const EdgeInsets.fromLTRB(
//                                                           0, 0, 15.0, 0),
//                                                   child: GestureDetector(
//                                                       onTap: () async {
//                                                         _makePhoneCall(
//                                                             storeDetails.mobile
//                                                                 .toString());
//                                                       },
//                                                       child: Image.asset(
//                                                         AppAssets.call_icon,
//                                                         width: 40,
//                                                         height: 40,
//                                                         // color: AppColors.red,
//                                                       ))),
//                                               Padding(
//                                                   padding:
//                                                       const EdgeInsets.fromLTRB(
//                                                           0, 0, 15.0, 0),
//                                                   child: ElevatedButton(
//                                                     onPressed: () {
//                                                       generateInvoice();
//                                                     },
//                                                     style: ElevatedButton
//                                                         .styleFrom(
//                                                       backgroundColor:
//                                                           AppColors.red,
//                                                       shape:
//                                                           RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(8),
//                                                       ),
//                                                     ),
//                                                     child: Text("PDF"),
//                                                   )),
//                                             ],
//                                           ),
//                                           // SizedBox(height: 4),
//                                           // Row(
//                                           //   mainAxisAlignment:
//                                           //       MainAxisAlignment.spaceBetween,
//                                           //   children: [
//                                           //     SubHeadingWidget(
//                                           //       title: '2.5km • 10mins',
//                                           //       fontSize: 14.0,
//                                           //       color: AppColors.black,
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                           // SizedBox(height: 8),
//                                           Row(children: [
//                                             Expanded(
//                                                 child: SubHeadingWidget(
//                                               title: 'South Indian Foods',
//                                               fontSize: 14.0,
//                                               color: AppColors.black,
//                                             )),
//                                             // GestureDetector(
//                                             //     onTap: () {
//                                             // _removeOverlay();
//                                             // Navigator.push(
//                                             //   context,
//                                             //   MaterialPageRoute(
//                                             //     builder: (context) =>
//                                             //         RatingListPage(),
//                                             //   ),
//                                             // );
//                                             // },
//                                             // child: Column(
//                                             //   children: [
//                                             //     Container(
//                                             //       padding:
//                                             //           EdgeInsets.symmetric(
//                                             //         vertical: 4.0,
//                                             //         horizontal: 8.0,
//                                             //       ),
//                                             //       decoration: BoxDecoration(
//                                             //         color: AppColors.red,
//                                             //         borderRadius:
//                                             //             BorderRadius
//                                             //                 .circular(12.0),
//                                             //       ),
//                                             //       child: Row(
//                                             //         children: [
//                                             //           Icon(
//                                             //             Icons.star,
//                                             //             color:
//                                             //                 AppColors.light,
//                                             //             size: 16,
//                                             //           ),
//                                             //           SizedBox(width: 4),
//                                             //           Text(
//                                             //             '4.5',
//                                             //             style: TextStyle(
//                                             //               color: AppColors
//                                             //                   .light,
//                                             //               fontWeight:
//                                             //                   FontWeight
//                                             //                       .bold,
//                                             //             ),
//                                             //           ),
//                                             //         ],
//                                             //       ),
//                                             //     ),
//                                             //     SizedBox(
//                                             //       height: 5.0,
//                                             //     ),
//                                             //     SubHeadingWidget(
//                                             //       title: '252K Rating',
//                                             //       fontSize: 12.0,
//                                             //       color: AppColors.red,
//                                             //     ),
//                                             //     SizedBox(
//                                             //         width: 60,
//                                             //         child: DottedLine(
//                                             //           direction:
//                                             //               Axis.horizontal,
//                                             //           dashColor:
//                                             //               AppColors.red,
//                                             //           lineLength: 80,
//                                             //           dashLength: 2,
//                                             //           dashGapLength: 2,
//                                             //         )),
//                                             //   ],
//                                             // ))
//                                           ]),
//                                           SizedBox(height: 5),
//                                           SubHeadingWidget(
//                                             title:
//                                                 "${storeDetails.address},${storeDetails.city},${storeDetails.state}",
//                                             fontSize: 14.0,
//                                             color: AppColors.black,
//                                           ),
//                                           SubHeadingWidget(
//                                             title: "${storeDetails.zipcode}",
//                                             fontSize: 14.0,
//                                             color: AppColors.black,
//                                           ),
//                                         ])),
//                                 Column(
//                                   children: [
//                                     DottedLine(
//                                       direction: Axis.horizontal,
//                                       dashColor: Color(0xFFE23744),
//                                       lineLength:
//                                           MediaQuery.of(context).size.width,
//                                       dashLength: 2,
//                                       dashGapLength: 2,
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 8.0, horizontal: 8.0),
//                                       decoration: BoxDecoration(
//                                         color: Colors.red[50],
//                                         borderRadius: BorderRadius.only(
//                                           bottomLeft: Radius.circular(8.0),
//                                           bottomRight: Radius.circular(8.0),
//                                         ),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           HeadingWidget(
//                                             title:
//                                                 "Mobile  : ", // 'Grill Chicken Arabian Restaurant',
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                           SubHeadingWidget(
//                                             title: storeDetails
//                                                 .mobile, // 'Grill Chicken Arabian Restaurant',
//                                             fontSize: 14.0,
//                                             color: Colors.black,
//                                             //fontWeight: FontWeight.bold,
//                                           ),
//                                           // Image.asset(
//                                           //   AppAssets.offerimg,
//                                           //   height: 25,
//                                           //   width: 25,
//                                           // ),
//                                           // SizedBox(width: 8),
//                                           // Text(
//                                           //   '40% Off • Upto ₹90',
//                                           //   style: TextStyle(
//                                           //     fontSize: 14,
//                                           //     color: Colors.red,
//                                           //   ),
//                                           // ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           // CustomeTextField(
//                           //   width: MediaQuery.of(context).size.width - 10.0,
//                           //   hint: 'Find your dish',
//                           //   prefixIcon: Icon(
//                           //     Icons.search,
//                           //     color: AppColors.red,
//                           //   ),
//                           //   labelColor: Colors.grey[900],
//                           //   focusBorderColor: AppColors.primary,
//                           //   borderRadius:
//                           //       BorderRadius.all(Radius.circular(20.0)),
//                           //   borderColor: AppColors.lightGrey3,
//                           //   onChanged: (value) {
//                           //     if (value.isNotEmpty) {
//                           //       storedetailslistpage = storedetailslistpageAll
//                           //           .map((category) {
//                           //             final filteredProducts =
//                           //                 category.products.where((product) {
//                           //               return product.itemName != null &&
//                           //                   product.itemName!
//                           //                       .toLowerCase()
//                           //                       .contains(value.toLowerCase());
//                           //             }).toList();

//                           //             return CategoryProductList(
//                           //               categoryId: category.categoryId,
//                           //               categoryName: category.categoryName,
//                           //               description: category.description,
//                           //               slug: category.slug,
//                           //               serial: category.serial,
//                           //               imageUrl: category.imageUrl,
//                           //               products: filteredProducts,
//                           //               createdDate: category.createdDate,
//                           //             );
//                           //           })
//                           //           .where((category) =>
//                           //               category.products.isNotEmpty)
//                           //           .toList();
//                           //     } else {
//                           //       storedetailslistpage = storedetailslistpageAll;
//                           //     }
//                           //     print(
//                           //         'Filtered categories count: ${storedetailslistpage.length}');
//                           //     setState(() {});
//                           //   },
//                           // ),
//                           // SizedBox(height: 5),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: storedetailslistpage.length,
//                             itemBuilder: (context, categoryIndex) {
//                               final category =
//                                   storedetailslistpage[categoryIndex];

//                               if (category.products.isEmpty) {
//                                 return SizedBox.shrink();
//                               }

//                               return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 8.0, horizontal: 16.0),
//                                       child: Text(
//                                         category.categoryName!,
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     ListView.builder(
//                                       shrinkWrap: true,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       itemCount: category.products.length,
//                                       itemBuilder: (context, productIndex) {
//                                         final product =
//                                             category.products[productIndex];

//                                         int productId = int.tryParse(
//                                                 product.itemId.toString()) ??
//                                             0;
//                                         int storeId = int.tryParse(
//                                                 product.storeId.toString()) ??
//                                             0;
//                                         int quantity =
//                                             categoryProductQuantities[storeId]
//                                                     ?[productId] ??
//                                                 0;
//                                         return Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             SizedBox(height: 10),
//                                             if (product.itemStock == 1)
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 16.0,
//                                                         vertical: 8.0),
//                                                 child: Row(
//                                                   children: [
//                                                     Stack(
//                                                       clipBehavior: Clip.none,
//                                                       children: [
//                                                         if (product.itemImageUrl
//                                                                 .toString() !=
//                                                             null)
//                                                           ClipRRect(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         10),
//                                                             child: SizedBox(
//                                                               width: 100,
//                                                               height: 100,
//                                                               child:
//                                                                   Image.network(
//                                                                 AppConstants
//                                                                         .imgBaseUrl +
//                                                                     product
//                                                                         .itemImageUrl
//                                                                         .toString(),
//                                                                 fit: BoxFit
//                                                                     .contain,
//                                                                 height: 60.0,
//                                                                 errorBuilder: (BuildContext
//                                                                         context,
//                                                                     Object
//                                                                         exception,
//                                                                     StackTrace?
//                                                                         stackTrace) {
//                                                                   return Image.asset(
//                                                                       AppAssets
//                                                                           .storeBiriyaniImg,
//                                                                       width:
//                                                                           120.0,
//                                                                       height:
//                                                                           120.0,
//                                                                       fit: BoxFit
//                                                                           .cover);
//                                                                 },
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         Positioned(
//                                                           bottom: -13,
//                                                           left: 8,
//                                                           right: 8,
//                                                           child: dishQuantities[
//                                                                               categoryIndex]
//                                                                           ?[
//                                                                           productIndex] !=
//                                                                       null &&
//                                                                   dishQuantities[
//                                                                               categoryIndex]
//                                                                           ?[
//                                                                           productIndex] !=
//                                                                       0
//                                                               ? Container(
//                                                                   height: 35,
//                                                                   padding: EdgeInsets
//                                                                       .symmetric(
//                                                                           horizontal:
//                                                                               2.0),
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     border: Border.all(
//                                                                         color: Colors
//                                                                             .red),
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             10),
//                                                                     color: Colors
//                                                                         .white,
//                                                                   ),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .center,
//                                                                     children: [
//                                                                       GestureDetector(
//                                                                         onTap: () =>
//                                                                             setState(() {
//                                                                           _decrement(
//                                                                               categoryIndex,
//                                                                               productIndex);

//                                                                           if (dishQuantities[categoryIndex]![productIndex] >
//                                                                               0) {
//                                                                             removequantity(storeId.toString(),
//                                                                                 productId.toString());
//                                                                           } else {
//                                                                             deletequantity(storeId.toString(),
//                                                                                 productId.toString());
//                                                                           }
//                                                                         }),
//                                                                         child: Icon(
//                                                                             Icons
//                                                                                 .remove,
//                                                                             color:
//                                                                                 Colors.red,
//                                                                             size: 22),
//                                                                       ),
//                                                                       Padding(
//                                                                         padding:
//                                                                             EdgeInsets.symmetric(horizontal: 5.0),
//                                                                         child:
//                                                                             Text(
//                                                                           '${dishQuantities[categoryIndex]?[productIndex]}',
//                                                                           style:
//                                                                               TextStyle(
//                                                                             color:
//                                                                                 Colors.red,
//                                                                             fontSize:
//                                                                                 20,
//                                                                             fontWeight:
//                                                                                 FontWeight.bold,
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                       GestureDetector(
//                                                                         onTap: () =>
//                                                                             setState(() {
//                                                                           addquantity(
//                                                                               storeId.toString(),
//                                                                               productId.toString(),
//                                                                               categoryIndex,
//                                                                               productIndex);
//                                                                           // _increment(
//                                                                           // categoryIndex,
//                                                                           // productIndex);
//                                                                         }),
//                                                                         child: Icon(
//                                                                             Icons
//                                                                                 .add,
//                                                                             color:
//                                                                                 Colors.red,
//                                                                             size: 22),
//                                                                       ),
//                                                                     ],
//                                                                   ))
//                                                               : GestureDetector(
//                                                                   onTap: () =>
//                                                                       setState(
//                                                                           () {
//                                                                     print(
//                                                                         "cart test $cartdetails");
//                                                                     addquantity(
//                                                                         product
//                                                                             .storeId
//                                                                             .toString(),
//                                                                         product
//                                                                             .itemId
//                                                                             .toString(),
//                                                                         categoryIndex,
//                                                                         productIndex);
//                                                                     // print(
//                                                                     //     "storeid $StoreIddetails");
//                                                                     // print(
//                                                                     //     "cartstoreid $cartstoreid");
//                                                                     // StoreIddetails != cartstoreid ||
//                                                                     //         cartstoreid !=
//                                                                     //             0 ||
//                                                                     //         cartstoreid !=
//                                                                     //             null
//                                                                     //     ? _increment(
//                                                                     //         categoryIndex,
//                                                                     //         productIndex)
//                                                                     //     : showInSnackBar(
//                                                                     //         context,
//                                                                     //         "Need To Clear Your Old Cart and Add this Hotel Menu");
//                                                                   }),
//                                                                   child:
//                                                                       Container(
//                                                                     height: 33,
//                                                                     decoration:
//                                                                         BoxDecoration(
//                                                                       border: Border.all(
//                                                                           color:
//                                                                               Colors.red),
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               10.0),
//                                                                       color: Colors
//                                                                           .white,
//                                                                     ),
//                                                                     child: Row(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .center,
//                                                                       children: [
//                                                                         Icon(
//                                                                           Icons
//                                                                               .add,
//                                                                           color:
//                                                                               Colors.red,
//                                                                         ),
//                                                                         SizedBox(
//                                                                             width:
//                                                                                 5.0),
//                                                                         Text(
//                                                                           "Add",
//                                                                           style: TextStyle(
//                                                                               color: Colors.red,
//                                                                               fontSize: 18),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(width: 16),
//                                                     Flexible(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               product.itemType ==
//                                                                       1
//                                                                   ? Image.asset(
//                                                                       AppAssets
//                                                                           .nonveg_icon,
//                                                                       width: 20,
//                                                                       height:
//                                                                           20,
//                                                                     )
//                                                                   : Image.asset(
//                                                                       AppAssets
//                                                                           .veg_icon,
//                                                                       width: 20,
//                                                                       height:
//                                                                           20,
//                                                                     ),
//                                                               SizedBox(
//                                                                 width: 3.0,
//                                                               ),
//                                                               HeadingWidget(
//                                                                 title: product
//                                                                             .itemType ==
//                                                                         1
//                                                                     ? "Non Veg"
//                                                                     : "Veg", // 'Non-Veg',
//                                                                 vMargin: 1.0,
//                                                                 fontSize: 13.0,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           HeadingWidget(
//                                                             title: product
//                                                                     .itemName![
//                                                                         0]
//                                                                     .toUpperCase() +
//                                                                 product
//                                                                     .itemName!
//                                                                     .substring(
//                                                                         1),
//                                                             fontSize: 16.0,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             vMargin: 1.0,
//                                                           ),

//                                                           Row(children: [
//                                                             Text(
//                                                               "₹${product.itemPrice.toString()}",
//                                                               //'₹150.0',
//                                                               style: TextStyle(
//                                                                 fontSize: 14,
//                                                                 decoration:
//                                                                     TextDecoration
//                                                                         .lineThrough,
//                                                                 color: Colors
//                                                                     .black,
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             HeadingWidget(
//                                                               title:
//                                                                   "₹${product.itemOfferPrice}", // '₹100.0',
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               vMargin: 1.0,
//                                                             ),
//                                                           ]),
//                                                           // Row(
//                                                           //   children: [
//                                                           //     Flexible(
//                                                           //         child:
//                                                           //             SubHeadingWidget(
//                                                           //       title: product
//                                                           //                   .itemDesc ==
//                                                           //               null
//                                                           //           ? ''
//                                                           //           : product
//                                                           //               .itemDesc
//                                                           //               .toString(),
//                                                           //       color:
//                                                           //           AppColors.black,
//                                                           //       vMargin: 1.0,
//                                                           //     )),
//                                                           //   ],
//                                                           // )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),

//                                             // Out Of Stock

//                                             if (product.itemStock == 0)
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                       color:
//                                                           const Color.fromARGB(
//                                                               255,
//                                                               194,
//                                                               194,
//                                                               194),
//                                                       width: 1.0,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             13),
//                                                     color: Color.fromARGB(
//                                                         255, 213, 212, 212)),
//                                                 child: Stack(
//                                                   children: [
//                                                     Padding(
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           horizontal: 16.0,
//                                                           vertical: 8.0),
//                                                       child: Row(
//                                                         children: [
//                                                           Stack(
//                                                             clipBehavior:
//                                                                 Clip.none,
//                                                             children: [
//                                                               if (product
//                                                                       .itemImageUrl !=
//                                                                   null)
//                                                                 ClipRRect(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10),
//                                                                   child:
//                                                                       SizedBox(
//                                                                     width: 100,
//                                                                     height: 100,
//                                                                     child: Image
//                                                                         .network(
//                                                                       AppConstants
//                                                                               .imgBaseUrl +
//                                                                           product
//                                                                               .itemImageUrl
//                                                                               .toString(),
//                                                                       fit: BoxFit
//                                                                           .contain,
//                                                                       height:
//                                                                           60.0,
//                                                                       errorBuilder: (BuildContext context,
//                                                                           Object
//                                                                               exception,
//                                                                           StackTrace?
//                                                                               stackTrace) {
//                                                                         return Image
//                                                                             .asset(
//                                                                           AppAssets
//                                                                               .storeBiriyaniImg,
//                                                                           width:
//                                                                               120.0,
//                                                                           height:
//                                                                               120.0,
//                                                                           fit: BoxFit
//                                                                               .cover,
//                                                                         );
//                                                                       },
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(width: 16),
//                                                           Flexible(
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Row(
//                                                                   children: [
//                                                                     product.itemType ==
//                                                                             1
//                                                                         ? Image
//                                                                             .asset(
//                                                                             AppAssets.nonveg_icon,
//                                                                             width:
//                                                                                 20,
//                                                                             height:
//                                                                                 20,
//                                                                           )
//                                                                         : Image
//                                                                             .asset(
//                                                                             AppAssets.veg_icon,
//                                                                             width:
//                                                                                 20,
//                                                                             height:
//                                                                                 20,
//                                                                           ),
//                                                                     SizedBox(
//                                                                         width:
//                                                                             3.0),
//                                                                     HeadingWidget(
//                                                                       title: product.itemType ==
//                                                                               1
//                                                                           ? "Non Veg"
//                                                                           : "Veg",
//                                                                       vMargin:
//                                                                           1.0,
//                                                                       fontSize:
//                                                                           13.0,
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 HeadingWidget(
//                                                                   title: product
//                                                                       .itemName,
//                                                                   fontSize:
//                                                                       16.0,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                   vMargin: 1.0,
//                                                                   color: Colors
//                                                                       .black,
//                                                                 ),
//                                                                 Row(
//                                                                   children: [
//                                                                     Text(
//                                                                       "₹${product.itemPrice.toString()}",
//                                                                       style:
//                                                                           TextStyle(
//                                                                         fontSize:
//                                                                             14,
//                                                                         decoration:
//                                                                             TextDecoration.lineThrough,
//                                                                         color: Colors
//                                                                             .black,
//                                                                       ),
//                                                                     ),
//                                                                     SizedBox(
//                                                                         width:
//                                                                             10),
//                                                                     HeadingWidget(
//                                                                       title:
//                                                                           "₹${product.itemOfferPrice}",
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       vMargin:
//                                                                           1.0,
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 Row(
//                                                                   children: [
//                                                                     Flexible(
//                                                                       child:
//                                                                           SubHeadingWidget(
//                                                                         title: product.itemDesc ==
//                                                                                 null
//                                                                             ? ''
//                                                                             : "",
//                                                                         color: AppColors
//                                                                             .black,
//                                                                         vMargin:
//                                                                             1.0,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     if (product.itemStock == 0)
//                                                       Positioned.fill(
//                                                         child: Container(
//                                                           alignment: Alignment
//                                                               .bottomCenter,
//                                                           color: const Color
//                                                                   .fromARGB(255,
//                                                                   112, 112, 112)
//                                                               .withOpacity(0.3),
//                                                           child: Text(
//                                                             "     Out of Stock",
//                                                             style: TextStyle(
//                                                               color:
//                                                                   AppColors.red,
//                                                               fontSize: 25,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                   ],
//                                                 ),
//                                               ),

//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                             Divider(
//                                                 height: 1,
//                                                 thickness: 0.5,
//                                                 color: AppColors.grey),
//                                           ],
//                                         );
//                                       },
//                                     ),
//                                     // ],
//                                   ]);
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//             bottomNavigationBar: BottomAppBar(
//               height: 80.0,
//               elevation: 0,
//               color: AppColors.light,
//               child: SafeArea(
//                 child: Padding(
//                   padding: EdgeInsets.all(4.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SubHeadingWidget(
//                             title:
//                                 "${selectedItems.length} item${selectedItems.length == 1 ? '' : 's'}",
//                             color: AppColors.black,
//                             fontSize: 15.0,
//                           ),
//                           HeadingWidget(
//                             title: "Price: ₹${totalPrice.toStringAsFixed(2)}",
//                             color: AppColors.red,
//                             fontSize: 18.0,
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                           width: 140,
//                           height: 75,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Navigate to cart
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.red,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 5, vertical: 10),
//                               child: Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       _removeOverlay();
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => CartPage(),
//                                         ),
//                                       );
//                                     },
//                                     child: SubHeadingWidget(
//                                       title: "Go to cart",
//                                       color: Colors.white,
//                                       fontSize: 16.0,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             floatingActionButton: GestureDetector(
//               onTap: () {
//                 if (isOverlayVisible) {
//                   _removeOverlay();
//                 } else {
//                   _showOverlay(context);
//                 }
//               },
//               child: isOverlayVisible
//                   ? Container(
//                       width: 70,
//                       height: 70,
//                       decoration: BoxDecoration(
//                         color: AppColors.black,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(1.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.close,
//                               color: Colors.white,
//                             ),
//                             Text(
//                               "Close",
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : Container(
//                       width: 70,
//                       height: 70,
//                       decoration: BoxDecoration(
//                         color: AppColors.black,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(1.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               AppAssets.noteBookImg,
//                               width: 20,
//                               height: 20,
//                               color: AppColors.light,
//                             ),
//                             Text(
//                               "Menu",
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//             )));
//   }
// }

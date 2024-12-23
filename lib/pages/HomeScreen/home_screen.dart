import 'package:flutter/material.dart';
import 'package:namfood/constants/app_assets.dart';
import 'package:namfood/pages/models/homescreen_model.dart';
import 'package:namfood/pages/store/store_page.dart';
import 'package:namfood/widgets/custom_text_field.dart';
import 'package:namfood/widgets/heading_widget.dart';
import 'package:namfood/widgets/sub_heading_widget.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../widgets/slider_ad_widget.dart';
import '../../widgets/svgiconButtonWidget.dart';
import 'package:shimmer/shimmer.dart';
import '../address/address_list_model.dart';
import '../address/addresspage.dart';
import '../cart/cart_page.dart';
import '../location/selectlocation_page.dart';
import '../models/banner_list_model.dart';
import '../models/locationpopup_model.dart';

import 'cart_list_model.dart';
import 'deletecart_model.dart';
import 'search_option.dart';
import 'stores_list_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final NamFoodApiService apiService = NamFoodApiService();

  List<popups> locationpopuppage = [];
  List<popups> locationpopuppageAll = [];

  Future getlocationpopup() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getlocationpopup();
      var response = locationpopupmodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          locationpopuppage = response.list;
          locationpopuppageAll = locationpopuppage;
          isLoading = false;
        });
      } else {
        setState(() {
          locationpopuppage = [];
          locationpopuppageAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        locationpopuppage = [];
        locationpopuppageAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  Future deletecart() async {
    final dialogBoxResult = await showAlertDialogInfo(
        context: context,
        title: 'Are you sure?',
        msg: 'You want to delete this data',
        status: 'danger',
        okBtn: false);
    if (dialogBoxResult == 'OK') {
      await apiService.getBearerToken();

      Map<String, dynamic> postData = {};
      print("delete $postData");

      var result = await apiService.deletecart(postData);
      DeleteCartmodel response = deleteCartmodelFromJson(result);

      if (!mounted) return; // Ensure widget is still in the tree

      if (response.status.toString() == 'SUCCESS') {
        // showInSnackBar(context, response.message.toString());
        setState(() {
          getAllCartList();
        });
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    }
  }

  late AnimationController? _animationController;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void refreshData() {
    // Update cartList or fetch new data
    setState(() {
      getAllCartList();
    });
  }

  Future<void> _navigateToMenus(int storeid) async {
    // Navigate to Menus and await the result
    final updatedCartItems = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StorePage(
          storeid: storeid,
        ),
      ),
    );

    if (updatedCartItems == true) {
      setState(() {
        getAllCartList();
        //  cartItems = updatedCartItems;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    gethomecarousel();
    getdashbordlist();
    getlocationpopup();
    getAllCartList();
    refreshData();
    getalladdressList();
    //   _animationController = AnimationController(
    //     vsync: this,
    //     duration: Duration(milliseconds: 800),
    //   );

    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showAnimatedBottomSheet();
    // });
  }

  void _showAnimatedBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        transitionAnimationController: _animationController,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 200,
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(
                  color: const Color.fromARGB(255, 233, 229, 229),
                  width: 2.0,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select a your location",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CustomeTextField(
                      borderColor: AppColors.grey1,
                      width: double.infinity,
                      hint: 'Enter Manual',
                      hintColor: AppColors.grey,
                      prefixIcon: Icon(
                        Icons.search_outlined,
                        color: AppColors.grey,
                      )),
                  SizedBox(
                    height: 190,
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        final e = locationpopuppage[index];
                        return Column(
                          children: [
                            Container(
                              // padding: EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isBottomBarVisible = false;
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              e.icon.toString(),
                                              height: 20,
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            HeadingWidget(
                                              title: e.type.toString(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Wrap(
                                          children: [
                                            HeadingWidget(
                                                fontSize: 14.00,
                                                fontWeight: FontWeight.w500,
                                                title: e.address.toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectLocationPage(),
                          ),
                        );
                      },
                      child: Text(
                        'View more',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.red,
                          //  decoration: TextDecoration.underline,
                          decorationColor: AppColors.red,
                        ),
                      )),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 4.9,
                      child: Divider(color: AppColors.red)),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: AppColors.grey,
                          indent: MediaQuery.of(context).size.width * 0.01,
                          endIndent: MediaQuery.of(context).size.width * 0.02,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Or',
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: AppColors.grey,
                          //  indent: screenWidth * 0.01,
                          endIndent: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  SvgIconButtonWidget(
                    title: "Select Automatically",
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.red,
                    onTap: () {},
                    leadingIcon: Image.asset(
                      AppAssets.mappoint_white,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
    }
  }

  Future<void> whatsapp(String contact) async {
    String androidUrl = "whatsapp://send?phone=$contact";
    String iosUrl = "https://wa.me/$contact";
    String webUrl = "https://api.whatsapp.com/send/?phone=$contact";
    print("contact number $contact");
    try {
      if (await canLaunchUrl(Uri.parse(androidUrl))) {
        await launchUrl(Uri.parse(androidUrl));
      } else if (await canLaunchUrl(Uri.parse(iosUrl))) {
        await launchUrl(Uri.parse(iosUrl),
            mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri.parse(webUrl),
            mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Could not launch WhatsApp for $contact: $e');
    }
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

      // Remove loading overlay
      loadingOverlay.remove();

      // Create the overlay with data
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: 160.0,
          right: 20.0,
          child: Material(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              width: 170,
              padding: EdgeInsets.only(
                  top: 1.0, left: 20.0, right: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(children: [
                Row(children: [
                  Text(
                    "Call Us       ",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  GestureDetector(
                      onTap: () async {
                        _makePhoneCall("9360159625");
                      },
                      child: Image.asset(AppAssets.call_icon,
                          height: 35, width: 35))
                ]),
                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  Text(
                    "Whats App ",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  GestureDetector(
                      onTap: () async {
                        whatsapp("9360159625");
                      },
                      child: Image.asset(AppAssets.whatsapp_icon,
                          //  color: Colors.green,
                          height: 35,
                          width: 35))
                ])
              ]),
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

  Future<bool> _onWillPop() async {
    Navigator.pop(context, true);
    _removeOverlay();
    return false;
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

  //Carousel
  List<BannerListData> carouselpage = [];
  List<BannerListData> carouselpageAll = [];
  bool isLoading2 = false;

  Future gethomecarousel() async {
    await apiService.getBearerToken();
    setState(() {
      isLoading2 = true;
    });

    try {
      var result = await apiService.getBannerList();
      var response = bannerListModelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          carouselpage = response.list;
          carouselpageAll = carouselpage;
          isLoading2 = false;
        });
      } else {
        setState(() {
          carouselpage = [];
          carouselpageAll = [];
          isLoading2 = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        carouselpage = [];
        carouselpageAll = [];
        isLoading2 = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  int currentIndex = 0;
  bool _isBottomBarVisible = true;
  double totalDiscountPrice = 0.0;

  List<CartListData> cartList = [];
  List<CartListData> cartListAll = [];
  bool isLoading3 = false;

  Future getAllCartList() async {
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
      // showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

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

  List<AddressList> myprofilepage = [];
  List<AddressList> myprofilepageAll = [];
  String? defaultAddressString;
  String? defaultcityString;
  String? defaultstateString;
  String? defaultlandmarkString;
  String? defaultAddress2String;
  String? defaultpostcodeString;
  bool isLoadingaddress = false;

  Future getalladdressList() async {
    await apiService.getBearerToken();
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService
          .getalladdressList(); // This will always return a String or throw an exception
      var response = addressListmodelFromJson(result); // Parse the JSON string
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          myprofilepageAll = response.list; // Full list of addresses
          isLoadingaddress = false;

          // Filter for default address
          myprofilepage = myprofilepageAll
              .where((address) => address.defaultAddress == 1)
              .toList();

          if (myprofilepage.isNotEmpty) {
            selectedAddress = myprofilepage.first;
            defaultcityString = (selectedAddress?.city == '')
                ? ''
                : "${selectedAddress?.city},";
            defaultstateString = (selectedAddress?.state == '')
                ? ''
                : "${selectedAddress?.state}";
            defaultlandmarkString = (selectedAddress?.landmark == '')
                ? ''
                : "${selectedAddress?.landmark}";
            defaultpostcodeString = (selectedAddress?.postcode == '')
                ? ''
                : "${selectedAddress?.postcode}.";
            defaultAddressString = (selectedAddress?.address == '')
                ? ''
                : "${selectedAddress?.address},";
            defaultAddress2String = (selectedAddress?.addressLine2 == '')
                ? ''
                : "${selectedAddress?.addressLine2},";
            print("city :$defaultcityString");
          } else {
            selectedAddress = null; // No default address exists
            defaultAddressString = "No default address available.";
          }

          // Print the address
          print(defaultAddressString);
        });
      } else {
        setState(() {
          myprofilepage = [];
          myprofilepageAll = [];
          isLoadingaddress = false;
        });
        print(response.message.toString());
      }
    } catch (e) {
      setState(() {
        myprofilepage = [];
        myprofilepageAll = [];
        isLoadingaddress = false;
      });
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
                height: 183,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder1() {
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
                height: 83,
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
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xFFE23744),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              toolbarHeight: 130,
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Addresspage(),
                                    ),
                                  );
                                },
                                child: Image.asset(AppAssets.map_icon)),
                            SizedBox(width: 8),
                            if (myprofilepage.length > 0)
                              isLoading
                                  ? ListView.builder(
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return _buildShimmerPlaceholder1();
                                      },
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        myprofilepage.isEmpty
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Addresspage(),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          'Please add Address',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                                                        )),
                                                  ])
                                            : Text(
                                                'Delivery location :',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                        Text(
                                          "$defaultAddressString$defaultAddress2String$defaultcityString$defaultlandmarkString",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          // softWrap: true,
                                        ),
                                      ],
                                    ),
                          ],
                        ),
                      ),
                      // GestureDetector(
                      //     onTap: () {},
                      //     child: Image.asset(AppAssets.notification_icon)),
                    ],
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        print("Navigating to TabSearchApp");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TabSearchApp(),
                          ),
                        );
                      },
                      child: Container(
                        child: CustomeTextField(
                          hint: "Restaurant name",
                          prefixIcon: Image.asset(AppAssets.search_icon),
                          boxColor: Colors.white,
                          borderColor: Colors.white,
                          focusBorderColor: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          boxRadius: BorderRadius.circular(10),
                          hintColor: const Color.fromARGB(255, 94, 93, 93),
                          labelColor: const Color.fromARGB(255, 103, 103, 103),
                          onChanged: (value) {
                            if (value != '') {
                              print('Search value: $value');
                              value = value.toString().toLowerCase();
                              dashlistpage = dashlistpageAll!
                                  .where((StoreListData e) => e.name
                                      .toString()
                                      .toLowerCase()
                                      .contains(value))
                                  .toList();
                            } else {
                              dashlistpage = dashlistpageAll;
                            }
                            setState(() {});
                          },
                          onTap: () {
                            print("Navigating to TabSearchApp");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TabSearchApp(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // SizedBox(
                  //         width: MediaQuery.of(context).size.width / 0.1,
                  //         child: CustomeTextField(
                  //           hint: "Restaurant name",
                  //           // prefixIcon: Icon(Icons.search, color: Color(0xFFE23744)),
                  //           prefixIcon: Image.asset(AppAssets.search_icon),
                  //           boxColor: Colors.white,
                  //           borderColor: Colors.white,
                  //           focusBorderColor: Colors.blue,
                  //           borderRadius: BorderRadius.circular(10),
                  //           contentPadding: EdgeInsets.symmetric(
                  //               horizontal: 20, vertical: 12),
                  //           boxRadius: BorderRadius.circular(10),
                  //           hintColor: const Color.fromARGB(255, 94, 93, 93),
                  //           labelColor:
                  //               const Color.fromARGB(255, 103, 103, 103),
                  //           onChanged: (value) {
                  //             if (value != '') {
                  //               print('value $value');
                  //               value = value.toString().toLowerCase();
                  //               dashlistpage = dashlistpageAll!
                  //                   .where((StoreListData e) => e.name
                  //                       .toString()
                  //                       .toLowerCase()
                  //                       .contains(value))
                  //                   .toList();
                  //             } else {
                  //               dashlistpage = dashlistpageAll;
                  //             }
                  //             setState(() {});
                  //           },
                  //         )),
                ],
              ),
            ),
            body: isLoading
                ? ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _buildShimmerPlaceholder();
                    },
                  )
                : Column(children: [
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(21, 23, 21, 15),
                            child: Column(
                              children: [
                                if (carouselpage != null &&
                                    carouselpage.isNotEmpty)
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    child: Image.network(
                                      AppConstants.imgBaseUrl +
                                          (carouselpage[0].imageUrl ??
                                              AppAssets.Banner),
                                      fit: BoxFit.fill,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Image.asset(
                                          AppAssets.Banner,
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                          height: 180,
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(height: 16),
                                // if (carouselpage.isNotEmpty)
                                //   CarouselSlider.builder(
                                //     itemCount: carouselpage.length,
                                //     itemBuilder: (BuildContext context, int itemIndex,
                                //         int pageViewIndex) {
                                //       final e = carouselpage[itemIndex];
                                //       return ClipRRect(
                                //                               borderRadius:
                                //                                   BorderRadius.circular(10),
                                //                               child: Image.network(
                                //                                 AppConstants.imgBaseUrl +
                                //                                     e.imageUrl,
                                //                                 width: double.infinity,
                                //                                 fit: BoxFit.fill,
                                //                                 height: 60.0,
                                //                                 // height: 100.0,
                                //                                 errorBuilder:
                                //                                     (BuildContext context,
                                //                                         Object exception,
                                //                                         StackTrace?
                                //                                             stackTrace) {
                                //                                   return Image.asset(
                                //                                       AppAssets.logo,
                                //                                       width: 30.0,
                                //                                       height: 50.0,
                                //                                       fit: BoxFit.cover);
                                //                                 },
                                //                               ),
                                //                             );
                                //     },
                                //     options: CarouselOptions(
                                //       autoPlay: true,
                                //       enlargeCenterPage: true,
                                //       aspectRatio: 13.2 / 6,
                                //       viewportFraction: 1.0,
                                //       onPageChanged: (index, reason) {
                                //         setState(() {
                                //           currentIndex = index;
                                //         });
                                //       },
                                //     ),
                                //   ),
                                // SizedBox(height: 16),
                                // if (carouselpage
                                //     .isNotEmpty) // Show DotsIndicator only if list is not empty
                                //   DotsIndicator(
                                //     dotsCount: carouselpage.length,
                                //     position: currentIndex,
                                //     decorator: DotsDecorator(
                                //       color: const Color.fromARGB(255, 216, 216, 216),
                                //       activeColor: Color(0xFFE23744),
                                //       size: const Size.square(8.0),
                                //       activeSize: const Size(12.0, 8.0),
                                //       activeShape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(5.0),
                                //       ),
                                //     ),
                                //   ),
                                if (carouselpage != null)
                                  if (carouselpage.isNotEmpty)
                                    SliderAdWidget(adList: carouselpage),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(21, 0, 0, 5),
                            child: HeadingWidget(
                              title: "Restaurant Explore",
                              fontSize: 17.0,
                            ),
                          ),
                          ListView.builder(
                            itemCount: dashlistpage.length,
                            shrinkWrap:
                                true, // Let the list take only as much space as needed
                            physics:
                                NeverScrollableScrollPhysics(), // Disable scrolling for ListView
                            itemBuilder: (context, index) {
                              final e = dashlistpage[index];
                              return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 18, 5),
                                  child: e.storeStatus == 1
                                      ? Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Color(0xFFEEEEEE),
                                              width: 0.2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                        255, 196, 195, 195)
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                              onTap: () {
                                                _navigateToMenus(e.storeId);
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) => StorePage(),
                                                //   ),
                                                // );
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                child:
                                                                    Image.asset(
                                                                  AppAssets
                                                                      .foodimg,
                                                                  height: 150,
                                                                  width: double
                                                                      .infinity,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                                      e.frontImg
                                                                          .toString(),
                                                                  height: 150,
                                                                  width: double
                                                                      .infinity,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                        // Positioned(
                                                        //   child: Container(
                                                        //     padding: EdgeInsets.symmetric(
                                                        //         horizontal: 7, vertical: 4),
                                                        //     decoration: BoxDecoration(
                                                        //       color: Colors.white,
                                                        //       borderRadius: BorderRadius.only(
                                                        //           bottomRight:
                                                        //               Radius.circular(10),
                                                        //           topLeft: Radius.circular(10)),
                                                        //     ),
                                                        //     child: Row(
                                                        //       mainAxisSize: MainAxisSize.min,
                                                        //       children: [
                                                        //         e.type == "Non-Veg"
                                                        //             ? Image.asset(
                                                        //                 AppAssets.nonveg_icon,
                                                        //                 width: 14,
                                                        //                 height: 14)
                                                        //             : Image.asset(
                                                        //                 AppAssets.veg_icon,
                                                        //                 width: 14,
                                                        //                 height: 14),
                                                        //         SizedBox(width: 4),
                                                        //         HeadingWidget(
                                                        //           title: e.type,
                                                        //           color: e.type == "Non-Veg"
                                                        //               ? Color(0xFFEF4848)
                                                        //               : Colors.green,
                                                        //           fontSize: 11.0,
                                                        //           fontWeight: FontWeight.bold,
                                                        //         ),
                                                        //       ],
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        // Positioned(
                                                        //   top: 8,
                                                        //   right: 8,
                                                        //   child: Icon(
                                                        //       Icons.favorite_border,
                                                        //       color: Colors.white),
                                                        // ),
                                                        // Positioned(
                                                        //   bottom: 8,
                                                        //   left: 8,
                                                        //   child: Row(
                                                        //     children: [
                                                        //       Column(
                                                        //         crossAxisAlignment:
                                                        //             CrossAxisAlignment
                                                        //                 .start,
                                                        //         children: [
                                                        //           HeadingWidget(
                                                        //             title: e.name
                                                        //                 .toString(),
                                                        //             //  'Grill Chicken Arabian \nRestaurant',
                                                        //             fontSize: 16.0,
                                                        //             fontWeight:
                                                        //                 FontWeight
                                                        //                     .bold,
                                                        //             color: Colors
                                                        //                 .white,
                                                        //           ),
                                                        //         ],
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                        // Positioned(
                                                        //   bottom: 21,
                                                        //   right: 12,
                                                        //   child: Container(
                                                        //     padding: EdgeInsets
                                                        //         .symmetric(
                                                        //             horizontal: 8),
                                                        //     height: 30,
                                                        //     decoration:
                                                        //         BoxDecoration(
                                                        //       color:
                                                        //           Color(0xFFE23744),
                                                        //       borderRadius:
                                                        //           BorderRadius
                                                        //               .circular(16),
                                                        //     ),
                                                        //     child: Row(
                                                        //       children: [
                                                        //         Icon(Icons.star,
                                                        //             color: Colors
                                                        //                 .white,
                                                        //             size: 16),
                                                        //         SizedBox(width: 4),
                                                        //         SubHeadingWidget(
                                                        //             title: ' 4.5 ',
                                                        //             color: Colors
                                                        //                 .white),
                                                        //       ],
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              HeadingWidget(
                                                                title: e.name
                                                                    .toString(), //'40% Off ,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18.00,
                                                              ),
                                                              SubHeadingWidget(
                                                                title:
                                                                    "${e.address.toString()}, ${e.city.toString()}, ${e.state.toString()},", //'40% Off ,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                              SubHeadingWidget(
                                                                title:
                                                                    "${e.zipcode.toString()}.", //'40% Off ,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ])),
                                                    // Padding(
                                                    //   padding:
                                                    //       const EdgeInsets.all(8.0),
                                                    //   child: Row(
                                                    //     mainAxisAlignment:
                                                    //         MainAxisAlignment
                                                    //             .spaceBetween,
                                                    //     children: [
                                                    //       Row(
                                                    //         children: [
                                                    // Image.asset(AppAssets.offerimg),
                                                    // SizedBox(width: 4),
                                                    // SubHeadingWidget(
                                                    //   title:
                                                    //       "${e.offerpercentage}% off", //'40% Off ,
                                                    //   color: Colors.black87,
                                                    // ),
                                                    // SubHeadingWidget(
                                                    //   title:
                                                    //       "-Upto ₹${e.offerupto}", // Upto ₹90',
                                                    //   color: Colors.black87,
                                                    // ),

                                                    //     SubHeadingWidget(
                                                    //       title: e.address
                                                    //           .toString(), //'40% Off ,
                                                    //       color:
                                                    //           Colors.black87,
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    // Row(
                                                    //   children: [
                                                    //     SubHeadingWidget(
                                                    //         title:
                                                    //             " ${e.km} Km - ", //'2.5km',
                                                    //         color: Colors.black),
                                                    //     SizedBox(width: 3),
                                                    //     SubHeadingWidget(
                                                    //         title: e.time, //'10mins',
                                                    //         color: Colors.black),
                                                    //   ],
                                                    // ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              )),
                                        )
                                      : null);
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Section with Icons and Text
                              Container(
                                color: AppColors.red,
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Icon(Icons.local_shipping,
                                            color: Colors.white, size: 40),
                                        SizedBox(height: 8),
                                        Text(
                                          'Free Delivery\n(above ₹1000)',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Icon(Icons.verified,
                                            color: Colors.yellow, size: 40),
                                        SizedBox(height: 8),
                                        Text(
                                          'Buyer\nProtection',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Icon(Icons.support_agent,
                                            color: Colors.blue, size: 40),
                                        SizedBox(height: 8),
                                        Text(
                                          'Customer\nSupport',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Address Section
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Food Delivery',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Nirajana complax, high school road, Thuvarankurichi, Tamil Nadu 621314',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    //  SizedBox(height: 4),
                                    // Text(
                                    //   'Nirajana complex high school road\nthuvavankurichi',
                                    //   style: TextStyle(fontSize: 14),
                                    // ),
                                  ],
                                ),
                              ),

                              // Social Media Links
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.facebook,
                                        color: Colors.blue,
                                        size: 45,
                                      ),
                                      onPressed: () {},
                                    ),
                                    // IconButton(
                                    //   icon: Icon(
                                    //     Icons.youtube_searched_for_outlined,
                                    //     color: Colors.red,
                                    //     size: 45,
                                    //   ),
                                    //   onPressed: () {},
                                    // ),
                                    GestureDetector(
                                        onTap: () async {
                                          whatsapp("9360159625");
                                        },
                                        child:
                                            Image.asset(AppAssets.whatsapp_icon,
                                                //  color: Colors.green,
                                                height: 35,
                                                width: 35))
                                  ],
                                ),
                              ),

                              // Links Section
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LinkText('TERMS AND CONDITIONS'),
                                    LinkText('PRIVACY POLICIES'),
                                    LinkText('REFUND POLICIES'),
                                    LinkText('SITEMAP'),
                                    LinkText('CONTACT US'),
                                    LinkText('ABOUT US'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                    )
                  ]),
            // floatingActionButton: GestureDetector(
            //   onTap: () {
            //     if (isOverlayVisible) {
            //       _removeOverlay();
            //     } else {
            //       _showOverlay(context);
            //     }
            //   },
            //   child: isOverlayVisible
            //       ? Container(
            //           width: 80,
            //           height: 80,
            //           decoration: BoxDecoration(
            //             color: AppColors.red,
            //             shape: BoxShape.circle,
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsets.all(1.0),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 Icon(
            //                   Icons.close,
            //                   color: Colors.white,
            //                 ),
            //                 Text(
            //                   "Close",
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         )
            //       : Container(
            //           width: 80,
            //           height: 80,
            //           decoration: BoxDecoration(
            //             color: AppColors.red,
            //             shape: BoxShape.circle,
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 // Image.asset(
            //                 //   AppAssets.call_icon,
            //                 //   width: 20,
            //                 //   height: 20,
            //                 //   //color: AppColors.light,
            //                 // ),
            //                 Text(
            //                   "Customer",
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //                 Text(
            //                   "Care",
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            // ),
            bottomNavigationBar: cartList.isNotEmpty
                ? BottomAppBar(
                    height: 105.0,
                    elevation: 0,
                    color: AppColors.light,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Store Image
                            // cartList[0].store_image == null ||
                            //         cartList[0].store_image == ""
                            //     ? ClipRRect(
                            //         borderRadius: BorderRadius.circular(12),
                            //         child: Image.asset(
                            //           AppAssets.storeBiriyaniImg,
                            //           height: 70,
                            //           width: 50,
                            //           fit: BoxFit.cover,
                            //         ),
                            //       )
                            //     : ClipRRect(
                            //         borderRadius: BorderRadius.circular(26),
                            //         child: Container(
                            //           height: 70,
                            //           width: 50,
                            //           decoration: BoxDecoration(
                            //             image: DecorationImage(
                            //               image: NetworkImage(
                            //                 AppConstants.imgBaseUrl +
                            //                     cartList[0].store_image.toString(),
                            //               ),
                            //               fit: BoxFit.cover,
                            //             ),
                            //           ),
                            //         ),
                            //       ),

                            SizedBox(width: 5),

                            // Store Details
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cartList[0].store_name.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // Text(
                                    //   '${totalCartItems.toString()} items | ₹${finalTotal.toString()}',
                                    //   style: TextStyle(
                                    //     fontSize: 14,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    //   overflow: TextOverflow.ellipsis,
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     //  Expanded(
                                //     // child:
                                //     Text(
                                //       'View all menu',
                                //       style: TextStyle(
                                //         fontSize: 14,
                                //         color: Colors.black,
                                //         decoration: TextDecoration.underline,
                                //       ),
                                //       // ),
                                //     ),
                                //     Icon(
                                //       Icons.arrow_forward_ios,
                                //       color: Colors.black,
                                //       size: 12,
                                //     ),
                                //   ],
                                // ),
                                //     ],
                                //   ),
                                // ),

                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //  Expanded(
                                    // child:
                                    Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Text(
                                          //   'View all menu',
                                          //   style: TextStyle(
                                          //     fontSize: 14,
                                          //     color: Colors.black,
                                          //     decoration: TextDecoration.underline,
                                          //   ),
                                          //   // ),
                                          // ),
                                          // Icon(
                                          //   Icons.arrow_forward_ios,
                                          //   color: Colors.black,
                                          //   size: 12,
                                          // ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${totalCartItems.toString()} items | ₹${finalTotal.toString()}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ]),

                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       '${totalCartItems.toString()} items | ₹${finalTotal.toString()}',
                                    //       style: TextStyle(
                                    //         fontSize: 14,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //       overflow: TextOverflow.ellipsis,
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(height: 10),
                                    // ElevatedButton(
                                    //   style: ElevatedButton.styleFrom(
                                    //     backgroundColor: Color(0xFFE23744),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(10),
                                    //     ),
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 15, vertical: 5),
                                    //   ),
                                    //   onPressed: () {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) => CartPage(),
                                    //       ),
                                    //     );
                                    //   },
                                    //   child: Text(
                                    //     'View Cart',
                                    //     style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontSize: 16,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            )),
                            SizedBox(width: 15),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFE23744),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CartPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'View Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            // Delete Cart Button
                            GestureDetector(
                              onTap: () async {
                                await deletecart();
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE23744),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : null));
  }
}

class LinkText extends StatelessWidget {
  final String text;

  const LinkText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:namfood/constants/app_assets.dart';
// import 'package:namfood/pages/models/homescreen_model.dart';
// import 'package:namfood/pages/store/store_page.dart';
// import 'package:namfood/widgets/custom_text_field.dart';
// import 'package:namfood/widgets/heading_widget.dart';
// import 'package:namfood/widgets/sub_heading_widget.dart';
// import 'package:dots_indicator/dots_indicator.dart';
// import '../../constants/app_colors.dart';
// import '../../constants/app_constants.dart';
// import '../../services/comFuncService.dart';
// import '../../services/nam_food_api_service.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// import '../../widgets/slider_ad_widget.dart';
// import '../../widgets/svgiconButtonWidget.dart';

// import '../address/address_list_model.dart';
// import '../address/addresspage.dart';
// import '../cart/cart_page.dart';
// import '../location/selectlocation_page.dart';
// import '../models/banner_list_model.dart';
// import '../models/locationpopup_model.dart';

// import 'cart_list_model.dart';
// import 'deletecart_model.dart';
// import 'stores_list_model.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   final NamFoodApiService apiService = NamFoodApiService();

//   List<popups> locationpopuppage = [];
//   List<popups> locationpopuppageAll = [];

//   Future getlocationpopup() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getlocationpopup();
//       var response = locationpopupmodelFromJson(result);
//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {
//           locationpopuppage = response.list;
//           locationpopuppageAll = locationpopuppage;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           locationpopuppage = [];
//           locationpopuppageAll = [];
//           isLoading = false;
//         });
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         locationpopuppage = [];
//         locationpopuppageAll = [];
//         isLoading = false;
//       });
//       showInSnackBar(context, 'Error occurred: $e');
//     }

//     setState(() {});
//   }

//   Future deletecart() async {
//     await apiService.getBearerToken();

//     Map<String, dynamic> postData = {};
//     print("delete $postData");

//     var result = await apiService.deletecart(postData);
//     DeleteCartmodel response = deleteCartmodelFromJson(result);

//     if (!mounted) return; // Ensure widget is still in the tree

//     if (response.status.toString() == 'SUCCESS') {
//       // showInSnackBar(context, response.message.toString());
//       setState(() {
//         getAllCartList();
//       });
//     } else {
//       print(response.message.toString());
//       showInSnackBar(context, response.message.toString());
//     }
//   }

//   late AnimationController? _animationController;

//   @override
//   void dispose() {
//     _animationController?.dispose();
//     super.dispose();
//   }

//   void refreshData() {
//     // Update cartList or fetch new data
//     setState(() {
//       getAllCartList();
//     });
//   }

//   Future<void> _navigateToMenus(int storeid) async {
//     // Navigate to Menus and await the result
//     final updatedCartItems = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StorePage(
//           storeid: storeid,
//         ),
//       ),
//     );

//     if (updatedCartItems == true) {
//       setState(() {
//         getAllCartList();
//         //  cartItems = updatedCartItems;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     //getalladdressList();
//     gethomecarousel();
//     getdashbordlist();
//     getlocationpopup();
//     getAllCartList();
//     refreshData();

//     //   _animationController = AnimationController(
//     //     vsync: this,
//     //     duration: Duration(milliseconds: 800),
//     //   );

//     //  WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   _showAnimatedBottomSheet();
//     // });
//   }

//   void _showAnimatedBottomSheet() {
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(16.0),
//           ),
//         ),
//         transitionAnimationController: _animationController,
//         builder: (context) {
//           return Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).size.height / 200,
//             ),
//             child: Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 border: Border.all(
//                   color: const Color.fromARGB(255, 233, 229, 229),
//                   width: 2.0,
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Select a your location",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   CustomeTextField(
//                       borderColor: AppColors.grey1,
//                       width: double.infinity,
//                       hint: 'Enter Manual',
//                       hintColor: AppColors.grey,
//                       prefixIcon: Icon(
//                         Icons.search_outlined,
//                         color: AppColors.grey,
//                       )),
//                   SizedBox(
//                     height: 190,
//                     child: ListView.builder(
//                       itemCount: 2,
//                       itemBuilder: (context, index) {
//                         final e = locationpopuppage[index];
//                         return Column(
//                           children: [
//                             Container(
//                               // padding: EdgeInsets.symmetric(vertical: 10),
//                               child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 8, horizontal: 0),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         _isBottomBarVisible = false;
//                                       });
//                                     },
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Image.asset(
//                                               e.icon.toString(),
//                                               height: 20,
//                                               width: 20,
//                                             ),
//                                             SizedBox(
//                                               width: 8,
//                                             ),
//                                             HeadingWidget(
//                                               title: e.type.toString(),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 6,
//                                         ),
//                                         Wrap(
//                                           children: [
//                                             HeadingWidget(
//                                                 fontSize: 14.00,
//                                                 fontWeight: FontWeight.w500,
//                                                 title: e.address.toString()),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   )),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                   GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SelectLocationPage(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'View more',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.red,
//                           //  decoration: TextDecoration.underline,
//                           decorationColor: AppColors.red,
//                         ),
//                       )),
//                   SizedBox(
//                       width: MediaQuery.of(context).size.width / 4.9,
//                       child: Divider(color: AppColors.red)),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Divider(
//                           thickness: 1,
//                           color: AppColors.grey,
//                           indent: MediaQuery.of(context).size.width * 0.01,
//                           endIndent: MediaQuery.of(context).size.width * 0.02,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Text(
//                         'Or',
//                         style: TextStyle(
//                             color: AppColors.black,
//                             fontSize: MediaQuery.of(context).size.width * 0.04),
//                       ),
//                       Expanded(
//                         child: Divider(
//                           thickness: 1,
//                           color: AppColors.grey,
//                           //  indent: screenWidth * 0.01,
//                           endIndent: MediaQuery.of(context).size.width * 0.05,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 2,
//                   ),
//                   SvgIconButtonWidget(
//                     title: "Select Automatically",
//                     width: MediaQuery.of(context).size.width,
//                     color: AppColors.red,
//                     onTap: () {},
//                     leadingIcon: Image.asset(
//                       AppAssets.mappoint_white,
//                       height: 20,
//                       width: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   //AddtoCart
//   List<StoreListData> dashlistpage = [];
//   List<StoreListData> dashlistpageAll = [];
//   bool isLoading = false;

//   Future getdashbordlist() async {
//     await apiService.getBearerToken();
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getdashStoreList();
//       var response = storeListModelFromJson(result);
//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {
//           dashlistpage = response.list;
//           dashlistpageAll = dashlistpage;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           dashlistpage = [];
//           dashlistpageAll = [];
//           isLoading = false;
//         });
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         dashlistpage = [];
//         dashlistpageAll = [];
//         isLoading = false;
//       });
//       showInSnackBar(context, 'Error occurred: $e');
//     }

//     setState(() {});
//   }

//   //Carousel
//   List<BannerListData> carouselpage = [];
//   List<BannerListData> carouselpageAll = [];
//   bool isLoading2 = false;

//   Future gethomecarousel() async {
//     await apiService.getBearerToken();
//     setState(() {
//       isLoading2 = true;
//     });

//     try {
//       var result = await apiService.getBannerList();
//       var response = bannerListModelFromJson(result);
//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {
//           carouselpage = response.list;
//           carouselpageAll = carouselpage;
//           isLoading2 = false;
//         });
//       } else {
//         setState(() {
//           carouselpage = [];
//           carouselpageAll = [];
//           isLoading2 = false;
//         });
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         carouselpage = [];
//         carouselpageAll = [];
//         isLoading2 = false;
//       });
//       showInSnackBar(context, 'Error occurred: $e');
//     }

//     setState(() {});
//   }

//   int currentIndex = 0;
//   bool _isBottomBarVisible = true;
//   double totalDiscountPrice = 0.0;

//   List<CartListData> cartList = [];
//   List<CartListData> cartListAll = [];
//   bool isLoading3 = false;

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
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         cartList = [];
//         cartListAll = [];
//         isLoading = false;
//       });
//       // showInSnackBar(context, 'Error occurred: $e');
//     }

//     setState(() {});
//   }

//   void calculateTotalDiscount() {
//     totalDiscountPrice = cartList.fold(
//       0.0,
//       (sum, item) => sum + (double.tryParse(item!.quantityPrice) ?? 0.0),
//     );
//     totalCartItems = cartList.fold(
//       0,
//       (sum, item) => sum + item.quantity,
//     );

//     finalTotal =
//         totalDiscountPrice + deliveryFee + platformFee + gstFee - discount;
//     setState(() {});
//   }

//   int totalCartItems = 0;
//   double deliveryFee = 0.0;
//   double platformFee = 0.0;
//   double gstFee = 0.0;
//   double discount = 0.0;
//   bool isTripAdded = false;
//   double finalTotal = 0.0;

//   // List<AddressList> myprofilepage = [];
//   // List<AddressList> myprofilepageAll = [];
//   // String? defaultAddressString;
//   // bool isLoadingaddress = false;
//   // Future getalladdressList() async {
//   //   setState(() {
//   //     isLoadingaddress = true;
//   //   });

//   //   try {
//   //     var result = await apiService
//   //         .getalladdressList(); // This will always return a String or throw an exception
//   //     var response = addressListmodelFromJson(result); // Parse the JSON string
//   //     if (response.status.toString() == 'SUCCESS') {
//   //       setState(() {
//   //         myprofilepageAll = response.list; // Full list of addresses
//   //         isLoadingaddress = false;

//   //         // Filter for default address
//   //         myprofilepage = myprofilepageAll
//   //             .where((address) => address.defaultAddress == 1)
//   //             .toList();

//   //         if (myprofilepage.isNotEmpty) {
//   //           selectedAddress = myprofilepage.first;
//   //           defaultAddressString =
//   //               "${selectedAddress?.address}, ${selectedAddress?.city}, ${selectedAddress?.landmark}, ${selectedAddress?.postcode}";
//   //         } else {
//   //           selectedAddress = null; // No default address exists
//   //           defaultAddressString = "No default address available.";
//   //         }

//   //         // Print the address
//   //         print(defaultAddressString);
//   //       });
//   //     } else {
//   //       setState(() {
//   //         myprofilepage = [];
//   //         myprofilepageAll = [];
//   //         isLoadingaddress = false;
//   //       });
//   //       print(response.message.toString());
//   //     }
//   //   } catch (e) {
//   //     setState(() {
//   //       myprofilepage = [];
//   //       myprofilepageAll = [];
//   //       isLoadingaddress = false;
//   //     });
//   //     print('Error occurred: $e');
//   //   }
//   // }

//   // AddressList? selectedAddress;

//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Color(0xFFE23744),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(20),
//             ),
//           ),
//           toolbarHeight: 130,
//           title: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 2),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => Addresspage(),
//                                 ),
//                               );
//                             },
//                             child: Image.asset(AppAssets.map_icon)),
//                         SizedBox(width: 8),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // isLoadingaddress
//                             //     ? Center(child: CircularProgressIndicator())
//                             //     : myprofilepage.isEmpty
//                             //         ?
//                             Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Current location',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "No.132 St, New York",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       // Icon(Icons.arrow_drop_down,
//                                       //     color: Colors.white),
//                                     ],
//                                   )
//                                 ])
//                             //         : Text(
//                             //             'Delivery location',
//                             //             style: TextStyle(
//                             //               color: Colors.white,
//                             //               fontSize: 14,
//                             //             ),
//                             //           ),
//                             // Text(
//                             //   defaultAddressString!,
//                             //   style: TextStyle(
//                             //       fontSize: 16.0,
//                             //       fontWeight: FontWeight.bold,
//                             //       color: Colors.white),
//                             // ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // GestureDetector(
//                   //     onTap: () {},
//                   //     child: Image.asset(AppAssets.notification_icon)),
//                 ],
//               ),
//               SizedBox(
//                   width: MediaQuery.of(context).size.width / 0.1,
//                   child: CustomeTextField(
//                     hint: "Restaurant name",
//                     // prefixIcon: Icon(Icons.search, color: Color(0xFFE23744)),
//                     prefixIcon: Image.asset(AppAssets.search_icon),
//                     boxColor: Colors.white,
//                     borderColor: Colors.white,
//                     focusBorderColor: Colors.blue,
//                     borderRadius: BorderRadius.circular(10),
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     boxRadius: BorderRadius.circular(10),
//                     hintColor: const Color.fromARGB(255, 94, 93, 93),
//                     labelColor: const Color.fromARGB(255, 103, 103, 103),
//                     onChanged: (value) {
//                       if (value != '') {
//                         print('value $value');
//                         value = value.toString().toLowerCase();
//                         dashlistpage = dashlistpageAll!
//                             .where((StoreListData e) =>
//                                 e.name.toString().toLowerCase().contains(value))
//                             .toList();
//                       } else {
//                         dashlistpage = dashlistpageAll;
//                       }
//                       setState(() {});
//                     },
//                   )),
//             ],
//           ),
//         ),
//         body: isLoading
//             ? Center(child: CircularProgressIndicator())
//             : Column(children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                       child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(21, 23, 21, 15),
//                         child: Column(
//                           children: [
//                             // if (carouselpage.isNotEmpty)
//                             //   CarouselSlider.builder(
//                             //     itemCount: carouselpage.length,
//                             //     itemBuilder: (BuildContext context, int itemIndex,
//                             //         int pageViewIndex) {
//                             //       final e = carouselpage[itemIndex];
//                             //       return ClipRRect(
//                             //                               borderRadius:
//                             //                                   BorderRadius.circular(10),
//                             //                               child: Image.network(
//                             //                                 AppConstants.imgBaseUrl +
//                             //                                     e.imageUrl,
//                             //                                 width: double.infinity,
//                             //                                 fit: BoxFit.fill,
//                             //                                 height: 60.0,
//                             //                                 // height: 100.0,
//                             //                                 errorBuilder:
//                             //                                     (BuildContext context,
//                             //                                         Object exception,
//                             //                                         StackTrace?
//                             //                                             stackTrace) {
//                             //                                   return Image.asset(
//                             //                                       AppAssets.logo,
//                             //                                       width: 30.0,
//                             //                                       height: 50.0,
//                             //                                       fit: BoxFit.cover);
//                             //                                 },
//                             //                               ),
//                             //                             );
//                             //     },
//                             //     options: CarouselOptions(
//                             //       autoPlay: true,
//                             //       enlargeCenterPage: true,
//                             //       aspectRatio: 13.2 / 6,
//                             //       viewportFraction: 1.0,
//                             //       onPageChanged: (index, reason) {
//                             //         setState(() {
//                             //           currentIndex = index;
//                             //         });
//                             //       },
//                             //     ),
//                             //   ),
//                             // SizedBox(height: 16),
//                             // if (carouselpage
//                             //     .isNotEmpty) // Show DotsIndicator only if list is not empty
//                             //   DotsIndicator(
//                             //     dotsCount: carouselpage.length,
//                             //     position: currentIndex,
//                             //     decorator: DotsDecorator(
//                             //       color: const Color.fromARGB(255, 216, 216, 216),
//                             //       activeColor: Color(0xFFE23744),
//                             //       size: const Size.square(8.0),
//                             //       activeSize: const Size(12.0, 8.0),
//                             //       activeShape: RoundedRectangleBorder(
//                             //         borderRadius: BorderRadius.circular(5.0),
//                             //       ),
//                             //     ),
//                             //   ),
//                             if (carouselpage != null)
//                               if (carouselpage.isNotEmpty)
//                                 SliderAdWidget(adList: carouselpage),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(21, 0, 0, 5),
//                         child: HeadingWidget(
//                           title: "Restaurant Explore",
//                           fontSize: 17.0,
//                         ),
//                       ),
//                       ListView.builder(
//                         itemCount: dashlistpage.length,
//                         shrinkWrap:
//                             true, // Let the list take only as much space as needed
//                         physics:
//                             NeverScrollableScrollPhysics(), // Disable scrolling for ListView
//                         itemBuilder: (context, index) {
//                           final e = dashlistpage[index];
//                           return Padding(
//                               padding: const EdgeInsets.fromLTRB(15, 0, 18, 5),
//                               child: e.storeStatus == 1
//                                   ? Container(
//                                       margin: EdgeInsets.only(bottom: 16),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(12),
//                                         border: Border.all(
//                                           color: Color(0xFFEEEEEE),
//                                           width: 0.2,
//                                         ),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Color.fromARGB(
//                                                     255, 196, 195, 195)
//                                                 .withOpacity(0.2),
//                                             spreadRadius: 2,
//                                             blurRadius: 4,
//                                             offset: Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: GestureDetector(
//                                           onTap: () {
//                                             _navigateToMenus(e.storeId);
//                                             // Navigator.push(
//                                             //   context,
//                                             //   MaterialPageRoute(
//                                             //     builder: (context) => StorePage(),
//                                             //   ),
//                                             // );
//                                           },
//                                           child: Card(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(12),
//                                             ),
//                                             elevation: 0,
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Stack(
//                                                   children: [
//                                                     e.frontImg == null
//                                                         ? ClipRRect(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         12),
//                                                             child: Image.asset(
//                                                               AppAssets.foodimg,
//                                                               height: 150,
//                                                               width: double
//                                                                   .infinity,
//                                                               fit: BoxFit.cover,
//                                                             ),
//                                                           )
//                                                         : ClipRRect(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         12),
//                                                             child:
//                                                                 Image.network(
//                                                               AppConstants
//                                                                       .imgBaseUrl +
//                                                                   e.frontImg
//                                                                       .toString(),
//                                                               height: 150,
//                                                               width: double
//                                                                   .infinity,
//                                                               fit: BoxFit.cover,
//                                                             ),
//                                                           ),
//                                                     // Positioned(
//                                                     //   child: Container(
//                                                     //     padding: EdgeInsets.symmetric(
//                                                     //         horizontal: 7, vertical: 4),
//                                                     //     decoration: BoxDecoration(
//                                                     //       color: Colors.white,
//                                                     //       borderRadius: BorderRadius.only(
//                                                     //           bottomRight:
//                                                     //               Radius.circular(10),
//                                                     //           topLeft: Radius.circular(10)),
//                                                     //     ),
//                                                     //     child: Row(
//                                                     //       mainAxisSize: MainAxisSize.min,
//                                                     //       children: [
//                                                     //         e.type == "Non-Veg"
//                                                     //             ? Image.asset(
//                                                     //                 AppAssets.nonveg_icon,
//                                                     //                 width: 14,
//                                                     //                 height: 14)
//                                                     //             : Image.asset(
//                                                     //                 AppAssets.veg_icon,
//                                                     //                 width: 14,
//                                                     //                 height: 14),
//                                                     //         SizedBox(width: 4),
//                                                     //         HeadingWidget(
//                                                     //           title: e.type,
//                                                     //           color: e.type == "Non-Veg"
//                                                     //               ? Color(0xFFEF4848)
//                                                     //               : Colors.green,
//                                                     //           fontSize: 11.0,
//                                                     //           fontWeight: FontWeight.bold,
//                                                     //         ),
//                                                     //       ],
//                                                     //     ),
//                                                     //   ),
//                                                     // ),
//                                                     // Positioned(
//                                                     //   top: 8,
//                                                     //   right: 8,
//                                                     //   child: Icon(
//                                                     //       Icons.favorite_border,
//                                                     //       color: Colors.white),
//                                                     // ),
//                                                     // Positioned(
//                                                     //   bottom: 8,
//                                                     //   left: 8,
//                                                     //   child: Row(
//                                                     //     children: [
//                                                     //       Column(
//                                                     //         crossAxisAlignment:
//                                                     //             CrossAxisAlignment
//                                                     //                 .start,
//                                                     //         children: [
//                                                     //           HeadingWidget(
//                                                     //             title: e.name
//                                                     //                 .toString(),
//                                                     //             //  'Grill Chicken Arabian \nRestaurant',
//                                                     //             fontSize: 16.0,
//                                                     //             fontWeight:
//                                                     //                 FontWeight
//                                                     //                     .bold,
//                                                     //             color: Colors
//                                                     //                 .white,
//                                                     //           ),
//                                                     //         ],
//                                                     //       ),
//                                                     //     ],
//                                                     //   ),
//                                                     // ),
//                                                     // Positioned(
//                                                     //   bottom: 21,
//                                                     //   right: 12,
//                                                     //   child: Container(
//                                                     //     padding: EdgeInsets
//                                                     //         .symmetric(
//                                                     //             horizontal: 8),
//                                                     //     height: 30,
//                                                     //     decoration:
//                                                     //         BoxDecoration(
//                                                     //       color:
//                                                     //           Color(0xFFE23744),
//                                                     //       borderRadius:
//                                                     //           BorderRadius
//                                                     //               .circular(16),
//                                                     //     ),
//                                                     //     child: Row(
//                                                     //       children: [
//                                                     //         Icon(Icons.star,
//                                                     //             color: Colors
//                                                     //                 .white,
//                                                     //             size: 16),
//                                                     //         SizedBox(width: 4),
//                                                     //         SubHeadingWidget(
//                                                     //             title: ' 4.5 ',
//                                                     //             color: Colors
//                                                     //                 .white),
//                                                     //       ],
//                                                     //     ),
//                                                     //   ),
//                                                     // ),
//                                                   ],
//                                                 ),
//                                                 Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           SubHeadingWidget(
//                                                             title: e.name
//                                                                 .toString(), //'40% Off ,
//                                                             color:
//                                                                 Colors.black87,
//                                                           ),
//                                                           SubHeadingWidget(
//                                                             title: e.address
//                                                                 .toString(), //'40% Off ,
//                                                             color:
//                                                                 Colors.black87,
//                                                           ),
//                                                         ])),
//                                                 // Padding(
//                                                 //   padding:
//                                                 //       const EdgeInsets.all(8.0),
//                                                 //   child: Row(
//                                                 //     mainAxisAlignment:
//                                                 //         MainAxisAlignment
//                                                 //             .spaceBetween,
//                                                 //     children: [
//                                                 //       Row(
//                                                 //         children: [
//                                                 // Image.asset(AppAssets.offerimg),
//                                                 // SizedBox(width: 4),
//                                                 // SubHeadingWidget(
//                                                 //   title:
//                                                 //       "${e.offerpercentage}% off", //'40% Off ,
//                                                 //   color: Colors.black87,
//                                                 // ),
//                                                 // SubHeadingWidget(
//                                                 //   title:
//                                                 //       "-Upto ₹${e.offerupto}", // Upto ₹90',
//                                                 //   color: Colors.black87,
//                                                 // ),

//                                                 //     SubHeadingWidget(
//                                                 //       title: e.address
//                                                 //           .toString(), //'40% Off ,
//                                                 //       color:
//                                                 //           Colors.black87,
//                                                 //     ),
//                                                 //   ],
//                                                 // ),
//                                                 // Row(
//                                                 //   children: [
//                                                 //     SubHeadingWidget(
//                                                 //         title:
//                                                 //             " ${e.km} Km - ", //'2.5km',
//                                                 //         color: Colors.black),
//                                                 //     SizedBox(width: 3),
//                                                 //     SubHeadingWidget(
//                                                 //         title: e.time, //'10mins',
//                                                 //         color: Colors.black),
//                                                 //   ],
//                                                 // ),
//                                                 //     ],
//                                                 //   ),
//                                                 // ),
//                                               ],
//                                             ),
//                                           )),
//                                     )
//                                   : null);
//                         },
//                       ),
//                     ],
//                   )),
//                 )
//               ]),
//         bottomNavigationBar: cartList.isNotEmpty
//             ? BottomAppBar(
//                 height: 105.0,
//                 elevation: 0,
//                 color: AppColors.light,
//                 child: SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.all(2.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Store Image
//                         // cartList[0].store_image == null ||
//                         //         cartList[0].store_image == ""
//                         //     ? ClipRRect(
//                         //         borderRadius: BorderRadius.circular(12),
//                         //         child: Image.asset(
//                         //           AppAssets.storeBiriyaniImg,
//                         //           height: 70,
//                         //           width: 50,
//                         //           fit: BoxFit.cover,
//                         //         ),
//                         //       )
//                         //     : ClipRRect(
//                         //         borderRadius: BorderRadius.circular(26),
//                         //         child: Container(
//                         //           height: 70,
//                         //           width: 50,
//                         //           decoration: BoxDecoration(
//                         //             image: DecorationImage(
//                         //               image: NetworkImage(
//                         //                 AppConstants.imgBaseUrl +
//                         //                     cartList[0].store_image.toString(),
//                         //               ),
//                         //               fit: BoxFit.cover,
//                         //             ),
//                         //           ),
//                         //         ),
//                         //       ),

//                         SizedBox(width: 5),

//                         // Store Details
//                         Expanded(
//                             child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   cartList[0].store_name.toString(),
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 Text(
//                                   '${totalCartItems.toString()} items | ₹${finalTotal.toString()}',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             // Row(
//                             //   mainAxisAlignment: MainAxisAlignment.start,
//                             //   children: [
//                             //     //  Expanded(
//                             //     // child:
//                             //     Text(
//                             //       'View all menu',
//                             //       style: TextStyle(
//                             //         fontSize: 14,
//                             //         color: Colors.black,
//                             //         decoration: TextDecoration.underline,
//                             //       ),
//                             //       // ),
//                             //     ),
//                             //     Icon(
//                             //       Icons.arrow_forward_ios,
//                             //       color: Colors.black,
//                             //       size: 12,
//                             //     ),
//                             //   ],
//                             // ),
//                             //     ],
//                             //   ),
//                             // ),

//                             // Column(
//                             //   mainAxisAlignment: MainAxisAlignment.center,
//                             //   children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 //  Expanded(
//                                 // child:
//                                 Row(
//                                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'View all menu',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                           decoration: TextDecoration.underline,
//                                         ),
//                                         // ),
//                                       ),
//                                       Icon(
//                                         Icons.arrow_forward_ios,
//                                         color: Colors.black,
//                                         size: 12,
//                                       ),
//                                     ]),

//                                 // Row(
//                                 //   children: [
//                                 //     Text(
//                                 //       '${totalCartItems.toString()} items | ₹${finalTotal.toString()}',
//                                 //       style: TextStyle(
//                                 //         fontSize: 14,
//                                 //         fontWeight: FontWeight.bold,
//                                 //       ),
//                                 //       overflow: TextOverflow.ellipsis,
//                                 //     ),
//                                 //   ],
//                                 // ),
//                                 // SizedBox(height: 10),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Color(0xFFE23744),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 15, vertical: 5),
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => CartPage(),
//                                       ),
//                                     );
//                                   },
//                                   child: Text(
//                                     'View Cart',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )),
//                         SizedBox(width: 15),

//                         // Delete Cart Button
//                         GestureDetector(
//                           onTap: () async {
//                             await deletecart();
//                           },
//                           child: Container(
//                             width: 30,
//                             height: 30,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Color(0xFFE23744),
//                             ),
//                             child: Center(
//                               child: Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                                 size: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             : null);
//   }
// }

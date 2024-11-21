import 'package:flutter/material.dart';
import 'package:namfood/constants/app_assets.dart';
import 'package:namfood/pages/models/homescreen_model.dart';
import 'package:namfood/pages/store/store_page.dart';
import 'package:namfood/widgets/custom_text_field.dart';
import 'package:namfood/widgets/heading_widget.dart';
import 'package:namfood/widgets/sub_heading_widget.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../widgets/svgiconButtonWidget.dart';
import '../location/selectlocation_page.dart';
import '../models/home_carouseldata_model.dart';
import '../models/locationpopup_model.dart';
import 'home_screen1.dart';

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

  late AnimationController? _animationController;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    gethomecarousel();
    getdashbordlist();
    getlocationpopup();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
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
    });
  }

  //AddtoCart
  List<dashboardlist> dashlistpage = [];
  List<dashboardlist> dashlistpageAll = [];
  bool isLoading = false;

  Future getdashbordlist() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getdashbordlist();
      var response = dashboardlistmodelFromJson(result);
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
  List<carousels> carouselpage = [];
  List<carousels> carouselpageAll = [];
  bool isLoading2 = false;

  Future gethomecarousel() async {
    setState(() {
      isLoading2 = true;
    });

    try {
      var result = await apiService.gethomecarousel();
      var response = homecarouselDataFromJson(result);
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

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      Image.asset(AppAssets.map_icon),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "No.132 St, New York",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen1(),
                        ),
                      );
                    },
                    child: Image.asset(AppAssets.notification_icon)),
              ],
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 0.1,
                child: CustomeTextField(
                  hint: "Restaurant name or dish",
                  // prefixIcon: Icon(Icons.search, color: Color(0xFFE23744)),
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
                )),
          ],
        ),
      ),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(21, 23, 21, 15),
                child: Column(
                  children: [
                    if (carouselpage.isNotEmpty)
                      CarouselSlider.builder(
                        itemCount: carouselpage.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          final e = carouselpage[itemIndex];
                          return ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Image.asset(
                              e.image,
                              fit: BoxFit.fill,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(''); // Fallback image
                              },
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 13.2 / 6,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      ),
                    SizedBox(height: 16),
                    if (carouselpage
                        .isNotEmpty) // Show DotsIndicator only if list is not empty
                      DotsIndicator(
                        dotsCount: carouselpage.length,
                        position: currentIndex,
                        decorator: DotsDecorator(
                          color: const Color.fromARGB(255, 216, 216, 216),
                          activeColor: Color(0xFFE23744),
                          size: const Size.square(8.0),
                          activeSize: const Size(12.0, 8.0),
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
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
                      padding: const EdgeInsets.fromLTRB(15, 0, 18, 5),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFEEEEEE),
                            width: 0.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 196, 195, 195)
                                  .withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StorePage(),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          AppAssets.foodimg,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                topLeft: Radius.circular(10)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              e.type == "Non-Veg"
                                                  ? Image.asset(
                                                      AppAssets.nonveg_icon,
                                                      width: 14,
                                                      height: 14)
                                                  : Image.asset(
                                                      AppAssets.veg_icon,
                                                      width: 14,
                                                      height: 14),
                                              SizedBox(width: 4),
                                              HeadingWidget(
                                                title: e.type,
                                                color: e.type == "Non-Veg"
                                                    ? Color(0xFFEF4848)
                                                    : Colors.green,
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Icon(Icons.favorite_border,
                                            color: Colors.white),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                HeadingWidget(
                                                  title: e.title,
                                                  //  'Grill Chicken Arabian \nRestaurant',
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 21,
                                        right: 12,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE23744),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.star,
                                                  color: Colors.white,
                                                  size: 16),
                                              SizedBox(width: 4),
                                              SubHeadingWidget(
                                                  title: e.reviews, // ' 4.5 ',
                                                  color: Colors.white),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(AppAssets.offerimg),
                                            SizedBox(width: 4),
                                            SubHeadingWidget(
                                              title:
                                                  "${e.offerpercentage}% off", //'40% Off ,
                                              color: Colors.black87,
                                            ),
                                            SubHeadingWidget(
                                              title:
                                                  "-Upto ₹${e.offerupto}", // Upto ₹90',
                                              color: Colors.black87,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SubHeadingWidget(
                                                title:
                                                    " ${e.km} Km - ", //'2.5km',
                                                color: Colors.black),
                                            SizedBox(width: 3),
                                            SubHeadingWidget(
                                                title: e.time, //'10mins',
                                                color: Colors.black),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ));
                },
              ),
            ],
          )),
        )
      ]),);
  }
    }
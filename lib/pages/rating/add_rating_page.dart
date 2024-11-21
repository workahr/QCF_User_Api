import 'package:flutter/material.dart';
import 'package:namfood/widgets/sub_heading_widget.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/heading_widget.dart';
import '../models/add_ratinglist_model.dart';

class AddRatingPage extends StatefulWidget {
  @override
  _AddRatingPageState createState() => _AddRatingPageState();
}

class _AddRatingPageState extends State<AddRatingPage> {
  // Variables to store ratings
  double restaurantRating = 4;
  double chickenBiryaniRating = 4;
  double chickenKebabRating = 4;
  double deliveryPersonRating = 3;
  TextEditingController commentController = TextEditingController();

  // Method to build star rating widget
  Widget buildStarRating(int rating, ValueChanged<double> onRatingChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            onRatingChanged(index + 1.0);
          },
          icon: Icon(
            size: 16.0,
            Icons.star,
            color: index < rating ? Colors.amber : Colors.grey[300],
          ),
        );
      }),
    );
  }

  final NamFoodApiService apiService = NamFoodApiService();

  @override
  void initState() {
    super.initState();

    getAddRatingList();
  }

  List<AddRatingList> adddRatingList = [];
  List<AddRatingList> adddRatingListAll = [];
  bool isLoading = false;
  double totalDiscountPrice = 0.0;

  Future getAddRatingList() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getAddRatingList();
      var response = AddRatinglistmodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          adddRatingList = response.list;
          adddRatingListAll = adddRatingList;
          isLoading = false;
        });
      } else {
        setState(() {
          adddRatingList = [];
          adddRatingListAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        adddRatingList = [];
        adddRatingListAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadingWidget(title: 'Back'),
        backgroundColor: AppColors.lightGrey3,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Section
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.feedback_message_icon,
                  height: 25,
                  width: 30,
                ),
                const SizedBox(width: 8),
                HeadingWidget(
                  title: 'We need your important comments!',
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Restaurant Image
            if (adddRatingList.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  adddRatingList[0].dishimage.toString(),
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            const SizedBox(height: 20),
            // Restaurant Name and Rating
            if (adddRatingList.isNotEmpty)
              HeadingWidget(
                title: adddRatingList[0].storeName,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            SubHeadingWidget(
              title: 'Please take a moment to rate a review',
              color: AppColors.black,
            ),
            const SizedBox(height: 10),
            if (adddRatingList.isNotEmpty)
              buildStarRating(adddRatingList[0].storeRating!, (rating) {
                setState(() {
                  restaurantRating = rating;
                });
              }),
            const SizedBox(height: 20),
            // Description Text Field
            CustomeTextField(
              width: MediaQuery.of(context).size.width - 10.0,
              hint: '  Description',

              labelColor: AppColors.primary,
              // borderColor: AppColors.primary2,
              focusBorderColor: AppColors.primary,
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              borderColor: AppColors.lightGrey3,
              lines: 4,
            ),
            const SizedBox(height: 20),
            //Bill container details
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child:
                  //  Padding(
                  // padding: EdgeInsets.all(16.0),
                  // child:
                  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingWidget(
                      title: 'Rate your order dish',
                      fontWeight: FontWeight.bold),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  if (adddRatingList.isNotEmpty)
                    ...adddRatingList[0].dishes.map((dish) {
                      return buildDishRating(
                          dish.name ?? '', int.parse(dish.rating.toString()),
                          (newRating) {
                        setState(() {
                          dish.rating = int.parse(newRating.toString());
                        });
                      });
                    }).toList(),
                  // buildDishRating('Chicken Biryani', chickenBiryaniRating,
                  //     (rating) {
                  //   setState(() {
                  //     chickenBiryaniRating = rating;
                  //   });
                  // }),
                  // buildDishRating('Chicken Kebab', chickenKebabRating,
                  //     (rating) {
                  //   setState(() {
                  //     chickenKebabRating = rating;
                  //   });
                  // }),
                ],
              ),
              //),
            ),
            const SizedBox(height: 20),
            // Rate Delivery Person Section
            //Bill container details
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child:
                  // Padding(
                  // padding: EdgeInsets.all(16.0),
                  // child:
                  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rate Delivery Person',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  if (adddRatingList.isNotEmpty)
                    buildDishRating(adddRatingList[0].deliveryperson.toString(),
                        int.parse(adddRatingList[0].personRating.toString()),
                        (rating) {
                      setState(() {
                        deliveryPersonRating = rating;
                      });
                    }),
                ],
              ),
              //),
            ),
            const SizedBox(height: 30),
            // Submit Button
            SizedBox(
                width: 130,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submission
                    print('Ratings Submitted');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: AppColors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Submit'),
                )),
          ],
        ),
      ),
    );
  }

  // Method to build individual dish rating row
  Widget buildDishRating(
      String dishName, int rating, ValueChanged<double> onRatingChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SubHeadingWidget(
          fontSize: 12.0,
          title: dishName,
          color: AppColors.black,
        ),
        buildStarRating(rating, onRatingChanged),
      ],
    );
  }
}

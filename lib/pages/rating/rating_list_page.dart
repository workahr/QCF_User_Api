import 'package:flutter/material.dart';
import 'package:namfood/widgets/heading_widget.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../models/storerating_model.dart';

class RatingListPage extends StatefulWidget {
  @override
  _RatingListPageState createState() => _RatingListPageState();
}

class _RatingListPageState extends State<RatingListPage> {
  final NamFoodApiService apiService = NamFoodApiService();

  @override
  void initState() {
    super.initState();

    getstoreratinglist();
  }

  //AddtoCart
  List<storerating> storeratinglistpage = [];
  List<storerating> storeratinglistpageAll = [];
  bool isLoading = false;

  Future getstoreratinglist() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getstoreratinglist();
      var response = storeratinglistmodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          storeratinglistpage = response.list;
          storeratinglistpageAll = storeratinglistpage;
          isLoading = false;
        });
      } else {
        setState(() {
          storeratinglistpage = [];
          storeratinglistpageAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        storeratinglistpage = [];
        storeratinglistpageAll = [];
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
        title: HeadingWidget(title: 'Review & Rating', color: Colors.black),
        backgroundColor: AppColors.lightGrey3,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grill Chicken Arabian Restaurant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '4.0',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    buildStarRow(4),
                    SizedBox(height: 5),
                    Text('2,364 Reviews',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            buildRatingDistribution(),
            Divider(color: Colors.grey[300]),
            SizedBox(height: 20),
            Text(
              'Detailed Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
                itemCount: storeratinglistpage.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final e = storeratinglistpage[index];
                  return Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppColors.black,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/images/profileimg.png",
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                            ),

                            // CircleAvatar(
                            //   backgroundImage: NetworkImage(
                            //     e.image.toString(),
                            //   ),
                            //   radius: 25,
                            // ),
                            SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e.username.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4.0,
                                          horizontal: 8.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
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
                                              e.rating.toString(), // '4.5',
                                              style: TextStyle(
                                                color: AppColors.light,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Chicken Briyani"),
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          Icons.star,
                                          color: index < e.star
                                              ? Colors.amber
                                              : Colors.grey[300],
                                        );
                                      }),
                                    )
                                  ]),
                                  Row(children: [
                                    Text("Chicken Kebab"),
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          Icons.star,
                                          color: index < e.star
                                              ? Colors.amber
                                              : Colors.grey[300],
                                        );
                                      }),
                                    )
                                  ]),
                                  SizedBox(height: 10),
                                  Text(
                                    e.description.toString(),
                                    //  review['review'],
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300]),
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget buildStarRow(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          Icons.star,
          color: index < rating ? Colors.amber : Colors.grey[300],
        );
      }),
    );
  }

  // Method to build rating distribution bars
  Widget buildRatingDistribution() {
    return Column(
      children: [
        buildRatingBar(5, 0.7),
        buildRatingBar(4, 0.6),
        buildRatingBar(3, 0.5),
        buildRatingBar(2, 0.4),
        buildRatingBar(1, 0.2),
      ],
    );
  }

  // Method to build individual rating bar
  Widget buildRatingBar(int star, double fillPercentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$star'),
          SizedBox(width: 10),
          Expanded(
            child: LinearProgressIndicator(
              value: fillPercentage,
              color: Colors.red,
              backgroundColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}

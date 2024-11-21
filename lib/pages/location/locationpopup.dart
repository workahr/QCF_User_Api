import 'package:flutter/material.dart';
import 'package:namfood/pages/models/locationpopup_model.dart';
import 'package:namfood/widgets/sub_heading_widget.dart';
import 'package:namfood/widgets/svgiconButtonWidget.dart';

import '../../constants/constants.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/button1_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/heading_widget.dart';
import '../models/selectlocation_model.dart';

class BottomPopupDemo extends StatefulWidget {
  @override
  State<BottomPopupDemo> createState() => _BottomPopupDemoState();
}

class _BottomPopupDemoState extends State<BottomPopupDemo> {
  final NamFoodApiService apiService = NamFoodApiService();

  @override
  void initState() {
    super.initState();

    getlocationpopup();
  }

  //selectocation
  List<popups> locationpopuppage = [];
  List<popups> locationpopuppageAll = [];
  bool isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Popup Demo"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => _buildBottomPopupContent(context),
            );
          },
          child: Text("Show Bottom Popup"),
        ),
      ),
    );
  }

  Widget _buildBottomPopupContent(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              height: 240,
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  final e = locationpopuppage[index];
                  return Column(
                    children: [
                      Container(
                        // padding: EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      fontSize: 16.00,
                                      fontWeight: FontWeight.w500,
                                      title: e.address.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Text(
              'view more',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.red,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.red,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: AppColors.grey,
                    indent: screenWidth * 0.05, // 5% of screen width
                    endIndent: screenWidth * 0.02, // 2% of screen width
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  'Or',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: screenWidth * 0.04), // 4% of screen width
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: AppColors.grey,
                    indent: screenWidth * 0.02, // 2% of screen width
                    endIndent: screenWidth * 0.05, // 5% of screen width
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            SvgIconButtonWidget(
              title: "Select Automatically",
              width: screenWidth,
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
  }
}

void main() {
  runApp(MaterialApp(
    home: BottomPopupDemo(),
  ));
}

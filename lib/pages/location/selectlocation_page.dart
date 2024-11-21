import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/heading_widget.dart';
import '../models/selectlocation_model.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final NamFoodApiService apiService = NamFoodApiService();

  @override
  void initState() {
    super.initState();

    getselectlocation();
  }

  //selectocation
  List<locations> locationpage = [];
  List<locations> locationpageAll = [];
  bool isLoading = false;

  Future getselectlocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getselectlocation();
      var response = selectlocationmodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          locationpage = response.list;
          locationpageAll = locationpage;
          isLoading = false;
        });
      } else {
        setState(() {
          locationpage = [];
          locationpageAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        locationpage = [];
        locationpageAll = [];
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
        backgroundColor: AppColors.lightGrey3,
        title: Text(
          'Select a location',
          style: TextStyle(
            color: AppColors.n_black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: screenHeight * 0),
            child: CustomeTextField(
                borderColor: AppColors.grey1,
                width: screenWidth,
                hint: 'Search your location',
                hintColor: AppColors.grey,
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: AppColors.grey,
                )),
          ),
          Container(
            child: ListTile(
              leading: Image.asset(
                AppAssets.mappoint_red,
                width: 20,
                height: 20,
              ),
              title: HeadingWidget(
                title: 'Locate me',
                fontWeight: FontWeight.w600,
                color: AppColors.red,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppColors.red,
              ),
            ),
          ),
          SizedBox(
            height: 8,
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
              Text(
                'Saved Address',
                style: TextStyle(
                    color: AppColors.grey,
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
          Expanded(
            child: ListView.builder(
              itemCount: locationpage.length,
              itemBuilder: (context, index) {
                final e = locationpage[index];
                return Column(
                  children: [
                    Container(
                      // padding: EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20.0),
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Wrap(
                              children: [
                                HeadingWidget(
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
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:namfood/widgets/button_widget.dart';

import '../../constants/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/heading_widget.dart';

class EditProfilepage extends StatefulWidget {
  const EditProfilepage({super.key});

  @override
  State<EditProfilepage> createState() => _EditProfilepageState();
}

class _EditProfilepageState extends State<EditProfilepage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey3,
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.05),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(AppAssets.profileimg),
                  maxRadius: 50,
                ),
                Positioned(
                  bottom: 0,
                  left: 65,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.red),
                    child: Icon(
                      Icons.edit_outlined,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomeTextField(
                    labelText: 'Name',
                    borderColor: AppColors.grey,
                    width: screenWidth,
                  ),
                  CustomeTextField(
                    labelText: 'Mobile Number',
                    borderColor: AppColors.grey,
                    width: screenWidth,
                  ),
                  CustomeTextField(
                    labelText: 'Email Id',
                    borderColor: AppColors.grey,
                    width: screenWidth,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.04, horizontal: screenWidth * 0.04),
        child: ButtonWidget(
          borderRadius: 10,
          title: "Submit",
          width: screenWidth,
          color: AppColors.red,
          onTap: () {},
        ),
      ),
    );
  }
}

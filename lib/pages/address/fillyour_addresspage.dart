import 'package:flutter/material.dart';
import 'package:namfood/constants/app_assets.dart';
import 'package:namfood/pages/HomeScreen/home_screen.dart';
import 'package:namfood/widgets/heading_widget.dart';
import 'package:namfood/widgets/outline_btn_widget.dart';

import '../../constants/app_colors.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/sub_heading_widget.dart';

class FillyourAddresspage extends StatefulWidget {
  const FillyourAddresspage({super.key});

  @override
  State<FillyourAddresspage> createState() => _FillyourAddresspageState();
}

class _FillyourAddresspageState extends State<FillyourAddresspage> {
  int? _selectedCheckboxIndex;
  int _selectedIndex = 0;
  String _selectedAddressType = 'Home'; // Default selected address type

  // Method to build address form
  Widget _buildAddressForm(String type) {
    List<Widget> fields = [
      CustomeTextField(
        borderColor: AppColors.grey1,
        labelText: 'Contact Number',
        width: MediaQuery.of(context).size.width,
      ),
      CustomeTextField(
        borderColor: AppColors.grey1,
        labelText: 'Land Mark',
        width: MediaQuery.of(context).size.width,
      ),
      CustomeTextField(
        borderColor: AppColors.grey1,
        labelText: 'Address',
        lines: 3,
        width: MediaQuery.of(context).size.width,
      ),
      Row(
        children: [
          Checkbox(
            side: BorderSide(color: AppColors.grey, width: 2),
            activeColor: AppColors.red, // Color when checked
            checkColor: Colors.white, // Color of the tick mark
            value: _selectedCheckboxIndex == _selectedIndex,
            onChanged: (bool? value) {
              setState(() {
                _selectedCheckboxIndex = value == true ? _selectedIndex : null;
              });
            },
          ),
          SubHeadingWidget(
            title: 'Set as default address',
            color: AppColors.red,
          )
        ],
      ),
    ];

    if (type == 'Other') {
      fields.insert(
        0,
        CustomeTextField(
          borderColor: AppColors.grey1,
          labelText: 'Save As',
          width: MediaQuery.of(context).size.width,
        ),
      );
    }

    return Column(children: fields);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey3,
        title: Text('Fill your address'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlineBtnWidget(
              borderColor: AppColors.red,
              titleColor: AppColors.red,
              icon: Icons.my_location,
              iconColor: AppColors.red,
              title: "Locate me automatically",
              height: 50,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: AppColors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Or',
                    style: TextStyle(color: AppColors.black, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            HeadingWidget(
              title: "Fill Your Address Manually",
            ),
            SizedBox(height: 16),
            // Row of buttons to select address type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAddressTypeButton('Home', AppAssets.home_red),
                _buildAddressTypeButton('Work', AppAssets.work_red),
                _buildAddressTypeButton('Other', Icons.location_on_outlined),
              ],
            ),
            SizedBox(height: 20),
            // Address form based on selected type
            _buildAddressForm(_selectedAddressType),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ButtonWidget(
              borderRadius: 10,
              title: "Save",
              width: screenWidth,
              color: AppColors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeadingWidget(
                    title: 'Skip now',
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to create a button for address type
  Widget _buildAddressTypeButton(String type, dynamic icon) {
    bool isSelected = _selectedAddressType == type;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedAddressType = type;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : AppColors.red,
        backgroundColor: isSelected ? AppColors.red : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.red),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon is IconData
              ? Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.red,
                )
              : Image.asset(
                  isSelected ? AppAssets.home_white : icon,
                  width: 18,
                  height: 18,
                ),
          SizedBox(width: 8),
          Text(type),
        ],
      ),
    );
  }
}

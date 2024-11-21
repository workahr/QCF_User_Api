import 'package:flutter/material.dart';
import 'package:namfood/constants/app_colors.dart';
import 'package:namfood/widgets/custom_text_field.dart';
import 'package:namfood/widgets/sub_heading_widget.dart';
import '../widgets/button_widget.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  int? _selectedCheckboxIndex;
  int _selectedIndex = 0; // Track the selected section (Home, Work, Others)

  // Method to change the section
  void _onSectionSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildAddressForm({
    required String contactLabel,
    required String landmarkLabel,
    required String addressLabel,
    String? extraFieldLabel,
  }) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        if (extraFieldLabel != null)
          CustomeTextField(
            borderColor: AppColors.grey,
            labelText: extraFieldLabel,
            width: screenWidth,
          ),
        CustomeTextField(
          borderColor: AppColors.grey1,
          labelText: contactLabel,
          width: screenWidth,
        ),
        CustomeTextField(
          borderColor: AppColors.grey1,
          labelText: landmarkLabel,
          width: screenWidth,
        ),
        CustomeTextField(
          contentPadding: EdgeInsets.all(16),
          borderColor: AppColors.grey1,
          labelText: addressLabel,
          lines: 3,
          width: screenWidth,
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
                  _selectedCheckboxIndex =
                      value == true ? _selectedIndex : null;
                });
              },
            ),
            SubHeadingWidget(
              title: 'Set as default address',
              color: AppColors.red,
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20.0),
        child: Column(
          children: [
            // Custom Buttons for Section Switching
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton(
                  label: "Home",
                  isSelected: _selectedIndex == 0,
                  icon: Icons.home,
                  onTap: () => _onSectionSelected(0),
                ),
                SizedBox(
                  width: 20,
                ),
                _buildTabButton(
                  label: "Work",
                  isSelected: _selectedIndex == 1,
                  icon: Icons.work_outline,
                  onTap: () => _onSectionSelected(1),
                ),
                SizedBox(
                  width: 20,
                ),
                _buildTabButton(
                  label: "Others",
                  isSelected: _selectedIndex == 2,
                  icon: Icons.location_on_outlined,
                  onTap: () => _onSectionSelected(2),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Content for each section
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildAddressForm(
                    contactLabel: "Contact Number",
                    landmarkLabel: "Land Mark",
                    addressLabel: "Address",
                  ),
                  _buildAddressForm(
                    contactLabel: "Contact Number",
                    landmarkLabel: "Land Mark",
                    addressLabel: "Address",
                  ),
                  _buildAddressForm(
                    contactLabel: "Contact Number",
                    landmarkLabel: "Land Mark",
                    addressLabel: "Address",
                    extraFieldLabel: "Save As",
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
          height: 50.00,
          borderRadius: 10,
          title: "Submit",
          width: screenWidth,
          color: AppColors.red,
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      flex: 2,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : AppColors.red,
          backgroundColor: isSelected ? AppColors.red : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.red),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.red,
              size: 18,
            ),
            SizedBox(width: 12),
            Text(label),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:namfood/constants/app_assets.dart';
// import 'package:namfood/widgets/heading_widget.dart';
// import 'package:namfood/widgets/outline_btn_widget.dart';

// import '../../constants/app_colors.dart';
// import '../../widgets/button_widget.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/sub_heading_widget.dart';
// import '../maincontainer.dart';

// class FillyourAddresspage extends StatefulWidget {
//   const FillyourAddresspage({super.key});

//   @override
//   State<FillyourAddresspage> createState() => _FillyourAddresspageState();
// }

// class _FillyourAddresspageState extends State<FillyourAddresspage> {
//   bool _isChecked1 = false;
//   bool _isChecked2 = false;
//   bool _isChecked3 = false;
//   int _selectedIndex = 0; // Track the selected tab

//   // Method to change the tab
//   void _onTabSelected(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.lightGrey3,
//         title: Text('Fill your address'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             OutlineBtnWidget(
//               borderColor: AppColors.red,
//               titleColor: AppColors.red,
//               icon: Icons.location_on_outlined,
//               iconColor: AppColors.red,
//               title: "Locate me automatically",
//               height: 50,
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Divider(
//                     thickness: 1,
//                     color: AppColors.grey,
//                     indent: screenWidth * 0.05, // 5% of screen width
//                     endIndent: screenWidth * 0.02, // 2% of screen width
//                   ),
//                 ),
//                 Text(
//                   'Or',
//                   style: TextStyle(
//                       color: AppColors.black,
//                       fontSize: screenWidth * 0.04), // 4% of screen width
//                 ),
//                 Expanded(
//                   child: Divider(
//                     thickness: 1,
//                     color: AppColors.grey,
//                     indent: screenWidth * 0.02, // 2% of screen width
//                     endIndent: screenWidth * 0.05, // 5% of screen width
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             HeadingWidget(
//               title: "Fill Your Address Manually",
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             // Custom Tab Bar with ElevatedButtons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 // Home Tab
//                 Expanded(
//                   flex: 2,
//                   child: ElevatedButton(
//                     onPressed: () => _onTabSelected(0),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor:
//                           _selectedIndex == 0 ? Colors.white : AppColors.red,
//                       backgroundColor:
//                           _selectedIndex == 0 ? AppColors.red : Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(color: AppColors.red),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 16.0),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           _selectedIndex == 0
//                               ? AppAssets.home_white
//                               : AppAssets.home_red,
//                           width: 18,
//                           height: 18,
//                         ),
//                         SizedBox(width: 12),
//                         Text('Home'),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),

//                 // Work Tab
//                 Expanded(
//                   flex: 2,
//                   child: ElevatedButton(
//                     onPressed: () => _onTabSelected(1),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor:
//                           _selectedIndex == 1 ? Colors.white : AppColors.red,
//                       backgroundColor:
//                           _selectedIndex == 1 ? AppColors.red : Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(color: AppColors.red),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 16.0),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           _selectedIndex == 1
//                               ? AppAssets.work_white
//                               : AppAssets.work_red,
//                           width: 18,
//                           height: 18,
//                         ),
//                         SizedBox(width: 8),
//                         Text('Work'),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),

//                 // Others Tab
//                 Expanded(
//                   flex: 2,
//                   child: ElevatedButton(
//                     onPressed: () => _onTabSelected(2),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor:
//                           _selectedIndex == 2 ? Colors.white : AppColors.red,
//                       backgroundColor:
//                           _selectedIndex == 2 ? AppColors.red : Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(color: AppColors.red),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 16.0),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.location_on_outlined,
//                           color: _selectedIndex == 2
//                               ? Colors.white
//                               : AppColors.red,
//                           size: 20,
//                         ),
//                         SizedBox(width: 8),
//                         Text('Others'),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             // Content for each tab
//             Expanded(
//               child: IndexedStack(
//                 index: _selectedIndex, // Display the selected tab's content
//                 children: [
//                   Column(
//                     children: [
//                       CustomeTextField(
//                         borderColor: AppColors.grey1,
//                         labelText: 'Contact Number',
//                         width: screenWidth,
//                       ),
//                       CustomeTextField(
//                         borderColor: AppColors.grey1,
//                         labelText: 'Land Mark',
//                         width: screenWidth,
//                       ),
//                       CustomeTextField(
//                         borderColor: AppColors.grey1,
//                         labelText: 'Address',
//                         lines: 3,
//                         width: screenWidth,
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             side: BorderSide(color: AppColors.grey, width: 2),
//                             activeColor: AppColors.red, // Color when checked
//                             checkColor: Colors.white, // Color of the tick mark
//                             value: _isChecked1,
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 _isChecked1 = value ?? false;
//                               });
//                             },
//                           ),
//                           SubHeadingWidget(
//                             title: 'Set as default address',
//                             color: AppColors.red,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       CustomeTextField(
//                         borderColor: AppColors.grey1,
//                         labelText: 'Contact Number',
//                         width: screenWidth,
//                       ),
//                       CustomeTextField(
//                         borderColor: AppColors.grey1,
//                         labelText: 'Land Mark',
//                         width: screenWidth,
//                       ),
//                       CustomeTextField(
//                         borderColor: AppColors.grey1,
//                         labelText: 'Address',
//                         lines: 3,
//                         width: screenWidth,
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             side: BorderSide(color: AppColors.grey, width: 2),
//                             activeColor: AppColors.red, // Color when checked
//                             checkColor: Colors.white, // Color of the tick mark
//                             value: _isChecked2,
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 _isChecked2 = value ?? false;
//                               });
//                             },
//                           ),
//                           SubHeadingWidget(
//                             title: 'Set as default address',
//                             color: AppColors.red,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       CustomeTextField(
//                         borderColor: AppColors.grey1,
//                         labelText: 'Save As',
//                         width: screenWidth,
//                       ),
//                       CustomeTextField(
//                         borderColor: AppColors.grey1,
//                         labelText: 'Contact Number',
//                         width: screenWidth,
//                       ),
//                       CustomeTextField(
//                         borderColor: AppColors.grey1,
//                         labelText: 'Land Mark',
//                         width: screenWidth,
//                       ),
//                       CustomeTextField(
//                         borderColor: AppColors.grey1,
//                         labelText: 'Address',
//                         lines: 3,
//                         width: screenWidth,
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             side: BorderSide(color: AppColors.grey, width: 2),
//                             activeColor: AppColors.red, // Color when checked
//                             checkColor: Colors.white, // Color of the tick mark
//                             value: _isChecked3,
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 _isChecked3 = value ?? false;
//                               });
//                             },
//                           ),
//                           SubHeadingWidget(
//                             title: 'Set as default address',
//                             color: AppColors.red,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             Center(
//                 child: SizedBox(
//                     width: 150,
//                     height: 50,
//                     child: ButtonWidget(
//                       borderRadius: 10,
//                       title: "Save",
//                       width: screenWidth,
//                       color: AppColors.red,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MainContainer(),
//                           ),
//                         );
//                       },
//                     ))),
//             SizedBox(height: 20),
//             Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   HeadingWidget(
//                     title: 'Skip now',
//                   ),
//                   Icon(
//                     Icons.arrow_forward_ios,
//                     size: 16,
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:namfood/constants/app_assets.dart';
import 'package:namfood/widgets/heading_widget.dart';
import 'package:namfood/widgets/outline_btn_widget.dart';

import '../../constants/app_colors.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/sub_heading_widget.dart';
import '../maincontainer.dart';

class FillyourAddresspage extends StatefulWidget {
  const FillyourAddresspage({super.key});

  @override
  State<FillyourAddresspage> createState() => _FillyourAddresspageState();
}

class _FillyourAddresspageState extends State<FillyourAddresspage> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  int _selectedIndex = 0; // Track the selected tab

  // Method to change the tab
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey3,
        title: Text('Fill your address'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlineBtnWidget(
                borderColor: AppColors.red,
                titleColor: AppColors.red,
                icon: Icons.location_on_outlined,
                iconColor: AppColors.red,
                title: "Locate me automatically",
                height: 50,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: AppColors.grey1,
                      indent: screenWidth * 0.01, // 5% of screen width
                      endIndent: screenWidth * 0.02, // 2% of screen width
                    ),
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
                      color: AppColors.grey1,
                      indent: screenWidth * 0.02, // 2% of screen width
                      endIndent: screenWidth * 0.01, // 5% of screen width
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              HeadingWidget(
                title: "Fill Your Address Manually",
              ),
              SizedBox(
                height: 16,
              ),
              // Custom Tab Bar with ElevatedButtons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Tab
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => _onTabSelected(0),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            _selectedIndex == 0 ? Colors.white : AppColors.red,
                        backgroundColor:
                            _selectedIndex == 0 ? AppColors.red : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: AppColors.red),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _selectedIndex == 0
                                ? AppAssets.home_white
                                : AppAssets.home_red,
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(width: 12),
                          Text('Home'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),

                  // Work Tab
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => _onTabSelected(1),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            _selectedIndex == 1 ? Colors.white : AppColors.red,
                        backgroundColor:
                            _selectedIndex == 1 ? AppColors.red : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: AppColors.red),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _selectedIndex == 1
                                ? AppAssets.work_white
                                : AppAssets.work_red,
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(width: 8),
                          Text('Work'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),

                  // Others Tab
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => _onTabSelected(2),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            _selectedIndex == 2 ? Colors.white : AppColors.red,
                        backgroundColor:
                            _selectedIndex == 2 ? AppColors.red : Colors.white,
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
                            Icons.location_on_outlined,
                            color: _selectedIndex == 2
                                ? Colors.white
                                : AppColors.red,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Others'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Content for each tab
              IndexedStack(
                index: _selectedIndex, // Display the selected tab's content
                children: [
                  Column(
                    children: [
                      CustomeTextField(
                        borderColor: AppColors.grey1,
                        labelText: 'Contact Number',
                        width: screenWidth,
                      ),
                      CustomeTextField(
                        borderColor: AppColors.grey1,
                        labelText: 'Land Mark',
                        width: screenWidth,
                      ),
                      CustomeTextField(
                        borderColor: AppColors.grey1,
                        labelText: 'Address',
                        lines: 3,
                        width: screenWidth,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            side: BorderSide(color: AppColors.grey, width: 2),
                            activeColor: AppColors.red, // Color when checked
                            checkColor: Colors.white, // Color of the tick mark
                            value: _isChecked1,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked1 = value ?? false;
                              });
                            },
                          ),
                          SubHeadingWidget(
                            title: 'Set as default address',
                            color: AppColors.red,
                          )
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CustomeTextField(
                        borderColor: AppColors.grey1,
                        labelText: 'Contact Number',
                        width: screenWidth,
                      ),
                      CustomeTextField(
                        borderColor: AppColors.grey1,
                        labelText: 'Land Mark',
                        width: screenWidth,
                      ),
                      CustomeTextField(
                        borderColor: AppColors.grey1,
                        labelText: 'Address',
                        lines: 3,
                        width: screenWidth,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            side: BorderSide(color: AppColors.grey, width: 2),
                            activeColor: AppColors.red, // Color when checked
                            checkColor: Colors.white, // Color of the tick mark
                            value: _isChecked2,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked2 = value ?? false;
                              });
                            },
                          ),
                          SubHeadingWidget(
                            title: 'Set as default address',
                            color: AppColors.red,
                          )
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CustomeTextField(
                        borderColor: AppColors.grey1,
                        labelText: 'Save As',
                        width: screenWidth,
                      ),
                      CustomeTextField(
                        borderColor: AppColors.grey1,
                        labelText: 'Contact Number',
                        width: screenWidth,
                      ),
                      CustomeTextField(
                        borderColor: AppColors.grey1,
                        labelText: 'Land Mark',
                        width: screenWidth,
                      ),
                      CustomeTextField(
                        borderColor: AppColors.grey1,
                        labelText: 'Address',
                        lines: 3,
                        width: screenWidth,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            side: BorderSide(color: AppColors.grey, width: 2),
                            activeColor: AppColors.red, // Color when checked
                            checkColor: Colors.white, // Color of the tick mark
                            value: _isChecked3,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked3 = value ?? false;
                              });
                            },
                          ),
                          SubHeadingWidget(
                            title: 'Set as default address',
                            color: AppColors.red,
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Center(
                  child: SizedBox(
                      width: 150,
                      height: 50,
                      child: ButtonWidget(
                        borderRadius: 10,
                        title: "Save",
                        width: screenWidth,
                        color: AppColors.red,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainContainer(),
                            ),
                          );
                        },
                      ))),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:namfood/constants/app_assets.dart';
import 'package:namfood/widgets/custom_text_field.dart';
import 'package:namfood/widgets/heading_widget.dart';
import 'package:namfood/widgets/sub_heading_widget.dart';

import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../models/feedback_page_model.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final NamFoodApiService apiService = NamFoodApiService();

  List<FeedBackList> feedbacklistpage = [];
  List<FeedBackList> feedbacklistpageAll = [];
  bool isLoading = false;

  Map<int, bool> _expandedStates = {};

  Future getfeedbacklist() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getfeedbacklist();
      var response = feedbacklistmodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          feedbacklistpage = response.list;
          feedbacklistpageAll = feedbacklistpage;
          isLoading = false;
        });
      } else {
        setState(() {
          feedbacklistpage = [];
          feedbacklistpageAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        feedbacklistpage = [];
        feedbacklistpageAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }
  }

  void _submitFeedback() {
    if (_feedbackController.text.isEmpty) return;

    print("Feedback Submitted: ${_feedbackController.text}");
    _feedbackController.clear();
  }

  @override
  void initState() {
    super.initState();
    getfeedbacklist();
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedStates.containsKey(index)) {
        _expandedStates[index] = !_expandedStates[index]!;
      } else {
        _expandedStates[index] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey3,
        title: HeadingWidget(title: "Feedback & Complaints"),
      ),
      body: SingleChildScrollView(
        // Wrap the entire body with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.feedback_message_icon,
                    height: 25,
                    width: 30,
                  ),
                  SizedBox(width: 10),
                  SubHeadingWidget(
                      title: "We need your valuable feedback",
                      color: Colors.black)
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width / 0.1,
                child: CustomeTextField(
                  control: _feedbackController,
                  hint: "   Description",
                  lines: 5,
                  borderRadius: BorderRadius.circular(15.0),
                  borderColor: Color(0xFFEEEEEE),
                  focusBorderColor: Color.fromARGB(255, 199, 199, 199),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE23744),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text("Submit"),
                    )),
              ),
              SizedBox(height: 24),
              HeadingWidget(
                  title: "Your Feedbacks & Complaints", fontSize: 18.0),
              // ListView.builder remains unchanged; it will be scrollable within SingleChildScrollView
              ListView.builder(
                itemCount: feedbacklistpage.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final e = feedbacklistpage[index];
                  // Format the date properly
                  String formattedDate = DateFormat('dd-MMM-yyyy')
                      .format(DateTime.parse(e.createdDate.toString()));

                  bool isExpanded = _expandedStates[index] ?? false;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.feedback_profile_icon,
                            height: 40,
                            width: 40,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("You",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(formattedDate,
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(e.clientfeedback, softWrap: true, maxLines: null),
                      // SizedBox(height: 1),
                      if (e.adminreplyfeedback != "" &&
                          e.adminreplyfeedback != null)
                        SizedBox(height: 10),
                      if (e.adminreplyfeedback != "" &&
                          e.adminreplyfeedback != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 241, 239, 239),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Padding(
                                padding: EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          AppAssets.feedback_admin_icon,
                                          height: 40,
                                          width: 40,
                                        ),
                                        SizedBox(width: 8),
                                        Text("Admin",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(isExpanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down),
                                          onPressed: () {
                                            _toggleExpansion(index);
                                          },
                                        ),
                                      ],
                                    ),
                                    if (isExpanded)
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              child: Divider(
                                                  color: Color.fromARGB(
                                                      255, 228, 228, 228)),
                                            ),
                                            Text(formattedDate,
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                e.adminreplyfeedback.toString(),
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 54, 54, 54))),
                                          ],
                                        ),
                                      ),
                                  ],
                                )),
                          ),
                        ),
                      SizedBox(height: 10),
                      Divider(
                        color: Color.fromARGB(255, 241, 239, 239),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:namfood/constants/app_assets.dart';
// import 'package:namfood/widgets/custom_text_field.dart';
// import 'package:namfood/widgets/heading_widget.dart';
// import 'package:namfood/widgets/sub_heading_widget.dart';

// import '../../constants/app_colors.dart';

// class FeedbackPage extends StatefulWidget {
//   @override
//   _FeedbackPageState createState() => _FeedbackPageState();
// }

// class _FeedbackPageState extends State<FeedbackPage> {
//   final TextEditingController _feedbackController = TextEditingController();
//   final List<FeedbackItem> _feedbackItems = [];

//   void _submitFeedback() {
//     if (_feedbackController.text.isEmpty) return;

//     setState(() {
//       _feedbackItems.add(FeedbackItem(
//         feedbackText: _feedbackController.text,
//         date: DateTime.now(),
//       ));
//       _feedbackController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.lightGrey3,
//         title: HeadingWidget(title: "Feedback & Complaints"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(AppAssets.feedback_message_icon),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 SubHeadingWidget(
//                   title: "We need your valuable feedback",
//                   color: Colors.black,
//                 )
//               ],
//             ),
//             SizedBox(height: 16),
//             SizedBox(
//                 width: MediaQuery.of(context).size.width / 0.1,
//                 child: CustomeTextField(
//                   //  boxColor: const Color.fromARGB(255, 246, 245, 245),
//                   control: _feedbackController,
//                   hint: "Description",
//                   lines: 5,
//                   borderRadius: BorderRadius.circular(15.0),
//                   borderColor: Color(0xFFEEEEEE),
//                   focusBorderColor: Color.fromARGB(255, 199, 199, 199),
//                 )),
//             SizedBox(height: 16),
//             Center(
//               child: ElevatedButton(
//                 onPressed: _submitFeedback,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFE23744), // Button color
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0), // Border radius
//                   ),
//                 ),
//                 child: Text(" Submit "),
//               ),
//             ),
//             SizedBox(height: 24),
//             HeadingWidget(
//               title: "Your Feedbacks & Complaints",
//               fontSize: 15.0,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _feedbackItems.length,
//                 itemBuilder: (context, index) {
//                   final item = _feedbackItems[index];
//                   return FeedbackCard(item: item);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FeedbackItem {
//   final String feedbackText;
//   final DateTime date;
//   bool isExpanded = false;

//   FeedbackItem({
//     required this.feedbackText,
//     required this.date,
//   });
// }

// class FeedbackCard extends StatefulWidget {
//   final FeedbackItem item;

//   FeedbackCard({required this.item});

//   @override
//   _FeedbackCardState createState() => _FeedbackCardState();
// }

// class _FeedbackCardState extends State<FeedbackCard> {
//   @override
//   Widget build(BuildContext context) {
//     String formattedDate = DateFormat('d-MMM-yyyy').format(widget.item.date);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 15),
//         Row(
//           children: [
//             //  Icon(Icons.person, size: 40),
//             Image.asset(AppAssets.feedback_profile_icon),
//             SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("You", style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(
//                   formattedDate,
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(height: 8),
//         Text(
//           widget.item.feedbackText,
//           softWrap: true,
//           maxLines: null, // Allows text to wrap onto new lines
//         ),
//         SizedBox(height: 15),
//         Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Color.fromARGB(255, 241, 239, 239), // Border color
//                 width: 1.0, // Border width
//               ),
//               borderRadius: BorderRadius.circular(
//                   8.0), // Optional: same as Card's corner radius
//             ),
//             child:
//                 // Card(
//                 //     margin: EdgeInsets.symmetric(vertical: 8.0),
//                 //     child:
//                 Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               widget.item.isExpanded = !widget.item.isExpanded;
//                             });
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               // Icon(Icons.admin_panel_settings, size: 30),
//                               Image.asset(AppAssets.feedback_admin_icon),
//                               SizedBox(width: 8),
//                               Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Admin",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(
//                                       formattedDate,
//                                       style: TextStyle(color: Colors.black),
//                                     )
//                                   ]),
//                               Spacer(),
//                               Icon(widget.item.isExpanded
//                                   ? Icons.keyboard_arrow_up
//                                   : Icons.keyboard_arrow_down),
//                             ],
//                           ),
//                         ),
//                         if (widget.item.isExpanded)
//                           Padding(
//                             padding: EdgeInsets.only(top: 8.0),
//                             child: Column(
//                               children: [
//                                 Divider(
//                                   color: Color.fromARGB(255, 228, 228, 228),
//                                 ),
//                                 Text(
//                                   "Admin response here. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
//                                   style: TextStyle(
//                                       color: const Color.fromARGB(
//                                           255, 54, 54, 54)),
//                                 )
//                               ],
//                             ),
//                           ),
//                       ],
//                     )))
//       ],
//     );
//   }
// }

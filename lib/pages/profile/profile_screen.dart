import 'package:flutter/material.dart';
import 'package:namfood/pages/address/addresspage.dart';
import 'package:namfood/constants/constants.dart';
import 'package:namfood/pages/models/myprofile_title_model.dart';
import 'package:namfood/pages/profile/edit_profilepage.dart';
import 'package:namfood/pages/profile/feedback_page.dart';
import 'package:namfood/widgets/button_widget.dart';
import 'package:namfood/widgets/outline_btn_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../address/edit_addresspage.dart';
import '../../constants/app_assets.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../models/myprofile_model.dart';
import 'join_deliveryboy.dart';
import 'join_withus_store.dart';
import 'profiledetails_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _expandedIndex = -1;
  int all_expandedIndex = -1;
  final NamFoodApiService apiService = NamFoodApiService();

  @override
  void initState() {
    super.initState();
    getprofileDetails();
    getmyprofile();
    getmyprofiletitle();
  }

  //myprofile
  List<myprofilelist> myprofilepage = [];
  List<myprofilelist> myprofilepageAll = [];
  bool isLoading = false;

  Future getmyprofile() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getmyprofile();
      var response = myprofilemodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          myprofilepage = response.list;
          myprofilepageAll = myprofilepage;
          isLoading = false;
        });
      } else {
        setState(() {
          myprofilepage = [];
          myprofilepageAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        myprofilepage = [];
        myprofilepageAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  //myprofiletitle
  List<myprofiletitles> myprofiletitlepage = [];
  List<myprofiletitles> myprofiletitlepageAll = [];
  bool isLoading1 = false;

  Future getmyprofiletitle() async {
    setState(() {
      isLoading1 = true;
    });

    try {
      var result = await apiService.getmyprofiletitle();
      var response = myprofiletitlemodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          myprofiletitlepage = response.list;
          myprofiletitlepageAll = myprofiletitlepage;
          isLoading1 = false;
        });
      } else {
        setState(() {
          myprofiletitlepage = [];
          myprofiletitlepageAll = [];
          isLoading1 = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        myprofiletitlepage = [];
        myprofiletitlepageAll = [];
        isLoading1 = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
    }

    setState(() {});
  }

  Future<void> _handleLogout() async {
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to Login Page
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

// myprofile
  ProfileDetails? profiledetailsList;
  // List<ProfileDetails> profiledetailsListAll = [];

  Future getprofileDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getprofileDetails();
      var response = userDetailsmodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          print("userdetails $profiledetailsList");
          profiledetailsList = response.list;
          // profiledetailsListAll = profiledetailsList;
          isLoading = false;
        });
      } else {
        setState(() {
          profiledetailsList = null;
          // profiledetailsListAll = [];
          isLoading = false;
        });
        showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        profiledetailsList = null;
        // profiledetailsListAll = [];
        isLoading = false;
      });
      showInSnackBar(context, 'Error occurred: $e');
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(140.0),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: AppBar(
                      title: Text(
                        'My Profile',
                        style: TextStyle(color: AppColors.white),
                      ),
                      automaticallyImplyLeading: false,
                      backgroundColor: AppColors.red,
                      flexibleSpace: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    profiledetailsList != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                AppConstants.imgBaseUrl +
                                                    profiledetailsList!.imageUrl
                                                        .toString()
                                                //AppAssets.profileavathar
                                                ),
                                            radius: 30.0,
                                            backgroundColor: Colors.white,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      AppAssets.profileimg),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (profiledetailsList != null)
                                          HeadingWidget(
                                            title:
                                                (profiledetailsList!.fullname ??
                                                    ''), // "Johan Singh",
                                            color: AppColors.white,
                                          ),
                                        if (profiledetailsList != null)
                                          HeadingWidget(
                                            title: profiledetailsList!
                                                .mobile, // "999548547",
                                            color: AppColors.white,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             EditProfilepage()));
                                    if (profiledetailsList != null)
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfilepage(
                                                    userId:
                                                        profiledetailsList!.id,
                                                  ))).then((value) {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: Colors.white,
                                  ),
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: AppColors.red,
                                  ),
                                  label: Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: AppColors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount:
                      myprofiletitlepage.length, // Set the number of items
                  itemBuilder: (context, index) {
                    final e = myprofiletitlepage[index];
                    final status = e.title.toString();
                    if (status == 'Address')
                      return Container(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Image.asset(
                                e.icon.toString(),
                                height: 24,
                                width: 24,
                              ),
                              title: HeadingWidget(
                                title: e.title.toString(),
                                color: AppColors.black,
                              ),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Addresspage()));
                                    });
                                  }),
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Addresspage()));
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    else if (status == 'Join as deliveryboy')
                      return Container(
                        height: 50,
                        child: ListTile(
                          leading: Image.asset(
                            e.icon.toString(),
                            height: 24,
                            width: 24,
                          ),
                          title: HeadingWidget(
                            title: e.title.toString(),
                            color: AppColors.black,
                          ),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JoinDeliveryboy(),
                                    ),
                                  );
                                });
                              }),
                          onTap: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JoinDeliveryboy(),
                                ),
                              );
                            });
                          },
                        ),
                      );
                    else if (status == 'Join with us for store')
                      return Container(
                        height: 50,
                        child: ListTile(
                          leading: Image.asset(
                            e.icon.toString(),
                            height: 24,
                            width: 24,
                          ),
                          title: HeadingWidget(
                            title: e.title.toString(),
                            color: AppColors.black,
                          ),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Joinwithusforstore(),
                                    ),
                                  );
                                });
                              }),
                          onTap: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Joinwithusforstore(),
                                ),
                              );
                            });
                          },
                        ),
                      );
                    else if (status == 'Log out')
                      return Container(
                        height: 50,
                        child: ListTile(
                          leading: Image.asset(
                            e.icon.toString(),
                            height: 24,
                            width: 24,
                          ),
                          title: HeadingWidget(
                            title: e.title.toString(),
                            color: AppColors.black,
                          ),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  _handleLogout();
                                });
                              }),
                          onTap: () {
                            setState(() {
                              _handleLogout();
                            });
                          },
                        ),
                      );

                    Divider(
                      color: AppColors.grey1,
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}






// import 'package:flutter/material.dart';
// import 'package:namfood/pages/address/addresspage.dart';
// import 'package:namfood/constants/constants.dart';
// import 'package:namfood/pages/models/myprofile_title_model.dart';
// import 'package:namfood/pages/profile/edit_profilepage.dart';
// import 'package:namfood/pages/profile/feedback_page.dart';
// import 'package:namfood/widgets/button_widget.dart';
// import 'package:namfood/widgets/outline_btn_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../address/edit_addresspage.dart';
// import '../../constants/app_assets.dart';
// import '../../services/comFuncService.dart';
// import '../../services/nam_food_api_service.dart';
// import '../../widgets/heading_widget.dart';
// import '../../widgets/sub_heading_widget.dart';
// import '../models/myprofile_model.dart';
// import 'profiledetails_model.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   int _expandedIndex = -1;
//   int all_expandedIndex = -1;
//   final NamFoodApiService apiService = NamFoodApiService();

//   @override
//   void initState() {
//     super.initState();
//     getprofileDetails();
//     getmyprofile();
//     getmyprofiletitle();
//   }

//   //myprofile
//   List<myprofilelist> myprofilepage = [];
//   List<myprofilelist> myprofilepageAll = [];
//   bool isLoading = false;

//   Future getmyprofile() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getmyprofile();
//       var response = myprofilemodelFromJson(result);
//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {
//           myprofilepage = response.list;
//           myprofilepageAll = myprofilepage;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           myprofilepage = [];
//           myprofilepageAll = [];
//           isLoading = false;
//         });
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         myprofilepage = [];
//         myprofilepageAll = [];
//         isLoading = false;
//       });
//       showInSnackBar(context, 'Error occurred: $e');
//     }

//     setState(() {});
//   }

//   //myprofiletitle
//   List<myprofiletitles> myprofiletitlepage = [];
//   List<myprofiletitles> myprofiletitlepageAll = [];
//   bool isLoading1 = false;

//   Future getmyprofiletitle() async {
//     setState(() {
//       isLoading1 = true;
//     });

//     try {
//       var result = await apiService.getmyprofiletitle();
//       var response = myprofiletitlemodelFromJson(result);
//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {
//           myprofiletitlepage = response.list;
//           myprofiletitlepageAll = myprofiletitlepage;
//           isLoading1 = false;
//         });
//       } else {
//         setState(() {
//           myprofiletitlepage = [];
//           myprofiletitlepageAll = [];
//           isLoading1 = false;
//         });
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         myprofiletitlepage = [];
//         myprofiletitlepageAll = [];
//         isLoading1 = false;
//       });
//       showInSnackBar(context, 'Error occurred: $e');
//     }

//     setState(() {});
//   }

//   Future<void> _handleLogout() async {
//     // Clear SharedPreferences
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();

//     // Navigate to Login Page
//     Navigator.pushNamedAndRemoveUntil(
//         context, '/login', ModalRoute.withName('/login'));
//   }

// // myprofile
//   ProfileDetails? profiledetailsList;
//   // List<ProfileDetails> profiledetailsListAll = [];

//   Future getprofileDetails() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getprofileDetails();
//       var response = userDetailsmodelFromJson(result);
//       if (response.status.toString() == 'SUCCESS') {
//         setState(() {
//           print("userdetails $profiledetailsList");
//           profiledetailsList = response.list;
//           // profiledetailsListAll = profiledetailsList;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           profiledetailsList = null;
//           // profiledetailsListAll = [];
//           isLoading = false;
//         });
//         showInSnackBar(context, response.message.toString());
//       }
//     } catch (e) {
//       setState(() {
//         profiledetailsList = null;
//         // profiledetailsListAll = [];
//         isLoading = false;
//       });
//       showInSnackBar(context, 'Error occurred: $e');
//       print('Error occurred: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//         appBar: PreferredSize(
//             preferredSize: Size.fromHeight(140.0),
//             child: isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(20.0),
//                       bottomRight: Radius.circular(20.0),
//                     ),
//                     child: AppBar(
//                       title: Text(
//                         'My Profile',
//                         style: TextStyle(color: AppColors.white),
//                       ),
//                       automaticallyImplyLeading: false,
//                       backgroundColor: AppColors.red,
//                       flexibleSpace: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 60,
//                             ),
//                             SizedBox(height: 16),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     profiledetailsList != null
//                                         ? CircleAvatar(
//                                             backgroundImage: NetworkImage(
//                                                 AppConstants.imgBaseUrl +
//                                                     profiledetailsList!.imageUrl
//                                                         .toString()
//                                                 //AppAssets.profileavathar
//                                                 ),
//                                             radius: 30.0,
//                                             backgroundColor: Colors.white,
//                                           )
//                                         : ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(16),
//                                             child: Container(
//                                               width: 60,
//                                               height: 60,
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 image: DecorationImage(
//                                                   image: AssetImage(
//                                                       AppAssets.profileimg),
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                     SizedBox(width: 12),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         if (profiledetailsList != null)
//                                           HeadingWidget(
//                                             title:
//                                                 (profiledetailsList!.fullname ??
//                                                     ''), // "Johan Singh",
//                                             color: AppColors.white,
//                                           ),
//                                         if (profiledetailsList != null)
//                                           HeadingWidget(
//                                             title: profiledetailsList!
//                                                 .mobile, // "999548547",
//                                             color: AppColors.white,
//                                           ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 ElevatedButton.icon(
//                                   onPressed: () {
//                                     // Navigator.push(
//                                     //     context,
//                                     //     MaterialPageRoute(
//                                     //         builder: (context) =>
//                                     //             EditProfilepage()));
//                                     if (profiledetailsList != null)
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   EditProfilepage(
//                                                     userId:
//                                                         profiledetailsList!.id,
//                                                   ))).then((value) {});
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                     backgroundColor: Colors.white,
//                                   ),
//                                   icon: Icon(
//                                     Icons.edit_outlined,
//                                     size: 18,
//                                     color: AppColors.red,
//                                   ),
//                                   label: Text(
//                                     'Edit',
//                                     style: TextStyle(
//                                       color: AppColors.red,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount:
//                       myprofiletitlepage.length, // Set the number of items
//                   itemBuilder: (context, index) {
//                     final e = myprofiletitlepage[index];
//                     final status = e.title.toString();
//                     if (status == 'Address')
//                       return Container(
//                         child: Column(
//                           children: [
//                             ListTile(
//                               leading: Image.asset(
//                                 e.icon.toString(),
//                                 height: 24,
//                                 width: 24,
//                               ),
//                               title: HeadingWidget(
//                                 title: e.title.toString(),
//                                 color: AppColors.black,
//                               ),
//                               trailing: IconButton(
//                                   icon: Icon(
//                                     Icons.arrow_forward_ios,
//                                     size: 16,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   Addresspage()));
//                                     });
//                                   }),
//                               onTap: () {
//                                 setState(() {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => Addresspage()));
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                     //  else if (status == 'Feedback & Complaints')
//                     // return Container(
//                     //   height: 50,
//                     //   child: ListTile(
//                     //     leading: Image.asset(
//                     //       e.icon.toString(),
//                     //       height: 24,
//                     //       width: 24,
//                     //     ),
//                     //     title: HeadingWidget(
//                     //       title: e.title.toString(),
//                     //       color: AppColors.black,
//                     //     ),
//                     //     trailing: IconButton(
//                     //         icon: Icon(
//                     //           Icons.arrow_forward_ios,
//                     //           size: 16,
//                     //         ),
//                     //         onPressed: () {
//                     //           setState(() {
//                     //             Navigator.push(
//                     //               context,
//                     //               MaterialPageRoute(
//                     //                 builder: (context) => FeedbackPage(),
//                     //               ),
//                     //             );
//                     //           });
//                     //         }),
//                     //     onTap: () {
//                     //       setState(() {
//                     //         Navigator.push(
//                     //           context,
//                     //           MaterialPageRoute(
//                     //             builder: (context) => FeedbackPage(),
//                     //           ),
//                     //         );
//                     //       });
//                     //     },
//                     //   ),
//                     // );
//                     else if (status == 'Log out')
//                       return Container(
//                         height: 50,
//                         child: ListTile(
//                           leading: Image.asset(
//                             e.icon.toString(),
//                             height: 24,
//                             width: 24,
//                           ),
//                           title: HeadingWidget(
//                             title: e.title.toString(),
//                             color: AppColors.black,
//                           ),
//                           trailing: IconButton(
//                               icon: Icon(
//                                 Icons.arrow_forward_ios,
//                                 size: 16,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _handleLogout();
//                                 });
//                               }),
//                           onTap: () {
//                             setState(() {
//                               _handleLogout();
//                             });
//                           },
//                         ),
//                       );

//                     Divider(
//                       color: AppColors.grey1,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }

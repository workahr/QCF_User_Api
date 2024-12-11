import 'package:flutter/material.dart';
import 'package:namfood/constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../models/myprofile_model.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/heading_widget.dart';
import 'address_edit_model.dart';
import 'address_list_model.dart';
import 'deleteaddress_model.dart';
import 'edit_addresspage.dart';
import 'fillyour_addresspage.dart';

class Addresspage extends StatefulWidget {
  const Addresspage({super.key});

  @override
  State<Addresspage> createState() => _AddresspageState();
}

class _AddresspageState extends State<Addresspage> {
  final NamFoodApiService apiService = NamFoodApiService();

  // myprofile
  List<AddressList> myprofilepage = [];
  List<AddressList> myprofilepageAll = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getalladdressList();
  }

  Future getalladdressList() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getalladdressList();
      var response = addressListmodelFromJson(result);
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
        // showInSnackBar(context, response.message.toString());
        print(response.message.toString());
      }
    } catch (e) {
      setState(() {
        myprofilepage = [];
        myprofilepageAll = [];
        isLoading = false;
      });
      // showInSnackBar(context, 'Error occurred: $e');
      print('Error occurred: $e');
    }
  }

  Future deleteAddressById(id) async {
    final dialogBoxResult = await showAlertDialogInfo(
        context: context,
        title: 'Are you sure?',
        msg: 'You want to delete this data',
        status: 'danger',
        okBtn: false);
    if (dialogBoxResult == 'OK') {
      await apiService.getBearerToken();
      print('owner delete test $id');
      Map<String, dynamic> postData = {"id": id};
      var result = await apiService.deleteAddressById(postData);
      Deleteaddressmodel response = deleteaddressmodelFromJson(result);

      if (response.status.toString() == 'SUCCESS') {
        print("test");
        showInSnackBar(context, response.message.toString());
        setState(() {
          getalladdressList();
        });
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    }
  }

  // Future<void> deleteAddressById(int id) async {
  //   // Show the confirmation dialog
  //   if (!mounted) return; // Ensure widget is still active before proceeding

  //   final dialogBoxResult = await showAlertDialogInfo(
  //     context: context,
  //     title: 'Are you sure?',
  //     msg: 'You want to delete this data',
  //     status: 'danger',
  //     okBtn: false,
  //   );

  //   if (dialogBoxResult == 'OK') {
  //     try {
  //       await apiService.getBearerToken(); // Get the token
  //       print('owner delete test $id');
  //       Map<String, dynamic> postData = {"id": id};
  //       var result = await apiService.deleteAddressById(postData);
  //       Deleteaddressmodel response = deleteaddressmodelFromJson(result);

  //       if (response.status.toString() == 'SUCCESS') {
  //         if (mounted) {
  //           // Safely access context and update the widget
  //           showInSnackBar(context, response.message.toString());
  //           setState(() {
  //             getalladdressList(); // Refresh address list
  //           });
  //         }
  //       } else {
  //         if (mounted) {
  //           showInSnackBar(context, response.message.toString());
  //         }
  //       }
  //     } catch (e) {
  //       if (mounted) {
  //         showInSnackBar(context, 'Error occurred: $e');
  //       }
  //       print('Error occurred: $e');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey3,
        title: Text('Address'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FillyourAddresspage(),
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: AppColors.red,
              ))
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : myprofilepage.isEmpty
              ? Center(child: Text('No addresses found'))
              : ListView.builder(
                  itemCount: myprofilepage.length,
                  itemBuilder: (context, index) {
                    final e = myprofilepage[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (e.type == "Home")
                                Image.asset(
                                  AppAssets.home_white,
                                  height: 24,
                                  width: 24,
                                  color: Colors.black,
                                ),
                              if (e.type == "Work")
                                Image.asset(
                                  AppAssets.work_white,
                                  height: 24,
                                  width: 24,
                                  color: Colors.black,
                                ),
                              if (e.type == "Other")
                                Image.asset(
                                  AppAssets.work_white,
                                  height: 24,
                                  width: 24,
                                  color: Colors.black,
                                ),
                              SizedBox(width: 8),
                              HeadingWidget(
                                title: e.type.toString(),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Wrap(
                            children: [
                              HeadingWidget(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                //  title: e.address.toString(),
                                title:
                                    "${e.address.toString()} ${e.addressLine2.toString()} ${e.city.toString()},",
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          HeadingWidget(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            title:
                                "${e.state.toString()}, Land Mark -${e.landmark.toString()},",
                          ),
                          HeadingWidget(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            title: "${e.postcode.toString()}.",
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FillyourAddresspage(
                                                addressId: e.id,
                                              ))).then((value) {});
                                },
                                child: Container(
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.red, width: 1.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                  onTap: () {
                                    deleteAddressById(e.id);
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.red, width: 1.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

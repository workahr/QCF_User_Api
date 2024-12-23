import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../widgets/custom_text_field.dart';

class JoinDeliveryboy extends StatefulWidget {
  const JoinDeliveryboy({super.key});

  @override
  State<JoinDeliveryboy> createState() => _JoinDeliveryboyState();
}

class _JoinDeliveryboyState extends State<JoinDeliveryboy> {
  final GlobalKey<FormState> storeForm = GlobalKey<FormState>();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mobilenumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();

  //   if (widget.storeId != null) {
  //     getStoreById();
  //   }
  // }

  // UserList? storeDetails;
  // ListStore? storeList;

  // Future<void> getStoreById() async {
  //   try {
  //     await apiService.getBearerToken();
  //     var result = await apiService.getStoreById(widget.storeId);
  //     StoreEditmodel response = getStorebyidmodelFromJson(result);

  //     if (response.status == 'SUCCESS') {
  //       setState(() {
  //         storeList = response.list; // Assign the store details
  //         storeDetails = response.userList; // Assign the user details

  //         // Safely assign values to controllers
  //         userNameController.text = storeDetails?.username ?? '';
  //         mobilenumberController.text = storeDetails?.number ?? '';
  //
  //         addressController.text = storeDetails?.address ?? '';
  //         mailController.text = storeDetails?.email ?? '';
  //         descriptionController.text = storeList?.description ?? '';

  //         liveimgSrc1 = storeList?.frontImg ?? '';
  //       });
  //     } else {
  //       showInSnackBar(context, response.message);
  //     }
  //   } catch (e, stackTrace) {
  //     // Log or handle errors gracefully
  //     print("Error occurred: $e");
  //     print(stackTrace);
  //     showInSnackBar(context, "An unexpected error occurred.");
  //   }
  // }

  // // Add Store
  // Future addstoredetails() async {
  //   await apiService.getBearerToken();
  //   if (imageFile == null && widget.storeId == null) {
  //     showInSnackBar(context, 'Store image is required');
  //     return;
  //   }
  //   if (imageFile1 == null && widget.storeId == null) {
  //     showInSnackBar(context, 'Store image is required');
  //     return;
  //   }

  //   if (storeForm.currentState!.validate()) {
  //     Map<String, dynamic> postData = {
  //       "username": userNameController.text,
  //       "number": mobilenumberController.text,
  //
  //       "address": addressController.text,
  //       "email": storemailController.text,
  //       "description": descriptionController.text,

  //       "online_visibility": "Yes",
  //       "tags": "store1",
  //       "store_status": 1,
  //     };
  //     print(postData);

  //     showSnackBar(context: context);
  //     // update-Car_management
  //     String url = 'v1/createstore';
  //     if (widget.storeId != null) {
  //       // postData['id'] = widget.carId;
  //       postData = {
  //         "store_id": widget.storeId,
  //         "user_id": storeDetails?.id ?? '',
  //         "username": userNameController.text,
  //         "password": passwordNameController.text,
  //         "fullname": ownerNameController.text,
  //         "mobile": mobileNumberController.text,
  //         "email": mailController.text,
  //         "name": storeNameController.text,
  //         "address": addressController.text,
  //         "city": cityController.text,
  //         "state": stateController.text,
  //         "gst_no": gstController.text,
  //         "pan_no": pannoController.text,
  //         "zipcode": zipcodeController.text,
  //         "online_visibility": "Yes",
  //         "tags": "store1",
  //         "store_status": 1,
  //       };
  //       url = 'v1/updatestore';
  //     }
  //     var result =
  //         await apiService.addstore(url, postData, imageFile, imageFile1);
  //     closeSnackBar(context: context);
  //     setState(() {
  //       // isLoading = false;
  //     });
  //     Addstoremodel response = addstoremodelFromJson(result);

  //     if (response.status.toString() == 'SUCCESS') {
  //       showInSnackBar(context, response.message.toString());
  //       // Navigator.pushNamedAndRemoveUntil(
  //       //     context, '/home', ModalRoute.withName('/home'));

  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) => AdminMainContainer(
  //       //       admininitialPage: 2,
  //       //     ),
  //       //   ),
  //       // );

  //       // Navigator.of(context).pushAndRemoveUntil(
  //       //   MaterialPageRoute(
  //       //       builder: (context) => AdminMainContainer(admininitialPage: 2)),
  //       //   (Route<dynamic> route) => false,
  //       // );
  //     } else {
  //       print(response.message.toString());
  //       showInSnackBar(context, response.message.toString());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE23744),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: const Text("Join as delivery boy",
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: storeForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomeTextField(
                      width: double.infinity,
                      control: userNameController,
                      labelText: "User Name",
                      borderColor: const Color(0xFFEEEEEE),
                    ),
                    CustomeTextField(
                      width: double.infinity,
                      control: mobilenumberController,
                      labelText: "Mobile Number",
                      borderColor: const Color(0xFFEEEEEE),
                    ),
                    CustomeTextField(
                      control: addressController,
                      labelText: "Address",
                      width: double.infinity,
                      borderColor: const Color(0xFFEEEEEE),
                    ),
                    CustomeTextField(
                      control: mailController,
                      labelText: "Email",
                      width: double.infinity,
                      borderColor: const Color(0xFFEEEEEE),
                    ),
                    CustomeTextField(
                      control: descriptionController,
                      contentPadding: EdgeInsets.all(16.0),
                      labelText: "Description",
                      lines: 3,
                      width: double.infinity,
                      borderColor: const Color(0xFFEEEEEE),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  if (userNameController.text == '' ||
                      userNameController.text == null) {
                    showInSnackBar(context, "Please Enter Username ");
                  } else if (mobilenumberController.text == '' ||
                      mobilenumberController.text == null) {
                    showInSnackBar(context, "Please Enter Mobile Number");
                    print("Please Enter Mobile Number");
                  } else if (addressController.text == '' ||
                      addressController.text == null) {
                    showInSnackBar(context, "Please Enter Store Address ");
                  } else if (mailController.text == '' ||
                      mailController.text == null) {
                    showInSnackBar(context, "Please Enter Email");
                  } else if (descriptionController.text == '' ||
                      descriptionController.text == null) {
                    showInSnackBar(context, "Please Enter description ");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Send',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

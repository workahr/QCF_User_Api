import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../services/comFuncService.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/outline_btn_widget.dart';
import 'dart:io';

class Joinwithusforstore extends StatefulWidget {
  const Joinwithusforstore({super.key});

  @override
  State<Joinwithusforstore> createState() => _JoinwithusforstoreState();
}

class _JoinwithusforstoreState extends State<Joinwithusforstore> {
  final GlobalKey<FormState> storeForm = GlobalKey<FormState>();

  final TextEditingController storeownernameController =
      TextEditingController();
  final TextEditingController storenumberController = TextEditingController();
  final TextEditingController storenameController = TextEditingController();
  final TextEditingController storeaddressController = TextEditingController();
  final TextEditingController storemailController = TextEditingController();
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
  //         storeownernameController.text = storeDetails?.ownername ?? '';
  //         storenumberController.text = storeDetails?.number ?? '';
  //         storenameController.text = storeDetails?.storename ?? '';
  //         storeaddressController.text = storeDetails?.address ?? '';
  //         storemailController.text = storeDetails?.email ?? '';
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

  //

  int type = 0;

  XFile? imageFile1;
  File? imageSrc1;
  String? liveimgSrc1;

  getImage1(ImageSource source1) async {
    try {
      Navigator.pop(context);
      final pickedImage1 = await ImagePicker().pickImage(source: source1);
      if (pickedImage1 != null) {
        imageFile1 = pickedImage1;
        imageSrc1 = File(pickedImage1.path);
        getRecognizedText1(pickedImage1);
        setState(() {});
      }
    } catch (e) {
      setState(() {});
    }
  }

  void getRecognizedText1(image1) async {
    try {
      final inputImage = InputImage.fromFilePath(image1.path);

      final textDetector = TextRecognizer();
      RecognizedText recognisedText =
          await textDetector.processImage(inputImage);
      final resVal = recognisedText.blocks.toList();
      List allDates = [];
      for (TextBlock block in resVal) {
        for (TextLine line in block.lines) {
          String recognizedLine = line.text;
          RegExp dateRegex = RegExp(r"\b\d{1,2}/\d{1,2}/\d{2,4}\b");
          Iterable<Match> matches = dateRegex.allMatches(recognizedLine);

          for (Match match in matches) {
            allDates.add(match.group(0));
          }
        }
      }

      await textDetector.close();

      print(allDates); // For example, print the dates
    } catch (e) {
      showInSnackBar(context, e.toString());
    }
  }

  int type1 = 0;

  showActionSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  await getImage1(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  await getImage1(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close_rounded),
                title: const Text('Close'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  showActionSheet1(BuildContext context1) {
    showModalBottomSheet(
        context: context1,
        builder: (BuildContext context1) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  await getImage1(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  await getImage1(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close_rounded),
                title: const Text('Close'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

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
        title: const Text("Join with us for store",
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
                      control: storeownernameController,
                      labelText: "Store Owner Name",
                      borderColor: const Color(0xFFEEEEEE),
                    ),
                    CustomeTextField(
                      width: double.infinity,
                      control: storenameController,
                      labelText: "Store Name",
                      borderColor: const Color(0xFFEEEEEE),
                    ),
                    CustomeTextField(
                      control: storenumberController,
                      labelText: "Mobile Number",
                      width: double.infinity,
                      borderColor: const Color(0xFFEEEEEE),
                    ),
                    CustomeTextField(
                      control: storemailController,
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
                    SizedBox(height: 10),
                    Text(
                      "Note: Upload image with shop name",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    OutlineBtnWidget(
                        title: 'Upload Store Image',
                        titleColor: Color(0xFF2C54D6),
                        // fillColor: Color(0xFFF3F6FF),
                        iconColor: Color(0xFF2C54D6),
                        // imageUrl: Image.asset(
                        //   AppAssets.Home,
                        //   height: 25,
                        //   width: 25,
                        // ),
                        width: MediaQuery.of(context).size.width - 10,
                        height: 50,
                        borderColor: Color(0xFF2C54D6),
                        onTap: () {
                          type = 0;
                          showActionSheet1(context);
                        }),
                    SizedBox(height: 10),
                    Center(
                      child: Stack(
                        children: [
                          liveimgSrc1 != "" &&
                                  liveimgSrc1 != null &&
                                  imageSrc1 == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          AppConstants.imgBaseUrl +
                                              (liveimgSrc1 ?? ''),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: liveimgSrc1 == null
                                        ? Image.asset(
                                            AppAssets.user,
                                            fit: BoxFit.fill,
                                          )
                                        : null,
                                  ),
                                )
                              : imageSrc1 != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          16), // Adjust the radius as needed
                                      child: Container(
                                        width: 360,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(imageSrc1!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  if (storeownernameController.text == '' ||
                      storeownernameController.text == null) {
                    showInSnackBar(context, "Please Enter Store Owner Name ");
                  } else if (storenumberController.text == '' ||
                      storenumberController.text == null) {
                    showInSnackBar(context, "Please Enter Mobile Number");
                  } else if (storenameController.text == '' ||
                      storenameController.text == null) {
                    showInSnackBar(context, "Please Enter Store Name");
                    print("Please Enter Mobile Number");
                  } else if (storeaddressController.text == '' ||
                      storeaddressController.text == null) {
                    showInSnackBar(context, "Please Enter Store Address ");
                  } else if (storemailController.text == '' ||
                      storemailController.text == null) {
                    showInSnackBar(context, "Please Enter Email");
                  } else if (descriptionController.text == '' ||
                      descriptionController.text == null) {
                    showInSnackBar(context, "Please Enter description ");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
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

import 'package:flutter/material.dart';
import 'package:namfood/pages/maincontainer.dart';
import 'package:namfood/widgets/button_widget.dart';
import 'dart:io';
import '../../constants/constants.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/heading_widget.dart';
import 'profile_screen.dart';
import 'profile_update_model.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'profiledetails_model.dart';

class EditProfilepage extends StatefulWidget {
  int? userId;
  EditProfilepage({super.key, this.userId});

  @override
  State<EditProfilepage> createState() => _EditProfilepageState();
}

class _EditProfilepageState extends State<EditProfilepage> {
  final NamFoodApiService apiService = NamFoodApiService();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();
  int type = 0;

  @override
  void initState() {
    super.initState();
    getprofileDetails();
  }

  ProfileDetails? profiledetailsList;
  // List<ProfileDetails> profiledetailsListAll = [];
  bool isLoading = false;

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

          isLoading = false;
          fullnameController.text =
              profiledetailsList?.fullname?.toString() ?? "";

          emailController.text = profiledetailsList?.email?.toString() ?? "";

          mobilenumberController.text =
              profiledetailsList?.mobile?.toString() ?? "";
          liveimgSrc = profiledetailsList?.imageUrl?.toString() ?? "";
          print(profiledetailsList!.imageUrl.toString());
        });
      } else {
        setState(() {
          profiledetailsList = null;
          // profiledetailsListAll = [];
          isLoading = false;
        });
        //  showInSnackBar(context, response.message.toString());
      }
    } catch (e) {
      setState(() {
        profiledetailsList = null;
        // profiledetailsListAll = [];
        isLoading = false;
      });
      // showInSnackBar(context, 'Error occurred: $e');
      print('Error occurred: $e');
    }
  }

  Future updateprofile() async {
    await apiService.getBearerToken();

    Map<String, dynamic> postData = {
      "fullname": fullnameController.text,
      "email": emailController.text
    };
    print(postData);

    showSnackBar(context: context);
    // update-Car_management
    String url = 'v1/updateprofile';

    var result = await apiService.updateprofile(url, postData, imageFile);
    closeSnackBar(context: context);
    setState(() {
      // isLoading = false;
    });
    UpdateProfilemodel response = updateProfilemodelFromJson(result);

    if (response.status.toString() == 'SUCCESS') {
      //  showInSnackBar(context, response.message.toString());

      // Navigator.pop(context, {'add': true});
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainContainer()));
    } else {
      print(response.message.toString());
      //  showInSnackBar(context, response.message.toString());
    }
  }

  XFile? imageFile;
  File? imageSrc;
  String? liveimgSrc;

  getImage(ImageSource source) async {
    try {
      Navigator.pop(context);
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imageFile = pickedImage;
        imageSrc = File(pickedImage.path);
        getRecognizedText(pickedImage);
        setState(() {});
      }
    } catch (e) {
      setState(() {});
    }
  }

  void getRecognizedText(image) async {
    try {
      final inputImage = InputImage.fromFilePath(image.path);

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
                  await getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  await getImage(ImageSource.camera);
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
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey3,
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.05),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                liveimgSrc != "" && liveimgSrc != null && imageSrc == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                AppConstants.imgBaseUrl + (liveimgSrc ?? ''),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : imageSrc != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: FileImage(imageSrc!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(AppAssets.profileimg),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                // Positioned edit icon
                Positioned(
                  bottom: -3, // Adjust to make the icon more visible
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      type = 0;
                      showActionSheet(context);
                    },
                    child: Container(
                      height: 40, // Slightly increase for better visibility
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.red,
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        color: AppColors.white,
                        size: 20, // Increase size if needed
                      ),
                    ),
                  ),
                ),
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
                    control: fullnameController,
                    labelText: 'Name *',
                    borderColor: AppColors.grey,
                    width: screenWidth,
                  ),
                  CustomeTextField(
                    control: mobilenumberController,
                    labelText: 'Mobile Number',
                    borderColor: AppColors.grey,
                    width: screenWidth,
                    readOnly: true,
                  ),
                  CustomeTextField(
                    control: emailController,
                    labelText: 'Email Id *',
                    borderColor: AppColors.grey,
                    width: screenWidth,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.04, horizontal: screenWidth * 0.04),
        child: ButtonWidget(
          borderRadius: 10,
          title: "Submit",
          width: screenWidth,
          color: AppColors.red,
          onTap: () {
            updateprofile();
          },
        ),
      ),
    );
  }
}

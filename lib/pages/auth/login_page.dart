import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:namfood/constants/app_colors.dart';
import 'package:namfood/pages/address/address_list_model.dart';
import 'package:namfood/pages/address/fillyour_addresspage.dart';
import 'package:namfood/pages/maincontainer.dart';
import 'package:namfood/services/nam_food_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_assets.dart';
import '../../controllers/base_controller.dart';
import '../../services/comFuncService.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../HomeScreen/home_screen.dart';
import 'auth_validations.dart';
import 'login_model.dart';
import 'otp_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  AuthValidation authValidation = AuthValidation();
  BaseController baseCtrl = Get.put(BaseController());
  final NamFoodApiService apiService = NamFoodApiService();
  String? auth;

  
  Future login() async {
    print("token user ${baseCtrl.fbUserId}");
    try {
       
      if (_phoneController.text != "") {
        Map<String, dynamic> postData = {
          'mobile': _phoneController.text,
          'otp': "",
          'mobile_push_id': baseCtrl.fbUserId
        };
        
        var result = await apiService.userLoginWithOtp(postData);
        LoginOtpModel response = loginOtpModelFromJson(result);

        closeSnackBar(context: context);
        print("postdata3 $postData");

        if (response.status.toString() == 'SUCCESS') {
          if (_phoneController.text == "1234567890") {
            print("login test");
            setState(() async {
              
              final prefs = await SharedPreferences.getInstance();
              if (response.authToken != null) {
                //Navigator.pushNamed(context, '/');
                prefs.setString('auth_token', response.authToken ?? '');
                prefs.setBool('isLoggedin', true);
                auth = response.authToken ?? '';
                getalladdressList();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainContainer(),
                  ),
                );
              }
            });
          } else {
            setState(() async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerificationPage(
                      phoneNumber: _phoneController.text, otp: response.otp!),
                ),
              );
            });
          }

          // final prefs = await SharedPreferences.getInstance();

          // //prefs.setString('fullname', response.fullname ?? '');

          //   if(response.authToken != null){
          //     Navigator.pushNamed(context, '/');
          //     prefs.setString('auth_token', response.authToken ?? '');
          //     prefs.setBool('isLoggedin', true);
          //   }
        } else {
          //  showInSnackBar(context, response.message.toString());
        }
      } else {
        showInSnackBar(context, "Please fill required fields");
      }
    } catch (error) {
      //  showInSnackBar(context, error.toString());
    }
  }

  List<AddressList> myprofilepage = [];
  List<AddressList> myprofilepageAll = [];
  bool isLoading = false;

  Future getalladdressList() async {
    await apiService.getBearerToken();
    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiService.getloginalladdressList(auth);
      var response = addressListmodelFromJson(result);
      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          myprofilepage = response.list;
          myprofilepageAll = myprofilepage;
          isLoading = false;
        });
        // if (loginStatus == true) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', ModalRoute.withName('/home'));
        // } else {
        //   Navigator.pushNamedAndRemoveUntil(
        //       context, '/login', ModalRoute.withName('/login'));
        // }
      } else {
        setState(() {
          myprofilepage = [];
          myprofilepageAll = [];
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FillyourAddresspage(),
          ),
        );
        // showInSnackBar(context, response.message.toString());
        print(response.message.toString());
      }
    } catch (e) {
      setState(() {
        myprofilepage = [];
        myprofilepageAll = [];
        isLoading = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FillyourAddresspage(),
          ),
        );
      });
      // showInSnackBar(context, 'Error occurred: $e');
      print('Error occurred: $e');
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(children: [
        Expanded(
            child: SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo and header section
            SizedBox(height: 15.0),
            Image.asset(
              AppAssets.logo,
              width: double.infinity,
              // height: 280.0,
              fit: BoxFit.fill,
            ),
            //const SizedBox(height: 200.0),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Enter your mobile number to proceed',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  //  const SizedBox(height: 10.0),
                  CustomeTextField(
                    labelText: 'Mobile Number',
                    control: _phoneController,
                    validator: authValidation
                        .errValidateMobileNo(_phoneController.text),
                    width: MediaQuery.of(context).size.width / 1.1,
                    type: const TextInputType.numberWithOptions(),
                    inputFormaters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^-?(\d+)?\.?\d{0,11}'))
                    ],
                    prefixText: '+91 ', // Set +91 as prefixText
                  ),

                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        login();
                        print(
                            'Get OTP tapped with number: ${_phoneController.text}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Get OTP',
                        style:
                            TextStyle(fontSize: 16.0, color: AppColors.light),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainContainer(
                              initialPage: 0,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Back To Home Page ->",
                        style: TextStyle(color: AppColors.red, fontSize: 16.0),
                      ),
                    ),
                  ),
                  //SizedBox(height: 20.0),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    "Powered By:",
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  HeadingWidget(
                    title: "www.profitdelivery.in",
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ))),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show number or initiate a call
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Customer Care"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Call Us:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" +91 9361616063"),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      _makePhoneCall("9361616063");
                    },
                    child: Container(
                      height: 35, // Set the size of the circle
                      width: 35, // Set the size of the circle
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Make it circular
                        color: Colors.white, // Set the inside color to white
                        border: Border.all(
                          color: Colors.red, // Set the border color to red
                          width: 2, // Set the border width
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          AppAssets.call_iconfill,
                          height: 25, // Set the size of the icon
                          width: 25, // Set the size of the icon
                        ),
                      ),
                    ),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                ),
              ],
            ),
          );
        },
        child: Icon(
          Icons.phone,
          color: Colors.white,
        ),
        tooltip: 'Customer Care',
        backgroundColor: AppColors.red, // Set the background color to red
      ),
    );
  }
}

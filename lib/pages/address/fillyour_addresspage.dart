import 'package:flutter/material.dart';
import 'package:namfood/constants/app_assets.dart';
import 'package:namfood/pages/HomeScreen/home_screen.dart';
import 'package:namfood/pages/address/address_list_model.dart';
import 'package:namfood/pages/maincontainer.dart';
import 'package:namfood/widgets/heading_widget.dart';
import 'package:namfood/widgets/outline_btn_widget.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/sub_heading_widget.dart';
import 'addaddress_model.dart';
import 'address_edit_model.dart';
import 'address_update_model.dart';
import 'addresspage.dart';

class FillyourAddresspage extends StatefulWidget {
  int? addressId;
  FillyourAddresspage({super.key, this.addressId});

  @override
  State<FillyourAddresspage> createState() => _FillyourAddresspageState();
}

class _FillyourAddresspageState extends State<FillyourAddresspage> {
  final NamFoodApiService apiService = NamFoodApiService();
  final GlobalKey<FormState> addressForm = GlobalKey<FormState>();

  int? _selectedCheckboxIndex;
  int _selectedIndex = 0;
  int? _selectedDefaultIndex;

  String _selectedAddressType = 'Home';

  TextEditingController contactnoController = TextEditingController();
  TextEditingController lankmarkController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postController = TextEditingController();

  final Map<String, bool> _defaultStatus = {
    'Home': false,
    'Work': false,
    'Other': false,
  };

  // Method to build address form
  Widget _buildAddressForm(String type) {
    List<Widget> fields = [
      // CustomeTextField(

      //   borderColor: AppColors.grey1,
      //   labelText: 'Contact Number',
      //   width: MediaQuery.of(context).size.width,
      // ),
      CustomeTextField(
        control: address1Controller,
        borderColor: AppColors.grey1,
        labelText: 'Address 1',
        width: MediaQuery.of(context).size.width,
      ),
      CustomeTextField(
        control: address2Controller,
        borderColor: AppColors.grey1,
        labelText: 'Address 2',
        width: MediaQuery.of(context).size.width,
      ),
      CustomeTextField(
        control: lankmarkController,
        borderColor: AppColors.grey1,
        labelText: 'Land Mark',
        width: MediaQuery.of(context).size.width,
      ),
      CustomeTextField(
        control: cityController,
        borderColor: AppColors.grey1,
        labelText: 'City',
        lines: 1,
        width: MediaQuery.of(context).size.width,
      ),
      CustomeTextField(
        control: stateController,
        borderColor: AppColors.grey1,
        labelText: 'State',
        lines: 1,
        width: MediaQuery.of(context).size.width,
      ),
      CustomeTextField(
        control: postController,
        borderColor: AppColors.grey1,
        labelText: 'Post Code',
        lines: 1,
        width: MediaQuery.of(context).size.width,
      ),
      Row(
        children: [
          Checkbox(
            side: BorderSide(color: AppColors.grey, width: 2),
            activeColor: AppColors.red, // Color when checked
            checkColor: Colors.white, // Tick mark color
            value: _defaultStatus[type],
            onChanged: (bool? value) {
              setState(() {
                _defaultStatus[type] = value ?? false; // Update status
                print('Default Address for $type: ${_defaultStatus[type]}');
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

  Future saveaddress() async {
    if (addressForm.currentState!.validate()) {
      Map<String, dynamic> postData = {
        "default_address": _defaultStatus[_selectedAddressType]! ? 1 : 0,
        "type": _selectedAddressType.toString(),
        "address": address1Controller.text,
        "address_line_2": address2Controller.text,
        "city": cityController.text,
        "state": stateController.text,
        "postcode": postController.text,
        "landmark": lankmarkController.text
      };
      print('postData $postData');

      var result = await apiService.saveaddress(postData);
      print('result $result');
      Addaddressmodel response = addaddressmodelFromJson(result);

      if (response.status.toString() == 'SUCCESS') {
        showInSnackBar(context, response.message.toString());
        // Navigator.pop(context, {'type': 1});
        //  Navigator.pop(context, {'add': true});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainContainer(),
          ),
        );
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  EditAddressList? addressDetails;

  Future getAddressById() async {
    await apiService.getBearerToken();

    var result = await apiService.getAddressById(widget.addressId);
    AdddressEditmodel response = adddressEditmodelFromJson(result);
    print(response);
    if (response.status.toString() == 'SUCCESS') {
      setState(() {
        addressDetails = response.list;
        _selectedAddressType = (addressDetails!.type ?? '').toString();

        _defaultStatus[_selectedAddressType] =
            addressDetails!.defaultAddress == 1;

        address1Controller.text = addressDetails!.address ?? '';
        address2Controller.text = addressDetails!.addressLine2 ?? '';
        cityController.text = addressDetails!.city ?? '';
        stateController.text = addressDetails!.state ?? '';
        postController.text = (addressDetails!.postcode ?? '').toString();
        lankmarkController.text = addressDetails!.landmark ?? '';
      });
    } else {
      showInSnackBar(context, "Data not found");
      //isLoaded = false;
    }
  }

  @override
  void initState() {
    super.initState();
    refresh();
    print('AddressById :' + widget.addressId.toString());
  }

  refresh() async {
    if (widget.addressId != null) {
      await getAddressById();
    }
  }

  Future updateaddress() async {
    await apiService.getBearerToken();
    if (addressForm.currentState!.validate()) {
      Map<String, dynamic> postData = {
        "id": widget.addressId,
        "default_address": _defaultStatus[_selectedAddressType]! ? 1 : 0,
        "type": _selectedAddressType.toString(),
        "address": address1Controller.text,
        "address_line_2": address2Controller.text,
        "city": cityController.text,
        "state": stateController.text,
        "postcode": postController.text,
        "landmark": lankmarkController.text
      };
      print("updateaddressupdate $postData");
      var result = await apiService.updateaddress(postData);

      AdddressUpdatemodel response = adddressUpdatemodelFromJson(result);

      if (response.status.toString() == 'SUCCESS') {
        showInSnackBar(context, response.message.toString());
        //  Navigator.pop(context, {'update': true});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Addresspage(),
          ),
        );
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
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
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: addressForm,
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
                    _buildAddressTypeButton(
                        'Other', Icons.location_on_outlined),
                  ],
                ),
                SizedBox(height: 20),

                _buildAddressForm(_selectedAddressType),
              ],
            ),
          )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ButtonWidget(
              borderRadius: 10,
              title: widget.addressId == null ? "Save" : "Update",
              width: screenWidth,
              color: AppColors.red,
              onTap: () {
                widget.addressId == null ? saveaddress() : updateaddress();
              },
            ),
            SizedBox(height: 20),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainContainer(),
                          ),
                        );
                      });
                    },
                    child: HeadingWidget(
                      title: 'Skip now',
                    )),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                )
              ],
            )),
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

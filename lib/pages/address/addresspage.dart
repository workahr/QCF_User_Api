import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../models/myprofile_model.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/heading_widget.dart';
import 'edit_addresspage.dart';

class Addresspage extends StatefulWidget {
  const Addresspage({super.key});

  @override
  State<Addresspage> createState() => _AddresspageState();
}

class _AddresspageState extends State<Addresspage> {
  final NamFoodApiService apiService = NamFoodApiService();

  // myprofile
  List<myprofilelist> myprofilepage = [];
  List<myprofilelist> myprofilepageAll = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getmyprofile();
  }

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
  }

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
                    builder: (context) => EditAddresspage(),
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
                              Image.asset(
                                e.icon.toString(),
                                height: 24,
                                width: 24,
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
                                title: e.address.toString(),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          HeadingWidget(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            title: e.contact.toString(),
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
                                      builder: (context) => EditAddresspage(),
                                    ),
                                  );
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
                              Container(
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
                              ),
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

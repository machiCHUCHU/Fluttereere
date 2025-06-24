import 'dart:core';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/ConstWidgets.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newCoOwnerPage.dart';
import 'package:capstone/brandnew/newLaundryServicePage.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/brandnew/newProfilePage.dart';
import 'package:capstone/brandnew/newServiceTime.dart';
import 'package:capstone/brandnew/newShopInformationPage.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewSettingsScreen extends StatefulWidget {
  const NewSettingsScreen({super.key});

  @override
  State<NewSettingsScreen> createState() => _NewSettingsScreenState();
}

class _NewSettingsScreenState extends State<NewSettingsScreen> {
  List<dynamic> settings = []; List<dynamic> service = []; Map set = {}; bool hasData = false;
  bool hasImage = false; bool isLoading = true; String? token; String? usertype; String? access;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usertype = prefs.getString('usertype');
      access = prefs.getString('accesstype');
    });
  }

  Future<void> settingsDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getInfos('${prefs.getString('token')}');

    token = prefs.getString('token');

    if(response.error == null){
      setState(() {
        settings = response.data as List<dynamic>;
        service = response.data1 as List<dynamic>;
        hasData = settings.isNotEmpty;
        set = settings[0] as Map;
        hasImage = set['OwnerImage'] != null;
        isLoading = false;
      });
    }else{
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> logoutState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await logout('${prefs.getString('token')}');

    if (response.error == null) {
      await prefs.clear();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NewLoginScreen()),
              (route) => false,
        );
      }
    } else {
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  @override
  void initState(){
    super.initState();
    getUser();
    settingsDisplay();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  usertype == 'owner'
                      ? Navigator.push(context, MaterialPageRoute(builder: (context) => const NewProfileScreen()))
                      : warningTextDialog(context, 'Access Denied', 'Sorry you dont\'t have permission to access this.');
                },
                child: Ink(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: RowItem(
                      title: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade600,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.person,color: Colors.white,),
                          ),
                          const Text(' Profile',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      description: const Icon(CupertinoIcons.chevron_forward)
                  ),
                ),
              ),
              const SizedBox(height: 10,),

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NewShopInformationScreen()));
                },
                child: Ink(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: RowItem(
                      title: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.store,color: Colors.white,),
                          ),
                          const Text(' Shop Information',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      description: const Icon(CupertinoIcons.chevron_forward)
                  ),
                ),
              ),
              const SizedBox(height: 10,),

             InkWell(
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLaundryServiceScreen()));
               },
               child: Ink(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(5),
                   color: Colors.white,
                 ),
                 child: RowItem(
                     title: Row(
                       children: [
                         Container(
                           decoration: BoxDecoration(
                             color: Colors.green,
                             borderRadius: BorderRadius.circular(10),
                           ),
                           padding: const EdgeInsets.all(8),
                           child: const Icon(Icons.local_laundry_service,color: Colors.white,),
                         ),
                         const Text(' Laundry Services',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                       ],
                     ),
                     description: const Icon(CupertinoIcons.chevron_forward)
                 ),
               ),
             ),
              const SizedBox(height: 10,),

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NewServiceTimeScreen()));
                },
                child: Ink(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: RowItem(
                      title: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.timelapse_outlined,color: Colors.white,),
                          ),
                          const Text(' Service Time',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      description: const Icon(CupertinoIcons.chevron_forward)
                  ),
                ),
              ),
              const SizedBox(height: 10,),

             InkWell(
               onTap: (){
                 usertype == 'owner'
                     ? Navigator.push(context, MaterialPageRoute(builder: (context) => const NewCoOwnerScreen()))
                     : warningTextDialog(context, 'Access Denied', 'Sorry you don\'t have permission to access this');
               },
               child: Ink(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(5),
                   color: Colors.white,
                 ),
                 child: RowItem(
                     title: Row(
                       children: [
                         Container(
                           decoration: BoxDecoration(
                             color: Colors.black,
                             borderRadius: BorderRadius.circular(10),
                           ),
                           padding: const EdgeInsets.all(8),
                           child: const Icon(CupertinoIcons.person_3_fill,color: Colors.white,),
                         ),
                         const Text(' Co-Owners',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                       ],
                     ),
                     description: const Icon(CupertinoIcons.chevron_forward)
                 ),
               ),
             ),
              const SizedBox(height: 10,),

              InkWell(
                onTap: (){
                  logoutDialog(context, logoutState);
                },
                child: Ink(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.logout,color: Colors.white,),
                      ),
                      const Text(' Logout ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}

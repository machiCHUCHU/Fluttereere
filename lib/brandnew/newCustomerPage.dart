import 'dart:convert';
import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  String? token;
  bool isLoading = true;

  void _bottomModal(String name, String address, String contact, String image,
      bool hasPicture, String date, String valued, String id) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * .5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.person_circle,
                            size: 32,
                            color: ColorStyle.tertiary,
                          ),
                          const Text(
                            ' Customer Information',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: ProfilePicture(
                        name: name,
                        fontsize: 16,
                        radius: 18,
                        img: hasPicture ? '$picaddress/$image' : null,
                      ),
                      title: Text(name),
                    ),
                    const Divider(height: 0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            address,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Contact Information',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    contact,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date Requested',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            valued == '0' ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      foregroundColor: ColorStyle.tertiary,
                      side: BorderSide(color: ColorStyle.tertiary),
                      fixedSize: Size(MediaQuery.of(context).size.width * .42, 30),
                    ),
                    onPressed: () {
                      addedShopStat(id, '2');
                    },
                    child: const Text('Decline'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: ColorStyle.tertiary,
                      foregroundColor: Colors.white,
                      fixedSize: Size(MediaQuery.of(context).size.width * .42, 30),
                    ),
                    onPressed: () {
                      addedShopStat(id, '1');
                    },
                    child: const Text('Mark Valued'),
                  ),
                ],
              ),
            ) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }


  List<dynamic> addedshop = [];

  String? id;
  String? status;
  bool isValued = false;
  bool hasData = false;


  Future<void> addedShopStat(String customerid, String stat) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog(
        context: context,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );

    ApiResponse apiResponse = await updateAddedShop(
        '${prefs.getString('token')}',
        customerid.toString(),
        stat
    );

    Navigator.pop(context);

    if(apiResponse.error == null){
     if(stat == '1'){
       print(apiResponse.data);
       await successDialog(context, 'Customer mark valued.');
       Navigator.pop(context);
     }else{
       await warningDialog(context, 'Request rejected.');
       Navigator.pop(context);
     }
        addedShopDisplay();
    }else{
      Navigator.pop(context);
     await errorDialog(context, '${apiResponse.error}');
    }
  }

  Future<void> addedShopDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getAddedShop('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        addedshop = response.data as List<dynamic>;
        isLoading = false;
        hasData = addedshop.isNotEmpty;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      errorDialog(context,'${response.error}');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    addedShopDisplay();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Scaffold(
          appBar: AppBar(
            title: const Text('Valued Customers'),
            titleTextStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
          ),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          )
      );
    }

    if(hasData == false){
      return Scaffold(
          appBar: AppBar(
            title: const Text('Valued Customers'),
            titleTextStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
          ),
          body: const Center(
              child: Text(
                  'No list yet. Invite your first customer.'
              )
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Valued Customers'),
        titleTextStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView.builder(
                      shrinkWrap: true,
                      itemCount: addedshop.length,
                      itemBuilder: (context, index){
                        Map addshop = addedshop[index] as Map;

                        bool hasPicture = addshop['CustomerImage'] != null;
                        String status = '';
                        Color statusColor;
                        switch(addshop['IsValued']){
                          case '0':
                            status = 'Pending';
                            statusColor = Colors.yellow.shade400;
                            break;
                          case '1':
                            status = 'Valued';
                            statusColor = Colors.greenAccent;
                            break;
                          default:
                            status = 'Rejected';
                            statusColor = Colors.redAccent;
                            break;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 1,
                                  color: Colors.grey.shade400,
                                  offset: Offset(0, 2)
                                )
                              ]
                            ),
                            child: ListTile(
                              onTap: (){
                                _bottomModal('${addshop['CustomerName']}', '${addshop['CustomerAddress']}',
                                    '${addshop['CustomerContactNumber']}', '${addshop['CustomerImage']}',
                                    hasPicture, '${addshop['Date']}', '${addshop['IsValued']}', '${addshop['AddedShopID']}');
                              },
                              contentPadding: EdgeInsets.all(8),
                              leading: ProfilePicture(
                                name: '${addshop['CustomerName']}',
                                radius: 28,
                                fontsize: 18,
                                img: hasPicture ? '$picaddress/${addshop['CustomerImage']}' : null,
                              ),
                              title: Text('${addshop['CustomerName']}'),
                              titleTextStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                              subtitle: Text('${addshop['CustomerAddress']}',style: TextStyle(fontSize: 10),),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                                child: Text(status,style: TextStyle(color: Colors.white,fontSize: 14),textAlign: TextAlign.center,),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
              ],
            ),
          )
      ),
    );
  }
}
/*
import 'dart:convert';
import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/drawer/ownerDrawer.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PendingCustomerScreen extends StatefulWidget {
  const PendingCustomerScreen({super.key});

  @override
  State<PendingCustomerScreen> createState() => _PendingCustomerScreenState();
}

class _PendingCustomerScreenState extends State<PendingCustomerScreen> {
  String? token;
  int? userid;
  int? shopid;
  bool isLoading = true;

  void customerDialog(String name, String address, String contact, String added_id, String image){
    bool hasImage = image.isNotEmpty;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Container(
            alignment: Alignment.center,
            height: 100,
            child: AlertDialog(
              content: Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: hasImage
                          ? MemoryImage(base64Decode(image)) as ImageProvider
                          : AssetImage('assets/pepe.png') as ImageProvider,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      address,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      contact,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Color(0XFF597FAF),width: 2)

                        )
                      ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text(
                            'Cancel',
                          style: TextStyle(
                            color: Color(0XFF597FAF),
                            fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0XFF597FAF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Color(0XFF597FAF),width: 2)

                            )
                        ),
                        onPressed: (){
                          addedShopStat(added_id);
                        },
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                              color: Color(0xFFF6F6F6),
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  void customerDialogDisplay(String name, String address, String contact, String added_id, String image){
    bool hasImage = image.isNotEmpty;

    showDialog(
        context: context,
        builder: (BuildContext context){
          return Container(
            alignment: Alignment.center,
            height: 100,
            child: AlertDialog(
              content: Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: hasImage
                          ? MemoryImage(base64Decode(image)) as ImageProvider
                          : AssetImage('assets/pepe.png') as ImageProvider,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      address,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      contact,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
      addedShopDisplay();
    });

  }

  List<dynamic> addedshop = [];

  String? id;
  String? status;
  bool isValued = false;
  bool hasData = false;

  void _cancelSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: 'Shop request cancelled')
    );
  }
  void _acceptSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(message: 'Customer accepted')
    );
  }

  Future<void> addedShopStat(String customerid) async{
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
        token.toString(),
        customerid.toString()
    );

    if(apiResponse.error == null){
      Navigator.popUntil(context, (route) => route.isFirst);
      _acceptSnackbar();
      setState(() {
        addedShopDisplay();
      });
    }else{
      Navigator.pop(context);
      print(apiResponse.error);
    }
  }

  Future<void> addedShopDisplay() async{

    ApiResponse response = await getAddedShop(token.toString());

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
      print('${response.error}');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    print(token);
    if(isLoading){
      return Scaffold(
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
          body: const Center(
              child: Text(
                  'No list yet. Invite your first customer.'
              )
          )
      );
    }

    return Scaffold(
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

                      bool hasPicture = addshop['Image'].isNotEmpty;

                      return InkWell(
                        onTap: (){
                          if('${addshop['IsValued']}' == '1'){
                            customerDialogDisplay(
                                '${addshop['Name']}', '${addshop['Address']}',
                                '${addshop['ContactNumber']}','${addshop['AddedShopID']}',
                                '${addshop['Image']}'
                            );
                          }
                          else{
                            customerDialog(
                                '${addshop['Name']}', '${addshop['Address']}',
                                '${addshop['ContactNumber']}','${addshop['AddedShopID']}',
                                '${addshop['Image']}'
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.black,
                            child: SizedBox(
                                height: 100,
                                width: 400,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: CircleAvatar(
                                        radius: 35,

                                        backgroundImage: hasPicture
                                            ? MemoryImage(base64Decode('${addshop['Image']}')) as ImageProvider<Object>
                                            : AssetImage('assets/pepe.png') as ImageProvider<Object>,
                                      ),
                                      margin: EdgeInsets.only(left: 10),
                                    ),
                                    Text(
                                      '${addshop['Username']}',
                                      style: TextStyle(
                                          fontSize: 30
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: (){
                                          if('${addshop['IsValued']}' == '1'){
                                            customerDialogDisplay(
                                                '${addshop['Name']}', '${addshop['Address']}',
                                                '${addshop['ContactNumber']}','${addshop['AddedShopID']}',
                                                '${addshop['Image']}'
                                            );
                                          }else{
                                            customerDialog(
                                                '${addshop['Name']}', '${addshop['Address']}',
                                                '${addshop['ContactNumber']}','${addshop['AddedShopID']}',
                                                '${addshop['Image']}'
                                            );
                                          }

                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        icon: Builder(
                                          builder: (BuildContext context) {
                                            if('${addshop['IsValued']}' == '1'){
                                              return const Icon(
                                                Icons.star,
                                                size: 50,
                                                color: Colors.white,
                                              );
                                            }else{
                                              return const Icon(
                                                Icons.star_border,
                                                size: 50,
                                                color: Colors.white,
                                              );
                                            }
                                          },
                                        )
                                    )
                                  ],
                                )
                            ),
                          ),
                        ),
                      );
                    }
                )
              ],
            ),
          )
      ),
    );
  }
}*/

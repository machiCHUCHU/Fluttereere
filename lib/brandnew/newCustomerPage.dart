import 'dart:convert';
import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/setWidget/appbar.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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

  void _bottomModal(String name, String address, String contact, String image, bool hasPicture) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .4,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 20,),
                RowItem(
                    title: const Row(
                      children: [
                        Icon(Icons.person, color: ColorStyle.tertiary,),
                        Text('Name:')
                      ],
                    ),
                    description: Text(name, style: TextStyle(fontWeight: FontWeight.bold),)
                ),
                RowItem(
                    title: const Row(
                      children: [
                        Icon(Icons.call,color: ColorStyle.tertiary,),
                        Text('Contact Number:')
                      ],
                    ),
                    description: Text(contact, style: TextStyle(fontWeight: FontWeight.bold),)
                ),
                RowItem(
                    title: const Row(
                      children: [
                        Icon(Icons.location_on,color: ColorStyle.tertiary,),
                        Text('Address:')
                      ],
                    ),
                    description: Text(address, style: TextStyle(fontWeight: FontWeight.bold),)
                )
              ],
            ),
          ),

          Positioned(
            top: -50,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white, // Border color
                  width: 4.0, // Border width
                ),
              ),
              child: CircleAvatar(
                backgroundImage: hasPicture
                    ? NetworkImage('$picaddress/$image')
                    : AssetImage('assets/pepe.png') as ImageProvider,
                radius: 50,
              ),
            ),
          ),
        ],
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
     }else{
       await errorDialog(context, 'Request rejected.');
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
          appBar: const ForAppBar(
            title: Text('Customers'),
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
      return const Scaffold(
          appBar: ForAppBar(
            title: Text('Customers'),
          ),
          body: Center(
              child: Text(
                  'No list yet. Invite your first customer.'
              )
          )
      );
    }

    return Scaffold(
      appBar: const ForAppBar(
        title: Text('Customers'),
      ),
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: addedshop.length,
                      itemBuilder: (context, index){
                        Map addshop = addedshop[index] as Map;

                        bool hasPicture = addshop['CustomerImage'].isNotEmpty;
                        bool isAccepted = addshop['IsValued'] == '1';
                        print(hasPicture);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: (){
                              _bottomModal('${addshop['CustomerName']}', '${addshop['CustomerAddress']}',
                                  '${addshop['CustomerContactNumber']}', '${addshop['CustomerImage']}', hasPicture);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: hasPicture
                                          ? NetworkImage('$picaddress/${addshop['CustomerImage']}')
                                          : AssetImage('assets/pepe.png') as ImageProvider,
                                      radius: 40,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${addshop['CustomerName']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),overflow: TextOverflow.ellipsis,),
                                          isAccepted ? Text(
                                            'Marked as Valued Customer',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green
                                            ),
                                          ) : Row(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorStyle.tertiary,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)
                                                    )
                                                ),
                                                onPressed: (){
                                                  confirmDialog(context, 'Accept request?', (){addedShopStat('${addshop['AddedShopID']}', '1');});
                                                },
                                                child: const Text(
                                                    'Mark   ',
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    ),
                                                    textAlign: TextAlign.center
                                                ),
                                              ),
                                              const SizedBox(width: 5,),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)
                                                      )
                                                  ),
                                                  onPressed: (){
                                                    confirmDialog(context, 'Reject request?', (){addedShopStat('${addshop['AddedShopID']}', '2');});
                                                  },
                                                  child: const Text(
                                                    'Reject ',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black
                                                    ),
                                                  )
                                              )
                                            ],)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ),
                        );
                      }
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
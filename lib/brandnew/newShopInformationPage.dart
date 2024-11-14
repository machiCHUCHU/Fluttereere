import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/servicesadd.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

import 'package:simple_time_range_picker/simple_time_range_picker.dart';

class NewShopInformationScreen extends StatefulWidget {
  const NewShopInformationScreen({super.key});

  @override
  State<NewShopInformationScreen> createState() => _NewShopInformationScreenState();
}

class _NewShopInformationScreenState extends State<NewShopInformationScreen> {
  List<dynamic> shopinfo = []; Map shop = {}; bool isLoading = true; late Color statColor;
  String days = '';
  String? usertype;
  String? access;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usertype = prefs.getString('usertype');
      access = prefs.getString('accesstype');
    });
  }

  Future<void> shopInfoDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getShopInformation('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        shopinfo = response.data as List<dynamic>;
        shop = shopinfo[0] as Map;
        isLoading = false;
      });
    }else{
      print(response.error);
    }
  }

  @override
  void initState() {
    getUser();
    shopInfoDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch(shop['ShopStatus']){
      case 'open':
       statColor = Colors.green;
        break;
      case 'closed':
       statColor = Colors.red;
        break;
      default:
       statColor = Colors.yellow;
        break;
    }

    switch(shop['WorkDay']){
      case 'weekdays':
        days = 'Monday - Friday';
        break;
      case 'weekend':
        days = 'Saturday and Sunday';
        break;
      default:
        days = 'Monday - Sunday';
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Information'),
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context,true);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: isLoading
          ? loading()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  color: Colors.grey
                )
              ]
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ListTile(
                  contentPadding: const EdgeInsets.all(4),
                  leading: CircleAvatar(
                    radius: 32,
                    backgroundColor: ColorStyle.tertiary,
                    child: ProfilePicture(
                      name: '${shop['ShopName']}',
                      radius: 26,
                      fontsize: 24,
                      img: shop['ShopImage'] == null || shop['ShopImage'] == '' ? null : '$picaddress/${shop['ShopImage']}',
                    ),
                  ),
                  title: Text('${shop['ShopName']}'),
                  subtitle: Container(
                      child: Text('${shop['ShopStatus']}',style: TextStyle(color: statColor),)
                  )
              ),
              const SizedBox(height: 10,),
              RowItem(
                  title: const Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      Text('Shop Address',style: TextStyle(fontSize: 12),)
                    ],
                  ),
                  description: Text('${shop['ShopAddress']}',style: TextStyle(fontSize: 12))
              ),
              const Divider(),
              RowItem(
                  title: const Row(
                    children: [
                      Icon(Icons.today),
                      Text('Business Days',style: TextStyle(fontSize: 12),)
                    ],
                  ),
                  description: Text(days,style: TextStyle(fontSize: 12))
              ),
              const Divider(),
              RowItem(
                  title: const Row(
                    children: [
                      Icon(Icons.timelapse),
                      Text('Business Hours',style: TextStyle(fontSize: 12),)
                    ],
                  ),
                  description: Text('${shop['WorkHour']}',style: TextStyle(fontSize: 12))
              ),
              const Divider(),
              RowItem(
                  title: const Row(
                    children: [
                      Icon(Icons.monitor_weight_outlined),
                      Text('Max Load Cater Daily',style: TextStyle(fontSize: 12),)
                    ],
                  ),
                  description: Text('${shop['MaxLoad']} loads',style: TextStyle(fontSize: 12))
              ),
              const Divider(),
              const SizedBox(height: 10,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.tertiary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  onPressed: usertype == 'owner'
                      ?()async{
                    final response = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        EditShopInformationScreen(image: '${shop['ShopImage']}', shopName: '${shop['ShopName']}',
                            shopStat: '${shop['ShopStatus']}', shopAddress: '${shop['ShopAddress']}',
                            workDay: '${shop['WorkDay']}', workHour: '${shop['WorkHour']}', maxLoad: '${shop['MaxLoad']}' )));

                    if(response == true){
                      shopInfoDisplay();
                    }
                  }
                      : (){
                    warningTextDialog(context, 'Access Denied', 'Sorry you don\'t have permission to edit the information');
                  },
                  child: const Text('Edit Information',style: TextStyle(color: Colors.white),)
              )
            ],
          ),
        )
          ),
    );
  }
}

class EditShopInformationScreen extends StatefulWidget {
  final String image; final String shopName; final String shopStat;
  final String shopAddress; final String workDay; final String workHour; final String maxLoad;
  const EditShopInformationScreen({super.key, required this.image, required this.shopName, required this.shopStat,
    required this.shopAddress, required this.workDay, required this.workHour, required this.maxLoad});

  @override
  State<EditShopInformationScreen> createState() => _EditShopInformationScreenState();
}

class _EditShopInformationScreenState extends State<EditShopInformationScreen> {
  Uint8List? _pickedImageBytes; String _image = ''; String _businessdays = '';
  String _businesshours = ''; String _shopstatus = '';
  final TextEditingController _shopname = TextEditingController();
  final TextEditingController _shopaddress = TextEditingController();
  final TextEditingController _maxload = TextEditingController();

  List<String> _openDay = ['weekly','weekdays','weekend'];
  List<String> _shopStat = ['open','closed','full'];

  Future<void> _pickAndUploadImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: (){
                Navigator.pop(context, ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt),
              iconSize: 75,
              color: Colors.blueAccent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            IconButton(
              onPressed: (){
                Navigator.pop(context, ImageSource.gallery);
              },
              icon: const Icon(Icons.folder),
              iconSize: 75,
              color: Colors.blueAccent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            )
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? pickedImage = await ImagePicker().pickImage(
          source: source,
          maxHeight: 500,
          maxWidth: 500
      );

      if (pickedImage != null) {
        final byteData = await pickedImage.readAsBytes();

        setState(() {
          _pickedImageBytes = byteData;
          _image = base64Encode(_pickedImageBytes!);
        });


      } else {

      }
    }
  }

  Future<void> updateShopInfo() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String hasPickedImage;
    if(_pickedImageBytes != null){
      hasPickedImage = base64Encode(_pickedImageBytes!);

    }else{
      hasPickedImage = _image;
    }
    ApiResponse response = await editShopInfo(
        _shopname.text, _shopaddress.text, _businessdays, _businesshours,
        _maxload.text, _shopstatus, hasPickedImage, '${prefs.getString('token')}');

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context,true);
    }else{
      await warningDialog(context, '${response.error}');
    }
  }

  @override
  void initState() {
    _image = widget.image;
    _businessdays = widget.workDay;
    _businesshours = widget.workHour;
    _shopstatus = widget.shopStat;
    _shopname.text = widget.shopName;
    _shopaddress.text = widget.shopAddress;
    _maxload.text = widget.maxLoad;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Information'),
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context,true);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                children: [
                  if(_pickedImageBytes == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                    color: ColorStyle.tertiary,
                                    shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: ColorStyle.tertiary,
                                  radius: 50,
                                  child: ProfilePicture(
                                    name: widget.shopName,
                                    radius: 48,
                                    fontsize: 28,
                                    img: _image == '' ? null : '$picaddress/$_image',
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 70,
                                  left: 70,
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: ColorStyle.tertiary,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          _pickAndUploadImage();
                                        },
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 15,
                                          weight: 50,
                                        ),
                                      )))
                            ],
                          ),
                        ),
                    ),
                  if (_pickedImageBytes != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                      color: ColorStyle.tertiary,
                                      shape: BoxShape.circle
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 50,
                                    backgroundImage: MemoryImage(_pickedImageBytes!),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 70,
                                  left: 70,
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: ColorStyle.tertiary,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          _pickAndUploadImage();
                                        },
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 15,
                                          weight: 50,
                                        ),
                                      )))
                            ],
                          ),
                        ),
                    ),

                ],
              ),
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Shop Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _shopname,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                  )
              ),
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Shop Address',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _shopaddress,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                  )
              ),
            ),
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Business Days',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *.45,
                        child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                                    borderSide: BorderSide(
                                        color: Colors.grey
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                                )
                            ),
                            value: _businessdays,
                            items: _openDay.map((value){
                              return DropdownMenuItem(
                                  value: value,
                                  child: Text(value)
                              );
                            }).toList(),
                            onChanged: (newValue){
                              _businessdays = newValue!;
                            }
                        )
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Business Hours',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *.45,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              fixedSize: Size(MediaQuery.of(context).size.width, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                              ),
                              side: BorderSide(style: BorderStyle.solid, width: 1),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              backgroundColor: Colors.white
                          ),
                          onPressed: (){
                            TimeRangePicker.show(
                                context: (context),
                                onSubmitted: (TimeRangeValue value) {
                                  setState(() {
                                    _businesshours = '${value.startTime?.format(context)} - ${value.endTime?.format(context)}';
                                  });
                                }
                            );
                          },
                          child: Align(alignment: Alignment.centerLeft,
                            child: Text(_businesshours.isEmpty ? 'Select' : _businesshours, style: TextStyle(fontSize: 16, color: Colors.black54),),)
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Max Load Cater Daily',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *.45,
                        child: TextField(
                          controller: _maxload,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                              )
                          ),
                        ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Business Hours',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *.45,
                      child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                              )
                          ),
                          value: _shopstatus,
                          items: _shopStat.map((value){
                            return DropdownMenuItem(
                                value: value,
                                child: Text(value)
                            );
                          }).toList(),
                          onChanged: (newValue){
                            _shopstatus = newValue!;
                          }
                      )
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
              backgroundColor: ColorStyle.tertiary
          ),
          onPressed: (){
            updateShopInfo();
          },
          child: const Text('Edit Shop Information',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}

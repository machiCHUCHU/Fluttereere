import 'dart:convert';
import 'dart:core';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newCoOwnerPage.dart';
import 'package:capstone/brandnew/newLaundryServicePage.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/brandnew/newProfilePage.dart';
import 'package:capstone/brandnew/newServiceTime.dart';
import 'package:capstone/brandnew/newShopInformationPage.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/settingStyle.dart';
import 'package:capstone/styles/signupStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

import 'package:simple_time_range_picker/simple_time_range_picker.dart';

class NewSettingsScreen extends StatefulWidget {
  const NewSettingsScreen({super.key});

  @override
  State<NewSettingsScreen> createState() => _NewSettingsScreenState();
}

class _NewSettingsScreenState extends State<NewSettingsScreen> {
  List<dynamic> settings = [];
  List<dynamic> service = [];
  Map set = {};
  bool hasData = false;
  bool hasImage = false;
  bool isLoading = true;
  String? token;
  String? usertype;
  String? access;

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
      print(response.error);
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
      appBar: AppBar(
        title: const Text('Settings'),
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
                            child: Icon(Icons.person,color: Colors.white,),
                          ),
                          Text(' Profile',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      description: Icon(CupertinoIcons.chevron_forward)
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
                            child: Icon(Icons.store,color: Colors.white,),
                          ),
                          Text(' Shop Information',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      description: Icon(CupertinoIcons.chevron_forward)
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
                           child: Icon(Icons.local_laundry_service,color: Colors.white,),
                         ),
                         Text(' Laundry Services',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                       ],
                     ),
                     description: Icon(CupertinoIcons.chevron_forward)
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
                            child: Icon(Icons.timelapse_outlined,color: Colors.white,),
                          ),
                          Text(' Service Time',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      description: Icon(CupertinoIcons.chevron_forward)
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
                           child: Icon(CupertinoIcons.person_3_fill,color: Colors.white,),
                         ),
                         Text(' Co-Owners',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                       ],
                     ),
                     description: Icon(CupertinoIcons.chevron_forward)
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
                        child: Icon(Icons.logout,color: Colors.white,),
                      ),
                      Text(' Logout ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
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

class EditUserScreen extends StatefulWidget {
  final String id; final String name; final String sex;
  final String address; final String contact; final String image;
  const EditUserScreen({super.key, required this.id, required this.name,
    required this.sex, required this.address, required this.contact, required this.image});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  String? _selectedGender;
  final TextEditingController _address = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  String? image;
  XFile? imageData;

  @override
  void initState(){
    super.initState();
    widget.id;
    _name.text = widget.name;
    _address.text = widget.address;
    _contact.text = widget.contact;
    _selectedGender = widget.sex;
    image = widget.image;
  }

  Future<void> updateUser() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String hasPickedImage;
    if(_pickedImageBytes != null){
      hasPickedImage = base64Encode(_pickedImageBytes!);
    }else{
      hasPickedImage = image!;
    }

    ApiResponse apiResponse = await updateOwnerProfile(
        widget.id, _name.text, _selectedGender!,
        _address.text, _contact.text, hasPickedImage,
    '${prefs.getString('token')}');

    Navigator.pop(context);

    if(apiResponse.error == null){
      await successDialog(context, 'Profile has been updated');
      if(_contact.text != widget.contact){
        await reloginDialog(context);
        prefs.clear();
      }
      Navigator.pop(context, true);
    }else{
      errorDialog(context, '${apiResponse.error}');
    }
  }

  Uint8List? _pickedImageBytes;
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
        });


      } else {

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context,true);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(_pickedImageBytes == null)
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 130,
                        width: 100,
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                  color: ColorStyle.tertiary,
                                  shape: BoxShape.circle
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: image != null
                                    ? NetworkImage('$picaddress/$image')
                                    : const AssetImage('assets/pepe.png') as ImageProvider,
                                radius: 50,
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
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 130,
                        width: 100,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                padding: const EdgeInsets.all(2),
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
                  const Text(
                    'Name',
                    style: SettingStyle.formTitle,
                  ),
                  const SizedBox(height: 5,),
                  TextFormField(
                    controller: _name,
                    decoration: SettingStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),

                  const Text(
                    'Sex',
                    style: SettingStyle.formTitle,
                  ),
                  const SizedBox(height: 5,),
                  DropdownButtonFormField<String>(
                    decoration: SignupStyle.allForm,
                    hint: const Text('Select Sex'),
                    value: _selectedGender,
                    items: ['male', 'female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),

                  const Text(
                    'Address',
                    style: SettingStyle.formTitle,
                  ),
                  const SizedBox(height: 5,),
                  TextFormField(
                    controller: _address,
                    decoration: SettingStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),

                  const Text(
                    'Contact Number',
                    style: SettingStyle.formTitle,
                  ),
                  const SizedBox(height: 5,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _contact,
                    decoration: SettingStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),

                ],
              ),
            )
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorStyle.tertiary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              )
          ),
          onPressed: (){
            if(_formKey.currentState!.validate()){
              setState(() {
                updateUser();
              });
            }
          },
          child: const Text(
            'Edit Profile',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}

class EditShopScreen extends StatefulWidget {
  final String shopName;
  final String shopAddress;
  final String workDay;
  final String workHour;
  final String washerCount;
  final String washerTime;
  final String dryerCount;
  final String dryerTime;
  final String foldTime;
  final List<dynamic> services;
  const EditShopScreen({super.key, required this.shopName, required this.shopAddress, required this.workDay, required this.workHour, required this.washerCount, required this.washerTime, required this.dryerCount, required this.dryerTime, required this.foldTime, required this.services});

  @override
  State<EditShopScreen> createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _shopName = TextEditingController();
  String? _selectedGender;
  final TextEditingController _shopAddress = TextEditingController();
  final TextEditingController _lightLoad = TextEditingController();
  final TextEditingController _lightCost = TextEditingController();
  final TextEditingController _heavyLoad = TextEditingController();
  final TextEditingController _heavyCost = TextEditingController();
  final TextEditingController _comforterLoad = TextEditingController();
  final TextEditingController _comforterCost = TextEditingController();
  String _shopTime = '';
  String? image;
  String _workDays = '';

  Future<void> shopInfoUpdate() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updateShop(
        '${widget.services[0]['ServiceID']}', '${widget.services[1]['ServiceID']}', '${widget.services[2]['ServiceID']}',
        _lightLoad.text, _lightCost.text, _heavyLoad.text, _heavyCost.text,
        _comforterLoad.text, _comforterCost.text, _shopName.text, _shopAddress.text,
        _workDays, _shopTime, '${prefs.getString('token')}'
    );

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context,true);
    }else{
      await errorDialog(context, '${response.error}');
    }
  }


  @override
  void initState(){
    super.initState();
    _shopName.text = widget.shopName;
    _shopAddress.text = widget.shopAddress;
    _shopTime = widget.workHour;
    _workDays = widget.workDay;
    _lightLoad.text = '${widget.services[0]['LoadWeight']}';
    _lightCost.text = '${widget.services[0]['LoadPrice']}';
    _heavyLoad.text = '${widget.services[1]['LoadWeight']}';
    _heavyCost.text = '${widget.services[1]['LoadPrice']}';
    _comforterLoad.text = '${widget.services[2]['LoadWeight']}';
    _comforterCost.text = '${widget.services[2]['LoadPrice']}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shop Profile'),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Name',
                    style: SettingStyle.formTitle,
                  ),
                  const SizedBox(height: 5,),
                  TextFormField(
                    controller: _shopName,
                    decoration: SettingStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 15,),

                  const Text(
                    'Address',
                    style: SettingStyle.formTitle,
                  ),
                  const SizedBox(height: 5,),
                  TextFormField(
                    controller: _shopAddress,
                    decoration: SettingStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 15,),

                  const Text(
                    'Working Days',
                    style: SignupStyle.formTitle,
                  ),
                  const SizedBox(height: 5,),
                  DropdownButtonFormField<String>(
                    decoration: SignupStyle.allForm,
                    hint: const Text('Select'),
                    value: _workDays,
                    items: ['weekend', 'weekdays', 'weekly'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _workDays = newValue!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),

                  const Text(
                    'Working Hours',
                    style: SignupStyle.formTitle,
                  ),
                  const SizedBox(height: 5,),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          fixedSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height *.075),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(style: BorderStyle.solid, width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          backgroundColor: Colors.white
                      ),
                      onPressed: (){
                        TimeRangePicker.show(
                            context: (context),
                            onSubmitted: (TimeRangeValue value) {
                              setState(() {
                                _shopTime = '${value.startTime?.format(context)} - ${value.endTime?.format(context)}';
                              });
                            }
                        );
                      },
                      child: Align(alignment: Alignment.centerLeft,
                        child: Text(_shopTime.isEmpty ? 'Select' : _shopTime, style: const TextStyle(fontSize: 16, color: Colors.black54),),)
                  ),
                  const SizedBox(height: 15,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Light Load (kg)',
                            style: SignupStyle.formTitle,
                          ),
                          const SizedBox(height: 5,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *.45,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _lightLoad,
                              decoration: SignupStyle.allForm,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Light Cost',
                            style: SignupStyle.formTitle,
                          ),
                          const SizedBox(height: 5,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *.45,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _lightCost,
                              decoration: SignupStyle.allForm,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Heavy Load (kg)',
                            style: SignupStyle.formTitle,
                          ),
                          const SizedBox(height: 5,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *.45,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _heavyLoad,
                              decoration: SignupStyle.allForm,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Heavy Cost',
                            style: SignupStyle.formTitle,
                          ),
                          const SizedBox(height: 5,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *.45,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _heavyCost,
                              decoration: SignupStyle.allForm,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Comforter Load (kg)',
                            style: SignupStyle.formTitle,
                          ),
                          const SizedBox(height: 5,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *.45,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _comforterLoad,
                              decoration: SignupStyle.allForm,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Comforter Cost',
                            style: SignupStyle.formTitle,
                          ),
                          const SizedBox(height: 5,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *.45,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _comforterCost,
                              decoration: SignupStyle.allForm,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      )
                    ],
                  ),

                ],
              ),
            )
        ),
      bottomNavigationBar:
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorStyle.tertiary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              )
          ),
          onPressed: (){
            if(_shopName.text.isEmpty || _shopAddress.text.isEmpty || _shopTime.isEmpty || _workDays.isEmpty ||
                _lightLoad.text.isEmpty || _heavyLoad.text.isEmpty || _comforterLoad.text.isEmpty || _lightCost.text.isEmpty
                || _heavyCost.text.isEmpty || _comforterCost.text.isEmpty){
              warningDialog(context, 'Fields cannot be empty');
            }else{
              shopInfoUpdate();
            }
          },
          child: const Text(
            'Edit Profile',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}

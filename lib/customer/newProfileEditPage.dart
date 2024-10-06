import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/signupStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:row_item/row_item.dart';
import 'dart:typed_data';


import 'package:shared_preferences/shared_preferences.dart';

class NewProfileEditScreen extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final String sex;
  final String address;
  final String contact;
  const NewProfileEditScreen({super.key, required this.image, required this.name, required this.sex, required this.address, required this.contact, required this.id});
  
  @override
  State<NewProfileEditScreen> createState() => _NewProfileEditScreenState();
}

class _NewProfileEditScreenState extends State<NewProfileEditScreen> {
  String _name = '';
  String _address = '';
  String _sex = '';
  String _image = '';
  String _contact = '';

  @override
  void initState() {
    _image = widget.image;
    _name = widget.name;
    _sex = widget.sex;
    _address = widget.address;
    _contact = widget.contact;
    super.initState();
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
          _image = base64Encode(_pickedImageBytes!);
        });


      } else {

      }
    }
  }

  Future<void> removeAccess() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    ApiResponse response = await logout('${prefs.get('token')}');

    if(response.error == null){
    }else{
      print(response.error);
    }
  }

  Future<void> updateProfile() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.black,
            size: 50,
          ),
        );
      },
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String hasPickedImage;
    if(_pickedImageBytes != null){
      hasPickedImage = base64Encode(_pickedImageBytes!);

    }else{
      hasPickedImage = _image;
    }

    ApiResponse response = await updateCustomerProfile(
        widget.id, _name, _sex, _address, _contact, hasPickedImage, '${prefs.getString('token')}');

    if(!mounted) return;
    Navigator.pop(context);

    if (response.error == null) {
      await successDialog(context, '${response.data}');
      if(_contact != widget.contact){
        await reloginDialog(context);
        prefs.clear();
      }else{
        Navigator.pop(context,true);
      }
    } else {
      await errorDialog(context, '${response.error}');
      Navigator.pop(context);
    }
  }

  bool isEditable(){
    if(widget.name != _name || widget.sex != _sex || widget.address != _address || widget.contact != _contact || widget.image != _image){
      return true;
    }else{
      return false;
    }
  }

  void sexDialog(){
    showDialog(

        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: const Text('Sex',textAlign: TextAlign.center,),
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            content: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
                     setState(() {
                       _sex = 'male';
                     });
                     Navigator.pop(context);
                    },
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: const Text('Male',style: TextStyle(fontSize: 18),)
                    ),
                  ),
                  InkWell(
                    onTap: (){
                     setState(() {
                       _sex = 'female';
                     });
                     Navigator.pop(context);
                    },
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: const Text('Female',style: TextStyle(fontSize: 18),)
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_image);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Information'),
        titleTextStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            isEditable() 
                ? confirmationDialog(context, 'Discard Changes?', 'Your current changes will be lost.')
                : Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
        actions: [
          IconButton(
              onPressed: isEditable() ? (){
                updateProfile();
              } : null,
              icon: Icon(Icons.check_sharp, color: isEditable() ? Colors.white : Colors.white70,),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SingleChildScrollView(
          child: Column(
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
                            backgroundImage: _image.isNotEmpty
                                ? NetworkImage('$picaddress/$_image')
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
              InkWell(
                onTap: ()async{
                  final response = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  InputNameScreen(name: _name,)));

                  setState(() {
                    _name = response;
                  });
                },
                child: Ink(
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                            top: BorderSide(color: Colors.grey.shade300)
                        ),
                    ),
                    child: RowItem(
                      title: const Text('Name'),
                      description: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(child: Text(_name, overflow: TextOverflow.ellipsis,),),
                          const Icon(CupertinoIcons.chevron_forward,size: 18,color: Colors.grey,)
                        ],
                      )
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  sexDialog();
                },
                child: Ink(
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300)
                        ),
                    ),
                    child: RowItem(
                      title: const Text('Sex'),
                      description: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(_sex, overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),
                          const Icon(CupertinoIcons.chevron_forward,size: 18,color: Colors.grey,)
                        ],
                      )
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: ()async{
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  InputAddressScreen(address: _address)));

                    setState(() {
                      _address = result;
                    });
                },
                child: Ink(
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300)
                        ),
                    ),
                    child: RowItem(
                      title: const Text('Address'),
                      description: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(child: Text(_address, overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,)),
                          const Icon(CupertinoIcons.chevron_forward,size: 18,color: Colors.grey,)
                        ],
                      )
                    ),
                  ),
                )
              ),
              InkWell(
                onTap: ()async{
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => InputNumberScreen(number: _contact)));

                  if(result != null){
                    setState(() {
                      _contact = result;
                    });
                  }
                },
                child: Ink(
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300)
                      ),
                    ),
                    child: RowItem(
                      title: const Text('Contact'),
                      description: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(_contact, overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),
                          const Icon(CupertinoIcons.chevron_forward,size: 18,color: Colors.grey,)
                        ],
                      )
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InputNumberScreen extends StatefulWidget {
  final String number;
  const InputNumberScreen({super.key, required this.number});

  @override
  State<InputNumberScreen> createState() => _InputNumberScreenState();
}

class _InputNumberScreenState extends State<InputNumberScreen> {
  final TextEditingController _number = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? numInput = '';

  Future<void> otpDisplay() async{/*widget.contact*/
    await otpVerification(_number.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Phone Number'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.call),
                  contentPadding: EdgeInsets.all(0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red
                    )
                  )
                ),
                maxLength: 11,
                validator: (newValue){
                  numInput = newValue;
                  if(newValue == widget.number){
                    warningTextDialog(context, 'Invalid Number', 'You have entered your current number. Please input a new number.');
                    return 'Invalid Number';
                  }else if(newValue == null || newValue.isEmpty){
                    return 'Input a value';
                  }else if(newValue.length < 10){
                    return 'Invalid Number';
                  }else{
                    otpDisplay();
                    return null;
                  }
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width,20),
                    backgroundColor: ColorStyle.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){

                      final response = await Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(contact: numInput!)));

                      Navigator.pop(context, response);
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
              )
            ],
          ),
        )
      ),
    );
  }
}

class InputAddressScreen extends StatefulWidget {
  final String address;
  const InputAddressScreen({super.key, required this.address});

  @override
  State<InputAddressScreen> createState() => _InputAddressScreenState();
}

class _InputAddressScreenState extends State<InputAddressScreen> {
  final TextEditingController _address = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String newAddress = '';

  @override
  void initState() {
    _address.text = widget.address;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Address'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _address,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    )
                ),
                validator: (value){
                  newAddress = value!;
                  if(value.isEmpty){
                    return 'Input a value';
                  }else{
                    return null;
                  }
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width,20),
                      backgroundColor: ColorStyle.tertiary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      Navigator.pop(context, newAddress);
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              )
            ],
          ),
        )
      ),
    );
  }
}

class InputNameScreen extends StatefulWidget {
  final String name;
  const InputNameScreen({super.key, required this.name});

  @override
  State<InputNameScreen> createState() => _InputNameScreenState();
}

class _InputNameScreenState extends State<InputNameScreen> {
  final TextEditingController _name = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String newName = '';

  @override
  void initState() {
    _name.text = widget.name;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Name'),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  validator: (value){
                    newName = value!;
                    if(value.isEmpty){
                      return 'Input a value';
                    }else{
                      return null;
                    }
                  },
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width,20),
                        backgroundColor: ColorStyle.tertiary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        )
                    ),
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        Navigator.pop(context, newName);
                      }
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}




class OTPScreen extends StatefulWidget {
  final String contact;
  const OTPScreen({super.key, required this.contact});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
          fontSize: 22,
          color: Colors.black
      ),
      decoration: SignupStyle.otpInput
  );

  bool showTimer = true;
  bool? isVerified;

  String otp = '';
  Future<void> otpDisplay() async{/*widget.contact*/
    await otpVerification(widget.contact);
  }

  Future<void> inputCodeCheck() async{
    ApiResponse response = await otpCheck(otp);

    if(response.error == null){
      Navigator.pop(context, widget.contact);
    }else{
      warningTextDialog(context, 'Invalid OTP', '${response.error}');
    }
  }

  @override
  void initState(){
    super.initState();
    widget.contact;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Verification Code'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Your verification code is sent to',
                    style: TextStyle(

                        fontSize: 14
                    ),
                  ),
                const SizedBox(height: 10,),
                Text(
                    widget.contact,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                const SizedBox(height: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pinput(
                      validator: (value){
                        otp = value!;
                      },
                      length: 4,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(color: ColorStyle.tertiary)
                          )
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Didn't get the code?  "),
                        showTimer
                            ? TimerCountdown(
                          format: CountDownTimerFormat.minutesSeconds,
                          enableDescriptions: false,
                          spacerWidth: 0,
                          timeTextStyle: const TextStyle(
                              fontSize: 15
                          ),
                          endTime: DateTime.now().add(const Duration(minutes: 5)),
                          onEnd: () {
                            setState(() {
                              showTimer = false;
                            });
                          },
                        )
                            : Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(0),
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  showTimer = true;
                                });
                                otpDisplay();
                              },
                              child: const Text(
                                'Resend',
                                style: SignupStyle.resendButton,
                              ),
                            )
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                    style: SignupStyle.signButton(),
                    onPressed: ()async{
                      await inputCodeCheck();
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}


import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/material.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/signupStyle.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pinput/pinput.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NewSignupScreen extends StatefulWidget {
  final String usertype;
  const NewSignupScreen({super.key, required this.usertype});

  @override
  State<NewSignupScreen> createState() => _NewSignupScreenState();
}

class _NewSignupScreenState extends State<NewSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameForm = TextEditingController();
  final TextEditingController _addressForm = TextEditingController();
  final TextEditingController _contactForm = TextEditingController();
  final TextEditingController _passForm = TextEditingController();

  bool isHidden = true;
  bool loading = true;
  bool isSubmitted = false;
  String? _selectedGender;

  Uint8List? _pickedImageBytes;
  Future<void> _pickAndUploadImage() async {
    final ImageSource? source = await showMaterialModalBottomSheet<ImageSource>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
          )
      ),
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.pop(context, ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera_alt),
                  iconSize: 75,
                  color: ColorStyle.tertiary,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                const Text(
                  'Camera',
                  style: SignupStyle.imagePick,
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.pop(context, ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image),
                  iconSize: 75,
                  color: ColorStyle.tertiary,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                const Text(
                  'Gallery',
                  style: SignupStyle.imagePick,
                )
              ],
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

  void _confirmationDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.topSlide,
      title: 'Proceed?',
      body: const Text(
          'Please double check information provided before proceeding.',
        textAlign: TextAlign.center,
      ),
      btnCancelOnPress: (){
      },
      btnOkOnPress: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            NewOTPScreen(
              address: _addressForm.text, contact: _contactForm.text,
              password: _passForm.text, gender: _selectedGender.toString(),
              usertype: widget.usertype, image: _pickedImageBytes ?? Uint8List(0), name: _nameForm.text,
            )));
    }
    ).show();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Register',
                  style: SignupStyle.titleStyle,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create a new account',
                  style: SignupStyle.secondaryTitle,
                ),
              ),
              const SizedBox(height: 30,),
              Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(_pickedImageBytes == null)
                              SizedBox(
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
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage('assets/user.png'),
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
                            if (_pickedImageBytes != null)
                              SizedBox(
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
                          ],
                        ),

                        const Text(
                          'Name',
                          style: SignupStyle.formTitle,
                        ),
                        const SizedBox(height: 5,),
                        TextFormField(
                          controller: _nameForm,
                          decoration: SignupStyle.allForm,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15,),

                        const Text(
                          'Address',
                          style: SignupStyle.formTitle,
                        ),
                        const SizedBox(height: 5,),
                        TextFormField(
                          controller: _addressForm,
                          decoration: SignupStyle.allForm,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required.';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15,),
                        const Text(
                          'Contact Number',
                          style: SignupStyle.formTitle,
                        ),
                        const SizedBox(height: 5,),
                        TextFormField(
                          controller: _contactForm,
                          keyboardType: TextInputType.number,
                          decoration: SignupStyle.allForm,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required.';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15,),
                        const Text(
                          'Sex',
                          style: SignupStyle.formTitle,
                        ),
                        const SizedBox(height: 5,),
                        DropdownButtonFormField<String>(
                          decoration: SignupStyle.allForm,
                          hint: const Text('Select Sex'),
                          value: _selectedGender,
                          items: ['Male', 'Female'].map((String value) {
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
                          'Password',
                          style: SignupStyle.formTitle,
                        ),
                        const SizedBox(height: 5,),
                        TextFormField(
                          controller: _passForm,
                          obscureText: isHidden,
                          decoration: SignupStyle.passForm(
                            isHidden: isHidden,
                            visibility: (){
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5,),

                        const SizedBox(height: 30,),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: SignupStyle.signButton(),
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  _confirmationDialog();
                                }
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              )
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'Already have an account? '
                            ),
                            GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLoginScreen()));
                                },
                                child: const Text(
                                  'Login',
                                  style: SignupStyle.textButton,
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}

class NewOTPScreen extends StatefulWidget {
  final String name;
  final String address;
  final String contact;
  final String password;
  final String gender;
  final String usertype;
  final Uint8List image;
  const NewOTPScreen({super.key, required this.address, required this.contact, required this.password, required this.gender, required this.usertype, required this.image, required this.name});

  @override
  State<NewOTPScreen> createState() => _NewOTPScreenState();
}

class _NewOTPScreenState extends State<NewOTPScreen> {

  Future<void> regForm() async {
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

      ApiResponse apiResponse = await register(
          widget.name, widget.gender, widget.address, widget.contact,
          widget.password, base64Encode(widget.image), widget.usertype);

      if (apiResponse.error == null) {
        await successDialog(context, 'Registered Successfully');
        Navigator.pop(context);
        if (mounted) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NewLoginScreen()), (route) => false);
        }
      } else {
        await errorDialog(context, '${apiResponse.error}');
        Navigator.pop(context);
      }
    }


  @override
  void initState(){
    super.initState();
    widget.name;
    widget.gender;
    widget.address;
    widget.contact;
    widget.password;
    widget.image;
    otpDisplay();
  }

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

  String? code;
  Future<void> otpDisplay() async{/*widget.contact*/
    ApiResponse response = await otpVerification(widget.contact);

    if(response.error == null){
      setState(() {
        code = response.data.toString();
      });
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    print(code);
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'Verification',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      child: const Text(
                        'Enter the code sent to your number.',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: Text(
                        widget.contact,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                      ),
                    ),
                    Pinput(
                      validator: (value){
                        if(value == code){
                          isVerified = true;
                          return null;
                        }else{
                          isVerified = false;
                          return null;
                        }
                      },
                      length: 4,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(color: ColorStyle.tertiary)
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          margin: const EdgeInsets.only(left:40, top: 5),
                          child: Row(
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
                                endTime: DateTime.now().add(const Duration(minutes: 1)),
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
                          )
                      ),
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                        style: SignupStyle.signButton(),
                        onPressed: (){
                          if(isVerified == true){
                            setState(() {
                              regForm();
                            });
                          }else{
                            const Text('Wrong Code');
                          }
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
        )
    );
  }
}
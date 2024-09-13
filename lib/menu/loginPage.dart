import 'dart:async';
import 'dart:convert';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/customer/userHome.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:capstone/home/homePage.dart';
import 'package:capstone/menu/getting_startedPage.dart';
import 'package:capstone/menu/inventoryPage.dart';
import 'package:capstone/model/user.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/testPage.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:capstone/imagepick.dart';
import 'package:capstone/api_response.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:capstone/brandnew/newLoginPage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = true;

  Future<void> loginUser() async {
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

    ApiResponse response = await login(
        txtEmail.text,
        txtPassword.text,
    );


    if(response.error == null){
     _saveAndRedirectToHome(response.data as User);
     _successSnackbar();
    } else {
      setState(() {
        loading = false;
      });
      Navigator.pop(context);

      print(response.error);
    }
  }
  void _successSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Welcome User!',
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  void _errorSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: 'Invalid Credentials')
    );
  }

  Future<void> _saveAndRedirectToHome(User user) async {
    ApiResponse apiResponse = await matchShop(user.userid.toString());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.token ?? '');
    await prefs.setString('username', user.username ?? '');
    await prefs.setInt('userid', user.userid ?? 0);
    await prefs.setString('ownername', user.name ?? '');
    await prefs.setString('contact', user.contact ?? '');
    await prefs.setString('image', user.image!);

    print(user.token);
    print(user.userid);
    print(user.testid);
    print(apiResponse.data);



    if(user.usertype == 'owner'){
        if(apiResponse.data == 'empty'){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const StartingSetupScreen()), (route) => false);
        }else{
          await prefs.setInt('shopid', user.testid ?? 0);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashboardScreen()), (route) => false);
        }
    }else {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserHomepage()), (route) => false);
    }

  }

  void _showUserTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Register As',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup/customer');
                  // Handle customer registration logic here
                },
                child: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF050C9C).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, color: Color(0xFF050C9C), size: 30),
                      SizedBox(height: 8),
                      Text(
                        'Customer',
                        style: TextStyle(fontSize: 14, color: Color(0xFF050C9C)),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup/owner');
                  // Handle owner registration logic here
                },
                child: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFF050C9C),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF050C9C).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store, color: Colors.white, size: 30),
                      SizedBox(height: 8),
                      Text(
                        'Owner',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  

  void initState(){
    super.initState();
  }

  Uint8List? _pickedImageBytes;
  Uint8List? _uploadedImageBytes;

  bool _isUploading = false;



  @override
  Widget build(BuildContext context) {

    return DoubleTapToExit(
        snackBar: const SnackBar(
          content: Text('Tap again to exit')
      ),
        child: Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.local_laundry_service,
                    size: 100,
                    color: Color(0xFF3572EF),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome Back to Laundry Mate!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Let's get your laundry managed!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // EMAIL
                  TextFormField(
                    controller: txtEmail,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // PASSWORD
                  TextFormField(
                    obscureText: true,
                    controller: txtPassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty || value.length < 4) {
                        return 'Please enter a valid password!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // LOG IN
                  TextButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          loading = true;
                          loginUser();
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3572EF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // REGISTER
                  GestureDetector(
                    onTap: _showUserTypeDialog,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'Sign up',
                          style: TextStyle(
                            color: Color(0xFF050C9C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLoginScreen()));
                      }, 
                      child: const Text('New Login')
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
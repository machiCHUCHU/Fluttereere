

import 'dart:async';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/newHomePage.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/brandnew/newSetupPage.dart';
import 'package:capstone/customer/newCustomerHomePage.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'styles/mainColorStyle.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async{
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: ColorStyle.tertiary
        ),
        scaffoldBackgroundColor: Colors.grey.shade200
      ),
      home: const RedirectScreen()
    );
  }
}


class RedirectScreen extends StatefulWidget {
  const RedirectScreen({super.key});

  @override
  _RedirectScreenState createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {

  bool hasToken = false;
  String userType = '';
  bool isLoading = true;


  Future<void> availToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await rememberToken('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        userType = '${response.data}';
        hasToken = true;
      });
    }else{
      await prefs.remove('${prefs.getString('token')}');
    }
  }

  Future<void> redirectScreen() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse apiResponse = await matchShop('${prefs.getString('token')}');
    await availToken();
    bool isLoggedIn = hasToken;

    if(isLoggedIn){
      if(userType == 'customer'){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewCustomerHomeScreen()));
      }else{
        if(apiResponse.data == 'empty'){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewSetupScreen()));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewHomeScreen()));
        }
      }
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewLoginScreen()));
    }
  }

  @override
  void initState() {
    redirectScreen().then((_){
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
            ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/LMateLogo.png'),
            LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      ) : Container(),
    );
  }
}


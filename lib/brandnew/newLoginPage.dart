import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newForgotPasswordPage.dart';
import 'package:capstone/brandnew/newHomePage.dart';
import 'package:capstone/brandnew/newSetupPage.dart';
import 'package:capstone/brandnew/newSignupPage.dart';
import 'package:capstone/customer/newCustomerHomePage.dart';
import 'package:capstone/model/user.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/testPage.dart';
import 'package:flutter/material.dart';
import 'package:capstone/styles/loginStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({super.key});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contactForm = TextEditingController();
  final TextEditingController _passForm = TextEditingController();

  bool isHidden = true;
  bool loading = true;
  bool isSubmitted = false;

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
      _contactForm.text,
      _passForm.text,
    );


    if(response.error == null){
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
      errorDialog(context, 'Invalid Credentials');
    }
  }
  Future<void> _saveAndRedirectToHome(User user) async {
    ApiResponse apiResponse = await matchShop('${user.token}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.token ?? '');
    await prefs.setString('username', user.username ?? '');
    await prefs.setInt('userid', user.userid ?? 0);




    if(user.usertype == 'owner'){
      await successDialog(context, 'Login Successfully');
      if(apiResponse.data == 'empty'){
        if(mounted){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NewSetupScreen()), (route) => false);
        }
      }else{
        if(mounted){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NewHomeScreen()), (route) => false);
        }
      }
    }
    else {
      await successDialog(context, 'Login Successfully');
      if(mounted){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NewCustomerHomeScreen()), (route) => false);
      }
    }

  }

  void _bottomModalAccount(){
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25)
        )
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * .3,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const Text(
                'Select an Account',
                style: LoginStyle.modalTitle,
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: ()async{
                      final response = await Navigator.push(context, MaterialPageRoute(builder: (context) => const
                      NewSignupScreen(usertype: 'customer',)));

                      if(response == true){
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: ColorStyle.tertiary,
                              width: 2
                          )
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 80,
                            color: ColorStyle.tertiary,
                          ),
                          Text(
                            'Customer',
                            style: LoginStyle.modalSubTitle,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()async{
                      final response = await Navigator.push(context, MaterialPageRoute(builder: (context) => const NewSignupScreen(
                        usertype: 'owner',)));

                      if(response == true){
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: ColorStyle.tertiary,
                              width: 2
                          )
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work,
                            size: 80,
                            color: ColorStyle.tertiary,
                          ),
                          Text(
                            'Owner',
                            style: LoginStyle.modalSubTitle,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/LMateLogo.png',scale: 2,)
                    ],
                  ),
                  const Text(
                    'Welcome to LaundryMate',
                    style: LoginStyle.titleStyle,
                  ),
                  const Text(
                    'Let\'s get your laundry managed!',
                    style: LoginStyle.secondaryTitle,
                  ),
                  const SizedBox(height: 30,),
                  SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Contact Number',
                              style: LoginStyle.formTitle,
                            ),
                            const SizedBox(height: 5,),
                            TextFormField(
                              controller: _contactForm,
                              decoration: LoginStyle.emailForm,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your contact number.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15,),

                            const Text(
                              'Password',
                              style: LoginStyle.formTitle,
                            ),
                            const SizedBox(height: 5,),
                            TextFormField(
                              controller: _passForm,
                              obscureText: isHidden,
                              decoration: LoginStyle.passForm(
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
                                  return 'Please enter your password.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 5,),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NewForgotPasswordScreen()));
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: LoginStyle.textButton,
                                  )
                              ),
                            ),
                            const SizedBox(height: 30,),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  style: LoginStyle.loginButton(),
                                  onPressed: (){
                                    setState((){
                                      isSubmitted = true;
                                    });
                                    if(_formKey.currentState!.validate()){
                                      setState(() {
                                        loading = true;
                                        loginUser();
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                    'Don\'t have an account? '
                                ),
                                GestureDetector(
                                    onTap: (){
                                      _bottomModalAccount();
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: LoginStyle.textButton,
                                    )
                                ),
                              ],
                            ),
                            /*TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => testScreen()));
                                },
                                child: const Text('test')
                            )*/
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
}

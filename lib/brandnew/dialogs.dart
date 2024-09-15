import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setWidget/appbar.dart';

Future<void> successDialog(BuildContext context, String title) async {
  await AwesomeDialog(
    context: context,
    animType: AnimType.topSlide,
    dismissOnBackKeyPress: false,
    dismissOnTouchOutside: false,
    dialogType: DialogType.success,
    autoHide: const Duration(seconds: 2),
    title: title,
  ).show();
}

void logoutDialog(BuildContext context, Function logoutCallback) async {
  await AwesomeDialog(
    context: context,
    animType: AnimType.topSlide,
    dismissOnBackKeyPress: false,
    dismissOnTouchOutside: false,
    dialogType: DialogType.question,
    title: 'Are you sure you want to logout?',
    btnCancelOnPress: (){},
    btnOkOnPress: (){logoutCallback();},
    btnOkText: 'Logout'
  ).show();
}

Future<void> errorDialog(BuildContext context, String title) async {
  await AwesomeDialog(
    context: context,
    animType: AnimType.topSlide,
    dismissOnBackKeyPress: false,
    dismissOnTouchOutside: false,
    dialogType: DialogType.error,
    autoHide: const Duration(seconds: 2),
    title: title,
  ).show();
}

void confirmDialog(BuildContext context, String title, Function callback) async{
  await AwesomeDialog(
    context: context,
    animType: AnimType.topSlide,
    dismissOnBackKeyPress: false,
    dismissOnTouchOutside: false,
    dialogType: DialogType.question,
      btnCancelOnPress: (){},
      btnOkOnPress: (){callback();},
    title: title
  ).show();
}

void inputDialog(BuildContext context, Function callback, TextEditingController _code) async{
  TextEditingController _codeInput = TextEditingController(text: _code.text);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  await AwesomeDialog(
    context: context,
    animType: AnimType.topSlide,
    dialogType: DialogType.noHeader,
    body: Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Enter Shop Code',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        color: Colors.red,
                        width: 5
                    )
                )
            ),
            controller: _codeInput,
            maxLength: 6,
            showCursor: false,
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Field cannot be empty';
              }
            },
          )
        ],
      ),
    ),
    btnCancelOnPress: (){},
    btnOkOnPress: ()async{
      if(_formKey.currentState!.validate()){
        _code.text = _codeInput.text;
        await callback();
      }
    },
  ).show();
}

Future<void> warningDialog(BuildContext context, String title) async {
  await AwesomeDialog(
    context: context,
    animType: AnimType.topSlide,
    dismissOnBackKeyPress: false,
    dismissOnTouchOutside: false,
    dialogType: DialogType.warning,
    autoHide: const Duration(seconds: 2),
    title: title,
  ).show();
}

Future<void> reloginDialog(BuildContext context) async {



  await AwesomeDialog(
    context: context,
    animType: AnimType.topSlide,
    dismissOnBackKeyPress: false,
    dismissOnTouchOutside: false,
    dialogType: DialogType.warning,
    btnOkOnPress: (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NewLoginScreen()), (route) => false);
    },
    title: 'Phone Number Changed',
    desc: 'Please login again!'
  ).show();
}
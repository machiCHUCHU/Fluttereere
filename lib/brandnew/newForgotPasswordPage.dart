import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/services/validation.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/signupStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:pinput/pinput.dart';

class NewForgotPasswordScreen extends StatefulWidget {
  const NewForgotPasswordScreen({super.key});

  @override
  State<NewForgotPasswordScreen> createState() => _NewForgotPasswordScreenState();
}

class _NewForgotPasswordScreenState extends State<NewForgotPasswordScreen> {
  final TextEditingController _contact = TextEditingController();
  bool isExist = false;

  Future<bool> validateNumber()async{
    ApiResponse response = await numberExist(_contact.text);

    if(response.error == null){
      return isExist = response.data as bool;
    }else{
      throw '';
    }
  }

  Future<void> otpDisplay() async{/*widget.contact*/
    await otpVerification(_contact.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
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
            const Text(
                'Contact Number',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            ),
            TextField(
              keyboardType: TextInputType.phone,
              maxLength: 11,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey)
                )
              ),
              controller: _contact,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyle.tertiary,
                fixedSize: Size(MediaQuery.of(context).size.width, 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                )
              ),
                onPressed: ()async{
                await validateNumber();
                  if(_contact.text.isEmpty){
                    warningDialog(context, 'Please fill up the form');
                  }
                  else if(isExist == false){
                    warningTextDialog(context, 'Invalid Contact Number', 'The contact number doesn\'t exist in our record');
                  }else{
                    otpDisplay();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(contact: _contact.text)));
                  }
                },
                child: const Text('Submit',style: TextStyle(color: Colors.white),)
            )
          ],
        ),
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordChangeScreen(contact: widget.contact)));
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
        automaticallyImplyLeading: false,
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

class PasswordChangeScreen extends StatefulWidget {
  final String contact;
  const PasswordChangeScreen({super.key, required this.contact});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  bool validatePassword(String password){
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&_])[A-Za-z\d@$!%*?&_]{8,}$');

    return regex.hasMatch(password);
  }

  Future<void> changePass() async{
    ApiResponse response = await changePassword(widget.contact, _newPass.text);
    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NewLoginScreen()), (route) => false);
    }else{
      errorDialog(context, 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'New Password',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey)
                  )
              ),
              controller: _newPass,
            ),
            const SizedBox(height: 5,),
            const Text(
              'Confirm Password',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey)
                  )
              ),
              controller: _confirmPass,
            ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorStyle.tertiary,
              fixedSize: Size(MediaQuery.of(context).size.width, 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              )
          ),
          onPressed: (){
            if(_newPass.text.isEmpty || _confirmPass.text.isEmpty){
              warningDialog(context, 'Please fill up the form');
            }else if(!validatePassword(_newPass.text)){
              warningTextDialog(context, 'Invalid Password Format',
                  'Your password should contain atleast 8 characters, one uppercase letter, '
                      'one lowercase letter, one number, and one special character');
            }else if(_newPass.text != _confirmPass.text){
              warningTextDialog(context, 'Password not match', 'Password you entered don\'t match. Please try again.');
            }else{
              changePass();
            }
          },
          child: const Text('Submit',style: TextStyle(color: Colors.white),)

        ),
        ]
      ),
    )
    );
  }
}

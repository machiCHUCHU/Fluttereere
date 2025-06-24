
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/ConstWidgets.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/model/CoOwnerInfo.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/registrationStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:group_button/group_button.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCoOwnerScreen extends StatefulWidget {
  const NewCoOwnerScreen({super.key});

  @override
  State<NewCoOwnerScreen> createState() => _NewCoOwnerScreenState();
}

class _NewCoOwnerScreenState extends State<NewCoOwnerScreen> {
  List<dynamic> coOwners = []; bool isLoading = true; bool hasData = false;

  Future<void> coOwnerDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getCoOwners('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        coOwners = response.data as List<dynamic>;
        isLoading = false;
        hasData = coOwners.isNotEmpty;
      });
    }else{
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  @override
  void initState() {
    coOwnerDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Co-Owners'),
      ),
      body: isLoading
          ? loading()
          : hasData
          ? ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: coOwners.length,
          itemBuilder: (context, index){
            Map co = coOwners[index] as Map;
            Color accessColor; Color bgColor;
            if(co['AccessType'] == 'full'){
              accessColor = Colors.green;
              bgColor = Colors.greenAccent.shade100;
            }else{
              accessColor = Colors.yellow.shade700;
              bgColor = Colors.yellowAccent.shade100;
            }

            return InkWell(
              onTap: ()async{
                CoOwnerInfo info = CoOwnerInfo(name: '${co['CoOwnerName']}', address: '${co['CoOwnerAddress']}',
                contact: '${co['CoOwnerContact']}', access: '${co['AccessType']}', id: '${co['CoOwnerID']}');
                final response = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    EditCoOwnerScreen(info: info,)));

                if(response == true){
                  coOwnerDisplay();
                }
              },
              child: Ink(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 1,
                          color: Colors.grey
                      )
                    ]
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ProfilePicture(
                      name: '${co['CoOwnerName']}',
                      radius: 28,
                      fontsize: 22
                  ),
                  title: Text('${co['CoOwnerName']}'),
                  subtitleTextStyle: const TextStyle(fontSize: 12,color: Colors.black),
                  titleTextStyle: const TextStyle(color: ColorStyle.tertiary, fontWeight: FontWeight.bold,fontSize: 18),
                  subtitle: Text('${co['CoOwnerAddress']}'),
                  trailing: Container(
                    width: 80,
                    decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text('${co['AccessType']}',textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: accessColor),),
                  ),
                ),
              ),
            );
          }
      )
          : const Center(child: Text('No Co-Owners Added Yet'),),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorStyle.tertiary,
        tooltip: 'Add Co-Owner',
        onPressed: ()async{
          final response = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCoOwnerScreen()));

          if(response == true){

          }
        },
        child: const Icon(Icons.add, size: 50,color: Colors.white,),
      ),
    );
  }
}

class AddCoOwnerScreen extends StatefulWidget {
  const AddCoOwnerScreen({super.key});

  @override
  State<AddCoOwnerScreen> createState() => _AddCoOwnerScreenState();
}

class _AddCoOwnerScreenState extends State<AddCoOwnerScreen> {
  final TextEditingController _coName = TextEditingController();
  final TextEditingController _coAddress = TextEditingController();
  final TextEditingController _coContact = TextEditingController();
  final TextEditingController _coPassword = TextEditingController();
  String selectedAccess = ''; bool exist = false; bool isHidden =true;

  bool validateNumber(String contactNumber) {
    final regex = RegExp(r'^(09|\+639)\d{9}$');

    return regex.hasMatch(contactNumber);
  }

  bool validatePassword(String password){
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    return regex.hasMatch(password);
  }
  Future<bool> isNumberExists() async{
    ApiResponse response = await numberExist(_coAddress.text);

    if(response.error == null){
      return exist = response.data as bool;
    }else{
      throw ('');
    }
  }

  Future<void> otpDisplay() async{
    await otpVerification(_coContact.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Add Co-Owners'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ColorStyle.tertiary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Co-Owner Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _coName,
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
              child: const Text('Co-Owner Address',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _coAddress,
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
              child: const Text('Co-Owner Contact Number',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _coContact,
              keyboardType: TextInputType.phone,
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
              child: const Text('Password',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _coPassword,
              obscureText: isHidden,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white, suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    isHidden = !isHidden;
                  });
                },
                icon: Icon(isHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  enabledBorder: const OutlineInputBorder(
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
              child: const Text('Access Privilege',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  GroupButton(
                    isRadio: true,
                    options: const GroupButtonOptions(
                      selectedColor: Colors.blue,
                      unselectedColor: Colors.grey,
                      selectedTextStyle: TextStyle(color: Colors.white),
                    ),
                    onSelected: (selected, index, isSelected) {
                      setState(() {
                        selectedAccess = selected;
                      });
                    },
                    buttons: const ["Full Access", "Limited Access"],
                    buttonBuilder: (selected, value, context) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: selected ? ColorStyle.tertiary : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: ColorStyle.tertiary,
                            width: 2
                          )
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Icon(
                              value == 'Full Access' ? Icons.verified : Icons.report,
                              color: selected ? Colors.white : ColorStyle.tertiary,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              value,
                              style: TextStyle(
                                color: selected ? Colors.white : ColorStyle.tertiary,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        selectedAccess,
                      style: TextStyle(
                        color: selectedAccess == 'Full Access' ?
                            Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  selectedAccess == '' ?
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                            'Select Privilege',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                      : Text(
                    selectedAccess == 'Full Access' ?
                    'Giving your co-owner this privilege will grant them full control of your shop\'s details.'
                        ' This includes viewing, updating, and deleting any information provided of your shop as well as manipulating'
                        ' transactions happening within.' :
                    'Giving your co-owner this privilege will only grant them limited access of your shop\'s '
                        'information and transaction. Specifically, they can only view the activity happening.',
                    style: const TextStyle(

                    ),
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),

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
          onPressed: ()async{
            await isNumberExists();
            if(!context.mounted) return;
            if(_coName.text.isEmpty || _coAddress.text.isEmpty || _coContact.text.isEmpty || _coPassword.text.isEmpty || selectedAccess == ''){
              warningDialog(context, 'All fields are required');
            }else if(exist == true){
              warningTextDialog(context, 'Invalid Contact Number',
                  'Contact number already existed. Please input another number.');
            }else if(!validateNumber(_coContact.text)){
              warningTextDialog(context, 'Invalid Contact Number',
                  'Please input a valid contact number.\n'
                      'e.g. 09123456789');
            }else if(!validatePassword(_coPassword.text)){
              warningTextDialog(context, 'Invalid Password Format',
                  'Your password should contain at least 8 characters, one uppercase letter, '
                      'one lowercase letter, one number, and one special character');
            }
            else{
              CoOwnerInfo info = CoOwnerInfo(
                  name: _coName.text, address: _coAddress.text, contact: _coContact.text,
                  access: selectedAccess);
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  NewOTPScreen(info: info, password: _coPassword.text)));
              otpDisplay();
            }
          },
          child: const Text('Add Co-Owner',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}

class NewOTPScreen extends StatefulWidget {
  final CoOwnerInfo info;
  final String password;
  const NewOTPScreen({super.key, required this.info, required this.password});

  @override
  State<NewOTPScreen> createState() => _NewOTPScreenState();
}

class _NewOTPScreenState extends State<NewOTPScreen> {


  Future<void> regForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return loading();
      },
    );
    String access = '';
    if(widget.info.access == 'Full Access'){
      access = 'full';
    }else{
      access == 'limit';
    }

    CoOwnerInfo info = CoOwnerInfo(
        name: widget.info.name, address: widget.info.address, contact: widget.info.contact,
        access: access);

    ApiResponse response = await addCoOwners(info, widget.password, '${prefs.getString('token')}');

    if(!mounted) return;
    if (response.error == null) {
      await successDialog(context, '${response.data}');
      if(!mounted) return;
      Navigator.pop(context);
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } else {
      await errorDialog(context, '${response.error}');
      if(!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> otpDisplay() async{/*widget.contact*/
    await otpVerification(widget.info.contact ?? '');

  }

  Future<void> addCoOwner() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    CoOwnerInfo info = CoOwnerInfo(
        name: widget.info.name, address: widget.info.address, contact: widget.info.contact,
        access: widget.info.access);

    ApiResponse response = await addCoOwners(info, widget.password, '${prefs.getString('token')}');

    if(!mounted) return;
    if(response.error == null){
      await successDialog(context, '${response.data}');
      if(!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
    }else{
    }
  }

  @override
  void initState(){
    super.initState();

  }

  final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
          fontSize: 22,
          color: Colors.black
      ),
      decoration: RegistrationStyle.otpInput
  );

  bool showTimer = true;
  bool? isVerified;
  String otp = '';

  Future<void> inputCodeCheck() async{
    ApiResponse response = await otpCheck(otp);

    if(response.error == null){
      regForm();
    }else{
      if(!mounted) return;
      warningTextDialog(context, 'Invalid OTP', '${response.error}');
    }
  }


  @override
  Widget build(BuildContext context) {
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
                        widget.info.contact ?? '',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                      ),
                    ),
                    Pinput(
                      validator: (value){
                        otp = value!;
                        return null;
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
                                      style: RegistrationStyle.resendButton,
                                    ),
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                        style: RegistrationStyle.signButton(),
                        onPressed: (){
                          inputCodeCheck();
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

class EditCoOwnerScreen extends StatefulWidget {
  final CoOwnerInfo info;
  const EditCoOwnerScreen({super.key, required this.info});

  @override
  State<EditCoOwnerScreen> createState() => _EditCoOwnerScreenState();
}

class _EditCoOwnerScreenState extends State<EditCoOwnerScreen> {
  final TextEditingController _coName = TextEditingController();
  final TextEditingController _coAddress = TextEditingController();
  String selectedAccess = ''; bool exist = false; bool isHidden =true; String selectedAcc = ''; int selIndex = 0;
  String editContact = '';

  bool validatePassword(String password){
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    return regex.hasMatch(password);
  }


  Future<void> editCoDetails() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String access = '';
    if(selectedAccess == 'Full Access'){
      setState(() {
        access = 'full';
      });
    }else{
      setState(() {
        access = 'limit';
      });
    }

    CoOwnerInfo info = CoOwnerInfo(
      id: widget.info.id, name: widget.info.name, address: widget.info.address,
        access: selectedAccess.isEmpty ? widget.info.access : access, contact: editContact);
    ApiResponse response = await editCoOwners(info, widget.info.contact ?? '','${prefs.getString('token')}');

    if(!mounted) return;
    if(response.error == null){
      await successDialog(context, '${response.data}');
      if(!mounted) return;
        Navigator.pop(context,true);
    }else{
      await warningDialog(context, '${response.error}');
    }
  }


  @override
  void initState() {
   _coName.text = widget.info.name ?? '';
   _coAddress.text = widget.info.address ?? '';
   editContact = widget.info.contact ?? '';
   selectedAcc = widget.info.access ?? '';
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    if(widget.info.access == 'full' || selectedAccess == 'Full Access'){

        selIndex = 0;

    }else if(widget.info.access == 'limit' || selectedAccess == 'Limited Access'){

        selIndex = 1;

    }
    GroupButtonController controller = GroupButtonController(
      selectedIndex: selIndex,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Edit Co-Owners Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Co-Owner Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _coName,
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
              child: const Text('Co-Owner Address',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _coAddress,
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
              child: const Text('Co-Owner Contact Number',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10)
                ),
                onPressed: ()async{
                  final response = await Navigator.push(context, MaterialPageRoute(builder: (context)
                  => const NumberChangeScreen()));

                  if(response != null){
                    setState(() {
                      editContact = response;
                    });
                  }
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.info.contact ?? '',style: TextStyle(color: Colors.grey.shade700,fontSize: 16)),
                )
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Access Privilege',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  GroupButton(
                    controller: controller,
                    isRadio: true,
                    options: const GroupButtonOptions(
                      selectedColor: Colors.blue,
                      unselectedColor: Colors.grey,
                      selectedTextStyle: TextStyle(color: Colors.white),
                    ),
                    onSelected: (selected, index, isSelected) {
                      setState(() {
                        selectedAccess = selected;
                        selIndex = index;
                      });

                    },
                    buttons: const ["Full Access", "Limited Access"],
                    buttonBuilder: (selected, value, context) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: selected ? ColorStyle.tertiary : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: ColorStyle.tertiary,
                                width: 2
                            )
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Icon(
                              value == 'Full Access' ? Icons.verified : Icons.report,
                              color: selected ? Colors.white : ColorStyle.tertiary,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              value,
                              style: TextStyle(
                                  color: selected ? Colors.white : ColorStyle.tertiary,
                                  fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      selectedAccess.isEmpty
                          ? selectedAcc == 'full'
                          ? 'Full Access' : 'Limited Access'
                          : selectedAccess,
                      style: TextStyle(
                          color: selectedAccess.isEmpty
                              ? selectedAcc == 'full'
                              ? Colors.green : Colors.orange
                              : selectedAccess == 'Full Access'
                              ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  selectedAccess.isEmpty ?
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      selectedAcc == 'full' ?
                      'Giving your co-owner this privilege will grant them full control of your shop\'s details.'
                          ' This includes viewing, updating, and deleting any information provided of your shop as well as manipulating'
                          ' transactions happening within.' :
                      'Giving your co-owner this privilege will only grant them limited access of your shop\'s '
                          'information and transaction. Specifically, they can only view the activity happening.',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                      : Text(
                    selectedAccess == 'Full Access' ? 'Giving your co-owner this privilege will grant them full control of your shop\'s details.'
                        ' This includes viewing, updating, and deleting any information provided of your shop as well as manipulating'
                        ' transactions happening within.' :
                    'Giving your co-owner this privilege will only grant them limited access of your shop\'s '
                        'information and transaction. Specifically, they can only view the activity happening.',
                    style: const TextStyle(

                    ),
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),

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
              editCoDetails();
          },
          child: const Text('Edit Details',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}

class NumberChangeScreen extends StatefulWidget {
  const NumberChangeScreen({super.key});

  @override
  State<NumberChangeScreen> createState() => _NumberChangeScreenState();
}

class _NumberChangeScreenState extends State<NumberChangeScreen> {
  final TextEditingController _newContact = TextEditingController();
  bool exist = false;
  bool validateNumber(String contactNumber) {
    final regex = RegExp(r'^(09|\+639)\d{9}$');

    return regex.hasMatch(contactNumber);
  }


  Future<bool> isNumberExists() async{
    ApiResponse response = await numberExist(_newContact.text);

    if(response.error == null){
      return exist = response.data as bool;
    }else{
      throw ('');
    }
  }

  Future<void> otpDisplay() async{
    await otpVerification(_newContact.text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Change Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            TextField(
              controller: _newContact,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  )
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyle.tertiary,
                  foregroundColor: Colors.white,
                  fixedSize: Size(MediaQuery.of(context).size.width, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                onPressed: ()async{
                  await isNumberExists();
                  if(!context.mounted) return;
                  if(exist == true){
                    warningTextDialog(context, 'Invalid Contact Number',
                        'Contact number already existed. Please input another number.');
                  }else if(!validateNumber(_newContact.text)){
                    warningTextDialog(context, 'Invalid Contact Number',
                        'Please input a valid contact number.\n'
                            'e.g. 09123456789');
                  }
                  else{
                    final response = await Navigator.push(context, MaterialPageRoute(builder: (context) => ValidateNewContactOTP(contact: _newContact.text)));
                    otpDisplay();
                    if(!context.mounted) return;
                    Navigator.pop(context,response);
                  }
                },
                child: const Text('Edit Contact')
            )
          ],
        ),
      ),
    );
  }
}


class ValidateNewContactOTP extends StatefulWidget {
  final String contact;
  const ValidateNewContactOTP({super.key, required this.contact, });

  @override
  State<ValidateNewContactOTP> createState() => _ValidateNewContactOTPState();
}

class _ValidateNewContactOTPState extends State<ValidateNewContactOTP> {


  Future<void> otpDisplay() async{/*widget.contact*/
    await otpVerification(widget.contact);
  }

  @override
  void initState(){
    super.initState();

  }

  final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
          fontSize: 22,
          color: Colors.black
      ),
      decoration: RegistrationStyle.otpInput
  );

  bool showTimer = true;
  bool? isVerified;
  String otp = '';

  Future<void> inputCodeCheck() async{
    ApiResponse response = await otpCheck(otp);
    if(!mounted) return;

    if(response.error == null){
      Navigator.pop(context, widget.contact);
    }else{
      warningTextDialog(context, 'Invalid OTP', '${response.error}');
    }
  }


  @override
  Widget build(BuildContext context) {
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
                        otp = value!;
                        return null;
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
                                      style: RegistrationStyle.resendButton,
                                    ),
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                        style: RegistrationStyle.signButton(),
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
        )
    );
  }
}
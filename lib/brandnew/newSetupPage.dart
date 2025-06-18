import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newHomePage.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/signupStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';

class NewSetupScreen extends StatefulWidget {
  const NewSetupScreen({super.key});

  @override
  State<NewSetupScreen> createState() => _NewSetupScreenState();
}

class _NewSetupScreenState extends State<NewSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
                  child: Image.asset(
                    'assets/LMateLogo.png',
                    scale: 1,
                  ),
                ),
            const Text(
                'Welcome to Laundry Mate!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
            ),
            const Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Help us set your shop information',
                    style: TextStyle(
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorStyle.tertiary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SetupInformationScreen()));
          },
          child: const Text(
            'Get Started',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}

class SetupInformationScreen extends StatefulWidget {
  const SetupInformationScreen({super.key});

  @override
  State<SetupInformationScreen> createState() => _SetupInformationScreenState();
}

class _SetupInformationScreenState extends State<SetupInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _shopName = TextEditingController();
  final TextEditingController _shopAddress = TextEditingController();
  final TextEditingController _washerQty = TextEditingController();
  final TextEditingController _washerTime = TextEditingController();
  final TextEditingController _dryerQty = TextEditingController();
  final TextEditingController _dryerTime = TextEditingController();
  final TextEditingController _foldingTime = TextEditingController();
  final TextEditingController _maxLoad = TextEditingController();
  Uint8List? _pickedImageBytes;

  final TextEditingController _servicename = TextEditingController();
  String _servicetype = ''; String _serviceoffer = ''; String _loadtype = '';
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  List<String> servicetype = ['Full Service','Self Service'];
  List<String> serviceoffer = ['Full Service','Wash Only','Dry Only','Wash-Dry'];
  List<String> loadtype = ['Light Load','Heavy Load','Comforter'];

  String _shopTime = ''; String? _workDays;

  TimeOfDay selectedTime = TimeOfDay.now();
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
  Future<void> addSetup() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    ApiResponse response = await shopInfoRegister(_shopName.text, _shopAddress.text,
        _maxLoad.text, _washerQty.text, _washerTime.text, _dryerQty.text, _dryerTime.text,
        _servicename.text, _servicetype, _serviceoffer, _weight.text, _price.text, _loadtype, 
        _desc.text, _shopTime, _workDays ?? '', _foldingTime.text, base64Encode(_pickedImageBytes ?? Uint8List(0)), 
        '${prefs.getString('token')}');

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NewHomeScreen()), (route) => false);
    }else{
      errorDialog(context, '${response.error}');
    }
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Shop Information'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        automaticallyImplyLeading: false,
      ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: SizedBox(
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

                                backgroundImage: _pickedImageBytes == null
                                    ? const AssetImage('assets/shop.png')
                                    : MemoryImage(_pickedImageBytes!) as ImageProvider,
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
                      ),),
                      const Text(
                        'Shop\'s Name',
                        style: SignupStyle.formTitle,
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        controller: _shopName,
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
                        'Shop\'s Address',
                        style: SignupStyle.formTitle,
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        controller: _shopAddress,
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
                        'Max Laundry Load Per Day (Laundry Request)',
                        style: SignupStyle.formTitle,
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _maxLoad,
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
                        'Washing Machine Quantity',
                        style: SignupStyle.formTitle,
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _washerQty,
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
                        'Washing Cycle Time (Duration in Minutes)',
                        style: SignupStyle.formTitle,
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _washerTime,
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
                        'Drying Machine Quantity',
                        style: SignupStyle.formTitle,
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _dryerQty,
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
                        'Drying Cycle Time (Duration in Minutes)',
                        style: SignupStyle.formTitle,
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _dryerTime,
                        decoration: SignupStyle.allForm,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      const Text(
                        'Clothes Folding Time (Duration in Minutes)',
                        style: SignupStyle.formTitle,
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _foldingTime,
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
                        'Business Days',
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
                            _workDays = newValue;
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
                        'Business Hours',
                        style: SignupStyle.formTitle,
                      ),
                      const SizedBox(height: 5,),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              fixedSize: Size(MediaQuery.of(context).size.width, 55),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                              ),
                              side: const BorderSide(style: BorderStyle.solid, width: 1),
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

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Laundry Service Name',
                            style: SignupStyle.formTitle,
                          ),
                          const SizedBox(height: 5,),
                          TextField(
                            controller: _servicename,
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Comforter',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Laundry Service Type',
                                    style: SignupStyle.formTitle,
                                  ),
                                  const SizedBox(height: 5,),
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
                                          items: serviceoffer.map((value){
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(value)
                                            );
                                          }).toList(),
                                          onChanged: (newValue){
                                            switch(newValue){
                                              case 'Full Service':
                                                _serviceoffer = 'full';
                                                break;
                                              case 'Wash Only':
                                                _serviceoffer = 'wash';
                                                break;
                                              case 'Dry Only':
                                                _serviceoffer = 'dry';
                                                break;
                                              default:
                                                _serviceoffer = 'wash-dry';
                                                break;
                                            }
                                          }
                                      )
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Service Option',
                                    style: SignupStyle.formTitle,
                                  ),
                                  const SizedBox(height: 5,),
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
                                        items: servicetype.map((value){
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(value)
                                          );
                                        }).toList(),
                                        onChanged: (newValue){
                                          if(newValue == 'Self Service'){
                                            _servicetype = 'self';
                                          }else{
                                            _servicetype = 'full';
                                          }
                                        }
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Max Weight per Load',
                                    style: SignupStyle.formTitle,
                                  ),
                                  const SizedBox(height: 5,),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *.45,
                                    child: TextField(
                                      controller: _weight,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: '1 kg',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Service Price',
                                    style: SignupStyle.formTitle,
                                  ),
                                  const SizedBox(height: 5,),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *.45,
                                    child: TextField(
                                      controller: _price,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: '100',
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
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),

                          const Text(
                            'Laundry Load Type',
                            style: SignupStyle.formTitle,
                          ),
                          const SizedBox(height: 5,),
                          DropdownButtonFormField(
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
                              items: loadtype.map((value){
                                return DropdownMenuItem(
                                    value: value,
                                    child: Text(value)
                                );
                              }).toList(),
                              onChanged: (newValue){
                                switch(newValue){
                                  case 'Light Load':
                                    _loadtype = 'light';
                                    break;
                                  case 'Heavy Load':
                                    _loadtype = 'heavy';
                                    break;
                                  default:
                                    _loadtype = 'comforter';
                                    break;
                                }
                              }
                          ),
                          const SizedBox(height: 10,),

                          const Text(
                            'Description (Accepted clothes for this service)',
                            style: SignupStyle.formTitle,
                          ),
                          const SizedBox(height: 5,),
                          TextField(
                            controller: _desc,
                            maxLines: null,
                            minLines: 1,
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
                        ],
                      ),

                      const Text(
                        'You can add more laundry services later.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: ColorStyle.tertiary
                        ),
                      ),
                      const SizedBox(height: 10,),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              fixedSize: Size(MediaQuery.of(context).size.width, 30)
                          ),
                          onPressed: (){
                            if(_formKey.currentState!.validate()){
                              addSetup();
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
    );
  }
}

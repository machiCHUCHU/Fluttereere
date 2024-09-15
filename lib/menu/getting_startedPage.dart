import 'dart:convert';
import 'dart:ui';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/newHomePage.dart';
import 'package:capstone/drawer/ownerDrawer.dart';
import 'package:capstone/home/homePage.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:day_picker/day_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class StartingSetupScreen extends StatefulWidget {
  const StartingSetupScreen({super.key});

  @override
  State<StartingSetupScreen> createState() => _StartingSetupScreenState();
}

class _StartingSetupScreenState extends State<StartingSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 250,
                width: 250,
                child: Image.asset('assets/pepe.png'),
              ),
            ),
             const SizedBox(height: 10,),
             Text(
              'Welcome to LaundryMate',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                )
              )
            ),
            const SizedBox(height: 100,),

            const Text(
              'Get started by setting up your shop.',
              style: TextStyle(
                fontSize: 30,

              ),
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent
        ),
        onPressed: () {
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
           Future.delayed(const Duration(seconds: 2),(){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ShopSetupScreen()), (route) => false);
          }
          );


        },
        child: Text(
          'Get Started',
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
            )
          ),
        ),
      ),
    );
  }
}


class ShopSetupScreen extends StatefulWidget {
  const ShopSetupScreen({super.key});

  @override
  State<ShopSetupScreen> createState() => _ShopSetupScreenState();
}

class _ShopSetupScreenState extends State<ShopSetupScreen> {
  bool isSetup = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _shopName = TextEditingController();
  final TextEditingController _shopAdd = TextEditingController();
  final TextEditingController _washPcs = TextEditingController();
  final TextEditingController _washDuration = TextEditingController();
  final TextEditingController _dryPcs = TextEditingController();
  final TextEditingController _dryDuration = TextEditingController();
  final TextEditingController _foldDuration = TextEditingController();

  bool _selfserviceOffer = false;
  int? _selfService;
  bool _fullserviceOffer = false;
  int? _fullService;
  final TextEditingController _maxLoad = TextEditingController();
  final TextEditingController _selfDeduct = TextEditingController();
  String? _openHrs;
  String? _openDays;
  final TextEditingController _serviceCost = TextEditingController();
  final TextEditingController _serviceCost2 = TextEditingController();
  final TextEditingController _serviceCost3 = TextEditingController();

  final TextEditingController _lightWeight = TextEditingController();
  final TextEditingController _heaveWeight = TextEditingController();
  final TextEditingController _comforterWeight = TextEditingController();


  int? userid;
  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getInt('userid');
    });
  }

  @override
  void initState(){
    getUser();
    super.initState();
  }

  Future<void> shopinfoReg()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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

    if(_selfserviceOffer == true){
      _selfService = 1;
    }else{
      _selfService = 0;
    }

    if(_fullserviceOffer == true){
      _fullService = 1;
    }else{
      _fullService = 0;
    }
    ApiResponse apiResponse = await shopInfoRegister(
        _shopName.text, _shopAdd.text, _maxLoad.text, _washPcs.text, _washDuration.text,
        _dryPcs.text, _dryDuration.text, _lightWeight.text, _heaveWeight.text, _comforterWeight.text,
        _serviceCost.text, _serviceCost2.text, _serviceCost3.text, _openHrs.toString(), _openDays.toString(), _foldDuration.text,
        base64Encode(Uint8List(0)),
        '${prefs.getString('token')}'
    );

    if(apiResponse.error == null){
      print('success');
      _successSnackbar();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShopCodeScreen(shopcodeid: userid.toString(),)));
    } else {
      print(apiResponse.error);
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

  List<PageViewModel> setupPages(){
    return[
      PageViewModel(
        titleWidget: const SizedBox.shrink(),
          bodyWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Laundry Shop\'s Name',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    TextFormField(
                      controller: _shopName,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3,
                          ),
                        ),
                        hintText: 'Your Shop\'s Name',
                        filled: true,
                        fillColor: const Color(0xFFF6f6f6),
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF4A5667),
                            width: 3
                          ),

                        ),
                      ),
                      textAlign: TextAlign.center,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'This field can\'t be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 35,),

                    const Text(
                      'Laundry Shop\'s Address',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    TextFormField(
                      controller: _shopAdd,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF4A5667),
                            width: 3,
                          ),
                        ),
                        hintText: 'Your Shop\'s Name',
                        filled: true,
                        fillColor: const Color(0xFFF6f6f6),
                        hintStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3
                          ),

                        ),
                      ),
                      textAlign: TextAlign.center,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'This field can\'t be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 35,),

                    const Text(
                      'Maximum laundry loads can cater daily',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _maxLoad,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF4A5667),
                            width: 3,
                          ),
                        ),
                        hintText: 'Maximum Loads',
                        filled: true,
                        fillColor: const Color(0xFFF6f6f6),
                        hintStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3
                          ),

                        ),
                      ),
                      textAlign: TextAlign.center,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'This field can\'t be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 35,),

                    const Text(
                      'Washing Machine Quantity',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _washPcs,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF4A5667),
                            width: 3,
                          ),
                        ),
                        hintText: 'Washing Machine Quantity',
                        filled: true,
                        fillColor: const Color(0xFFF6f6f6),
                        hintStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3
                          ),

                        ),
                      ),
                      textAlign: TextAlign.center,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'This field can\'t be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 35,),

                    const Text(
                      'Duration of Washing Clothes (In Minutes)',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _washDuration,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF4A5667),
                            width: 3,
                          ),
                        ),
                        hintText: 'Washing Duration',
                        filled: true,
                        fillColor: const Color(0xFFF6f6f6),
                        hintStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3
                          ),

                        ),
                      ),
                      textAlign: TextAlign.center,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'This field can\'t be empty';
                        }
                        return null;
                      },
                    ),
                  ],
              )
      ),
      PageViewModel(
        titleWidget: SizedBox.shrink(),
        bodyWidget: Column(
              children: [
                const Text(
                  'Drying Machine Quantity',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
                TextFormField(
                  controller: _dryPcs,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF4A5667),
                        width: 3,
                      ),
                    ),
                    hintText: 'Drying Machine Quantity',
                    filled: true,
                    fillColor: const Color(0xFFF6f6f6),
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Color(0xFF4A5667),
                          width: 3
                      ),

                    ),
                  ),
                  textAlign: TextAlign.center,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'This field can\'t be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 35,),

                const Text(
                  'Duration of Drying Clothes (In Minutes)',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  controller: _dryDuration,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF4A5667),
                        width: 3,
                      ),
                    ),
                    hintText: 'Drying Duration',
                    filled: true,
                    fillColor: const Color(0xFFF6f6f6),
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Color(0xFF4A5667),
                          width: 3
                      ),

                    ),
                  ),
                  textAlign: TextAlign.center,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'This field can\'t be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 35,),

                const Text(
                  'Folding Time (In Minutes)',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  controller: _foldDuration,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF4A5667),
                        width: 3,
                      ),
                    ),
                    hintText: 'Drying Duration',
                    filled: true,
                    fillColor: const Color(0xFFF6f6f6),
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Color(0xFF4A5667),
                          width: 3
                      ),

                    ),
                  ),
                  textAlign: TextAlign.center,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'This field can\'t be empty';
                    }
                    return null;
                  },
                ),

              ],
            )
      ),
      PageViewModel(
        titleWidget: SizedBox.shrink(),
        bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Laundry Services Prices per Load',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _lightWeight,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3,
                            ),
                          ),
                          hintText: 'Light load weight',
                          filled: true,
                          fillColor: const Color(0xFFF6f6f6),
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Color(0xFF4A5667),
                                width: 3
                            ),

                          ),
                        ),
                        textAlign: TextAlign.center,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        controller: _serviceCost,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3,
                            ),
                          ),
                          hintText: 'Cost',
                          filled: true,
                          fillColor: const Color(0xFFF6f6f6),
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Color(0xFF4A5667),
                                width: 3
                            ),

                          ),
                        ),
                        textAlign: TextAlign.center,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _heaveWeight,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3,
                            ),
                          ),
                          hintText: 'Heavy load weight',
                          filled: true,
                          fillColor: const Color(0xFFF6f6f6),
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Color(0xFF4A5667),
                                width: 3
                            ),

                          ),
                        ),
                        textAlign: TextAlign.center,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        controller: _serviceCost2,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3,
                            ),
                          ),
                          hintText: 'Cost',
                          filled: true,
                          fillColor: const Color(0xFFF6f6f6),
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Color(0xFF4A5667),
                                width: 3
                            ),

                          ),
                        ),
                        textAlign: TextAlign.center,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _comforterWeight,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3,
                            ),
                          ),
                          hintText: 'Comforter load weight',
                          filled: true,
                          fillColor: const Color(0xFFF6f6f6),
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Color(0xFF4A5667),
                                width: 3
                            ),

                          ),
                        ),
                        textAlign: TextAlign.center,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        controller: _serviceCost3,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color(0xFF4A5667),
                              width: 3,
                            ),
                          ),
                          hintText: 'Cost',
                          filled: true,
                          fillColor: const Color(0xFFF6f6f6),
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Color(0xFF4A5667),
                                width: 3
                            ),

                          ),
                        ),
                        textAlign: TextAlign.center,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 30,),
                const Text(
                  'Open Hours',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   Container(
                     width: 200,
                     padding: EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       border: Border.all(
                         color: Color(0xFF4A5667),
                         width: 3
                       )
                     ),
                     child: Text(
                         _openHrs ?? 'Select Time',
                       style: const TextStyle(
                         fontWeight: FontWeight.bold
                       ),
                       textAlign: TextAlign.center,
                     ),
                   ),
                   ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFF597FAF),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(5)
                       )
                     ),
                       onPressed: (){
                         TimeRangePicker.show(
                             context: (context),
                             onSubmitted: (TimeRangeValue value) {
                               setState(() {
                                 _openHrs = '${value.startTime?.format(context)} - ${value.endTime?.format(context)}';
                               });
                             }
                         );
                       },
                       child: const Text(
                           'Select time',
                         style: TextStyle(
                           color: Color(0xFFF6F6F6)
                         ),
                       )
                   ),
                 ],
               ),

                const SizedBox(height: 30,),
                const Text(
                  'Shop Open',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 94),
                  child: ListTile(
                    title: const Text(
                        'Weekdays',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                    leading: Radio(
                      value: 'weekdays',
                      groupValue: _openDays,
                      onChanged: (value){
                        setState(() {
                          _openDays = value;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 95),
                  child: ListTile(
                    title: const Text(
                        'Weekend',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    leading: Radio(
                      value: 'weekend',
                      groupValue: _openDays,
                      onChanged: (value){
                        setState(() {
                          _openDays = value;
                        });
                      },
                    ),
                  ),
                )

              ],
            )
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child:  SafeArea(
            child: IntroductionScreen(
              globalBackgroundColor: const Color(0xFFF6f6f6),
              next: const Text(
                'Next',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              nextStyle: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                elevation: 50,
                shadowColor: Colors.black,
              ),
              done: const Text(
                'Done',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              doneStyle: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                elevation: 50,
                shadowColor: Colors.black,
              ),
              back: const Text(
                'Prev',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
              backStyle: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  elevation: 20,
                  side: const BorderSide(
                      width: 2,
                      color: Colors.blueAccent
                  )
              ),
              onDone: (){
                if(_formKey.currentState!.validate()){
                  setState(() {
                    shopinfoReg();
                  });
                }
              },
              pages: setupPages(),
              showBackButton: true,
              dotsDecorator: const DotsDecorator(
                  activeSize:  Size.fromRadius(0),
                  size: Size.fromRadius(0)
              ),
              freeze: true,
            ),
          )

        ),
    );
  }
}

class ShopCodeScreen extends StatefulWidget {
  final String shopcodeid;
  const ShopCodeScreen({super.key, required this.shopcodeid});

  @override
  State<ShopCodeScreen> createState() => _ShopCodeScreenState();
}

class _ShopCodeScreenState extends State<ShopCodeScreen> {
  String? token;
  int? userid;
  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
    });
  }

  String shopcode = '';
  int? newlyshopid;

  Future<void> displayShopCode() async {

    ApiResponse response = await getShopCode(widget.shopcodeid);
    final prefs = await SharedPreferences.getInstance();

    if(response.error == null){
      setState(() {
        shopcode = response.shopcode!;
        newlyshopid = response.total;
      });
      await prefs.setInt('shopid', newlyshopid!);
    } else {
      print('${response.error}');

    }
  }



  void initState(){
    displayShopCode();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white70,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            shopcode,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'This code will serve as a key to let your customer access your shop.',
            style: TextStyle(
              fontSize: 24
            ),
            textAlign: TextAlign.center,
          ),
        ),

      ],
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent
        ),
        onPressed: (){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NewHomeScreen()), (route) => false);
        },
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}

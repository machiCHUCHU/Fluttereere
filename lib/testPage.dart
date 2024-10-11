import 'dart:convert';
import 'dart:typed_data';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/testPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class testScreen extends StatefulWidget {

  const testScreen({super.key});

  @override
  State<testScreen> createState() => _testScreenState();
}

class _testScreenState extends State<testScreen> {
  List<dynamic> walkin = []; List<dynamic> rating = [];
  Map finaLoc = {};

  Future<void> getWalkin() async{
    final response = await http.get(
      Uri.parse('$ipaddress/test/data'),
      headers: {
        'Accept': 'application/json'
      }
    );

    if(response.statusCode == 200){
      setState(() {
        walkin = jsonDecode(response.body)['data'];
      });
    }else{
      print(response.statusCode);
    }
  }

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  String _output = '';

  XFile? imageData;
  Uint8List? imageDataBytes;
  String? base64encoded;
  List<DateTime?> dateValue = [];
  String? dateValueString;
  
  Future<void> imagepick() async{
    imageData = await ImagePicker().pickImage(source: ImageSource.camera);
    
    final dataBytes = await imageData?.readAsBytes();
    setState(() {
      imageDataBytes = dataBytes ?? Uint8List(0);
      base64encoded = base64Encode(imageDataBytes ?? Uint8List(0));
    });
  }

  Future<void> datePicker() async{
    var pickedDate = await showCalendarDatePicker2Dialog(
        context: context,
        config: CalendarDatePicker2WithActionButtonsConfig(),
        dialogSize: Size(400, 400)
    );

    dateValue = pickedDate!;
    dateValueString = DateFormat('yyyy-MM-dd').format(dateValue[0]!);
    DateTime format = DateTime.parse(dateValueString!);
    setState(() {

    });

    if(format.isBefore(DateTime.now().subtract(Duration(days: 1)))){
      warningDialog(context, 'Invalid Date');
    }

  }
  
  Future<void> starRating() async{
    final response = await http.get(
      Uri.parse('$ipaddress/test/data'),
      headers: {
        'Authorization': 'application/json'
      }
    );

    if(response.statusCode == 200){
      setState(() {
        rating = jsonDecode(response.body)['data'];
      });
    }else{
      print('errr');
    }
  }

  @override
  void initState() {
    starRating();
    super.initState();
  }

  SingingCharacter? _character = SingingCharacter.jefferson;

  List<String> gender = ['male','female'];
  String? selected;


  String placeM = '';
  @override
  Widget build(BuildContext context) {
    print(dateValueString);

    return Scaffold(
      appBar: AppBar(
        title: Text('jelo'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              IconButton(
                onPressed: (){
                  imagepick();
                },
                icon: Icon(Icons.camera),
              ),
              imageDataBytes == null ? SizedBox.shrink() : Image.memory(imageDataBytes!),
              TextButton(
                  onPressed: (){
                    datePicker();
                  },
                  child: Text('sfsfs')
              ),
              LinearPercentIndicator(
                percent: .4,
                lineHeight: 10,
                barRadius: Radius.circular(4),
                progressColor: Colors.yellow,
              ),
              DropdownButtonFormField(
                  items: gender.map((String sex){
                    return DropdownMenuItem(
                      value: sex,
                        child: Text(sex)
                    );
                  }).toList(),
                  value: selected,
                  onChanged: (value){
                    selected = value!;
                    print(selected);
                  }
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: rating.length,
                  itemBuilder: (context, index){
                    Map rate = rating[index] as Map;
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: RatingBar(
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star,color: Colors.yellow,),
                          half: Icon(Icons.star_half, color: Colors.yellow,),
                          empty: Icon(Icons.star_border,color: Colors.grey,),
                        ),
                        initialRating: double.tryParse('${rate['Rate']}') ?? 0,
                        ignoreGestures: true,
                        allowHalfRating: false,
                        onRatingUpdate: (value){
                          
                        },
                      ),
                    );
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum SingingCharacter {
  layette,
  jefferson
}
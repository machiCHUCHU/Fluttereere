import 'dart:convert';
import 'dart:typed_data';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/servicesadd.dart';
import 'package:capstone/services/thirdparty.dart';
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
  List<dynamic> address = []; Map add = {};
  List<Placemark> placemarks = [];
  Future<void> getLoc() async{
    ApiResponse response = await getLocation();

    if(response.error == null){
      add = response.data as Map;

    }else{
      print(response.error);
    }
  }

  Future<void> getAdd() async{
    getLoc();


  }
  List<Map<String, dynamic>> records = [
    {
      'name': 'Value 1'
    },
  ];

  Future<void> addName() async{
    ApiResponse response = await testing(records);
    if(response.error == null){
      successDialog(context, 'sige');
    }else{
      errorDialog(context, '${response.error}');
    }
}


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('jelo'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
             Text(add.isEmpty ? 'Address' : '${placemarks[1].locality}, ${placemarks[1].thoroughfare}, ${placemarks[1].subAdministrativeArea}'),
              TextButton(
                  onPressed: ()async{
                    await getLoc();
                    print('${add['latitude']} + ${add['longitude']}');

                      placemarks = await placemarkFromCoordinates(add['latitude'], add['longitude']);

                      setState(() {
                        add;
                      });

                  },
                  child: const Text('Get Location')
              ),
              TextButton(
                  onPressed: (){
                    print(jsonEncode(records));

                   addName();
                  },
                  child: Text('Add record')
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
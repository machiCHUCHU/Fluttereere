import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:map_location_picker/map_location_picker.dart';
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
  List<String> location = [];
  Map finaLoc = {};

  Future<void> getLocation() async{
    final response = await http.get(
      Uri.parse('https://api.bigdatacloud.net/data/reverse-geocode-client')
    );

    if(response.statusCode == 200){
      finaLoc = jsonDecode(response.body);

    }else{

    }
  }

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  String _output = '';

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  String placeM = '';
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
        onPopInvoked: (didPop) {
        if(didPop){
          return;
        }
        Navigator.pop(context);

        },
        child: Scaffold(
            body: MapLocationPicker(
              apiKey: "AIzaSyBShIIsxNI3tRSQvukZThSXBM1-LdVpAqc",
              onNext: (GeocodingResult? result) {

              },
              hideBackButton: true,
              currentLatLng: LatLng(14.5995,120.9842),
            )
        )
    );
  }
}

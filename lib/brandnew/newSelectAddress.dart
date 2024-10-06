import 'package:capstone/api_response.dart';
import 'package:capstone/services/thirdparty.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/material.dart';

class NewSelectAddressScreen extends StatefulWidget {
  const NewSelectAddressScreen({super.key});

  @override
  State<NewSelectAddressScreen> createState() => _NewSelectAddressScreenState();
}

class _NewSelectAddressScreenState extends State<NewSelectAddressScreen> {
  List<dynamic> region =[]; String? selectedRegion; bool nextProvince = false; String? regionCode;
  List<dynamic> province =[]; String? selectedProvince; bool nextCity = false; String? provinceCode;
  List<dynamic> cityMuni =[]; String? selectedCityMuni; bool nextBarangay = false; String? cityMuniCode;

  Future<void> displayRegion() async{
    ApiResponse response = await getRegion();

    if(response.error == null){
      setState(() {
        region = response.data as List<dynamic>;
      });
    }else{
      response.error;
    }
  }

  Future<void> displayProvince() async{
    ApiResponse response = await getProvince('$regionCode');

    if(response.error == null){
      setState(() {
        province = response.data as List<dynamic>;
      });
    }else{
      response.error;
    }
  }

  Future<void> displayCityMunicipality() async{
    ApiResponse response = await getProvince('$selectedRegion');

    if(response.error == null){
      setState(() {
        cityMuni = response.data as List<dynamic>;
      });
    }else{
      response.error;
    }
  }

  @override
  void initState() {
    displayRegion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your address'),
        titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),
        backgroundColor: Colors.grey.shade200,
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                foregroundColor: ColorStyle.tertiary
              ),
              onPressed: (){},
              child: const Text('Reset')
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text('Select'),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              value: regionCode,
              items: region.map<DropdownMenuItem<String>>((dynamic region) {
                return DropdownMenuItem<String>(
                  onTap: () {
                    setState(() {
                      selectedRegion = region['name'];
                      nextProvince = true;
                    });
                    displayProvince();
                  },
                  value: region['code'],
                  child: Text(regionCode == '' ? 'Select Region' : '${region['name']}'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {

                  regionCode = newValue;
                });


              },
            ),


            nextProvince
                ? DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              items: province.map<DropdownMenuItem<String>>((dynamic province) {
                return DropdownMenuItem<String>(
                  onTap: () {},
                  value: province['code'], // The value for this dropdown item
                  child: Text(provinceCode == '' ? 'Select Province' : '${province['name']}'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  nextCity = true; // Display the city dropdown
                  selectedProvince = newValue; // Update the selected province
                });
              },
            )
                : SizedBox(),
          ],
        ),
      )

    );
  }
}

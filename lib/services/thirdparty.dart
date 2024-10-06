import 'dart:convert';
import 'package:capstone/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/model/user.dart';

Future<ApiResponse> getRegion() async{
  ApiResponse apiResponse = ApiResponse();
  
  final response = await http.get(
      Uri.parse('https://psgc.gitlab.io/api/regions/'),
    headers: {
        'Accept': 'application/json'
    }
  );

  if(response.statusCode == 200){
    apiResponse.data = jsonDecode(response.body);
  }else{
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getProvince(String regionCode) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
      Uri.parse('https://psgc.gitlab.io/api/regions/$regionCode/provinces'),
      headers: {
        'Accept': 'application/json'
      }
  );

  if(response.statusCode == 200){
    apiResponse.data = jsonDecode(response.body);
  }else{
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getCityMunicipality(String provinceCode) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
      Uri.parse('https://psgc.gitlab.io/api/provinces/$provinceCode/cities-municipalities'),
      headers: {
        'Accept': 'application/json'
      }
  );

  if(response.statusCode == 200){
    apiResponse.data = jsonDecode(response.body);
  }else{
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}
import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getAuditUser(String page,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/report/user-log'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'page':page
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getAuditInventory(String page,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/report/inventory-log'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'page': page
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

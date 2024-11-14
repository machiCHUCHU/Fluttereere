import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getAuditUser(String page,String token) async{
  ApiResponse apiResponse = ApiResponse();

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

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['audit'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}

Future<ApiResponse> getAuditInventory(String page,String token) async{
  ApiResponse apiResponse = ApiResponse();

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

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['audit'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}

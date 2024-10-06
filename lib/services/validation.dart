import 'dart:convert';
import 'package:capstone/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/model/user.dart';

Future<ApiResponse> numberExist(String contact) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
      Uri.parse('$ipaddress/check/number'),
    headers: {
        'Accept': 'application/json'
    },
    body: {
        'contact': contact
    }
  );

  if(response.statusCode == 200){
    apiResponse.data = jsonDecode(response.body)['message'];
  }else{
    apiResponse.error = jsonDecode(response.body)['message'];
  }

  return apiResponse;
}
import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getUpcomingTask(String date, String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
    Uri.parse('$ipaddress/upcoming-task'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: {
      'date': date
    }
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['data'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}
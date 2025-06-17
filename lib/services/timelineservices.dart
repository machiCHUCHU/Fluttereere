import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getTimelines(String bookid,String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
      Uri.parse('$ipaddress/timeline'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    body: {
        'bookid':bookid
    }
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['timeline'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getTimeSchedule(String shopid,String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
      Uri.parse('$ipaddress/select-time'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'shopid':shopid
      }
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['time'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getTimelineNotif(String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
      Uri.parse('$ipaddress/timeline-notif'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },

  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['timeline'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> confirmationNotif(String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
    Uri.parse('$ipaddress/confirmation-notif'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },

  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['notif'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse>   confirmLaundry(String bookid,String confirm,String notifid,String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
      Uri.parse('$ipaddress/confirm-laundry'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'bookid':bookid,
        'notifid':notifid,
        'confirm':confirm
      }
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['message'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}
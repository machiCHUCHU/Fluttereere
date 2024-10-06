import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:capstone/api_response.dart';
import 'package:capstone/connect/laravel.dart';

Future<ApiResponse> getDonutChart(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/donut'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['services'];
        apiResponse.count = jsonDecode(response.body)['servicemade'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

    }

  } catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getInventoryChart(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/inventory-chart'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['inventory'];
        apiResponse.count = jsonDecode(response.body)['count'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

    }

  } catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getMonthlySalesBarChart(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/sales/monthly'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

    }

  } catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}
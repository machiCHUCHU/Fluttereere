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

Future<ApiResponse> getProfile(String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
      Uri.parse('$ipaddress/settings/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['owner'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getShopInformation(String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
    Uri.parse('$ipaddress/settings/shop-information'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['shop'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getLaundryServices(String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
    Uri.parse('$ipaddress/settings/laundry-services'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  switch(response.statusCode){
    case 200:
        apiResponse.data = jsonDecode(response.body)['service'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getOperation(String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
    Uri.parse('$ipaddress/settings/service-time'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['operation'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> addLaundryServices(String servicename,String weight,String servicetype,String offer,String price,
    String desc, String loadtype,String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
    Uri.parse('$ipaddress/settings/laundry-services/add'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: {
      'servicename':servicename,
      'weight':weight,
      'servicetype':servicetype,
      'offer':offer,
      'price':price,
      'desc':desc,
      'loadtype':loadtype
    }
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['message'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> editLaundryServices(String servicename,String weight,String servicetype,String offer,String price,
    String desc, String loadtype,String token,String serviceid) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.put(
      Uri.parse('$ipaddress/settings/laundry-services/update'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'servicename':servicename,
        'weight':weight,
        'servicetype':servicetype,
        'offer':offer,
        'price':price,
        'desc':desc,
        'loadtype':loadtype,
        'serviceid':serviceid
      }
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['message'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> editShopInfo(String shopname, String shopaddress, String days,
    String hours, String maxload, String status, String image, String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.put(
      Uri.parse('$ipaddress/settings/shop-information/update'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'shopname':shopname,
        'shopaddress':shopaddress,
        'days':days,
        'hours':hours,
        'maxload':maxload,
        'status':status,
        'image':image,
      }
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['message'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}

Future<ApiResponse> getValuedCustomers(String page, String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
      Uri.parse('$ipaddress/valued-customers'),
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
      apiResponse.data = jsonDecode(response.body)['top'];
      apiResponse.data1 = jsonDecode(response.body)['rest'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}

Future<ApiResponse> getCoOwners(String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
      Uri.parse('$ipaddress/settings/co-owners'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['data'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}

Future<ApiResponse> addCoOwners(String coname, String coaddress, String cocontact,
    String password,String access,String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
    Uri.parse('$ipaddress/settings/co-owners/add'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: {
      'coname':coname,
      'coaddress':coaddress,
      'cocontact':cocontact,
      'password':password,
      'access':access
    }
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['message'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}

Future<ApiResponse> editCoOwners(String coname, String coaddress, String cocontact,
   String coid, String oldcontact,String access,String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
      Uri.parse('$ipaddress/settings/co-owners/update'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'coname':coname,
        'coaddress':coaddress,
        'cocontact':cocontact,
        'oldcontact':oldcontact,
        'co_owner_id':coid,
        'access':access
      }
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['message'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}

Future<ApiResponse> shopPerformance(String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
    Uri.parse('$ipaddress/report/shop-rating/performance'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body);
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}

Future<ApiResponse> getNewRatings(String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.get(
    Uri.parse('$ipaddress/report/shop-rating/reviews'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['review'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}

Future<ApiResponse> editServiceTime(String washqty, String washtime, String dryqty,
    String drytime, String foldtime, String machineid,String token) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
      Uri.parse('$ipaddress/settings/service-time/update'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'washqty':washqty,
        'washtime':washtime,
        'dryqty':dryqty,
        'drytime':drytime,
        'foldtime':foldtime,
        'machineid':machineid
      }
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['message'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}

Future<ApiResponse> testing(List<Map<String, dynamic>> records) async{
  ApiResponse apiResponse = ApiResponse();

  final response = await http.post(
    Uri.parse('$ipaddress/record'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
          'records':records
        })
  );

  switch(response.statusCode){
    case 200:
      apiResponse.data = jsonDecode(response.body)['message'];
    case 403:
      apiResponse.error = jsonDecode(response.body);
    case 422:
      apiResponse.error = jsonDecode(response.body)['message'];
    default:
      apiResponse.error = jsonDecode(response.body);
  }

  return apiResponse;
}
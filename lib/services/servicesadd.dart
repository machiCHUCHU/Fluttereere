import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/model/CoOwnerInfo.dart';
import 'package:capstone/model/LaundryServiceInfo.dart';
import 'package:capstone/model/MachineInfo.dart';
import 'package:capstone/model/ShopInfo.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getUpcomingTask(String date, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
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

Future<ApiResponse> getProfile(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/settings/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = 'Something went wrong';
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getShopInformation(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/settings/shop-information'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = 'Something went wrong';
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getLaundryServices(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/settings/laundry-services'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = 'Something went wrong';
    }

  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getOperation(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/settings/service-time'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = 'Something went wrong';
    }

  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> addLaundryServices(LaundryServiceInfo service,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/settings/laundry-services/add'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'servicename':service.name,
          'weight':service.loadWeight,
          'servicetype':service.type,
          'offer':service.offer,
          'price':service.loadPrice,
          'desc':service.description,
          'loadtype':service.loadType
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

Future<ApiResponse> editLaundryServices(LaundryServiceInfo service, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(
        Uri.parse('$ipaddress/settings/laundry-services/update'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'servicename':service.name,
          'weight':service.loadWeight,
          'servicetype':service.type,
          'offer':service.offer,
          'price':service.loadPrice,
          'desc':service.description,
          'loadtype':service.loadType,
          'serviceid':service.id
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

Future<ApiResponse> editShopInfo(ShopInfo info, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(
        Uri.parse('$ipaddress/settings/shop-information/update'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'shopname':info.name,
          'shopaddress':info.address,
          'days':info.workDay,
          'hours':info.workHour,
          'maxload':info.maxLoad,
          'status':info.status,
          'image':info.image,
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

Future<ApiResponse> getValuedCustomers(String page, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['top'];
      apiResponse.data1 = jsonDecode(response.body)['rest'];
    }else{
      apiResponse.error = 'Something went wrong';
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getCoOwners(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/settings/co-owners'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = 'Something went wrong';
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> addCoOwners(CoOwnerInfo info, String password, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/settings/co-owners/add'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'coname':info.name,
          'coaddress':info.address,
          'cocontact':info.contact,
          'password':password,
          'access':info.access
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

Future<ApiResponse> editCoOwners(CoOwnerInfo info, String oldcontact, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/settings/co-owners/update'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'coname':info.name,
          'coaddress':info.address,
          'cocontact':info.contact,
          'oldcontact':oldcontact,
          'co_owner_id':info.id,
          'access':info.access
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

Future<ApiResponse> shopPerformance(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/report/shop-rating/performance'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body);
    }else{
      apiResponse.error = 'Something went wrong';
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getNewRatings(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/report/shop-rating/reviews'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = 'Something went wrong';
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> editServiceTime(MachineInfo info,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/settings/service-time/update'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'washqty':info.washerQty,
          'washtime':info.washerTime,
          'dryqty':info.dryerQty,
          'drytime':info.dryerTime,
          'foldtime':info.foldingTime,
          'machineid':info.id
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
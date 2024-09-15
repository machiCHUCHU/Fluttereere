import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:capstone/api_response.dart';
import 'package:capstone/model/booking.dart';
import 'package:capstone/model/chart.dart';
import 'package:capstone/model/rating.dart';
import 'package:http/http.dart' as http;
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/model/user.dart';

Future<ApiResponse> pictureAdd(String base64Image) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse('$ipaddress/picture'),
      headers: {'Accept': 'application/json'},
      body: {
        'image': base64Image,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['path'];
        break;
      case 422:
      case 403:
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
    }
  } catch (e) {
    apiResponse.error = "$e";
  }

  return apiResponse;
}

Future<ApiResponse> register(String name, String sex, String address,
    String contact, String pass, String image, String usertype) async {

  ApiResponse apiResponse = ApiResponse();

  try{

    final response = await http.post(
        Uri.parse('$ipaddress/registration'),
        headers: {'Accept': 'application/json'},
        body: {
          'name':name,
          'sex':sex,
          'address':address,
          'contact':contact,
          'image':image,
          'password':pass,
          'password_confirmation':pass,
          'usertype':usertype
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['response'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        print(apiResponse.error);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        print(apiResponse.error);
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        print(apiResponse.error);
        break;
    }

  } catch(e){
    apiResponse.error = "$e";
  }

  return apiResponse;

}

Future<ApiResponse> login(String contact, String password) async {

  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
        Uri.parse('$ipaddress/login'),
        headers: {'Accept':'application/json'},
        body: {
          'contact':contact,
          'password':password,
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        print(apiResponse.error);
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        print(apiResponse.error);
        break;
    }

  } catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> logout(String token) async{
  ApiResponse apiResponse = ApiResponse();
  
  try{
    final response = await http.post(
      Uri.parse('$ipaddress/logout'),
      headers: {
        'Authorization': 'Bearer $token'
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        print(apiResponse.error);
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        print(apiResponse.error);
        break;
    }

  } catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;

}

Future<ApiResponse> shopInfoRegister(
    String shopName, String shopAdd, String maxLoad, String washerQty, String washerTime,String dryerQty,
    String dryerTime, String lightWeight, String heavyWeight, String comfWeight, String lightCost,
    String heavyCost, String comfCost, String workHour, String workDay, String foldTime, String shopimage, String token
    ) async {

  ApiResponse apiResponse = ApiResponse();

  try{

    final response = await http.post(
        Uri.parse('$ipaddress/shop-setup'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'ShopName':shopName,
          'ShopImage': shopimage,
          'ShopAddress':shopAdd,
          'MaxLoad':maxLoad,
          'WasherQty':washerQty,
          'WasherTime':washerTime,
          'DryerQty':dryerQty,
          'DryerTime':dryerTime,
          'WorkHour':workHour,
          'WorkDay':workDay,
          'FoldingTime':foldTime,
          'LightWeight':lightWeight,
          'LightPrice':lightCost,
          'HeavyWeight':heavyWeight,
          'HeavyPrice': heavyCost,
          'ComfWeight': comfWeight,
          'ComfPrice':comfCost
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['response'];
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
    apiResponse.error = "$e";
  }

  return apiResponse;

}

Future<ApiResponse> getShopCode(String id) async {

  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/shop-code/$id'),
        headers: {
          'Accept': 'application/json',
        },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.shopcode = jsonDecode(response.body)['shopcode'];
        apiResponse.total = jsonDecode(response.body)['newshopid'];
        print('success');
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


Future<ApiResponse> addInventory(String itemname, String itemqty, String itemvol, String voluse, String token) async {

  ApiResponse apiResponse = ApiResponse();

  try{

    final response = await http.post(
        Uri.parse('$ipaddress/shop-inventory/add'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'ItemName':itemname,
          'ItemQty':itemqty,
          'itemVolume':itemvol,
          'volumeuse':voluse
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['response'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        print(apiResponse.error);
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
    }

  } catch(e){
    apiResponse.error = "$e";
  }

  return apiResponse;

}

//checking
Future<ApiResponse> getAddedShop(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/shop-added-customer'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['addedshop'];
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

Future<ApiResponse> updateAddedShop(String token,String id, String status) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/shop-added-customer/update/$id'),
      headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
      },
      body: {
      'stat':status
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];

        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        print(response.body);
        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getInventory(String token) async {
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/shop-inventory'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['inventory'];
        apiResponse.total = jsonDecode(response.body)['total'];
        apiResponse.out = jsonDecode(response.body)['out'];
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

Future<ApiResponse> deleteInventory(String id, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(Uri.parse('$ipaddress/shop-inventory/delete/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['response'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = "Something went wrong.";
        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

                            /*String number v*/
Future<ApiResponse> otpVerification(String number) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.post( /* $number*/
        Uri.parse('$ipaddress/verification/$number'),
        headers: {
          'Accept': 'application/json',
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['code'];
        print('success');
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

Future<ApiResponse> updateInventory(String id, String itemname, String itemqty, String itemvol, String voluse) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/shop-inventory/update/$id'),
      headers: {
        'Accept': 'application/json'
      },
      body: {
        'ItemName':itemname,
        'ItemQty':itemqty,
        'itemVolume':itemvol,
        'volumeuse': voluse
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['response'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getPendingBooking(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/bookings/pending'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['pending'];

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

Future<ApiResponse> getPendingBookingCount(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/bookings/pending'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.total = jsonDecode(response.body)['pending_count'];
        print(apiResponse.data);
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

Future<ApiResponse> pendingBookingStatus(String id, String stat, String detergentid, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/bookings/pending/update/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'stat':stat,
          'detergentId': detergentid
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.status = jsonDecode(response.body)['status'];
        apiResponse.message = jsonDecode(response.body)['message'];
        apiResponse.data = jsonDecode(response.body)['response'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;

        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getProcessBooking(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/bookings/process'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['process'];
        print(apiResponse.data);
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

Future<ApiResponse> getProcessBookingCount(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/bookings/process'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.total = jsonDecode(response.body)['process_count'];
        print(apiResponse.data);
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

Future<ApiResponse> processBookingStatus(String id, String stat, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/bookings/process/update/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'stat':stat,
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.status = jsonDecode(response.body)['status'];
        apiResponse.message = jsonDecode(response.body)['message'];
        apiResponse.data = jsonDecode(response.body)['response'];
        apiResponse.notif = jsonDecode(response.body)['notif'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getFinishedBooking(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/bookings/finished'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['finish'];
        print(apiResponse.data);
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

Future<ApiResponse> getFinishedBookingCount(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/bookings/finished'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.total = jsonDecode(response.body)['finish_count'];
        print(apiResponse.data);
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

Future<ApiResponse> matchShop(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(Uri.parse('$ipaddress/shop-match'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['response'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getShopProfile(String id) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/profile/$id'),
        headers: {
          'Accept': 'application/json',
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['shop'];
        print(apiResponse.data);
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

Future<ApiResponse> getUserProfile(String id) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/profile/$id'),
        headers: {
          'Accept': 'application/json',
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['user'];
        print(apiResponse.data);
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

Future<ApiResponse> updateUserProfile(String id, String name, String add, String contact, String base64image) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/profile/$id/update'),
        headers: {
          'Accept': 'application/json'
        },
        body: {
          'name':name,
          'address':add,
          'contact':contact,
          'image': base64image
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['response'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getRating(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/rating'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['ratings'];
        apiResponse.totalstar = jsonDecode(response.body)['star_counts'];
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

Future<ApiResponse> getRatingCount(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/rating'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
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

Future<ApiResponse> getWeeklyBookingChart(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/booking/weekly'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.mon = jsonDecode(response.body)['monday'];
        apiResponse.tue = jsonDecode(response.body)['tuesday'];
        apiResponse.wed = jsonDecode(response.body)['wednesday'];
        apiResponse.thu = jsonDecode(response.body)['thursday'];
        apiResponse.fri = jsonDecode(response.body)['friday'];
        apiResponse.sat = jsonDecode(response.body)['saturday'];
        apiResponse.sun = jsonDecode(response.body)['sunday'];
        apiResponse.mostday = jsonDecode(response.body)['mostday']['daycount'] ?? 0;
        apiResponse.status = jsonDecode(response.body)['mostday']['dayname'];
        apiResponse.totalbooks = jsonDecode(response.body)['total'][0]['totalbooks'];
        apiResponse.weeklyload = jsonDecode(response.body)['total'][0]['customerload'];
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

Future<ApiResponse> getMonthBookingChart(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/booking/monthly'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.jan = jsonDecode(response.body)['jan'];
        apiResponse.feb = jsonDecode(response.body)['feb'];
        apiResponse.mar = jsonDecode(response.body)['mar'];
        apiResponse.apr = jsonDecode(response.body)['apr'];
        apiResponse.may = jsonDecode(response.body)['may'];
        apiResponse.jun = jsonDecode(response.body)['jun'];
        apiResponse.jul = jsonDecode(response.body)['jul'];
        apiResponse.aug = jsonDecode(response.body)['aug'];
        apiResponse.sep = jsonDecode(response.body)['sep'];
        apiResponse.oct = jsonDecode(response.body)['oct'];
        apiResponse.nov = jsonDecode(response.body)['nov'];
        apiResponse.dec = jsonDecode(response.body)['dec'];
        apiResponse.mostmonth = jsonDecode(response.body)['monthly']['monthcount'];
        apiResponse.status = jsonDecode(response.body)['monthly']['monthname'];
        apiResponse.totalbooks = jsonDecode(response.body)['total'][0]['totalbooks'];
        apiResponse.monthlyload = jsonDecode(response.body)['total'][0]['customerload'];
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

Future<ApiResponse> getWeeklySalesChart(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/sales/weekly'),
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

Future<ApiResponse> getMonthlySalesChart(String token) async{
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
        apiResponse.jan = jsonDecode(response.body)['jan'];
        apiResponse.feb = jsonDecode(response.body)['feb'];
        apiResponse.mar = jsonDecode(response.body)['mar'];
        apiResponse.apr = jsonDecode(response.body)['apr'];
        apiResponse.may = jsonDecode(response.body)['may'];
        apiResponse.jun = jsonDecode(response.body)['jun'];
        apiResponse.jul = jsonDecode(response.body)['jul'];
        apiResponse.aug = jsonDecode(response.body)['aug'];
        apiResponse.sep = jsonDecode(response.body)['sep'];
        apiResponse.oct = jsonDecode(response.body)['oct'];
        apiResponse.nov = jsonDecode(response.body)['nov'];
        apiResponse.dec = jsonDecode(response.body)['dec'];
        apiResponse.low = jsonDecode(response.body)['min'];
        apiResponse.high = jsonDecode(response.body)['high'];
        apiResponse.total = jsonDecode(response.body)['total'];
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

Future<ApiResponse> getHome(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/home'),
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

Future<ApiResponse> getAppbar(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/appbar'),
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

Future<ApiResponse> getBookings(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/bookings'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['bookings'];
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

Future<ApiResponse> getInfos(String token) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.get(
        Uri.parse('$ipaddress/settings'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['info'];
        apiResponse.data1 = jsonDecode(response.body)['service'];
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
  } catch (e) {
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> updateOwnerProfile(String id, String name, String sex, String address, String contact, String image, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/settings/profile/update/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'name':name,
          'sex':sex,
          'address':address,
          'contact': contact,
          'image': image
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['response'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> addWalkin(String contact, String load, String service, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{

    final response = await http.post(
        Uri.parse('$ipaddress/book/walkin'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'contact': contact,
          'load':load,
          'service': service,
        }
    );

    switch(response.statusCode){
      case 201:
        apiResponse.data = jsonDecode(response.body)['message'];
        print(apiResponse.data);
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        print(apiResponse.error);
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
    }

  } catch(e){
    apiResponse.error = "$e";
  }

  return apiResponse;
}

Future<ApiResponse> getWalkin(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.get(
        Uri.parse('$ipaddress/book/walkin/display'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['walkin'];
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

Future<ApiResponse> getReport(String startDate, String endDate, String status, String type, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.post(
        Uri.parse('$ipaddress/reports'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'start': startDate,
          'end': endDate,
          'stat': status,
          'type': type
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['data'];
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

Future<ApiResponse> getCustomers(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/customers'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> addBookings(String load, String sched, String customerId, String serviceId,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{

    final response = await http.post(
        Uri.parse('$ipaddress/book/registered'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'load': load,
          'sched': sched,
          'customerId': customerId,
          'serviceId': serviceId
        }
    );

    switch(response.statusCode){
      case 201:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        print(apiResponse.error);
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
    }

  } catch(e){
    apiResponse.error = "$e";
  }

  return apiResponse;
}

Future<ApiResponse> updateWalkin(String stat, String token, String id) async{
  ApiResponse apiResponse = ApiResponse();
  
  try{
    final response = await http.put(
      Uri.parse('$ipaddress/book/walkin/update/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'stat': stat
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        print(apiResponse.error);
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> updateBooking(String stat, String token, String id) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(
        Uri.parse('$ipaddress/bookings/update/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'stat': stat
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        print(apiResponse.error);
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getWashing(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
        Uri.parse('$ipaddress/wash/display'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['bookings'];
        apiResponse.data1 = jsonDecode(response.body)['walkin'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getDrying(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
        Uri.parse('$ipaddress/dry/display'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['bookings'];
        apiResponse.data1 = jsonDecode(response.body)['walkin'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getFolding(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
        Uri.parse('$ipaddress/fold/display'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['bookings'];
        apiResponse.data1 = jsonDecode(response.body)['walkin'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getPickup(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
        Uri.parse('$ipaddress/pickup/display'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['bookings'];
        apiResponse.data1 = jsonDecode(response.body)['walkin'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getComplete(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
        Uri.parse('$ipaddress/complete/display'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['bookings'];
        apiResponse.data1 = jsonDecode(response.body)['walkin'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> updatePayment(String type, String id, String token) async{
  ApiResponse apiResponse = ApiResponse();
  
  try{
    final response = await http.put(
      Uri.parse('$ipaddress/payment/update/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'type': type
      }
    );

    switch(response.statusCode){
      case 201:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> updateComplete(String type, String id, String paid, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(
        Uri.parse('$ipaddress/complete/update/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'type': type,
          'paid': paid
        }
    );

    switch(response.statusCode){
      case 201:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}


/*------------------------------------------------------------------------------------------*/
Future<ApiResponse> getRequestShops(String token) async{
  ApiResponse apiResponse = ApiResponse();
  
  try{
    final response = await http.get(
      Uri.parse('$ipaddress/shop-request/display'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['shop_request'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> addRequestShops(String code, String token) async {

  ApiResponse apiResponse = ApiResponse();

  try{

    final response = await http.post(
        Uri.parse('$ipaddress/shop-request'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'code': code
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        print(apiResponse.error);
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
    }

  } catch(e){
    apiResponse.error = "$e";
  }

  return apiResponse;

}

Future<ApiResponse> getRequestShopInfo(String shopId, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/shop/display'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      body: {
          'shopid': shopId
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['shop'];
        apiResponse.data1 = jsonDecode(response.body)['service'];
        apiResponse.data2 = jsonDecode(response.body)['ratings'];
        apiResponse.total = jsonDecode(response.body)['rateSum'];
        apiResponse.count = jsonDecode(response.body)['rateCount'];
        apiResponse.message = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getLaundry(String nav,String token) async{
  ApiResponse apiResponse = ApiResponse();
  bool isNav = true;
  try{
    final response = await http.post(
        Uri.parse('$ipaddress/laundry/status/display'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'nav': nav
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['bookings'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> getSummary(String bookId, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
        Uri.parse('$ipaddress/laundry/summary/$bookId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['summary'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> cancelService(String bookId,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
      Uri.parse('$ipaddress/laundry/cancellation/$bookId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> completeService(String bookId,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
      Uri.parse('$ipaddress/laundry/completion/$bookId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> submitReview(String rate,String comment, String bookid, String shopid, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
      Uri.parse('$ipaddress/laundry/review/submit'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'rate': rate,
        'comment': comment,
        'bookid': bookid,
        'shopid': shopid
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> viewReview(String bookid, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/laundry/review'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'bookid': bookid,
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['review'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> selectService(String shopId, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
        Uri.parse('$ipaddress/laundry-service/$shopId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },

    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['service'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> availService(String load, String cost, String sched, String shopid, String serviceid, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
      Uri.parse('$ipaddress/laundry-service/avail'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'load': load,
        'cost': cost,
        'sched': sched,
        'shopid': shopid,
        'serviceid': serviceid
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> customerNotif(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
        Uri.parse('$ipaddress/laundry/notifications'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['notif'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> customerNotifRead(String notifid,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
      Uri.parse('$ipaddress/laundry/notifications/read/$notifid'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> customerProfile(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/customer/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['customer'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> rememberToken(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/remember'),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> updateShop(
    String lightid, String heavyid, String comforterid, String lightload, String lightprice,
    String heavyload, String heavyprice, String comforterload, String comforterprice,
    String shopname, String shopadd, String workday, String workhour,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(
      Uri.parse('$ipaddress/shop/update'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'lightid': lightid,
        'heavyid': heavyid,
        'comforterid': comforterid,
        'lightload': lightload,
        'heavyload': heavyload,
        'comforterload': comforterload,
        'lightprice': lightprice,
        'heavyprice': heavyprice,
        'comforterprice': comforterprice,
        'shopname': shopname,
        'shopadd': shopadd,
        'workday': workday,
        'workhour': workhour
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> unfollowShop(String addshopid,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(
      Uri.parse('$ipaddress/shop-request/update/$addshopid'),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> updateCustomerProfile(
    String id, String name, String sex, String address,
    String contact, String image, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/customer/profile/update/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'name':name,
          'sex':sex,
          'address':address,
          'contact': contact,
          'image': image
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
    }
  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}
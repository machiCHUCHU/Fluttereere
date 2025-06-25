import 'dart:convert';
import 'package:capstone/api_response.dart';
import 'package:capstone/model/BookingInfo.dart';
import 'package:capstone/model/CoOwnerInfo.dart';
import 'package:capstone/model/CustomerInfo.dart';
import 'package:capstone/model/Inventory.dart';
import 'package:capstone/model/LaundryServiceInfo.dart';
import 'package:capstone/model/MachineInfo.dart';
import 'package:capstone/model/OwnerInfo.dart';
import 'package:capstone/model/ShopInfo.dart';
import 'package:capstone/model/WalkinInfo.dart';
import 'package:http/http.dart' as http;
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/model/user.dart';
String? session;

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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = "Something went wrong";
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

    if(response.statusCode == 200){
      apiResponse.data = User.fromJson(jsonDecode(response.body));
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;

}

Future<ApiResponse> changePassword(String contact, String password) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/change-password'),
        headers: {
          'Accept': 'application/json'
        },
      body: {
          'contact':contact,
          'password': password
      }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;

}

Future<ApiResponse> otpVerification(String contact) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.post(
        Uri.parse('$ipaddress/verification'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'contact': contact
        }
    );

    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      session = rawCookie.split(';')[0];
    }

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> otpCheck(String otpinput) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.post(
        Uri.parse('$ipaddress/verification/otp'),
        headers: {
          'Accept': 'application/json',
          'Cookie': session ?? ''
        },
        body: {
          'otpinput': otpinput
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['message'];
    }else{
      apiResponse.error = 'Something went wrong';
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

//owner http services

Future<ApiResponse> shopInfoRegister(ShopInfo shopInfo, LaundryServiceInfo service, MachineInfo machine, String token) async {

  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/shop-setup'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'ShopName':shopInfo.name,
          'ShopImage': shopInfo.image,
          'ShopAddress':shopInfo.address,
          'MaxLoad':shopInfo.maxLoad,
          'WasherQty':machine.washerQty,
          'WasherTime':machine.washerTime,
          'DryerQty':machine.dryerQty,
          'DryerTime':machine.dryerTime,
          'WorkHour':shopInfo.workHour,
          'WorkDay':shopInfo.workDay,
          'FoldingTime':machine.foldingTime,
          'servicename':service.name,
          'servicetype':service.type,
          'serviceoffer':service.offer,
          'loadweight':service.loadWeight,
          'loadprice':service.loadPrice,
          'loadtype':service.loadType,
          'description':service.description
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = "Something went wrong";
  }

  return apiResponse;
}

Future<ApiResponse> addInventory(Inventory inventory, String token) async {

  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
        Uri.parse('$ipaddress/shop-inventory/add'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'ItemName':inventory.itemName,
          'ItemQty':inventory.itemQty,
          'itemVolume':inventory.itemVolume,
          'volumeuse':inventory.volummeUse,
          'category': inventory.category,
          'isuse': inventory.isUse
        }
    );



    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = "Something went wrong";
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

Future<ApiResponse> updateInventory(Inventory inv, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/shop-inventory/update/${inv.id}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'ItemName':inv.itemName,
        'ItemQty':inv.itemQty,
        'itemVolume':inv.itemVolume,
        'volumeuse': inv.volummeUse,
        'category': inv.category,
        'isuse': inv.isUse
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

Future<ApiResponse> matchShop(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(Uri.parse('$ipaddress/shop-match'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
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

Future<ApiResponse> getRating(String index,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.post(
        Uri.parse('$ipaddress/rating'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      body: {
          'index':index
      }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body);
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

    if(response.statusCode == 200){
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
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch (e) {
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> updateOwnerProfile(OwnerInfo info, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/settings/profile/update/${info.id}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'name':info.name,
          'sex':info.sex,
          'address':info.address,
          'contact': info.contact,
          'image': info.image
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

Future<ApiResponse> addWalkin(WalkinInfo info, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{

    final response = await http.post(
        Uri.parse('$ipaddress/book/walkin'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'contact': info.contact,
          'load':info.walkinLoad,
          'total':info.total,
          'service': info.serviceId,
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = "Something went wrong";
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> getReport(String page, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try {

    final response = await http.post(
        Uri.parse('$ipaddress/reports'),
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

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

Future<ApiResponse> addBookings(BookingInfo info, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{

    final response = await http.post(
        Uri.parse('$ipaddress/book/registered'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'load': info.customerLoad,
          'sched': info.schedule,
          'customerId': info.customerId,
          'serviceId': info.serviceId,
          'loadcost': info.loadCost
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = "Something went wrong";
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

Future<ApiResponse> updateBooking(String stat, String token, String id, String finalweight, String finalcost) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(
        Uri.parse('$ipaddress/bookings/update/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'stat': stat,
          'finalweight': finalweight,
          'finalcost': finalcost
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

//customer http services
Future<ApiResponse> getLaundry(String nav,String token) async{
  ApiResponse apiResponse = ApiResponse();
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['service'];
    }else{
      apiResponse.data = 'Something went wrong';
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

Future<ApiResponse> availService(List<Map<String,dynamic>> records,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.post(
      Uri.parse('$ipaddress/laundry-service/avail'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'records':records
      })
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

Future<ApiResponse> updateCustomerProfile(CustomerInfo info, String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/customer/profile/update/${info.id}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'name':info.name,
          'sex':info.sex,
          'address':info.address,
          'contact': info.contact,
          'image': info.image
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

Future<ApiResponse> accessType(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/access-type'),
      headers: {
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['shop'];
      apiResponse.data1 = jsonDecode(response.body)['service'];
      apiResponse.data2 = jsonDecode(response.body)['ratings'];
      apiResponse.total = jsonDecode(response.body)['rateSum'];
      apiResponse.count = jsonDecode(response.body)['rateCount'];
    }else{
      apiResponse.error = 'Something went wrong';
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

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
      apiResponse.data = jsonDecode(response.body)['response'];
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
      apiResponse.data = jsonDecode(response.body)['response'];
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

Future<ApiResponse> getTimelines(String bookid,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
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

Future<ApiResponse> getTimelineNotif(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/timeline-notif'),
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

Future<ApiResponse> confirmationNotif(String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.get(
      Uri.parse('$ipaddress/confirmation-notif'),
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

Future<ApiResponse>confirmLaundry(String bookid,String confirm,String notifid,String token) async{
  ApiResponse apiResponse = ApiResponse();

  try{
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

Future<ApiResponse> numberExist(String contact) async{
  ApiResponse apiResponse = ApiResponse();

  try{
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
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = 'Something went wrong';
    }
  }catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}

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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['services'];
      apiResponse.count = jsonDecode(response.body)['servicemade'];
    }else{
      apiResponse.error = 'Something went wrong';
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['inventory'];
      apiResponse.count = jsonDecode(response.body)['count'];
    }else{
      apiResponse.error = 'Something went wrong';
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body);
    }else{
      apiResponse.error = 'Something went wrong';
    }

  } catch(e){
    apiResponse.error = 'Something went wrong';
  }

  return apiResponse;
}
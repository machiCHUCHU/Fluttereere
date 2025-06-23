import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:http/http.dart' as http;

//Dart services for requesting api

Future<ApiResponse> addInventory(String itemname, String itemqty, String itemvol, String voluse,
    String category, String isuse, String token) async {
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
          'volumeuse':voluse,
          'category': category,
          'isuse': isuse
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = "$e";
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
      apiResponse.total = jsonDecode(response.body)['total'];
      apiResponse.out = jsonDecode(response.body)['out'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> updateInventory(String id, String itemname, String itemqty,
    String itemvol, String voluse, String token, String category, String isuse) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    final response = await http.put(Uri.parse('$ipaddress/shop-inventory/update/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'ItemName':itemname,
          'ItemQty':itemqty,
          'itemVolume':itemvol,
          'volumeuse': voluse,
          'category': category,
          'isuse': isuse
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  }catch(e){
    apiResponse.error = '$e';
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
      apiResponse.data = jsonDecode(response.body)['ratings'];
      apiResponse.totalstar = jsonDecode(response.body)['star_counts'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body);
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body);
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> addWalkin(String contact, String load, String service, String total, String token) async{
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
          'total':total,
          'service': service,
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  } catch(e){
    apiResponse.error = '$e';
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
    apiResponse.error = '$e';
  }

  return apiResponse;
}

Future<ApiResponse> addBookings(String load, String sched, String customerId, String serviceId, String loadcost,String token) async{
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
          'serviceId': serviceId,
          'loadcost': loadcost
        }
    );

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }
  }catch(e){
    apiResponse.error = '$e';
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
      apiResponse.data = jsonDecode(response.body)['message'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['bookings'];
      apiResponse.data1 = jsonDecode(response.body)['walkin'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['bookings'];
      apiResponse.data1 = jsonDecode(response.body)['walkin'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['bookings'];
      apiResponse.data1 = jsonDecode(response.body)['walkin'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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
    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['bookings'];
      apiResponse.data1 = jsonDecode(response.body)['walkin'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['bookings'];
      apiResponse.data1 = jsonDecode(response.body)['walkin'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['message'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}

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
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  }catch(e){
    apiResponse.error = '$e';
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

    if(response.statusCode == 200){
      apiResponse.data = jsonDecode(response.body)['response'];
    }else{
      apiResponse.error = jsonDecode(response.body)['message'];
    }

  }catch(e){
    apiResponse.error = '$e';
  }

  return apiResponse;
}
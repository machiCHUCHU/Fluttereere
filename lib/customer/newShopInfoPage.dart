import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/customer/NewServiceBookingPage.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewShopInfoScreen extends StatefulWidget {
  final String shopId;
  const NewShopInfoScreen({super.key, required this.shopId});

  @override
  State<NewShopInfoScreen> createState() => _NewShopInfoScreenState();
}

class _NewShopInfoScreenState extends State<NewShopInfoScreen> {
  List<dynamic> shopInfo = [];
  List<dynamic> services = [];
  List<dynamic> ratings = [];
  int overallRate = 0;
  int count = 0;
  Map info = {};
  bool isLoading = true;
  bool hasRating = false;
  Color? status;
  Color? btnColor;
  String message = '';
  Future<void> displayShopInfo() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getRequestShopInfo(widget.shopId, '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        shopInfo = response.data as List<dynamic>;
        info = shopInfo[0] as Map;
        services = response.data1 as List<dynamic>;
        ratings = response.data2 as List<dynamic>;
        overallRate = response.total ?? 0;
        count = response.count ?? 0;
        message = response.message!;
        isLoading = false;
        hasRating = ratings.isNotEmpty;
      });
    }else{
      print(response.error);
    }
  }

  Future<void> statusRequest() async{
    await warningDialog(context, message);
  }

  @override
  void initState(){
    super.initState();
    displayShopInfo();
  }
  @override
  Widget build(BuildContext context) {
    switch(info['ShopStatus']){
      case 'open':
        status = Colors.green;
        break;
      case 'full':
        status = Colors.orange;
        break;
      default:
        status = Colors.red;
        break;
    }

    switch(info['IsValued']){
      case '0':
        btnColor = Colors.orange;
        break;
      case '1':
        btnColor = ColorStyle.tertiary;
        break;
      default:
        btnColor = Colors.red;
        break;
    }

    if(isLoading){
      return Scaffold(
          appBar: AppBar(
            title: Text('...'),
          ),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${info['ShopName']}'),
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorStyle.tertiary,
                      radius: 52,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundColor: ColorStyle.tertiary,
                        backgroundImage: NetworkImage('$picaddress/${info['ShopImage']}'),
                        radius: 48,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: ColorStyle.tertiary,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                          ),
                          child: Text('Shop\'s Information',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                      ),
                      Container(
                          padding: const EdgeInsets.all(8),
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                  color: Colors.grey
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RowItem(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.key,color: ColorStyle.tertiary,),
                                      Text(' Shop Code')
                                    ],
                                  ),
                                  description: Text('${info['ShopCode']}',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.end,)
                              ),
                              RowItem(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.circle, color: ColorStyle.tertiary,),
                                      Text(' Status')
                                    ],
                                  ),
                                  description: Text('${info['ShopStatus']}',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.end,)
                              ),
                              RowItem(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.location_on,color: ColorStyle.tertiary,),
                                      Text(' Address')
                                    ],
                                  ),
                                  description: Text('${info['ShopAddress']}',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.end,)
                              ),
                              RowItem(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.production_quantity_limits, color: ColorStyle.tertiary,),
                                      Text(' Max Load')
                                    ],
                                  ),
                                  description: Text('${info['MaxLoad']}',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.end,)
                              )
                            ],
                          )
                      ),
                      SizedBox(height: 10,),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: ColorStyle.tertiary,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                          ),
                          child: Text('Laundry Services Offered',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                      ),
                      Container(
                          padding: const EdgeInsets.all(8),
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                    color: Colors.grey
                                )
                              ]
                          ),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: services.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                Map serve = services[index] as Map;
                                List icon = [
                                  'assets/sport-wear.png',
                                  'assets/jacket.png',
                                  'assets/bed-sheets.png'
                                ];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: RowItem(
                                      title: Row(
                                        children: [
                                          Image.asset(icon[index],height: 25,width: 25,color: ColorStyle.tertiary,),
                                          Text('${serve['ServiceName']}')
                                        ],
                                      ),
                                      description: Text('₱ ${serve['LoadPrice']}.00',style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                );
                              }
                          )
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: info['RemainingLoad'] == 0 || info['ShopStatus'] == 'closed' ? Colors.grey : btnColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              )
                          ),
                          onPressed: info['RemainingLoad'] == 0 || info['ShopStatus'] == 'closed'
                              ? null
                              : (){
                            switch(info['IsValued']){
                              case '0':
                                statusRequest();
                                break;
                              case '1':
                                pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                                NewServiceBookingScreen(shopId: '${info['ShopID']}')));
                                break;
                              default:
                                statusRequest();
                                break;
                            }
                          },
                          child: const Text(
                            'Avail Service',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text( count == 0 ? '0': (overallRate/count).toStringAsFixed(1), style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                              ),),
                              Icon(Icons.star,color: Colors.orange.shade300,size: 22,),
                              Text(
                                'Reviews ($count)',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              )
                            ],
                          ),
                        ),
                        hasRating
                            ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ratings.length,
                            itemBuilder: (context,index){
                              Map rate = ratings[index] as Map;
                              bool hasImage = rate['Image'] != null;
                              bool hasComment = rate['Comment'] != null;
                              return Container(

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(height: 0,),
                                    Padding(
                                        padding: const EdgeInsets.all( 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RowItem(
                                                title: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: hasImage
                                                          ? NetworkImage('$picaddress/${rate['CustomerImage']}')
                                                          : const AssetImage('assets/user.png') as ImageProvider,
                                                      backgroundColor: Colors.grey.shade300,
                                                      radius: 15,
                                                    ),
                                                    Text(' ${rate['CustomerName']}'),
                                                  ],
                                                ),
                                                description: Text('${rate['DateIssued']}')
                                            ),

                                            const SizedBox(height: 5,),
                                            RatingBar.builder(
                                              initialRating: double.tryParse('${rate['Rate']}') ?? 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 12,
                                              ignoreGestures: true,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.orange.shade300,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                            const SizedBox(height: 5,),
                                            hasComment
                                                ? Text('${rate['Comment']}')
                                                : const SizedBox.shrink()
                                          ],
                                        ),
                                    )
                                  ],
                                ),
                              );
                            }
                        )
                            : const Column(
                              children: [
                                Divider(height: 2,),
                                Center(child: Text('No Reviews'),),
                              ],
                            )
                      ],
                    )
                ),
              ],
            ),
          )
    );
  }
}


import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/customer/NewServiceBookingPage.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
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
  String isValued = '';
  String shopStat = '';
  String warningDesc = '';

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
        message = response.message ?? '';
        isLoading = false;
        hasRating = ratings.isNotEmpty;
      });
    }else{
    }
  }

  Future<void> statusRequest() async{
    await warningTextDialog(context, isValued,warningDesc);
  }

  Future<void> shopStatus() async{
    await warningTextDialog(context, isValued, warningDesc);
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
        shopStat = 'Laundry Shop is currently full';
        break;
      case 'closed':
        status = Colors.red;
        shopStat = 'Laundry Shop is closed';
        break;
    }

    switch(message){
      case '0':
        btnColor = Colors.orange;
        isValued = 'Pending';
        warningDesc = 'Your request is still pending';
        break;
      case '1':
        btnColor = Colors.greenAccent;
        break;
      case '2':
        btnColor = Colors.red;
        break;
      default:
        btnColor = ColorStyle.tertiary;
        isValued = 'Code Verification';
        warningDesc = 'Service booking requires the shop\'s code before availing. Visit the laudry shop for more info.';
        break;
    }

    if(isLoading){
      return Scaffold(
          appBar: AppBar(
            title: const Text('Shop Information'),
            titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
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
        title: const Text('Shop Information'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: ColorStyle.tertiary,
                      radius: 52,
                    ),
                    ProfilePicture(
                        name: '${info['ShopName']}',
                        radius: 46,
                        fontsize: 24,
                        img: info['ShopImage'] == '' ? null : '$picaddress/${info['ShopImage']}',
                    )
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
                          decoration: const BoxDecoration(
                              color: ColorStyle.tertiary,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                          ),
                          child: const Text('Shop\'s Information',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                      ),
                      Container(
                          padding: const EdgeInsets.all(8),
                          height: 140,
                          decoration: const BoxDecoration(
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
                                      Text(' Shop Name')
                                    ],
                                  ),
                                  description: Text('${info['ShopName']}',style: const TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.end,)
                              ),
                              RowItem(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.location_on,color: ColorStyle.tertiary,),
                                      Text(' Address')
                                    ],
                                  ),
                                  description: Text('${info['ShopAddress']}',style: const TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.end,)
                              ),
                              RowItem(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.circle, color: ColorStyle.tertiary,),
                                      Text(' Status')
                                    ],
                                  ),
                                  description: Text('${info['ShopStatus']}',style: const TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.end,)
                              ),
                              RowItem(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.production_quantity_limits, color: ColorStyle.tertiary,),
                                      Text(' Max Load')
                                    ],
                                  ),
                                  description: Text('${info['MaxLoad']}',style: const TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.end,)
                              )
                            ],
                          )
                      ),
                      const SizedBox(height: 10,),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: ColorStyle.tertiary,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                          ),
                          child: const Text('Laundry Services',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                      ),
                      Container(
                          padding: const EdgeInsets.all(8),
                          height: 140,
                          decoration: const BoxDecoration(
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
                                      description: Text('₱ ${serve['LoadPrice']}.00',style: const TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                );
                              }
                          )
                      ),
                      const SizedBox(height: 10,),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: info['RemainingLoad'] == 0 || info['ShopStatus'] == 'closed' ? Colors.grey : btnColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              )
                          ),
                          onPressed: info['RemainingLoad'] == 0 || info['ShopStatus'] == 'closed' || info['ShopStatus'] == 'full'
                              ? null
                              : (){
                            switch(message){
                              case '0':
                                statusRequest();
                                break;
                              case '1':
                                pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                                NewServiceBookingScreen(shopId: '${info['ShopID']}')));
                                break;
                              case '2':
                                statusRequest();
                                break;
                              default:
                                statusRequest();
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
                              Text( count == 0 ? '0': (overallRate/count).toStringAsFixed(1), style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                              ),),
                              Icon(Icons.star,color: Colors.orange.shade300,size: 22,),
                              Text(
                                'Reviews ($count)',
                                style: const TextStyle(
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
                                                    Expanded(child: Text(' ${rate['CustomerName']}'),)
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

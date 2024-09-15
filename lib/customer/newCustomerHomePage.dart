import 'dart:async';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/customer/NewNotificationInfoPage.dart';
import 'package:capstone/customer/newCustomerRatingPage.dart';
import 'package:capstone/customer/newProfileEditPage.dart';
import 'package:capstone/customer/newServiceSummaryPage.dart';
import 'package:capstone/customer/newShopInfoPage.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCustomerHomeScreen extends StatefulWidget {
  const NewCustomerHomeScreen({super.key});

  @override
  State<NewCustomerHomeScreen> createState() => _NewCustomerHomeScreenState();
}

class _NewCustomerHomeScreenState extends State<NewCustomerHomeScreen> {
  final GlobalKey<_TrackScreenState> _trackScreenKey = GlobalKey<_TrackScreenState>();
  final GlobalKey<_HomeScreenState> _homeScreenKey = GlobalKey<_HomeScreenState>();
  final GlobalKey<_NotificationScreenState> _notifScreenKey = GlobalKey<_NotificationScreenState>();
  final GlobalKey<_AccountScreenState> _accountScreenKey = GlobalKey<_AccountScreenState>();
  List<dynamic> shops = [];
  String? token; Timer? _timer;
  void getToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  Future<void> shopreqDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getRequestShops('${prefs.get('token')}');

    if(response.error == null){
      setState(() {
        shops = response.data as List<dynamic>;
      });
    }else{

    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Mate',),
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
      ),
      body: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: HomeScreen(key: _homeScreenKey,),
            onSelectedTabPressWhenNoScreensPushed: (){
              _homeScreenKey.currentState!.shopreqDisplay();
            },
            item: ItemConfig(
              icon: const Icon(Icons.home_filled),
              title: "Home",
              activeForegroundColor: Colors.white,
              inactiveForegroundColor: Colors.black,
            ),
          ),
          PersistentTabConfig(
            screen: TrackScreen(key: _trackScreenKey,),
            onSelectedTabPressWhenNoScreensPushed: (){
              _trackScreenKey.currentState!.laundryDisplay();
            },
            item: ItemConfig(
              icon: const Icon(Icons.history_toggle_off),
              title: "My Laundry",
              activeForegroundColor: Colors.white,
              inactiveForegroundColor: Colors.black,
            ),
          ),
          PersistentTabConfig(
            screen: NotificationScreen(key: _notifScreenKey,),
            onSelectedTabPressWhenNoScreensPushed: (){
              _notifScreenKey.currentState?.laundryNotif();
            },
            item: ItemConfig(
              icon: const Icon(Icons.notifications),
              title: "Notifications",
              activeForegroundColor: Colors.white,
              inactiveForegroundColor: Colors.black,
            ),
          ),
          PersistentTabConfig(
            screen: AccountScreen(key: _accountScreenKey,),
            onSelectedTabPressWhenNoScreensPushed: (){
              _accountScreenKey.currentState?.myProfile();
            },
            item: ItemConfig(
              icon: const Icon(Icons.person_pin),
              title: "Account",
              activeForegroundColor: Colors.white,
              inactiveForegroundColor: Colors.black,
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: const NavBarDecoration(
            color: ColorStyle.tertiary,
          ),
        ),
      ),
    );

  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<_HomeScreenState> _homeKey = GlobalKey<_HomeScreenState>();
  List<dynamic> shops = [];
  final TextEditingController _code = TextEditingController();
  bool isloading = true;
  Future<void> shopreqDisplay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getRequestShops('${prefs.get('token')}');
    if (response.error == null) {
      setState(() {
        shops = response.data as List<dynamic>;
        isloading = false;
        print('${prefs.get('token')}');
      });
    } else {
      throw ('${response.error}');
    }
  }


  Future<void> requestShops() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await addRequestShops(_code.text, '${prefs.get('token')}');

    if(response.error == null){
      setState(() {
        isloading = false;
      });
      await successDialog(context, '${response.data}');
    }else{
      setState(() {
        isloading = false;
      });
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> shopUnffolow(String addshopid) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await unfollowShop(addshopid, '${prefs.get('token')}');

    if(response.error == null){
      await successDialog(context, '${response.data}');
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  @override
  void initState(){
    super.initState();
    shopreqDisplay();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: shops.length,
          itemBuilder: (context,index){
            Map req = shops[index] as Map;
            Color status;
            switch(req['ShopStatus']){
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

            bool isEmptySlot = req['RemainingLoad'] == 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                  onTap: (){
                    pushWithoutNavBar(context, MaterialPageRoute(
                      builder: (context) => NewShopInfoScreen(shopId: '${req['ShopID']}'),
                    ),);

                  },
                  child: Ink(
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      minTileHeight: 80,
                      leadingAndTrailingTextStyle: TextStyle(
                        overflow: TextOverflow.ellipsis
                      ),
                      leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: ColorStyle.tertiary,
                          radius: 42,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage('$picaddress/${req['ShopImage']}'),
                            radius: 40,
                          ),
                        ),

                      ],
                    ),
                      title: Row(
                        children: [
                          Text('${req['ShopName']} ',
                            style: TextStyle(fontWeight: FontWeight.bold,color: ColorStyle.tertiary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text('Status:' ,style: TextStyle(fontSize: 12)),
                          Text('${req['ShopStatus']}',style: TextStyle(fontSize: 12,color: status),),
                        ],
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              padding: const EdgeInsets.all(4),
                              side: BorderSide(color: req['IsValued'] == '0' ? Colors.grey
                                  : ColorStyle.tertiary,width: 2),
                            fixedSize: Size(80, 10)
                          ),
                          onPressed: isEmptySlot || req['ShopStatus'] == 'full' || req['ShopStatus'] == 'closed'
                              ? null : (){
                            confirmDialog(context, 'Unfollow Shop?', (){
                              shopUnffolow('${req['AddedShopID']}');
                            });
                          },
                          child: Text(
                              req['IsValued'] == '0' ? 'Pending  ' : 'Following',
                            style: TextStyle(
                              color: req['IsValued'] == '0' ? Colors.grey
                                  : ColorStyle.tertiary
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )

              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorStyle.tertiary,
        foregroundColor: Colors.white,
        onPressed: (){
            inputDialog(context, requestShops, _code);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {

  List<dynamic> laundry = [];
  int nav = 0;
  bool isLoading = true;

  Future<void> laundryDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getLaundry(nav.toString(), '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        laundry = response.data as List<dynamic>;
        isLoading = false;

      });
    }else{

    }
  }

  Future<void> serviceCancelation(String bookId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await cancelService(bookId, '${prefs.getString('token')}');

    if(response.error == null){
      await successDialog(context, '${response.data}');
      laundryDisplay();
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> serviceCompletion(String bookId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await completeService(bookId, '${prefs.getString('token')}');

    if(response.error == null){
      await successDialog(context, '${response.data}');
      laundryDisplay();
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  Center loading(){
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 50,
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    laundryDisplay();
  }
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.grey.shade100,
              child: TabBar(
                labelColor: ColorStyle.tertiary,
                unselectedLabelColor: Colors.black,
                indicatorColor: ColorStyle.tertiary,
                  isScrollable: true,
                tabAlignment: TabAlignment.center,
                onTap: (value){
                  setState(() {
                    nav = value;
                    isLoading = true;
                    laundryDisplay();
                  });

                },
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Pick-up'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  isLoading
                      ? loading()
                      : ListView.builder(
                      shrinkWrap: true,
                      itemCount: laundry.length,
                      itemBuilder: (context, index){
                        Map laun = laundry[index] as Map;
                        String stat = '';
                        Color statColor;
                        switch(laun['Status']){
                          case '0':
                            stat = 'Pending';
                            statColor = Colors.orange;
                            break;
                          case '1':
                            stat = 'Washing';
                            statColor = Colors.blue;
                            break;
                          case '2':
                            stat = 'Drying';
                            statColor = Colors.yellow;
                            break;
                          case '3':
                            stat = 'Folding';
                            statColor = Colors.purple;
                            break;
                          case '4':
                            stat = 'Pick-up';
                            statColor = Colors.teal;
                            break;
                          default:
                            stat = 'Completed';
                            statColor = Colors.green;
                            break;
                        }
                        bool isPickup = laun['Status'] == '4';
                        bool isCancelled = laun['deleted_at'] != null;
                        bool isPending = laun['Status'] == '0';
                        bool isCurrent = int.parse(laun['Status']) == 0 || int.parse(laun['Status']) <= 4;
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: isCancelled ? null : (){
                              pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                                  NewServiceSummaryScreen(bookId: '${laun['BookingID']}')));
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(

                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RowItem(
                                        title: Row(
                                          children: [
                                            Icon(Icons.store,color: ColorStyle.tertiary,),
                                            Text('${laun['ShopName']}', style: TextStyle(fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                        description: Text(
                                          isCancelled ? 'Cancelled' : stat,
                                          style: TextStyle(color: isCancelled ? Colors.red : statColor),
                                        )
                                    ),
                                    const Divider(),
                                    const Text('Laundry Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                    RowItem(title: const Text('Service Availed'), description: Text('${laun['ServiceName']}', style: TextStyle(fontWeight: FontWeight.bold))),
                                    RowItem(title: const Text('Laundry Load'), description: Text('${laun['CustomerLoad']} kg/s', style: TextStyle(fontWeight: FontWeight.bold))),
                                    RowItem(title: const Text('Date'), description: Text('${laun['Schedule']}', style: TextStyle(fontWeight: FontWeight.bold),)),
                                    const SizedBox(height: 10,),
                                    RowItem(
                                        title: const SizedBox.shrink(),
                                        description: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Text('Total Cost: '),
                                            Text('₱${laun['LoadCost']}.00', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),)
                                          ],
                                        )
                                    ),
                                    isCurrent || isCancelled
                                        ? RowItem(
                                        title: const SizedBox.shrink(),
                                        description: isCancelled
                                            ? const SizedBox.shrink()
                                            :  isPending ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              )
                                          ),
                                          onPressed: (){
                                            serviceCancelation('${laun['BookingID']}');
                                          },
                                          child: const Text('Cancel       ',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                                        ):
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorStyle.tertiary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              )
                                          ),
                                          onPressed: isPickup ? (){
                                            serviceCompletion('${laun['BookingID']}');
                                          } : null,
                                          child: const Text('Completed',style: TextStyle(color: Colors.white),),
                                        )
                                    )
                                        : RowItem(
                                        title: const SizedBox.shrink(),
                                        description:
                                        '${laun['Status']}' == '6'
                                            ? OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              padding: const EdgeInsets.all(8)
                                          ),
                                          onPressed: (){
                                            pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                                                ViewRatingScreen(bookId: '${laun['BookingID']}')));
                                          },
                                          child: const Text('View Rating',style: TextStyle(color: ColorStyle.tertiary),),
                                        )
                                            : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorStyle.tertiary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              )
                                          ),
                                          onPressed: ()async{
                                            final result = await pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                                                NewCustomerRatingScreen(bookId: '${laun['BookingID']}', shopId: '${laun['ShopID']}')));

                                            if(result == true){
                                              laundryDisplay();
                                            }
                                          },
                                          child: const Text('Rate',style: TextStyle(color: Colors.white),),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                  isLoading
                      ? loading()
                      : ListView.builder(
                      shrinkWrap: true,
                      itemCount: laundry.length,
                      itemBuilder: (context, index){
                        Map laun = laundry[index] as Map;
                        String stat = '';
                        Color statColor;
                        switch(laun['Status']){
                          case '0':
                            stat = 'Pending';
                            statColor = Colors.orange;
                            break;
                          case '1':
                            stat = 'Washing';
                            statColor = Colors.blue;
                            break;
                          case '2':
                            stat = 'Drying';
                            statColor = Colors.yellow;
                            break;
                          case '3':
                            stat = 'Folding';
                            statColor = Colors.purple;
                            break;
                          case '4':
                            stat = 'Pick-up';
                            statColor = Colors.teal;
                            break;
                          default:
                            stat = 'Completed';
                            statColor = Colors.green;
                            break;
                        }
                        bool isPickup = laun['Status'] == '4';
                        bool isCancelled = laun['deleted_at'] != null;
                        bool isPending = laun['Status'] == '0';
                        bool isCurrent = int.parse(laun['Status']) > 0 || int.parse(laun['Status']) >= 4;
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: isCancelled ? null : (){
                              pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                                  NewServiceSummaryScreen(bookId: '${laun['BookingID']}')));
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RowItem(
                                        title: Row(
                                          children: [
                                            Icon(Icons.store,color: ColorStyle.tertiary,),
                                            Text('${laun['ShopName']}', style: TextStyle(fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                        description: Text(
                                          isCancelled ? 'Cancelled' : stat,
                                          style: TextStyle(color: isCancelled ? Colors.red : statColor),
                                        )
                                    ),
                                    const Divider(),
                                    const Text('Laundry Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                    RowItem(title: const Text('Service Availed'), description: Text('${laun['ServiceName']}', style: TextStyle(fontWeight: FontWeight.bold))),
                                    RowItem(title: const Text('Laundry Load'), description: Text('${laun['CustomerLoad']} kg/s', style: TextStyle(fontWeight: FontWeight.bold))),
                                    RowItem(title: const Text('Date'), description: Text('${laun['Schedule']}', style: TextStyle(fontWeight: FontWeight.bold),)),
                                    const SizedBox(height: 10,),
                                    RowItem(
                                        title: const SizedBox.shrink(),
                                        description: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Text('Total Cost: '),
                                            Text('₱${laun['LoadCost']}.00', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),)
                                          ],
                                        )
                                    ),
                                    RowItem(
                                        title: const SizedBox.shrink(),
                                        description: isCancelled
                                            ? const SizedBox.shrink()
                                            :  isPending ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              )
                                          ),
                                          onPressed: (){
                                            serviceCancelation('${laun['BookingID']}');
                                          },
                                          child: const Text('Cancel       ',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                                        ):
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorStyle.tertiary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              )
                                          ),
                                          onPressed: isPickup ? (){
                                            serviceCompletion('${laun['BookingID']}');
                                          } : null,
                                          child: const Text('Completed',style: TextStyle(color: Colors.white),),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                  isLoading
                      ? loading()
                      : ListView.builder(
                      shrinkWrap: true,
                      itemCount: laundry.length,
                      itemBuilder: (context, index){
                        Map laun = laundry[index] as Map;
                        String stat = '';
                        Color statColor;
                        switch(laun['Status']){
                          case '0':
                            stat = 'Pending';
                            statColor = Colors.orange;
                            break;
                          case '1':
                            stat = 'Washing';
                            statColor = Colors.blue;
                            break;
                          case '2':
                            stat = 'Drying';
                            statColor = Colors.yellow;
                            break;
                          case '3':
                            stat = 'Folding';
                            statColor = Colors.purple;
                            break;
                          case '4':
                            stat = 'Pick-up';
                            statColor = Colors.teal;
                            break;
                          default:
                            stat = 'Completed';
                            statColor = Colors.green;
                            break;
                        }
                        bool isPickup = laun['Status'] == '4';
                        bool isCancelled = laun['deleted_at'] != null;
                        bool isPending = laun['Status'] == '0';
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: isCancelled ? null : (){
                              pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                                  NewServiceSummaryScreen(bookId: '${laun['BookingID']}')));
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RowItem(
                                        title: Row(
                                          children: [
                                            Icon(Icons.store,color: ColorStyle.tertiary,),
                                            Text('${laun['ShopName']}', style: TextStyle(fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                        description: Text(
                                          isCancelled ? 'Cancelled' : stat,
                                          style: TextStyle(color: isCancelled ? Colors.red : statColor),
                                        )
                                    ),
                                    const Divider(),
                                    const Text('Laundry Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                    RowItem(title: const Text('Service Availed'), description: Text('${laun['ServiceName']}', style: TextStyle(fontWeight: FontWeight.bold))),
                                    RowItem(title: const Text('Laundry Load'), description: Text('${laun['CustomerLoad']} kg/s', style: TextStyle(fontWeight: FontWeight.bold))),
                                    RowItem(title: const Text('Date'), description: Text('${laun['Schedule']}', style: TextStyle(fontWeight: FontWeight.bold),)),
                                    const SizedBox(height: 10,),
                                    RowItem(
                                        title: const SizedBox.shrink(),
                                        description: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Text('Total Cost: '),
                                            Text('₱${laun['LoadCost']}.00', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),)
                                          ],
                                        )
                                    ),
                                    RowItem(
                                        title: const SizedBox.shrink(),
                                        description:
                                        '${laun['Status']}' == '6'
                                            ? OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                            padding: const EdgeInsets.all(8)
                                          ),
                                          onPressed: (){
                                            pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                                            ViewRatingScreen(bookId: '${laun['BookingID']}')));
                                          },
                                          child: const Text('View Rating',style: TextStyle(color: ColorStyle.tertiary),),
                                        )
                                            : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorStyle.tertiary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              )
                                          ),
                                          onPressed: ()async{
                                            final result = await pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                                                NewCustomerRatingScreen(bookId: '${laun['BookingID']}', shopId: '${laun['ShopID']}')));

                                            if(result == true){
                                              laundryDisplay();
                                            }
                                          },
                                          child: const Text('Rate',style: TextStyle(color: Colors.white),),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                  isLoading
                      ? loading()
                      : ListView.builder(
                      shrinkWrap: true,
                      itemCount: laundry.length,
                      itemBuilder: (context, index){
                        Map laun = laundry[index] as Map;
                        String stat = '';
                        Color statColor;
                        switch(laun['Status']){
                          case '0':
                            stat = 'Pending';
                            statColor = Colors.orange;
                            break;
                          case '1':
                            stat = 'Washing';
                            statColor = Colors.blue;
                            break;
                          case '2':
                            stat = 'Drying';
                            statColor = Colors.yellow;
                            break;
                          case '3':
                            stat = 'Folding';
                            statColor = Colors.purple;
                            break;
                          case '4':
                            stat = 'Pick-up';
                            statColor = Colors.teal;
                            break;
                          default:
                            stat = 'Completed';
                            statColor = Colors.green;
                            break;
                        }
                        bool isPickup = laun['Status'] == '4';
                        bool isCancelled = laun['deleted_at'] != null;
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: isCancelled ? null : (){
                              pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                                  NewServiceSummaryScreen(bookId: '${laun['BookingID']}')));
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RowItem(
                                        title: Row(
                                          children: [
                                            Icon(Icons.store,color: ColorStyle.tertiary,),
                                            Text('${laun['ShopName']}', style: TextStyle(fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                        description: Text(
                                          isCancelled ? 'Cancelled' : stat,
                                          style: TextStyle(color: isCancelled ? Colors.red : statColor),
                                        )
                                    ),
                                    const Divider(),
                                    const Text('Laundry Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                    RowItem(title: const Text('Service Availed'), description: Text('${laun['ServiceName']}', style: TextStyle(fontWeight: FontWeight.bold))),
                                    RowItem(title: const Text('Laundry Load (kg)'), description: Text('${laun['CustomerLoad']}', style: TextStyle(fontWeight: FontWeight.bold))),
                                    RowItem(title: const Text('Date'), description: Text('${laun['Schedule']}', style: TextStyle(fontWeight: FontWeight.bold),)),
                                    const SizedBox(height: 10,),
                                    RowItem(
                                        title: const SizedBox.shrink(),
                                        description: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Text('Total Cost: '),
                                            Text('₱${laun['LoadCost']}', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),)
                                          ],
                                        )
                                    ),
                                    RowItem(
                                        title: const SizedBox.shrink(),
                                        description: isCancelled
                                            ? const SizedBox.shrink()
                                            :  ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorStyle.tertiary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              )
                                          ),
                                          onPressed: isPickup ? (){
                                            serviceCompletion('${laun['BookingID']}');
                                          } : null,
                                          child: const Text('Completed',style: TextStyle(color: Colors.white),),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notification = [];
  bool isLoading = true;
  String notifId = '';
  String isRead = '';

  Future<void> laundryNotif() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await customerNotif('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        notification = response.data as List<dynamic>;
        isLoading = false;
      });
    }else{

    }
  }

  Future<void> notifRead() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await customerNotifRead(notifId, '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        isRead = '${response.data}';
      });
    }else{

    }
  }



  @override
  void initState() {
    super.initState();
    laundryNotif();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
            itemCount: notification.length,
            itemBuilder: (context,index){
              Map notif = notification[index] as Map;
              String dateTime = DateFormat('MM/dd/yyyy hh:mm').format(DateTime.parse(notif['updated_at']));
              notifId = '${notif['NotifID']}';
              return Column(
                children: [
                  InkWell(
                    onTap: () async {
                      notifRead();
                      final response = await pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                          NewNotificationInfoScreen(bookId: '${notif['BookingID']}', title: notif['Title'])));

                      if(response == true){
                        setState(() {
                          laundryNotif();

                        });
                      }
                    },
                    child: ListTile(
                      tileColor: notif['is_read'] == '0' ? Colors.blue.shade50 : null,
                      leading: Image.asset('assets/LMateLogo.png',alignment: Alignment.topCenter,),
                      title: Text('${notif['Title']}',style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${notif['Message']}'),
                          Text(dateTime,style: TextStyle(fontSize: 10),)
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 0,)
                ],
              );
            }
        ),
    );
  }
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<dynamic> profile = [];
  Map prof = {};
  bool isloading = true;

  Future<void> myProfile() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await customerProfile('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        profile = response.data as List<dynamic>;
        prof = profile[0] as Map;
        isloading = false;
      });
    }else{

    }
  }

  Future<void> logoutState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await logout('${prefs.getString('token')}');

    if (response.error == null) {
      await prefs.clear();
      if (mounted) {
        pushReplacementWithoutNavBar(context, MaterialPageRoute(builder: (context) => const NewLoginScreen()));
      }
    } else {

    }
  }

  Center loading(){
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 50,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    myProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? loading()
          : Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(40),
                child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: ColorStyle.tertiary,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage('$picaddress/${prof['CustomerImage']}'),
                          radius: 55,
                        ),
                      ],
                    )
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                        top: BorderSide(color: Colors.grey.shade300)
                    ),
                    color: Colors.white
                ),
                child: RowItem(
                  title: const Text('Name'),
                  description: Text('${prof['CustomerName']}', overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300)
                    ),
                    color: Colors.white
                ),
                child: RowItem(
                  title: const Text('Sex'),
                  description: Text('${prof['CustomerSex']}', overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300)
                    ),
                    color: Colors.white
                ),
                child: RowItem(
                  title: const Text('Address'),
                  description: Text('${prof['CustomerAddress']}', overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300)
                    ),
                    color: Colors.white
                ),
                child: RowItem(
                  title: const Text('Contact'),
                  description: Text('${prof['CustomerContactNumber']}', overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyle.tertiary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    fixedSize: Size(MediaQuery.of(context).size.width * .8, 20),
                  ),
                  onPressed: ()async{
                    final result = await pushWithoutNavBar(context, MaterialPageRoute(builder: (context) =>
                        NewProfileEditScreen(
                            image: '${prof['CustomerImage']}', name: '${prof['CustomerName']}',
                            sex: '${prof['CustomerSex']}', address: '${prof['CustomerAddress']}',
                            contact: '${prof['CustomerContactNumber']}', id: '${prof['CustomerID']}',)));

                    if(result == true){
                      myProfile();
                    }
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      fixedSize: Size(MediaQuery.of(context).size.width * .8, 20),
                    ),
                    onPressed: (){
                      logoutDialog(context, (){
                        logoutState();
                      });
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                          color: ColorStyle.tertiary
                      ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
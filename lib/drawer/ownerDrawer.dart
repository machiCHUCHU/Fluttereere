/*
import 'dart:convert';
import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/home/bookingPage.dart';
import 'package:capstone/home/homePage.dart';
import 'package:capstone/home/profilePage.dart';
import 'package:capstone/home/ratingPage.dart';
import 'package:capstone/menu/customerPage.dart';
import 'package:capstone/menu/inventoryPage.dart';
import 'package:capstone/menu/loginPage.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/drawerStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';


class MyDrawer extends StatefulWidget {
  final int selectedIndex;
  const MyDrawer( {super.key, required this.selectedIndex});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  String? token;
  String? username;
  int? userid;
  String? name;
  String? contact;
  String image = '';
  Uint8List? memoryImage;
  late int _selectedIndex;
  bool isLoading = true;
  List<bool> isSelected = [
    true,
    false,
    false,
    false,
    false
  ];

  void selection(int index, Widget page){
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page,
    settings: RouteSettings(
      arguments: _selectedIndex
    )));
  }


  void getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      image = prefs.getString('image').toString();
      username = prefs.getString('username').toString();
      userid = prefs.getInt('userid');
      token = prefs.getString('token').toString();
      name = prefs.getString('ownername').toString();
      contact = prefs.getString('contact').toString();
    });

  }


  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                logoutState();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  

  Future<void> logoutState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await logout(token.toString());


    if(response.error == null){
      await prefs.clear();
      if(mounted){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NewLoginScreen()), (route) => false);
      }
    }else{
      print(response.error);
    }
  }

  @override
  void initState() {
    getUser();
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(token);
    return SafeArea(
      child: Theme(
        data: ThemeData(
          listTileTheme: const ListTileThemeData(
            selectedTileColor: ColorStyle.tertiary,
            selectedColor: Colors.white,
          ),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child:  Drawer(
            backgroundColor: const Color(0xFFF6F6F6),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3)
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                DrawerHeader(
                    decoration: DrawerStyle.headerBg,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorStyle.tertiary,
                          ),
                          child: CircleAvatar(
                            radius: 40,
                          ),
                        ),
                        Text(
                          '$name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                          },
                          child: const Text(
                            'View Profile',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white
                            ),
                          ),
                        )
                      ],
                    )
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: _selectedIndex == 0,
                  onTap: (){
                    selection(0, const DrawerHomeScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text(
                    'Inventory',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: _selectedIndex == 1,
                  onTap: (){
                    selection(1, const DrawerInventoryScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text(
                    'Bookings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: _selectedIndex == 2,
                  onTap: (){
                    selection(2, const DrawerBookingScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people_alt),
                  title: const Text(
                    'Customers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: _selectedIndex == 3,
                  onTap: (){
                    selection(3, const DrawerCustomerScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: const Text(
                    'Feedbacks',
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  selected: _selectedIndex == 4,
                  onTap: (){
                    selection(4, const DrawerFeedbackScreen());
                  },
                ),
                ListTile(
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: const Icon(
                    Icons.logout,
                  ),
                  onTap: (){
                    showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

class DrawerHomeScreen extends StatelessWidget {
  const DrawerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = ModalRoute.of(context)?.settings.arguments as int? ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      drawer: MyDrawer(selectedIndex: selectedIndex,),
      body: const DashboardScreen()
    );
  }
}

class DrawerInventoryScreen extends StatelessWidget {
  const DrawerInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = ModalRoute.of(context)?.settings.arguments as int? ?? 1;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Inventory',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        drawer: MyDrawer(selectedIndex: selectedIndex,),
        body: Container()
    );
  }
}

class DrawerBookingScreen extends StatelessWidget {
  const DrawerBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = ModalRoute.of(context)?.settings.arguments as int? ?? 2;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bookings',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        drawer: MyDrawer(selectedIndex: selectedIndex,),
        body: const BookingScreen()
    );
  }
}

class DrawerCustomerScreen extends StatelessWidget {
  const DrawerCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = ModalRoute.of(context)?.settings.arguments as int? ?? 3;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Customers',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        drawer: MyDrawer(selectedIndex: selectedIndex,),
        body: const PendingCustomerScreen()
    );
  }
}

class DrawerFeedbackScreen extends StatelessWidget {
  const DrawerFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = ModalRoute.of(context)?.settings.arguments as int? ?? 4;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Feedbacks',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        drawer: MyDrawer(selectedIndex: selectedIndex,),
        body: const RatingScreen()
    );
  }
}*/

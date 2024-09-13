import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewAppbar extends StatefulWidget implements PreferredSizeWidget{
  const NewAppbar({super.key});

  @override
  State<NewAppbar> createState() => _NewAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _NewAppbarState extends State<NewAppbar> {
  Map appbar = {};
  Future<void> appbarDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getAppbar('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        appbar = response.data as Map;
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NewLoginScreen()),
              (route) => false,
        );
      }
    } else {
      print(response.error);
    }
  }

  @override
  void initState(){
    super.initState();
    appbarDisplay();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const Text("hello world"),
        actions: [
          Text(
            '${appbar['shopname'] ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                logoutDialog(context, logoutState);
              },
              child: CircleAvatar(
                backgroundImage: '${appbar['pic']}' != null
                    ? NetworkImage('$picaddress/${appbar['pic']}')
                    : AssetImage('assets/pepe.png') as ImageProvider,
              ),
            ),
          ),
        ],
    );
  }
}

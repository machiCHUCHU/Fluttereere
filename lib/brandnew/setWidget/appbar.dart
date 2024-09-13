import 'dart:convert';
import 'package:capstone/connect/laravel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/brandnew/dialogs.dart';

class ForAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TabBar? tabBar;
  final Text? title;
  final Color? tabBarColor;
  const ForAppBar({Key? key, this.tabBar, this.tabBarColor, this.title}) : super(key: key);

  @override
  _ForAppBarState createState() => _ForAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (tabBar?.preferredSize.height ?? 0),
  );
}

class _ForAppBarState extends State<ForAppBar> {
  String? token;

  @override
  void initState() {
    super.initState();
    getUserAndAppBarData();
  }

  void getUserAndAppBarData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null) {
      await AppBarData().fetchAppBarData(token!);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> logoutState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await logout(token.toString());

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
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorStyle.tertiary,
      title: widget.title,
      actions: [
        Text(
          '${AppBarData().shopName ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              logoutDialog(context, logoutState);
            },
            child: CircleAvatar(
              backgroundImage: AppBarData().profileImage != null
                  ? NetworkImage('$picaddress/${AppBarData().profileImage!}')
                  : AssetImage('assets/pepe.png') as ImageProvider,
            ),
          ),
        ),
      ],
      bottom: widget.tabBar != null
          ? PreferredSize(
        preferredSize: widget.tabBar!.preferredSize,
        child: Container(
          color: widget.tabBarColor ?? Colors.transparent,
          child: widget.tabBar,
        ),
      )
          : null,
    );
  }
}


class AppBarData {
  static final AppBarData _instance = AppBarData._internal();

  factory AppBarData() {
    return _instance;
  }

  AppBarData._internal();

  String? shopName;
  String? profileImage;

  Future<void> fetchAppBarData(String token) async {
    ApiResponse response = await getAppbar(token);

    if (response.error == null) {
      final data = response.data as Map;
      shopName = data['shopname'];
      profileImage = data['pic'];
    } else {
      print(response.error);
    }
  }
}

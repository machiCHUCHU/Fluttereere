import 'mainColorStyle.dart';
import 'package:flutter/material.dart';

class DrawerStyle{
  static const BoxDecoration headerBg = BoxDecoration(
    color: Colors.white,
    image: DecorationImage(
        image: AssetImage('assets/bubble.jpg'),
        alignment: Alignment.bottomCenter
    ),
  );
}
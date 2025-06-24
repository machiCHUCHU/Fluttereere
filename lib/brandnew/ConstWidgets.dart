import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget backAppBar(BuildContext context, String title){
  return AppBar(
    title: Text(title),
    titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
    leading: IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
    ),
  );
}
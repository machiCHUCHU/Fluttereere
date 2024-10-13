
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'mainColorStyle.dart';
import 'package:flutter/material.dart';

class RegistrationStyle{
  static const TextStyle titleStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: ColorStyle.primary
  );

  static const TextStyle secondaryTitle = TextStyle(
      fontSize: 16,
      color: ColorStyle.secondary
  );

  static const TextStyle formTitle = TextStyle(
      color: ColorStyle.primary,
      fontWeight: FontWeight.bold,
      fontSize: 14
  );

  static const TextStyle textButton = TextStyle(
      color: ColorStyle.tertiary,
      fontWeight: FontWeight.bold
  );

  static InputDecoration allForm = InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade100,
    enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
        borderSide: BorderSide(
            color: Colors.grey.shade100,
            width: 1
        )
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),

        borderSide: BorderSide(
            color: Colors.grey.shade100,
            width: 1
        )
    ),
  );

  static InputDecoration passForm({
    required bool isHidden,
    required VoidCallback visibility,
  }){
    return InputDecoration(
      suffixIcon: IconButton(
        onPressed: visibility,
        icon: Icon(isHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined),
      ),
      filled: true,
      fillColor: Colors.grey.shade100,

      enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
          borderSide: BorderSide(
              color: Colors.grey.shade100,
              width: 1
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
          borderSide: BorderSide(
              color: Colors.grey.shade100,
              width: 1
          )
      ),
    );
  }

  static ButtonStyle signButton(){
    return ElevatedButton.styleFrom(
        backgroundColor: ColorStyle.tertiary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        )
    );
  }

  static BoxDecoration otpInput = BoxDecoration(
      color: ColorStyle.tertiary,
      borderRadius: BorderRadius.circular(0),
      border: Border.all(color: ColorStyle.tertiary)
  );

  static const TextStyle resendButton = TextStyle(
      color: ColorStyle.tertiary,
      fontSize: 14
  );

  static const TextStyle imagePick = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: ColorStyle.primary
  );
}
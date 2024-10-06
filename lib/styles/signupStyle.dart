
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'mainColorStyle.dart';
import 'package:flutter/material.dart';

class SignupStyle{
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
    fillColor: Colors.white,
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        borderSide: const BorderSide(
            color: Colors.red,
            width: 1
        )
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        borderSide: const BorderSide(
            color: Colors.black,
            width: 1
        )
    ),
    focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        borderSide: BorderSide(
            color: Colors.grey,
            width: 1
        )
    ),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        borderSide: const BorderSide(
            color: Colors.red,
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
      fillColor: Colors.white,
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
          borderSide: const BorderSide(
              color: Colors.red,
              width: 1
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
          borderSide: const BorderSide(
              color: Colors.black,
              width: 1
          )
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey,
              width: 1
          )
      ),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
          borderSide: const BorderSide(
              color: Colors.red,
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
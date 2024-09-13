import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone/styles/mainColorStyle.dart';

class CustomerStyle {
  bool isHidden = true;
  static const TextStyle titleStyle = TextStyle(
      fontSize: 24,
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

  static InputDecoration emailForm = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
            color: Colors.red,
            width: 2
        )
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
            color: Colors.black,
            width: 2
        )
    ),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.grey,
            width: 2
        )
    ),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
            color: Colors.red,
            width: 2
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
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
              color: Colors.red,
              width: 2
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
              color: Colors.black,
              width: 2
          )
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey,
              width: 2
          )
      ),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
              color: Colors.red,
              width: 2
          )
      ),
    );
  }

  static ButtonStyle loginButton(){
    return ElevatedButton.styleFrom(
        backgroundColor: ColorStyle.tertiary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        )
    );
  }

  static const TextStyle modalTitle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20
  );

  static const TextStyle modalSubTitle = TextStyle(
    color: ColorStyle.primary,
    fontSize: 16,
  );


}
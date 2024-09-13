
import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/menu/loginPage.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:capstone/menu/getting_startedPage.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomerSignUpScreen extends StatefulWidget {
  const CustomerSignUpScreen({super.key});

  @override
  State<CustomerSignUpScreen> createState() => _CustomerSignUpScreenState();
}

class _CustomerSignUpScreenState extends State<CustomerSignUpScreen> {



  @override
  void dispose(){
    txtUsername.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    txtContactNumber.dispose();
    txtAddress.dispose();
    txtLastName.dispose();
    txtMiddleName.dispose();
    txtFirstName.dispose();

    super.dispose();
  }

  Uint8List? _pickedImageBytes;
  Future<void> _pickAndUploadImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: (){
                Navigator.pop(context, ImageSource.camera);
              },
              icon: Icon(Icons.camera_alt),
              iconSize: 75,
              color: Colors.blueAccent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            IconButton(
              onPressed: (){
                Navigator.pop(context, ImageSource.gallery);
              },
              icon: Icon(Icons.folder),
              iconSize: 75,
              color: Colors.blueAccent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            )
          ],
        ),
      ),
    );

    if (source != null) { // Check if the user made a choice
      final XFile? pickedImage = await ImagePicker().pickImage(
          source: source,
          maxHeight: 500,
          maxWidth: 500
      );

      if (pickedImage != null) {
        final byteData = await pickedImage.readAsBytes();

        setState(() {
          _pickedImageBytes = byteData;
        });


      } else {
        // Handle the case where the image picking was canceled.
        print('Image picking canceled');
      }
    }
  }

  void _confirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Proceed?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: const Text('Double check provided information before proceeding.'),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')
            ),
            TextButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        OTPScreen(
                          username: txtUsername.text, firstname: txtFirstName.text, lastname: txtLastName.text, middlename: txtMiddleName.text,
                          address: txtAddress.text, contact: txtContactNumber.text, email: txtEmail.text, password: txtPassword.text,
                          gender: _selectedGender.toString(), usertype: 'customer', image: _pickedImageBytes!,
                        )));
                  }
                },
                child: const Text('Proceed')
            )
          ],
        );
      },
    );
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtMiddleName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtContactNumber = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  String? _selectedGender;
  bool _autoValidate = false;
  bool _obscureText = true;


  @override
  Widget build(BuildContext context) {
    print(_pickedImageBytes);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title:  const Text(
          'Create Your Account!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  if(_pickedImageBytes == null)
                    SizedBox(
                      height: 130,
                      width: 100,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFF9E9E9E),
                            radius: 50,
                            child: Icon(
                              Icons.person,
                              size: 100,
                            ),

                          ),
                          Positioned(
                              top: 70,
                              left: 70,
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      _pickAndUploadImage();
                                    },
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 15,
                                      weight: 50,
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  if (_pickedImageBytes != null)
                    SizedBox(
                      height: 130,
                      width: 100,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF9E9E9E),
                              radius: 50,
                              backgroundImage: MemoryImage(_pickedImageBytes!),
                            ),
                          ),
                          Positioned(
                              top: 70,
                              left: 70,
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      _pickAndUploadImage();
                                    },
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 15,
                                      weight: 50,
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  // Username
                  TextFormField(
                    controller: txtUsername,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    /*validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username!';
                      }
                      return null;
                    },*/
                  ),

                  const SizedBox(height: 16),

                  // First Name
                  TextFormField(
                    controller: txtFirstName,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    /*validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name!';
                      }
                      return null;
                     },*/
                  ),
                  const SizedBox(height: 16),

                  // Middle Name
                  TextFormField(
                    controller: txtMiddleName,
                    decoration: InputDecoration(
                      hintText: 'Middle Name',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    /*validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your middle name!';
                      }
                      return null;
                    }, */
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: txtLastName,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    /*validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name!';
                      }
                      return null;
                    }, */
                  ),
                  const SizedBox(height: 16),

                  //customer address
                  TextFormField(
                    controller: txtAddress,
                    decoration: InputDecoration(
                      hintText: 'Street No./Barangay/City/Province',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    /*validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name!';
                      }
                      return null;
                    }, */
                  ),
                  const SizedBox(height: 16),

                  // Contact Number
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: txtContactNumber,
                    decoration: InputDecoration(
                      hintText: 'Contact Number',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    /*validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your contact number!';
                      }
                      return null;
                    },*/
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: txtEmail,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    /*validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email!';
                      }
                      return null;
                    },*/
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    obscureText: _obscureText,
                    controller: txtPassword,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                      ),
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    /*validator: (String? value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Please enter a valid password!';
                      }
                      return null;
                    },*/
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Gender',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: _selectedGender,
                    items: ['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    /*validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender!';
                      }
                      return null;
                    },*/
                  ),
                  const SizedBox(height: 24),

                  // Sign Up
                  GestureDetector(
                    onTap: () {
                      _confirmationDialog();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3572EF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}


class OwnerSignUpScreen extends StatefulWidget {
  const OwnerSignUpScreen({super.key});

  @override
  State<OwnerSignUpScreen> createState() => _OwnerSignUpScreenState();
}

class _OwnerSignUpScreenState extends State<OwnerSignUpScreen> {


  @override
  void dispose(){
    txtUsername.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    txtContactNumber.dispose();
    txtAddress.dispose();
    txtLastName.dispose();
    txtMiddleName.dispose();
    txtFirstName.dispose();

    super.dispose();
  }

  Uint8List? _pickedImageBytes;
  Future<void> _pickAndUploadImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: (){
                Navigator.pop(context, ImageSource.camera);
              },
              icon: Icon(Icons.camera_alt),
              iconSize: 75,
              color: Colors.blueAccent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            IconButton(
              onPressed: (){
                Navigator.pop(context, ImageSource.gallery);
              },
              icon: Icon(Icons.folder),
              iconSize: 75,
              color: Colors.blueAccent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            )
          ],
        ),
      ),
    );

    if (source != null) { // Check if the user made a choice
      final XFile? pickedImage = await ImagePicker().pickImage(
          source: source,
          maxHeight: 500,
          maxWidth: 500
      );

      if (pickedImage != null) {
        final byteData = await pickedImage.readAsBytes();

        setState(() {
          _pickedImageBytes = byteData;
        });


      } else {
        // Handle the case where the image picking was canceled.
        print('Image picking canceled');
      }
    }
  }


  void _confirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Proceed?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: const Text('Double check provided information before proceeding.'),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')
            ),
            TextButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    OTPScreen(
                     username: txtUsername.text, firstname: txtFirstName.text, lastname: txtLastName.text, middlename: txtMiddleName.text,
                      address: txtAddress.text, contact: txtContactNumber.text, email: txtEmail.text, password: txtPassword.text, gender: _selectedGender.toString(), usertype: 'owner', image: _pickedImageBytes!,
                    )));
                  }
                },
                child: const Text('Proceed')
            )
          ],
        );
      },
    );
  }



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtMiddleName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtContactNumber = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  String? _selectedGender;
  bool _autoValidate = false;
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title:  const Text(
          'Create Your Account!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  if(_pickedImageBytes == null)
                    SizedBox(
                      height: 130,
                      width: 100,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFF9E9E9E),
                            radius: 50,
                            child: Icon(
                                Icons.person,
                                size: 100,
                            ),

                          ),
                          Positioned(
                            top: 70,
                              left: 70,
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      _pickAndUploadImage();
                                    },
                                    icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.black,
                                        size: 15,
                                        weight: 50,
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  if (_pickedImageBytes != null)
                    SizedBox(
                      height: 130,
                      width: 100,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF9E9E9E),
                              radius: 50,
                              backgroundImage: MemoryImage(_pickedImageBytes!),
                            ),
                          ),
                          Positioned(
                              top: 70,
                              left: 70,
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      _pickAndUploadImage();
                                    },
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 15,
                                      weight: 50,
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  // Username
                  TextFormField(
                    controller: txtUsername,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // First Name
                  TextFormField(
                    controller: txtFirstName,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                     },
                  ),
                  const SizedBox(height: 16),

                  // Middle Name
                  TextFormField(
                    controller: txtMiddleName,
                    decoration: InputDecoration(
                      hintText: 'Middle Name',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: txtLastName,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  //customer address
                  TextFormField(
                    controller: txtAddress,
                    decoration: InputDecoration(
                      hintText: 'Street No./Barangay/City/Province',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Contact Number
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: txtContactNumber,
                    decoration: InputDecoration(
                      hintText: 'Contact Number',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: txtEmail,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    obscureText: _obscureText,
                    controller: txtPassword,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                      ),
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Please enter a valid password!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Gender',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: _selectedGender,
                    items: ['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    /*validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender!';
                      }
                      return null;
                    },*/
                  ),
                  const SizedBox(height: 24),


                  // Sign Up
                  GestureDetector(
                    onTap: () {
                      _confirmationDialog();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3572EF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}

class OTPScreen extends StatefulWidget {
  final String username;
  final String firstname;
  final String middlename;
  final String lastname;
  final String address;
  final String contact;
  final String email;
  final String password;
  final String gender;
  final String usertype;
  final Uint8List image;
      const OTPScreen({super.key, required this.firstname, required this.lastname, required this.address, required this.contact, required this.email, required this.password, required this.gender, required this.username, required this.middlename, required this.usertype, required this.image});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  Future<void> regForm() async{
    showDialog(
        context: context,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );


  }

  @override
  void initState(){
    super.initState();
    widget.lastname;
    widget.middlename;
    widget.firstname;
    widget.gender;
    widget.address;
    widget.contact;
    widget.email;
    widget.username;
    widget.password;
    widget.image;
    otpDisplay();
  }

  void _successSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Registration Successful!!',
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  void _errorSnackbar(String? error){
    showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: '$error')
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Colors.black
    ),
    decoration: BoxDecoration(
      color: Colors.green.shade100,
      borderRadius: BorderRadius.circular(0),
      border: Border.all(color: Colors.transparent)
    )
  );

  bool showTimer = true;
  bool? isVerified;

  String? code;
  Future<void> otpDisplay() async{/*widget.contact*/
    ApiResponse response = await otpVerification(widget.contact);

    if(response.error == null){
      setState(() {
        code = response.data.toString();
      });
    } else {
      print('${response.error}');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
              children: [
                const Text(
                  'Verification',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  child: const Text(
                    'Enter the code sent to your number.',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: const Text(
                    '+63 9637 482 5230',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                    ),
                  ),
                ),
                Pinput(
                  validator: (value){
                    if(value == code){
                      isVerified = true;
                      return null;
                    }else{
                      isVerified = false;
                      return null;
                    }
                  },
                  length: 4,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: Colors.green)
                      )
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(left:40, top: 5),
                    child: Row(
                      children: [
                        Text("Didn't get the code?"),
                        showTimer
                            ? TimerCountdown(
                          format: CountDownTimerFormat.minutesSeconds,
                          enableDescriptions: false,
                          spacerWidth: 0,
                          timeTextStyle: TextStyle(
                            fontSize: 15
                          ),
                          endTime: DateTime.now().add(const Duration(seconds: 5)),
                          onEnd: () {
                            setState(() {
                              showTimer = false;
                            });
                          },
                        )
                            : Container(
                          margin: const EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              child: TextButton(
                              onPressed: (){
                                setState(() {
                                  showTimer = true;
                                });
                              },
                              child: Text(
                                  'Resend',
                                style: TextStyle(
                                  fontSize: 15
                                ),
                              )
                              ),
                            ),
                      ],
                    )
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: const Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                    onPressed: (){
                      if(isVerified == true){
                        setState(() {
                          regForm();
                        });
                      }else{
                        print('wrong code');
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    )
                )
              ],
            ),
          )
        ),
    );
  }
}

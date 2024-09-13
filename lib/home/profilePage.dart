import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/drawer/ownerDrawer.dart';
import 'package:capstone/model/user.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:row_item/row_item.dart';
import 'package:capstone/styles/profilePageStyle.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? token;
  int? userid;
  String? username;
  List<dynamic> profile = [];
  List<dynamic> user = [];
  bool hasLoading = true;
  String? image;
  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      username = prefs.getString('username');
      image = prefs.getString('image').toString();
    });
    shopProfileDisplay();
  }

  Future<void> shopProfileDisplay() async{
    ApiResponse response = await getShopProfile(userid.toString());
    ApiResponse response1 = await getUserProfile(userid.toString());
    if(response.error == null){
      setState(() {
        profile = response.data as List<dynamic>;
        user = response1.data as List<dynamic>;
        hasLoading = false;
      });
    }else{
      hasLoading = false;
      print(response.error);
    }
  }

  /*Future<void> userProfileDisplay() async{


    if(response.error == null){
      user = response.data as List<dynamic>;
      hasLoading = false;
    }else{
      print(response.error);
    }
  }*/

  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if(hasLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else{
      Map prof = profile[0] as Map;
      Map use = user[0] as Map;
      bool hasImage = image!.isNotEmpty;
      print('${use['Name']}');
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      // margin: EdgeInsets.only(top: 30),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: hasImage
                                  ? MemoryImage(base64Decode(image!))
                                  : AssetImage('assets/pepe.png') as ImageProvider,
                              backgroundColor: Colors.white,
                              radius: 50,
                            ),
                            Text(
                              username!,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              '${prof['ContactNumber']}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(double.infinity, 20)
                                ),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileInformationScreen(
                                    image: '${use['Image']}', name: '${use['Name']}', address: '${use['Address']}',
                                    contact: '${use['ContactNumber']}', email: '${use['email']}', ownerid: '${use['OwnerID']}',
                                  )));
                                },
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        // margin: EdgeInsets.only(top: 30),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RowItem(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: ProfileStyle.shopInfoIcon,
                                      ),
                                      Text(
                                        'Owner',
                                        style: ProfileStyle.shopInfoText,
                                      )
                                    ],
                                  ),
                                  description: Text(
                                    '${prof['Name']}',
                                    style: ProfileStyle.shopInfoText,
                                  )
                              ),
                              RowItem(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.store,
                                        size: ProfileStyle.shopInfoIcon,
                                      ),
                                      Text(
                                        'Shop',
                                        style: ProfileStyle.shopInfoText,
                                      )
                                    ],
                                  ),
                                  description: Text(
                                    '${prof['ShopName']}',
                                    style: ProfileStyle.shopInfoText,
                                  )
                              ),
                              RowItem(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: ProfileStyle.shopInfoIcon,
                                      ),
                                      Text(
                                        'Address',
                                        style: ProfileStyle.shopInfoText,
                                      )
                                    ],
                                  ),
                                  description: Text(
                                    '${prof['ShopAddress']}',
                                    style: ProfileStyle.shopInfoText,
                                  )
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_laundry_service,
                                    size: ProfileStyle.shopInfoIcon,
                                  ),
                                  Text(
                                    '${prof['WasherQty']}',
                                    style: ProfileStyle.shopInfoText,
                                  ),
                                  SizedBox(width: 15,),
                                  Icon(
                                    Icons.dry_cleaning,
                                    size: ProfileStyle.shopInfoIcon,
                                  ),
                                  Text(
                                    '${prof['DryerQty']}',
                                    style: ProfileStyle.shopInfoText,
                                  )
                                ],
                              ),
                              RowItem(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: ProfileStyle.shopInfoIcon,
                                      ),
                                      Text(
                                        'Shop Code',
                                        style: ProfileStyle.shopInfoText,
                                      )
                                    ],
                                  ),
                                  description: Text(
                                    '${prof['ShopCode']}',
                                    style: ProfileStyle.shopInfoText,
                                  )
                              ),


                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(double.infinity, 20)
                                  ),
                                  onPressed: (){

                                  },
                                  child: const Text(
                                    'Edit Shop Information',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
          )
      );
    }
  }
}

class ProfileInformationScreen extends StatefulWidget {
  final String image;
  final String name;
  final String address;
  final String contact;
  final String email;
  final String ownerid;
  const ProfileInformationScreen({super.key, required this.image, required this.name, required this.address, required this.contact, required this.email, required this.ownerid});

  @override
  State<ProfileInformationScreen> createState() => _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  String? token;
  int? userid;
  String? username;
  int? shopid;
  List<dynamic> profile = [];
  bool isLoading = true;


  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      username = prefs.getString('username');
      shopid = prefs.getInt('shopid');
    });
  }

  Future<void> updateUserProf() async{
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
    String hasPickedImage;
    if(_pickedImageBytes != null){
      hasPickedImage = base64Encode(_pickedImageBytes!);
    }else{
      hasPickedImage = image!;
    }

    ApiResponse apiResponse = await updateUserProfile(
        widget.ownerid, txtName.text, 
        txtAddress.text, txtContactNumber.text, hasPickedImage
    );

    if(apiResponse.error == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
    }else{
      Navigator.pop(context);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtContactNumber = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  String? image;
  String? _selectedGender;
  bool _obscureText = false;

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

  @override
  void initState(){
    super.initState();
    image = widget.image;
    txtName.text = widget.name;
    txtAddress.text = widget.address;
    txtContactNumber.text = widget.contact;
    txtEmail.text = widget.email;
    getUser();
  }

  @override
  Widget build(BuildContext context) {

    print(image!);
    // Map prof = profile[0] as Map;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),

        ),
        body: Center(
          child: Column(
            children: [
             Expanded(
               child:  Container(
               width: double.infinity,
               height: MediaQuery.of(context).size.height,
               // margin: EdgeInsets.only(top: 30),
               child: Card(
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(5)
                 ),
                 child: Form(
                   key: _formKey,
                   child: SingleChildScrollView(
                     child: Center(
                       child: Padding(
                         padding: EdgeInsets.all(8),
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
                                       backgroundImage: MemoryImage(base64Decode(image!)),
                                       radius: 50,
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
                             TextFormField(
                               controller: txtName,
                               decoration: InputDecoration(
                                 hintText: 'Name',
                                 filled: true,
                                 fillColor: Colors.grey[200],
                                 contentPadding: EdgeInsets.symmetric(vertical: 5),
                                 border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: BorderSide.none,
                                 ),
                               ),
                             ),

                             const SizedBox(height: 20),

                             //customer address
                             TextFormField(
                               controller: txtAddress,
                               decoration: InputDecoration(
                                 hintText: 'Street No./Barangay/City/Province',
                                 filled: true,
                                 fillColor: Colors.grey[200],
                                 contentPadding: EdgeInsets.symmetric(vertical: 5),
                                 border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: BorderSide.none,
                                 ),
                               ),
                             ),
                             const SizedBox(height: 20),

                             // Contact Number
                             TextFormField(
                               keyboardType: TextInputType.number,
                               controller: txtContactNumber,
                               decoration: InputDecoration(
                                 hintText: 'Contact Number',
                                 filled: true,
                                 fillColor: Colors.grey[200],
                                 contentPadding: EdgeInsets.symmetric(vertical: 5),
                                 border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30),
                                   borderSide: BorderSide.none,
                                 ),
                               ),
                             ),
                             const SizedBox(height: 20),

                             const SizedBox(height: 20),

                             ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                     fixedSize: Size(double.infinity, 20)
                                 ),
                                 onPressed: (){
                                   updateUserProf();
                                 },
                                 child: const Text(
                                   'Edit Profile',
                                   style: TextStyle(
                                       color: Colors.white
                                   ),
                                 )
                             ),
                           ],
                         ),
                       )
                     ),
                   )
                 ),
               ),
             ),
             )
            ],
          ),
        )
    );
  }
}
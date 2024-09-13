import 'dart:convert';

import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/brandnew/setWidget/appbar.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/drawer/ownerDrawer.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewReviewPage extends StatefulWidget {
  const NewReviewPage({super.key});

  @override
  State<NewReviewPage> createState() => _NewReviewPageState();
}

class _NewReviewPageState extends State<NewReviewPage> {
  String? token;
  int? shopid;

  List<dynamic> review = [];
  bool isLoading = true;
  bool hasData = false;

  int totalReviews = 0;
  int overallRating = 0;
  Map ratings = {};

  double calculateTotalRate() {
    return review.fold(0, (sum, item) => sum + (int.parse(item['Rate'])));
  }



  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      shopid = prefs.getInt('shopid');
    });
    reviewsDisplay();
  }


  Future<void> reviewsDisplay() async{
    ApiResponse apiResponse = await getRating(token.toString());

    if(apiResponse.error == null){
      setState(() {
        review = apiResponse.data as List<dynamic>;
        ratings = apiResponse.totalstar as Map;
        isLoading = false;
        hasData = review.isNotEmpty;
        totalReviews = review.length;
      });
    } else {
      setState(() {
        isLoading = false;
        hasData = false;
      });
      print('${apiResponse.error}');
    }
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
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    double rate = calculateTotalRate();
    double totalRate = rate / totalReviews;
    print(ratings);
    if(isLoading == true){
      return Scaffold(
          appBar: const ForAppBar(
            title: Text('Reviews'),
          ),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          )
      );
    }

    if(hasData == false){
      return const Scaffold(
          appBar: ForAppBar(
            title: Text('Reviews'),
          ),
          body: Center(
            child: Text(
              'There are no reviews yet.'
            ),
          )
      );
    }

    return Scaffold(
      appBar: const ForAppBar(
        title: Text('Reviews'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('Overall Rating', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        Text('$totalRate', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),),
                        RatingBar.builder(
                          initialRating: totalRate,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          ignoreGestures: true,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        Text('Based on $totalReviews reviews', style: TextStyle(color: ColorStyle.secondary, fontSize: 18)),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                        child: Text(
                                          'Excellent',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: LinearPercentIndicator(
                                        animation: true,
                                        lineHeight: 12.0,
                                        animationDuration: 100,
                                        percent: ratings['five_star'] / totalRate,
                                        barRadius: Radius.circular(20),
                                        progressColor: ColorStyle.tertiary,
                                      ),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                        child: Text(
                                          'Good',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: LinearPercentIndicator(
                                        animation: true,
                                        lineHeight: 12.0,
                                        animationDuration: 100,
                                        percent: ratings['four_star'] / totalRate,
                                        barRadius: Radius.circular(20),
                                        progressColor: ColorStyle.tertiary,
                                      ),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                        child: Text(
                                          'Average',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: LinearPercentIndicator(
                                        animation: true,
                                        lineHeight: 12.0,
                                        animationDuration: 100,
                                        percent: ratings['three_star'] / totalRate,
                                        barRadius: Radius.circular(20),
                                        progressColor: ColorStyle.tertiary,
                                      ),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                        child: Text(
                                          'Poor',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: LinearPercentIndicator(
                                        animation: true,
                                        lineHeight: 12.0,
                                        animationDuration: 100,
                                        percent: ratings['two_star'] / totalRate,
                                        barRadius: Radius.circular(20),
                                        progressColor: ColorStyle.tertiary,
                                      ),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                        child: Text(
                                          'Very Poor',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: LinearPercentIndicator(
                                        animation: true,
                                        lineHeight: 12.0,
                                        animationDuration: 100,
                                        percent: ratings['one_star'] / totalRate,
                                        barRadius: Radius.circular(20),
                                        progressColor: ColorStyle.tertiary,
                                      ),)
                                  ],
                                ),
                              ],
                            )
                        ),


                      ],
                    ),
                  ),
              ),
              const SizedBox(height: 10,),
              Container(
                color: Colors.white,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: review.length,
                    itemBuilder: (context, index){
                      Map rev = review[index] as Map;
                      bool hasImage = rev['Image'] != null;
                      print(rev);
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: hasImage
                                      ? NetworkImage('$picaddress/${rev['Image']}')
                                      : AssetImage('assets/user.png') as ImageProvider,
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                ),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${rev['CustomerName']}', style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text('${rev['DateIssued']}', textDirection: TextDirection.rtl,)
                                        ],
                                      ),
                                      RatingBar.builder(
                                        initialRating: double.tryParse('${rev['Rate']}')!.toDouble(),
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 15,
                                        ignoreGestures: true,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      const SizedBox(height: 5,),
                                      rev['Comment'] == null
                                          ? const SizedBox()
                                          : Text('${rev['Comment']}',),
                                    ],
                                  ),
                                ),)
                              ],
                            ),
                          ],
                        ),
                      );

                    }
                ),
              )
            ],
          ),
        ),
        ),
    );
  }
}

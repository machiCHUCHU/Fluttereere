

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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

    if(isLoading == true){
      return Scaffold(
          appBar: AppBar(
            title: const Text('Service Rating'),
            titleTextStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold
            ),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
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
      return Scaffold(
          appBar: AppBar(
            title: const Text('Service Rating'),
            titleTextStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold
            ),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          const Text('0',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),selectionColor: Colors.red,),
                          RatingBar.builder(
                            initialRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 14,
                            ignoreGestures: true,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.orange.shade300,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                      const SizedBox(width: 15,),
                      Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text('5 star(0)'),
                                  Expanded(child: LinearPercentIndicator(
                                    animation: true,
                                    lineHeight: 12.0,
                                    animationDuration: 100,
                                    percent: 0,
                                    barRadius: const Radius.circular(20),
                                    progressColor: Colors.orange.shade300,
                                  ))
                                ],),
                              Row(
                                children: [
                                  const Text('4 star(0)'),
                                  Expanded(child: LinearPercentIndicator(
                                    animation: true,
                                    lineHeight: 12.0,
                                    animationDuration: 100,
                                    percent: 0,
                                    barRadius: const Radius.circular(20),
                                    progressColor: Colors.orange.shade300,
                                  ))
                                ],),
                              Row(
                                children: [
                                  const Text('3 star(0)'),
                                  Expanded(child: LinearPercentIndicator(
                                    animation: true,
                                    lineHeight: 12.0,
                                    animationDuration: 100,
                                    percent: 0,
                                    barRadius: const Radius.circular(20),
                                    progressColor: Colors.orange.shade300,
                                  ))
                                ],),
                              Row(
                                children: [
                                  const Text('2 star(0)'),
                                  Expanded(child: LinearPercentIndicator(
                                    animation: true,
                                    lineHeight: 12.0,
                                    animationDuration: 100,
                                    percent: 0,
                                    barRadius: const Radius.circular(20),
                                    progressColor: Colors.orange.shade300,
                                  ))
                                ],),
                              Row(
                                children: [
                                  const Text('1 star(0)'),
                                  Expanded(child: LinearPercentIndicator(
                                    animation: true,
                                    lineHeight: 12.0,
                                    animationDuration: 100,
                                    percent: 0,
                                    barRadius: const Radius.circular(20),
                                    progressColor: Colors.orange.shade300,
                                  ))
                                ],),
                            ],
                          ))
                    ],
                  ),
                ),
                const Center(
                  child: Text('No Reviews Yet'),
                )
              ],
            ),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Rating'),
        titleTextStyle: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text('${(ratings['rate_sum']/ratings['rater']).toStringAsFixed(1)}',style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),selectionColor: Colors.red,),
                      RatingBar.builder(
                        initialRating: ratings['rate_sum']/ratings['rater'],
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 14,
                        ignoreGestures: true,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.orange.shade300,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                      child: Column(
                    children: [
                      Row(
                        children: [
                        Text('5 star(${ratings['five_star']})'),
                        Expanded(child: LinearPercentIndicator(
                          animation: true,
                          lineHeight: 12.0,
                          animationDuration: 100,
                          percent: ratings['five_star'] / ratings['rater'],
                          barRadius: const Radius.circular(20),
                          progressColor: Colors.orange.shade300,
                        ))
                      ],),
                      Row(
                        children: [
                          Text('4 star(${ratings['four_star']})'),
                          Expanded(child: LinearPercentIndicator(
                            animation: true,
                            lineHeight: 12.0,
                            animationDuration: 100,
                            percent: ratings['four_star'] / ratings['rater'],
                            barRadius: const Radius.circular(20),
                            progressColor: Colors.orange.shade300,
                          ))
                        ],),
                      Row(
                        children: [
                          Text('3 star(${ratings['three_star']})'),
                          Expanded(child: LinearPercentIndicator(
                            animation: true,
                            lineHeight: 12.0,
                            animationDuration: 100,
                            percent: ratings['three_star'] / ratings['rater'],
                            barRadius: const Radius.circular(20),
                            progressColor: Colors.orange.shade300,
                          ))
                        ],),
                      Row(
                        children: [
                          Text('2 star(${ratings['two_star']})'),
                          Expanded(child: LinearPercentIndicator(
                            animation: true,
                            lineHeight: 12.0,
                            animationDuration: 100,
                            percent: ratings['two_star'] / ratings['rater'],
                            barRadius: const Radius.circular(20),
                            progressColor: Colors.orange.shade300,
                          ))
                        ],),
                      Row(
                        children: [
                          Text('1 star(${ratings['one_star']})'),
                          Expanded(child: LinearPercentIndicator(
                            animation: true,
                            lineHeight: 12.0,
                            animationDuration: 100,
                            percent: ratings['one_star'] / ratings['rater'],
                            barRadius: const Radius.circular(20),
                            progressColor: Colors.orange.shade300,
                          ))
                        ],),
                    ],
                  ))
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: review.length,
                itemBuilder: (context, index){
                  Map rev = review[index] as Map;
                  bool hasImage = rev['Image'] != null;
                  print(rev);
                  return Container(
                    height: MediaQuery.of(context).size.height *.2,
                    decoration: const BoxDecoration(
                        color: Colors.white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Divider(height: 0,),
                        const SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 5),
                            ProfilePicture(
                                name: '${rev['CustomerName']}',
                                radius: 16,
                                fontsize: 14,
                                img: hasImage ? '$picaddress/${rev['CustomerImage']}' : null,
                            ),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${rev['CustomerName']}', style: const TextStyle(fontWeight: FontWeight.bold),),
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
                                      color: Colors.orange.shade300,
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
          ],
        ),
      )
    );
  }
}

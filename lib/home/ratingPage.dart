import 'dart:convert';

import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/drawer/ownerDrawer.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  String? token;
  int? shopid;
  String one_star = '';
  String two_star = '';
  String three_star = '';
  String four_star = '';
  String five_star = '';
  String total_star = '';
  String mark = '';

  double one_star_double = 0.0;
  double two_star_double = 0.0;
  double three_star_double = 0.0;
  double four_star_double = 0.0;
  double five_star_double = 0.0;
  double total_star_double = 0.0;

  List<dynamic> review = [];
  bool showMore = false;
  bool isLoading = true;
  bool hasData = false;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      shopid = prefs.getInt('shopid');
    });

    starRatingCount();
    reviewsDisplay();
  }

  Future<void> starRatingCount() async{
    ApiResponse apiResponse = await getRatingCount(token.toString());



    if(apiResponse.error == null){
      setState(() {

      });

      if(total_star_double == 0.0){
        setState(() {
          mark = 'No Ratings Yet';
        });
      }else if(total_star_double >= 0.1 && total_star_double <= 1.0){
        setState(() {
          mark = 'Very Poor';
        });
      }else if(total_star_double >= 1.1 && total_star_double <= 2.0){
        setState(() {
          mark = 'Poor';
        });
      }else if(total_star_double >= 2.1&& total_star_double <= 3.0){
        setState(() {
          mark = 'Average';
        });
      }else if(total_star_double >= 3.1 && total_star_double <= 4.0){
        setState(() {
          mark = 'Very Good';
        });
      }else{
        setState(() {
          mark = 'Excellent';
        });
      }
    } else {
      setState(() {

      });
      print('${apiResponse.error}');
    }
  }

  Future<void> reviewsDisplay() async{
    ApiResponse apiResponse = await getRating(token.toString());

    if(apiResponse.error == null){
      setState(() {
        review = apiResponse.data as List<dynamic>;
        isLoading = false;
        hasData = review.isNotEmpty;
      });
    } else {
      setState(() {
        isLoading = false;
        hasData = false;
      });
      print('${apiResponse.error}');
    }
  }

  void expandImageDialog(String ratingimage){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero
            ),
            child: Stack(
              children: [
                InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image.memory(

                      base64Decode(ratingimage)
                  ),
                ),
                Positioned(
                  top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                          Icons.close_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                )
              ],
            )
          );
        }
    );
  }

  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Scaffold(
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
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellowAccent,
                                size: 100,
                              ),
                              Text(
                                '${total_star_double}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                          Text(
                            'No Ratings',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Text('5 star'),
                              LinearPercentIndicator(
                                width: 180,
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 1000,
                                percent: four_star_double,
                                center: Text("${five_star_double * 100}%"),
                                progressColor: Colors.yellowAccent,
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child:  Row(
                                children: [
                                  const Text('4 star'),
                                  LinearPercentIndicator(
                                    width: 180,
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 1000,
                                    percent: four_star_double,
                                    center: Text("${four_star_double * 100}%"),
                                    progressColor: Colors.yellowAccent,
                                  ),
                                ],
                              )
                          ),
                          Row(
                            children: [
                              const Text('3 star'),
                              LinearPercentIndicator(
                                width: 180,
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 1000,
                                percent: three_star_double,
                                center: Text("${three_star_double * 100}%"),
                                progressColor: Colors.yellowAccent,
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child:  Row(
                                children: [
                                  const Text('2 star'),
                                  LinearPercentIndicator(
                                    width: 180,
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 1000,
                                    percent: two_star_double,
                                    center: Text('${two_star_double * 100}%'),
                                    progressColor: Colors.yellowAccent,
                                  ),
                                ],
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child:  Row(
                                children: [
                                  const Text('1 star'),
                                  LinearPercentIndicator(
                                    width: 180,
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 1000,
                                    percent: one_star_double,
                                    center: Text("${one_star_double * 100}%"),
                                    progressColor: Colors.yellowAccent,
                                  ),
                                ],
                              )
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Text(
                'No Reviews Yet.',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          )
      );
    }

    return Scaffold(
      body: Column(
          children: [
             Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellowAccent,
                              size: 100,
                            ),
                            Text(
                                '${total_star_double}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        Text(
                          '${mark}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              const Text('5 star'),
                              LinearPercentIndicator(
                                width: 180,
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 1000,
                                percent: five_star_double,
                                center: Text("${five_star_double * 100}%"),
                                progressColor: Colors.yellowAccent,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child:  Row(
                              children: [
                                const Text('4 star'),
                                LinearPercentIndicator(
                                  width: 180,
                                  animation: true,
                                  lineHeight: 20.0,
                                  animationDuration: 1000,
                                  percent: four_star_double,
                                  center: Text("${four_star_double * 100}%"),
                                  progressColor: Colors.yellowAccent,
                                ),
                              ],
                            )
                        ),
                        Row(
                              children: [
                                const Text('3 star'),
                                LinearPercentIndicator(
                                  width: 180,
                                  animation: true,
                                  lineHeight: 20.0,
                                  animationDuration: 1000,
                                  percent: three_star_double,
                                  center: Text("${three_star_double * 100}%"),
                                  progressColor: Colors.yellowAccent,
                                ),
                              ],
                            ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child:  Row(
                              children: [
                                const Text('2 star'),
                                LinearPercentIndicator(
                                  width: 180,
                                  animation: true,
                                  lineHeight: 20.0,
                                  animationDuration: 1000,
                                  percent: two_star_double,
                                  center: Text('${two_star_double * 100}%'),
                                  progressColor: Colors.yellowAccent,
                                ),
                              ],
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child:  Row(
                            children: [
                              const Text('1 star'),
                              LinearPercentIndicator(
                                width: 180,
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 1000,
                                percent: one_star_double,
                                center: Text("${one_star_double * 100}%"),
                                progressColor: Colors.yellowAccent,
                              ),
                            ],
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: review.length,
                      itemBuilder: (context, index){
                        Map rate = review[index] as Map;

                        bool hasPicture = rate['Image'].isNotEmpty && rate['Image'] != null;
                        bool hasRatingImage = rate['RatingImage'].isNotEmpty && rate['RatingImage'] != null;
                        bool expandText = false;

                        if(rate['RatingImage'].length == 100){
                          setState(() {
                            expandText = !expandText;
                          });
                        }

                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: hasPicture
                                        ? MemoryImage(base64Decode('${rate['Image']}')) as ImageProvider<Object>
                                        : AssetImage('assets/pepe.png') as ImageProvider<Object>,
                                    radius: 18,
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${rate['Name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        RatingBar(
                                          initialRating: double.parse('${rate['Rate']}'),
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemCount: 5,
                                          itemSize: 15,
                                          ratingWidget: RatingWidget(
                                            full: Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            half: Icon(Icons.star_half),
                                            empty: Icon(
                                              Icons.star_border,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                          onRatingUpdate: (rating) {
                                          },
                                          ignoreGestures: true,
                                        ),
                                        Text(
                                          '${rate['Comment']}',
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.justify,
                                          softWrap: true,
                                        ),
                                        InkWell(
                                          onTap: (){
                                            expandImageDialog('${rate['RatingImage']}');
                                          },
                                          child: ClipRRect(
                                            child: hasRatingImage
                                                ? Image.memory(
                                                width: 100,
                                                height: 100,
                                                base64Decode('${rate['RatingImage']}')
                                            )
                                                : SizedBox.shrink(),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                              )
                            ],
                          )
                        );
                      }
                  ),
                )
            )
          ],
        ),
    );
  }
}

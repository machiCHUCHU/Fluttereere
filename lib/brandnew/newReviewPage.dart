

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/ConstWidgets.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:group_button/group_button.dart';
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
  Map data = {};



  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      shopid = prefs.getInt('shopid');
    });
    reviewsDisplay();
  }


  Future<void> reviewsDisplay() async{
    ApiResponse response = await getRating(selectedRate,token.toString());

    if(response.error == null){
      setState(() {
        data = response.data as Map;
        review = data['ratings'];
        isLoading = false;
        hasData = review.isNotEmpty;
        totalReviews = review.length;
      });
    } else {
      setState(() {
        isLoading = false;
        hasData = false;
      });
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  final GroupButtonController _controller = GroupButtonController(
    selectedIndex: 0,
  );
  String selectedRate = '';

  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading == true){
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: backAppBar(context, 'Service Rating'),
          ),
          body: loading()
      );
    }

    if(hasData == false){
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: backAppBar(context, 'Service Rating'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 1,
                            color: Colors.grey
                        )
                      ]
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text('${((data['star_counts']['rate_sum'] ?? 0)/data['star_counts']['rater']).toStringAsFixed(1)}',style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),selectionColor: Colors.red,),
                          RatingBar.builder(
                            initialRating: data['star_counts']['rate_sum']/data['star_counts']['rater'],
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
                              GroupButton(
                                controller: _controller,
                                isRadio: true,
                                onSelected: (selected, index, isSelected){
                                  switch(index){
                                    case 0:
                                      selectedRate = '0';
                                      break;
                                    case 1:
                                      selectedRate = '5';
                                      break;
                                    case 2:
                                      selectedRate = '4';
                                      break;
                                    case 3:
                                      selectedRate = '3';
                                      break;
                                    case 4:
                                      selectedRate = '2';
                                      break;
                                    default:
                                      selectedRate = '1';
                                      break;
                                  }
                                  setState(() {
                                  });
                                  reviewsDisplay();
                                },

                                buttons: [
                                  "All (${data['star_counts']['rater']})", "5 Star (${data['star_counts']['five_star']})",
                                  "4 Star (${data['star_counts']['four_star']})", "3 Star (${data['star_counts']['three_star']})",
                                  "2 Star (${data['star_counts']['two_star']})", "1 Star (${data['star_counts']['one_star']})"
                                ],
                                buttonBuilder: (selected, value, context) {
                                  return Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: selected ? Colors.white : Colors.grey.shade200,
                                        border: Border.all(
                                            color: selected ? ColorStyle.tertiary : Colors.grey,
                                            width: 1
                                        ),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: selected ? ColorStyle.tertiary : Colors.black,
                                          fontSize: 8
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                const Center(
                  child: Text('No Reviews Yet'),
                )
              ],
            ),
          )
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Service Rating'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey
                    )
                  ]
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text('${((data['star_counts']['rate_sum'] ?? 0)/data['star_counts']['rater']).toStringAsFixed(1)}',style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),selectionColor: Colors.red,),
                      RatingBar.builder(
                        initialRating: data['star_counts']['rate_sum']/data['star_counts']['rater'],
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
                      GroupButton(
                        controller: _controller,
                        isRadio: true,
                        onSelected: (selected, index, isSelected){
                          switch(index){
                            case 0:
                              selectedRate = '0';
                              break;
                            case 1:
                              selectedRate = '5';
                              break;
                            case 2:
                              selectedRate = '4';
                              break;
                            case 3:
                              selectedRate = '3';
                              break;
                            case 4:
                              selectedRate = '2';
                              break;
                            default:
                              selectedRate = '1';
                              break;
                          }
                          setState(() {
                          });
                          reviewsDisplay();
                        },

                        buttons: [
                          "All (${data['star_counts']['rater']})", "5 Star (${data['star_counts']['five_star']})",
                          "4 Star (${data['star_counts']['four_star']})", "3 Star (${data['star_counts']['three_star']})",
                          "2 Star (${data['star_counts']['two_star']})", "1 Star (${data['star_counts']['one_star']})"
                        ],
                        buttonBuilder: (selected, value, context) {
                          return Container(
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                              color: selected ? Colors.white : Colors.grey.shade200,
                              border: Border.all(
                                color: selected ? ColorStyle.tertiary : Colors.grey,
                                width: 1
                              ),
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: selected ? ColorStyle.tertiary : Colors.black
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ))
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1
                  )
                ]
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: review.length,
                  itemBuilder: (context, index){
                    Map rev = review[index] as Map;
                    bool hasImage = rev['Image'] != null;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height *.2,
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
            )
          ],
        ),
      )
    );
  }
}

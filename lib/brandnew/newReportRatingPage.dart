import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/services/servicesadd.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NewReportRatingScreen extends StatefulWidget {
  const NewReportRatingScreen({super.key});

  @override
  State<NewReportRatingScreen> createState() => _NewReportRatingScreenState();
}

class _NewReportRatingScreenState extends State<NewReportRatingScreen> {
  Map ratings = {}; bool isLoading = true; Map perf = {}; bool hasReviews = false; List<dynamic> newreviews = [];

  Future<void> reviewsDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse apiResponse = await getRating('','${prefs.getString('token')}');

    if(apiResponse.error == null){
      setState(() {
        ratings = apiResponse.totalstar as Map;

      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> performanceDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse apiResponse = await shopPerformance('${prefs.getString('token')}');

    if(apiResponse.error == null){
      setState(() {
        perf = apiResponse.data as Map;
        isLoading = false;
      });
    } else {
      setState(() {

      });
    }
  }

  Future<void> newRatingsDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse apiResponse = await getNewRatings('${prefs.getString('token')}');

    if(apiResponse.error == null){
      setState(() {
        newreviews = apiResponse.data as List<dynamic>;
        hasReviews = newreviews.isNotEmpty;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    reviewsDisplay();
    newRatingsDisplay();
    performanceDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totRate = (perf['total_raters'] ?? 0) > 0
        ? double.tryParse('${((perf['sumrating'] ?? 0) / (perf['total_raters'] ?? 0)).toStringAsFixed(1)}') ?? 0
        : 0;

    double prevTotRate = (perf['prevtotal'] ?? 0) > 0
        ? double.tryParse('${((perf['prevsum'] ?? 0) / (perf['prevtotal'] ?? 0)).toStringAsFixed(1)}') ?? 0
        : 0;

    String rate = ((totRate - prevTotRate) * 100).toStringAsFixed(0);
    Color avgStar;
    Color up;
    if(double.tryParse(rate)! > 0){
      up = Colors.green;
    }else if(double.tryParse(rate)! < 0){
      up = Colors.redAccent;
    }else{
      up = Colors.grey;
    }
    if(totRate > 0 && totRate <=1){
      avgStar = Colors.redAccent;
    }else if(totRate > 1.1 && totRate <=2){
      avgStar = Colors.orange;
    }else if(totRate > 2.1 && totRate <=3){
      avgStar = Colors.yellow;
    }else if(totRate > 3.1 && totRate <=4){
      avgStar = Colors.lime;
    }else {
      avgStar = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Rating'),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: isLoading
          ? loading()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ColorStyle.tertiary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Average Rate',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Colors.grey
                  ),
                ],
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text('${(perf['total_raters']) > 0
                          ? (perf['sumrating'] / perf['total_raters']).toStringAsFixed(1)
                          : '0.0'}',
                        style: const TextStyle(
                            fontSize: 22
                        ),),
                      RatingBar(
                        ignoreGestures: true,
                        itemPadding: const EdgeInsets.all(0),
                        itemSize: 20,
                        allowHalfRating: true,
                        initialRating: double.tryParse('${(perf['sumrating'] ?? 0/perf['total_raters']).toStringAsFixed(1)}') ?? 0,
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star, color:avgStar),
                          half: Icon(Icons.star_half, color: avgStar),
                          empty: const Icon(Icons.star_border_outlined, color: Colors.grey),
                        ),
                        onRatingUpdate: (double value) {},
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_drop_up,size: 52,color: up,),
                      Text(
                        '$rate%',
                        style: TextStyle(
                          fontSize: 24,
                          color: up
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 15,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Rating Distribution',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Colors.grey
                  )
                ]
              ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 175,
                      width: 175,
                      child: SfCircularChart(
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CircularSeries<_DoughnutChart, String>>[
                          DoughnutSeries<_DoughnutChart, String>(
                            dataSource: [
                              _DoughnutChart('5 star', double.tryParse('${ratings['five_star']}') ?? 0, Colors.green),
                              _DoughnutChart('4 star', double.tryParse('${ratings['four_star']}') ?? 0,Colors.lime),
                              _DoughnutChart('3 star', double.tryParse('${ratings['three_star']}') ?? 0,Colors.yellow),
                              _DoughnutChart('2 star', double.tryParse('${ratings['two_star']}') ?? 0,Colors.orangeAccent),
                              _DoughnutChart('5 star', double.tryParse('${ratings['one_star']}') ?? 0,Colors.redAccent),
                            ],
                            xValueMapper: (_DoughnutChart data, _) => data.x,
                            yValueMapper: (_DoughnutChart data, _) => data.y,
                            pointColorMapper: (_DoughnutChart data, _) => data.color,
                            explode: true,
                            explodeAll: true,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Star Ratings
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 5 Star
                          Row(
                            children: [
                              Text('5 star(${ratings['five_star']})'),
                              Expanded(
                                child: RatingBar(
                                  ignoreGestures: true,
                                  itemPadding: const EdgeInsets.all(0),
                                  itemSize: 20,
                                  initialRating: 5,
                                  ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star, color: Colors.green),
                                    half: const Icon(Icons.star_half, color: Colors.white),
                                    empty: const Icon(Icons.star_border_outlined, color: Colors.grey),
                                  ),
                                  onRatingUpdate: (double value) {},
                                ),
                              ),
                            ],
                          ),
                          // 4 Star
                          Row(
                            children: [
                              Text('4 star(${ratings['four_star']})'),
                              Expanded(
                                child: RatingBar(
                                  ignoreGestures: true,
                                  itemPadding: const EdgeInsets.all(0),
                                  itemSize: 20,
                                  initialRating: 4,
                                  ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star, color: Colors.lime),
                                    half: const Icon(Icons.star_half, color: Colors.white),
                                    empty: const Icon(Icons.star_border_outlined, color: Colors.grey),
                                  ),
                                  onRatingUpdate: (double value) {},
                                ),
                              ),
                            ],
                          ),
                          // 3 Star
                          Row(
                            children: [
                              Text('3 star(${ratings['three_star']})'),
                              Expanded(
                                child: RatingBar(
                                  ignoreGestures: true,
                                  itemPadding: const EdgeInsets.all(0),
                                  itemSize: 20,
                                  initialRating: 3,
                                  ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star, color: Colors.yellow),
                                    half: const Icon(Icons.star_half, color: Colors.white),
                                    empty: const Icon(Icons.star_border_outlined, color: Colors.grey),
                                  ),
                                  onRatingUpdate: (double value) {},
                                ),
                              ),
                            ],
                          ),
                          // 2 Star
                          Row(
                            children: [
                              Text('2 star(${ratings['two_star']})'),
                              Expanded(
                                child: RatingBar(
                                  ignoreGestures: true,
                                  itemPadding: const EdgeInsets.all(0),
                                  itemSize: 20,
                                  initialRating: 2,
                                  ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star, color: Colors.orangeAccent),
                                    half: const Icon(Icons.star_half, color: Colors.white),
                                    empty: const Icon(Icons.star_border_outlined, color: Colors.grey),
                                  ),
                                  onRatingUpdate: (double value) {},
                                ),
                              ),
                            ],
                          ),
                          // 1 Star
                          Row(
                            children: [
                              Text('1 star(${ratings['one_star']})'),
                              Expanded(
                                child: RatingBar(
                                  ignoreGestures: true,
                                  itemPadding: const EdgeInsets.all(0),
                                  itemSize: 20,
                                  initialRating: 1,
                                  ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star, color: Colors.redAccent),
                                    half: const Icon(Icons.star_half, color: Colors.white),
                                    empty: const Icon(Icons.star_border_outlined, color: Colors.grey),
                                  ),
                                  onRatingUpdate: (double value) {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )

            ),
            const SizedBox(height: 15,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Today\'s Rating',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 500
                ),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey
                    )
                  ]
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: hasReviews
                    ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: newreviews.length,
                    itemBuilder: (context,index){
                      Map rev = newreviews[index] as Map;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            RowItem(
                                title: Row(
                                  children: [
                                    ProfilePicture(
                                        name: '${rev['CustomerName']}',
                                        radius: 24,
                                        fontsize: 16
                                    ),
                                    Expanded(child: Text(' ${rev['CustomerName']}',overflow: TextOverflow.ellipsis,))
                                  ],
                                ),
                                description: RatingBar(
                                  ignoreGestures: true,
                                  itemPadding: const EdgeInsets.all(0),
                                  itemSize: 16,
                                  allowHalfRating: true,
                                  initialRating: double.tryParse('${rev['Rate']}') ?? 0,
                                  ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star, color:Colors.yellow),
                                    half: const Icon(Icons.star_half, color: Colors.yellow),
                                    empty: const Icon(Icons.star_border_outlined, color: Colors.grey),
                                  ),
                                  onRatingUpdate: (double value) {},
                                )
                            ),

                          ],
                        ),
                      );
                    }
                )
                    : const Text('No New Reviews',textAlign: TextAlign.center,),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ReviewData {
  ReviewData(this.time, this.rates);
  final String time;
  final double rates;
}

class _DoughnutChart {
  _DoughnutChart(this.x, this.y,this.color);

  final String x;
  final double y;
  final Color color;
}

List<Color> donutColors = [
  Colors.green,
  Colors.lime,
  Colors.yellow,
  Colors.orange,
  Colors.red,
];
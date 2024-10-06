import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCustomerRatingScreen extends StatefulWidget {
  final String bookId;
  final String shopId;
  const NewCustomerRatingScreen({super.key, required this.bookId, required this.shopId});

  @override
  State<NewCustomerRatingScreen> createState() => _NewCustomerRatingScreenState();
}

class _NewCustomerRatingScreenState extends State<NewCustomerRatingScreen> {
  final TextEditingController _comment = TextEditingController();
  int star = 0;
  String scale = '';

  Future<void> ratingSubmission() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await submitReview(
        star.toString(), _comment.text, widget.bookId, widget.shopId, '${prefs.getString('token')}'
    );

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context, true);
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  bool emptyRate(){
    if(star == 0){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Service'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
        actions: [
          TextButton(
              onPressed: emptyRate()
                  ? null
                  : (){
                ratingSubmission();
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white
                ),
              )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      RatingBar.builder(
                        direction: Axis.horizontal,
                        minRating: 1,
                        itemCount: 5,
                        itemSize: 38,
                        glow: false,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        onRatingUpdate: (rating) {
                          star = rating.toInt();

                          switch(star){
                            case 1:
                              scale = 'Poor';
                              break;
                            case 2:
                              scale = 'Good';
                              break;
                            case 3:
                              scale = 'Very Good';
                              break;
                            case 4:
                              scale = 'Great';
                              break;
                            case 5:
                              scale = 'Excellent';
                              break;
                          }
                          setState(() {
                            star;
                            scale;
                          });
                        },
                      ),
                      Text(scale,style: const TextStyle(fontSize: 18),)
                    ],
                  )
                )
              ),
              TextField(
                controller: _comment,
                maxLines: null,
                minLines: 1,
                maxLength: 160,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 10,
                      color: Colors.black
                    )
                  ),
                  hintText: 'Write a Review...'
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ViewRatingScreen extends StatefulWidget {
  final String bookId;
  const ViewRatingScreen({super.key, required this.bookId});

  @override
  State<ViewRatingScreen> createState() => _ViewRatingScreenState();
}

class _ViewRatingScreenState extends State<ViewRatingScreen> {
  List<dynamic> rating = [];
  Map review = {};
  bool hasImage = false;
  bool isLoading = true;

  Center loading(){
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 50,
      ),
    );
  }

  Future<void> reviewDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await viewReview(widget.bookId, '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        rating = response.data as List<dynamic>;
        review = rating[0] as Map;
        hasImage = review['CustomerImage'] != null;
        isLoading = false;
      });
    }else{

    }
  }

  @override
  void initState(){
    super.initState();
    reviewDisplay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Rating'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? loading()
            : Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height *.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: Colors.black
              )
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: hasImage
                      ? NetworkImage('$picaddress/${review['CustomerImage']}')
                      : const AssetImage('assets/user.png') as ImageProvider,
                  radius: 20,
                ),
                title: Text('${review['CustomerName']}'),
                titleTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black
                ),
                subtitle: RatingBar(
                    ratingWidget: RatingWidget(
                      full: const Icon(Icons.star, color: Colors.amber),
                      half: const SizedBox.shrink(),
                      empty: const Icon(Icons.star_border, color: Colors.grey),
                    ),
                    itemSize: 14,
                    initialRating: double.parse('${review['Rate']}'),
                    onRatingUpdate: (value){
                    }
                ),
                contentPadding: const EdgeInsets.all(2),
                trailing: Text('${review['DateIssued']}'),

              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text('${review['Comment'] ?? ''}',),
              )
            ],
          ),
        ),
      )
    );
  }
}

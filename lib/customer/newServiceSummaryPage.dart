
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/services/timelineservices.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'newLaundryStatement.dart';

class NewServiceSummaryScreen extends StatefulWidget {
  final String bookId;
  const NewServiceSummaryScreen({super.key, required this.bookId});

  @override
  State<NewServiceSummaryScreen> createState() => _NewServiceSummaryScreenState();
}

class _NewServiceSummaryScreenState extends State<NewServiceSummaryScreen> {
  List<dynamic> summary = []; List<dynamic> timeline = []; String stat = '';
  Map summ = {};
  bool isLoading = true;

  Future<void> summaryDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getSummary(widget.bookId, '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        summary = response.data as List<dynamic>;
        summ = summary[0] as Map;

      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> timelineDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getTimelines(widget.bookId,'${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        timeline = response.data as List<dynamic>;
        isLoading = false;
      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }


  int activeStep = 0;



  @override
  void initState(){
    super.initState();
    summaryDisplay();
    timelineDisplay();
  }
  @override
  Widget build(BuildContext context) {
   if(isLoading){

   }else{
     if(int.parse('${summ['Status']}''${summ['Status']}') == 0){
       stat = 'Start of Laundry Service: ${summ['Schedule']}';
     }else if(int.parse('${summ['Status']}') >= 4){
       stat = 'Status updated at: ${summ['updated_at']}';
     }else{
       stat = 'Laundry Finished';
     }
   }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
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
             summ['deleted_at'] == null
              ?  Column(
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
                   padding: const EdgeInsets.all(8),
                   child:
                   EasyStepper(
                     borderThickness: 2,
                     internalPadding: 0,
                     activeStep: int.parse('${summ['Status']}'),
                     finishedStepTextColor: Colors.black,
                     enableStepTapping: false,
                     showLoadingAnimation: false,
                     stepRadius: 17,
                     activeStepTextColor: ColorStyle.tertiary,
                     activeStepBorderType: BorderType.normal,
                     activeStepBorderColor: ColorStyle.tertiary,
                     activeStepIconColor: ColorStyle.tertiary,
                     finishedStepBackgroundColor: ColorStyle.tertiary,
                     lineStyle: const LineStyle(
                       lineLength: 20,
                       lineThickness: 4,
                       lineSpace: 4,
                       lineType: LineType.normal,
                       defaultLineColor: ColorStyle.tertiary,
                       // progressColor: Colors.purple.shade700,
                     ),
                     steps: '${summ['ServiceOffer']}' == 'full' ? full
                         : '${summ['ServiceOffer']}' == 'dry' ? dryonly
                         : '${summ['ServiceOffer']}' == 'wash' ? washonly
                         : washdryonly,
                     onStepReached: (index){
                       setState(() {
                         index = int.parse('${summ['Status']}');
                         activeStep = index;
                       });
                     },
                   ),
                 ),
                 const SizedBox(height: 10,),

                 Container(
                   width: double.infinity,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(5),
                       color: Colors.white,
                       boxShadow: const [
                         BoxShadow(
                             blurRadius: 1,
                             color: Colors.grey
                         )
                       ]
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                           stat,
                           style: const TextStyle(
                               color: ColorStyle.tertiary,
                               fontSize: 16,
                               fontWeight: FontWeight.bold
                           ),),
                       ),
                       const Divider(height: 0,),

                     ],
                   ),
                 ),
                 const SizedBox(height: 10,),
               ],
             )
              : const SizedBox.shrink(),

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
                child: Column(
                  children: [
                    ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            color: ColorStyle.tertiary,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.local_laundry_service,color: Colors.white,),
                        ),
                      titleTextStyle: const TextStyle(color: Colors.black,fontSize: 12),
                      subtitleTextStyle: const TextStyle(color: Colors.grey,fontSize: 12),
                      title: Text('${summ['ServiceName']}'),
                      subtitle: Text(summ['LoadType'] == 'heavy' ? 'Heavy Load'
                          : summ['LoadType'] == 'light' ? 'Light Load' : 'Comforter'),
                      trailing: InkWell(
                        onTap: () async{
                         final response = await Navigator.push(context, MaterialPageRoute(builder: (context)
                         => NewLaundryStatementScreen(bookId: widget.bookId)));

                         if(response == true){
                           summaryDisplay();
                           timelineDisplay();
                         }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'Details',
                              style: TextStyle(fontSize: 12, color: ColorStyle.tertiary),
                            ),
                          ),
                        ),
                      ),

                    ),
                    Divider(height: 0,color: Colors.grey.shade300,),
                    Timeline.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(4),
                        itemCount: timeline.length,
                        itemBuilder: (context, index) {
                          Map time = timeline[index] as Map;

                          return TimelineTile(
                            nodeAlign: TimelineNodeAlign.start,
                            oppositeContents: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${time['timeline']}', style: const TextStyle(fontSize: 12)),
                            ),
                            contents: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${time['Message']}', style: TextStyle(fontSize: 14,color: index != 0  ? Colors.grey : ColorStyle.tertiary,)),
                                  Text('${time['timeline']}', style: TextStyle(fontSize: 12,color: index != 0  ? Colors.grey : ColorStyle.tertiary,)),
                                ],
                              ),
                            ),
                            node: TimelineNode(
                              overlap: true,
                              indicator: DotIndicator(size: 10,color: index != 0 ? Colors.grey : ColorStyle.tertiary,),
                              startConnector: index == 0 ? null : SolidLineConnector(space: 20,color: index != 0  ? Colors.grey : ColorStyle.tertiary,),
                              endConnector: index == timeline.length - 1 ? null : const SolidLineConnector(space: 20,color: Colors.grey,),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

List<EasyStep> washonly= [
  const EasyStep(
    icon: Icon(Icons.more_horiz),
    customTitle: Text('Pending',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
    finishIcon: Icon(Icons.check_sharp),
  ),
  const EasyStep(
      icon: Icon(Icons.water),
      customTitle: Text('Washing',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
  const EasyStep(
      icon: Icon(CupertinoIcons.check_mark_circled),
      customTitle: Text('Complete',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
];

List<EasyStep> dryonly= [
  const EasyStep(
    icon: Icon(Icons.more_horiz),
    customTitle: Text('Pending',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
    finishIcon: Icon(Icons.check_sharp),
  ),
  const EasyStep(
      icon: Icon(CupertinoIcons.wind),
      customTitle: Text('Drying',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
  const EasyStep(
      icon: Icon(CupertinoIcons.check_mark_circled),
      customTitle: Text('Complete',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
];

List<EasyStep> washdryonly= [
  const EasyStep(
    icon: Icon(Icons.more_horiz),
    customTitle: Text('Pending',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
    finishIcon: Icon(Icons.check_sharp),
  ),
  const EasyStep(
      icon: Icon(Icons.water),
      customTitle: Text('Washing',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
  const EasyStep(
      icon: Icon(CupertinoIcons.wind),
      customTitle: Text('Drying',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
  const EasyStep(
      icon: Icon(CupertinoIcons.check_mark_circled),
      customTitle: Text('Complete',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
];

List<EasyStep> full = const [
  EasyStep(
    icon: Icon(Icons.more_horiz),
    customTitle: Text('Pending',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
    finishIcon: Icon(Icons.check_sharp),
  ),
  EasyStep(
      icon: Icon(Icons.water),
      customTitle: Text('Washing',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
  EasyStep(
      icon: Icon(CupertinoIcons.wind),
      customTitle: Text('Drying',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
  EasyStep(
      icon: Icon(Icons.dry_cleaning),
      customTitle: Text('Folding',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
  EasyStep(
      icon: Icon(CupertinoIcons.cube),
      customTitle: Text('Pick-up',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
  EasyStep(
      icon: Icon(CupertinoIcons.check_mark_circled),
      customTitle: Text('Complete',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
      finishIcon: Icon(Icons.check_sharp)
  ),
];
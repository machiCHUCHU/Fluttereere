
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/services/servicesadd.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewServiceTimeScreen extends StatefulWidget {
  const NewServiceTimeScreen({super.key});

  @override
  State<NewServiceTimeScreen> createState() => _NewServiceTimeScreenState();
}

class _NewServiceTimeScreenState extends State<NewServiceTimeScreen> {
  List<dynamic> operation = []; Map op = {}; bool isLoading = true;
  String? usertype;
  String? access;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usertype = prefs.getString('usertype');
      access = prefs.getString('accesstype');
    });
  }

  Future<void> operationDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getOperation('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        operation = response.data as List<dynamic>;
        op = operation[0] as Map;
        isLoading = false;
      });
    }else{
    }
  }

  @override
  void initState() {
    getUser();
    operationDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Time'),
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context,true);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RowItem(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Washing Machine Number',style: TextStyle(color: Colors.grey,fontSize: 12),),
                          Text('${op['WasherQty']} Washer',style: const TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                      description: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Washing Duration',style: TextStyle(color: Colors.grey,fontSize: 12),),
                          Text('${op['WasherTime']} minutes',style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                  ),
                  const SizedBox(height: 10,),
                  RowItem(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Drying Machine Number',style: TextStyle(color: Colors.grey,fontSize: 12),),
                        Text('${op['DryerQty']} Dryer',style: const TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    description: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Drying Duration    ',style: TextStyle(color: Colors.grey,fontSize: 12),),
                        Text('${op['DryerTime']} minutes',style: const TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text('Clothes Folding Duration',style: TextStyle(color: Colors.grey,fontSize: 12),),
                  Text('${op['FoldingTime']} minutes',style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10,),
                  Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              )
                          ),
                          onPressed: usertype == 'owner'
                              ? ()async{
                            final response = await Navigator.push(context, MaterialPageRoute(builder: (context)
                            => EditServiceTimeScreen(washerqty: '${op['WasherQty']}', dryerqty: '${op['DryerQty']}',
                                washertime: '${op['WasherTime']}', dryertime: '${op['DryerTime']}',
                                foldtime: '${op['FoldingTime']}', machineid: '${op['ShopMachineID']}',)));

                            if(response == true){
                              operationDisplay();
                            }
                          }
                              : (){
                            warningTextDialog(context, 'Access Denied', 'You don\'t have permission to edit this information');
                          },
                          child: const Text('Edit Information',style: TextStyle(color: Colors.white),)
                      )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EditServiceTimeScreen extends StatefulWidget {
  final String washerqty; final String dryerqty; final String washertime; final String dryertime;
  final String foldtime; final String machineid;
  const EditServiceTimeScreen({super.key, required this.washerqty, required this.dryerqty, required this.washertime, required this.dryertime, required this.foldtime, required this.machineid});

  @override
  State<EditServiceTimeScreen> createState() => _EditServiceTimeScreenState();
}

class _EditServiceTimeScreenState extends State<EditServiceTimeScreen> {
  final TextEditingController _washerQty = TextEditingController();
  final TextEditingController _dryerQty = TextEditingController();
  final TextEditingController _washerDuration = TextEditingController();
  final TextEditingController _dryerDuration = TextEditingController();
  final TextEditingController _foldDuration = TextEditingController();

  Future<void> updateServiceTime()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await editServiceTime(_washerQty.text, _washerDuration.text, _dryerQty.text,
        _dryerDuration.text, _foldDuration.text, widget.machineid,'${prefs.getString('token')}');

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context,true);
    }else{

    }
  }

  @override
  void initState() {
    _washerQty.text = widget.washerqty;
    _dryerQty.text = widget.dryerqty;
    _dryerDuration.text = widget.dryertime;
    _washerDuration.text = widget.washertime;
    _foldDuration.text = widget.foldtime;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Service Time'),
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
              child: const Text('Washing Machine Quantity',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _washerQty,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                  )
              ),
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Washing Duration (in minutes)',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _washerDuration,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                  )
              ),
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Drying Machine Quantity',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _dryerQty,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                  )
              ),
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Drying Duration (in minutes)',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _dryerDuration,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                  )
              ),
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Folding Duration (in minutes)',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _foldDuration,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                  )
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
              backgroundColor: ColorStyle.tertiary
          ),
          onPressed: (){
            updateServiceTime();
          },
          child: const Text('Edit Service Time',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}


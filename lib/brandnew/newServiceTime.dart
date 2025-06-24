
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/ConstWidgets.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/model/MachineInfo.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
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
  String? usertype; String? access;

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
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Service Time'),
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
                            MachineInfo info = MachineInfo(
                              washerQty: '${op['WasherQty']}', dryerQty: '${op['DryerQty']}', washerTime: '${op['WasherTime']}',
                              dryerTime: '${op['DryerTime']}', foldingTime: '${op['FoldingTime']}', id: '${op['ShopMachineID']}'
                            );
                            
                            final response = await Navigator.push(context, MaterialPageRoute(builder: (context)
                            => EditServiceTimeScreen(info: info,)));

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
  final MachineInfo info;
  
  const EditServiceTimeScreen({super.key, required this.info});

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
    MachineInfo info = MachineInfo(
        washerQty: _washerQty.text, washerTime: _washerDuration.text, dryerQty: _dryerQty.text,
    dryerTime: _dryerDuration.text, foldingTime: _foldDuration.text, id: widget.info.id);
    ApiResponse response = await editServiceTime(info,'${prefs.getString('token')}');

    if(!mounted) return;
    if(response.error == null){
      await successDialog(context, '${response.data}');
      if(!mounted) return;
      Navigator.pop(context,true);
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  @override
  void initState() {
    _washerQty.text = widget.info.washerQty ?? '';
    _dryerQty.text = widget.info.dryerQty ?? '';
    _dryerDuration.text = widget.info.dryerTime ?? '';
    _washerDuration.text = widget.info.washerTime ?? '';
    _foldDuration.text = widget.info.foldingTime ?? '';
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Edit Service Time'),
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


import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone/services/auditservice.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UserLogScreen extends StatefulWidget {
  const UserLogScreen({super.key});

  @override
  State<UserLogScreen> createState() => _UserLogScreenState();
}

class _UserLogScreenState extends State<UserLogScreen> {
  List<dynamic> useraudit = []; List<dynamic> userauditnow = []; bool isLoading = true; bool hasData = false;
  String page = '';

  Future<void> auditDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getAuditUser(page,'${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        useraudit = response.data as List<dynamic>;
        isLoading = false;
        hasData = useraudit.isNotEmpty;
      });
    }else{

    }
  }



  @override
  void initState() {
    auditDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(useraudit);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Log'),
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
      body: isLoading ? loading()
      : SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleSwitch(
              minHeight: 30,
              dividerMargin: 8,
              animationDuration: 800,
              cornerRadius: 5.0,
              activeBgColors: [[ColorStyle.tertiary], [ColorStyle.tertiary]],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.white,
              inactiveFgColor: ColorStyle.tertiary,
              initialLabelIndex: page == '' ? 0 : int.parse(page),
              totalSwitches: 2,
              labels: ['Now', 'All'],
              customTextStyles: [
                TextStyle(
                    fontWeight: FontWeight.bold),
              ],
              radiusStyle: true,
              onToggle: (index) {
                page = index.toString();
               auditDisplay();
              },
            ),
            const SizedBox(height: 20,),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: Text(page == '' || page == '0' ? 'Today\'s Activity' : 'All Activity',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),

            hasData
                ? ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: 500
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1,
                          color: Colors.grey
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1)
                            )
                          ]
                      ),
                      child: Row(
                        children: [
                          Expanded(child: const Text('User')),
                          Expanded(child: const Text('Action')),
                          Expanded(child: const Text('Timestamp',textAlign: TextAlign.end,))
                        ],
                      ),
                    ),

                    Expanded(child: ListView.builder  (
                        shrinkWrap: true,
                        itemCount: useraudit.length,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        itemBuilder: (context, index){
                          Map now = useraudit[index] as Map;

                          return Column(
                            children: [
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(child: Text('${now['User']}')),
                                  Expanded(child: Text('${now['Description']}')),
                                  Expanded(child: Text('${now['timestamp']}',textAlign: TextAlign.end,))
                                ],
                              ),

                            ],
                          );
                        }
                    ))
                  ],
                ),
              ),
            )
                :  Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey
                    )
                  ]
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('No Activity Yet',textAlign: TextAlign.center,),
            ),
            const SizedBox(height: 30,),


          ],
        ),
      ),
    );
  }
}

class InventoryLogScreen extends StatefulWidget {
  const InventoryLogScreen({super.key});

  @override
  State<InventoryLogScreen> createState() => _InventoryLogScreenState();
}

class _InventoryLogScreenState extends State<InventoryLogScreen> {
  List<dynamic> inventoryaudit = []; List<dynamic> inventoryauditnow = []; bool isLoading = true; bool hasData = false;
  String page = '';

  Future<void> inventoryLog() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getAuditInventory(page,'${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        inventoryaudit = response.data as List<dynamic>;
        isLoading = false;
        hasData = inventoryaudit.isNotEmpty;
      });

    }else{
      print(response.data);
    }
  }

  @override
  void initState() {
    inventoryLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(page);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Log'),
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
      body: isLoading ? loading()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleSwitch(
              minHeight: 30,
              dividerMargin: 8,
              animationDuration: 800,
              cornerRadius: 5.0,
              activeBgColors: [[ColorStyle.tertiary], [ColorStyle.tertiary]],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.white,
              inactiveFgColor: ColorStyle.tertiary,
              initialLabelIndex: page == '' ? 0 : int.parse(page),
              totalSwitches: 2,
              labels: ['Now', 'All'],
              customTextStyles: [
                TextStyle(
                    fontWeight: FontWeight.bold),
              ],
              radiusStyle: true,
              onToggle: (index) {
                page = index.toString();
                inventoryLog();
              },
            ),
            const SizedBox(height: 20,),

            hasData
                ? ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .8
                ),
                child: ListView.builder  (
                    shrinkWrap: true,
                    itemCount: inventoryaudit.length,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, index){
                      Map now = inventoryaudit[index] as Map;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 1,
                                    color: Colors.grey
                                )
                              ]
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RowItem(
                                    title: Text('${now['timestamp']}'),
                                    description: now['StockOut'] == 0
                                        ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors.greenAccent.shade400,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Text('Stock-in',style: TextStyle(color: Colors.white),)
                                    )
                                        : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent.shade400,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Text('Stock-out',style: TextStyle(color: Colors.white),)
                                    )
                                ),
                              ),
                              const Divider(height: 0,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RowItem(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Modified By ',style: TextStyle(fontSize: 12,color: Colors.grey)),
                                      Text('${now['ModifiedBy']}',overflow: TextOverflow.visible)
                                    ],
                                  ),
                                  description: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Item Name ',style: TextStyle(fontSize: 12,color: Colors.grey)),
                                      Text('${now['ItemName']}',)
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RowItem(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Stock Available ',style: TextStyle(fontSize: 12,color: Colors.grey)),
                                      Text('${now['StockAvailable']} in-stock pcs',overflow: TextOverflow.visible)
                                    ],
                                  ),
                                  description: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(now['StockOut'] == 0 ? 'Stock-In      ': 'Stock-Out    ',style: TextStyle(fontSize: 12,color: Colors.grey)),
                                      Text(now['StockOut'] == 0 ? '${now['StockIn']} pcs' :'${now['StockOut']} pcs',)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                )
            )
                : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey
                    )
                  ]
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('No Activity Yet',textAlign: TextAlign.center,),
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}

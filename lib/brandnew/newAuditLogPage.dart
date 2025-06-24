
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/ConstWidgets.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/material.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UserLogScreen extends StatefulWidget {
  const UserLogScreen({super.key});

  @override
  State<UserLogScreen> createState() => _UserLogScreenState();
}

class _UserLogScreenState extends State<UserLogScreen> {
  List<dynamic> userAudit = []; List<dynamic> userAuditNow = [];
  bool isLoading = true; bool hasData = false; String page = '';

  Future<void> auditDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getAuditUser(page,'${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        userAudit = response.data as List<dynamic>;
        isLoading = false;
        hasData = userAudit.isNotEmpty;
      });
    }else{
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }
  
  @override
  void initState() {
    auditDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'User Log'),
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
              activeBgColors: const [[ColorStyle.tertiary], [ColorStyle.tertiary]],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.white,
              inactiveFgColor: ColorStyle.tertiary,
              initialLabelIndex: page == '' ? 0 : int.parse(page),
              totalSwitches: 2,
              labels: const ['Now', 'All'],
              customTextStyles: const [
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
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: Text(page == '' || page == '0' ? 'Today\'s Activity' : 'All Activity',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),

            hasData
                ? ConstrainedBox(
              constraints: const BoxConstraints(
                  maxHeight: 500
              ),
              child: Container(
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
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1)
                            )
                          ]
                      ),
                      child: const Row(
                        children: [
                          Expanded(child: Text('User')),
                          Expanded(child: Text('Action')),
                          Expanded(child: Text('Timestamp',textAlign: TextAlign.end,))
                        ],
                      ),
                    ),

                    Expanded(child: ListView.builder  (
                        shrinkWrap: true,
                        itemCount: userAudit.length,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        itemBuilder: (context, index){
                          Map now = userAudit[index] as Map;

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
  List<dynamic> inventoryAudit = []; List<dynamic> inventoryAuditNow = [];
  bool isLoading = true; bool hasData = false; String page = '';

  Future<void> inventoryLog() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getAuditInventory(page,'${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        inventoryAudit = response.data as List<dynamic>;
        isLoading = false;
        hasData = inventoryAudit.isNotEmpty;
      });

    }else{
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  @override
  void initState() {
    inventoryLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Inventory Log'),
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
              activeBgColors: const [[ColorStyle.tertiary], [ColorStyle.tertiary]],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.white,
              inactiveFgColor: ColorStyle.tertiary,
              initialLabelIndex: page == '' ? 0 : int.parse(page),
              totalSwitches: 2,
              labels: const ['Now', 'All'],
              customTextStyles: const [
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
                    itemCount: inventoryAudit.length,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, index){
                      Map now = inventoryAudit[index] as Map;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
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
                                        child: const Text('Stock-in',style: TextStyle(color: Colors.white),)
                                    )
                                        : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent.shade400,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Text('Stock-out',style: TextStyle(color: Colors.white),)
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
                                      const Text('Modified By ',style: TextStyle(fontSize: 12,color: Colors.grey)),
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
                                      const Text('Stock Available ',style: TextStyle(fontSize: 12,color: Colors.grey)),
                                      Text('${now['StockAvailable']} in-stock pcs',overflow: TextOverflow.visible)
                                    ],
                                  ),
                                  description: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(now['StockOut'] == 0 ? 'Stock-In      ': 'Stock-Out    ',style: const TextStyle(fontSize: 12,color: Colors.grey)),
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
                  boxShadow: const [
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

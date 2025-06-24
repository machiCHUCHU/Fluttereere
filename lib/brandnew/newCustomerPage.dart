
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/ConstWidgets.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';


class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  String? token; bool isLoading = true; String page = '';
  String? id; String? status; bool isValued = false; bool hasData = false;
  List<dynamic> topCustomers = []; List<dynamic> restCustomers = [];

  List<Color> topColor = [
    const Color(0xFFFFD700), const Color(0xFFC0C0C0),const Color(0xFFCD7F32),
    const Color(0xFF4169E1), const Color(0xFF50C878)
  ];

  Future<void> customerDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getValuedCustomers(page, '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        topCustomers = response.data as List<dynamic>;
        restCustomers = response.data1 as List<dynamic>;
        isLoading = false;
        hasData = true;
      });
    }else{
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  @override
  void initState() {
    customerDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: backAppBar(context, 'Valued Customers'),
          ),
          body: loading()
      );
    }

    if(hasData == false){
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: backAppBar(context, 'Valued Customers'),
          ),
          body: const Center(
              child: Text(
                  'No list yet. Invite your first customer.'
              )
          )
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Valued Customers'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleSwitch(
                  minWidth: 100,
                  minHeight: 30,
                  animationDuration: 800,
                  cornerRadius: 5.0,
                  activeBgColors: const [[ColorStyle.tertiary], [ColorStyle.tertiary]],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.white,
                  inactiveFgColor: ColorStyle.tertiary,
                  initialLabelIndex: page == '' ? 0 : int.parse(page),
                  totalSwitches: 2,
                  labels: const ['Bookings', 'Walk-in'],
                  customTextStyles: const [
                    TextStyle(
                        fontWeight: FontWeight.bold),
                  ],
                  radiusStyle: true,
                  onToggle: (index) {
                    page = index.toString();
                    setState(() {
                      isLoading = true;
                    });
                    customerDisplay();
                  },
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: ColorStyle.tertiary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Text('Top Customers',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                ),
                Column(
                  children: [
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
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: topCustomers.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            Map top = topCustomers[index] as Map;
                            bool isPage = page == '0' || page == '' ? true : false;

                            return Padding(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: topColor[index],
                                      foregroundColor: Colors.white,
                                      radius: 18,
                                      child: Text('${index + 1}'),
                                    ),
                                    Expanded(child: Text(isPage ? ' ${top['CustomerName']}': ' ${top['ContactNumber']}'),),
                                    Text(isPage ? '${top['total_bookings']} bookings' : '${top['total_walkins']} availed',style: const TextStyle(fontWeight: FontWeight.bold),)
                                  ],
                                )
                            );
                          }
                      ),
                    ),
                    const SizedBox(height: 25,),

                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * .4
                      ),
                      child: Container(
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

                        child: restCustomers.isEmpty
                            ? const Text('No additional records',textAlign: TextAlign.center,)
                            : ListView.builder(
                            shrinkWrap: true,
                            itemCount: restCustomers.length,
                            itemBuilder: (context,index){
                              Map rest = restCustomers[index] as Map;
                              bool isPage = page == '1' ? true : false;

                              return Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: ColorStyle.tertiary,
                                            foregroundColor: Colors.white,
                                            radius: 18,
                                            child: Text('${index + 6}'),
                                          ),
                                          Expanded(child: Text(isPage ? ' ${rest['ContactNumber']}': ' ${rest['CustomerName']}'),),
                                          Text(isPage ? ' ${rest['total_walkins']} availed': ' ${rest['total_bookings']} bookings',style: const TextStyle(fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ],
                                  )
                              );
                            }
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),

      ),
    );
  }
}
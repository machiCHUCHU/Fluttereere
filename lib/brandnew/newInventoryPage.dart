
import 'dart:ui';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/brandnew/setWidget/appbar.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/invStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/signupStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewInventoryScreen extends StatefulWidget {
  const NewInventoryScreen({super.key});

  @override
  State<NewInventoryScreen> createState() => _NewInventoryScreenState();
}

class _NewInventoryScreenState extends State<NewInventoryScreen> {
  List<dynamic> inventory = [];
  String? id;
  bool isLoading = true;
  String? token;
  int? userid;
  int? shopid;
  int? total;
  int? out;
  bool hasData = false;
  String? categoryName;
  bool isDefault = false;

  List<String> category = [
    'Detergent',
    'Fabric Conditioner',
    'Bleach',
    'Fabric Freshener'
  ];

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');

    });

    inventoryDisplay();
  }

  Future<void> inventoryDisplay() async{

    ApiResponse response = await getInventory(token.toString());

    if(response.error == null){
      setState(() {
        inventory = response.data as List<dynamic>;
        out = response.out;
        total = response.total;
        isLoading = false;
        hasData = inventory.isNotEmpty;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      errorDialog(context, '${response.error}');
    }
  }

  Future<void> inventoryDelete(String itemId) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );

    ApiResponse apiResponse = await deleteInventory(
        itemId,
        token.toString()
    );

    Navigator.pop(context);

    if(apiResponse.error == null){
      successDialog(context, 'Item has been deleted.');
      inventoryDisplay();
    }else{
      errorDialog(context, '${apiResponse.error}');
    }

  }

  void _bottomModal(String itemName, String itemQty, String itemId, String itemVol, String volUse, String remVol){
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
          )
      ),
      builder: (context) => SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    itemName,
                    style: InvStyle.modalTitle,
                  ),
                ),
                const Divider(),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RowItem(
                            title: const Row(
                              children: [
                                Icon(Icons.layers,color: Colors.blue,),
                                Text('Quantity', style: InvStyle.modalSubTitle)
                              ],
                            ),
                            description: Text(itemQty,style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          RowItem(
                            title: const Row(
                              children: [
                                Icon(Icons.water_drop, color: Colors.blue,),
                                Text('Volume', style: InvStyle.modalSubTitle)
                              ],
                            ),
                            description: Text(itemVol,style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          RowItem(
                            title: const Row(
                              children: [
                                Icon(Icons.water_drop, color: Colors.blue,),
                                Text('Remaining Volume', style: InvStyle.modalSubTitle,)
                              ],
                            ),
                            description: Text(remVol,style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          RowItem(
                            title: const Row(
                              children: [
                                Icon(Icons.filter_alt_sharp,color: Colors.blue,),
                                Text('Volume Usage', style: InvStyle.modalSubTitle)
                              ],
                            ),
                            description: Text(volUse,style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ),

                Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorStyle.tertiary,
                                  fixedSize: const Size(150, 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  )
                              ),
                              onPressed: () async{
                                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryEditScreen(
                                    itemname: itemName, itemqty: itemQty, itemvolume: itemVol,
                                    id: itemId, volumeuse: volUse, onUpdate: () {
                                      Navigator.of(context).pop();
                                      inventoryDisplay();
                                },)));

                                if(result == true){
                                  await inventoryDisplay();
                                }
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              )
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorStyle.tertiary,
                                  fixedSize: const Size(150, 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  )
                              ),
                              onPressed: (){
                                inventoryDelete(itemId);
                                Navigator.pop(context);
                                inventoryDisplay();
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              )
                          )
                        ],
                      ),
                    )
                )
              ],
            ),
          )
      ),
    );
  }




  @override
  void initState(){
    super.initState();
    getUser();

  }

  @override
  Widget build(BuildContext context) {
    print(out);
    if(isLoading){
      return Scaffold(
          appBar: const ForAppBar(
            title: Text('Inventory'),
          ),
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
        appBar: const ForAppBar(
          title: Text('Inventory'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .12,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$total',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24
                                  ),
                                ),
                                const Text(
                                  'total item',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: ColorStyle.secondary,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$out',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24
                                  ),
                                ),
                                const Text(
                                  'out of stock',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: ColorStyle.secondary,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                  const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            'No detergents are stored. Pleae add.'
                        ),
                      )
                  ),
                ],
              )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorStyle.tertiary,
          tooltip: 'Add Laundry Detergent',
          onPressed: () async{
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryAddScreen()));

            if (result == true) {
              await inventoryDisplay();  // Refresh the inventory list
            }
            print(result);
          },
          child: const Icon(Icons.add, size: 50), // Set icon size here
        ),
      );
    }

    return Scaffold(
      appBar: const ForAppBar(
        title: Text('Inventory'),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .12,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$total',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24
                                ),
                              ),
                              const Text(
                                'total item',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorStyle.secondary,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$out',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24
                                ),
                              ),
                              const Text(
                                'out of stock',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorStyle.secondary,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
                const SizedBox(height: 25,),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: inventory.length,
                    itemBuilder: (context, index){
                      Map inv = inventory[index] as Map;


                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .10,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: ColorStyle.tertiary,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset.zero,
                                    color: Colors.black12,
                                    spreadRadius: .5,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: double.maxFinite,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Container(
                                        width: MediaQuery.of(context).size.width * .25,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${inv['ItemQty']}',
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const Text(
                                                  'qty',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: ColorStyle.secondary
                                                  ),
                                                )
                                              ],
                                            )
                                        )
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${inv['ItemName']}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: (){
                                    _bottomModal(
                                        '${inv['ItemName']}', '${inv['ItemQty']}',
                                        '${inv['InventoryID']}', '${inv['ItemVolume']}', '${inv['VolumeUse']}',
                                        '${inv['RemainingVolume']}'
                                    );
                                  },
                                  icon: const Icon(Icons.more_vert_rounded, color: Colors.white,),
                                ),
                              ))
                            ],
                          ),
                        ),
                      );
                    }
                ),
              ],
            ),
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorStyle.tertiary,
        tooltip: 'Add Laundry Detergent',
        onPressed: () async{
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryAddScreen()));

          if (result == true) {
            await inventoryDisplay();
          }
        },
        child: const Icon(Icons.add, size: 50, color: Colors.white,), // Set icon size here
      ),
    );
  }
}

class InventoryAddScreen extends StatefulWidget {
  const InventoryAddScreen({super.key});

  @override
  State<InventoryAddScreen> createState() => _InventoryAddScreenState();
}

class _InventoryAddScreenState extends State<InventoryAddScreen> {

  String? token;
  int? userid;
  int? shopid;
  String? categoryName;
  bool setUse = false;
  String isDefault = '';
  List<String> category = [
    'Detergent',
    'Fabric Conditioner',
    'Bleach',
    'Fabric Freshener Spray'
  ];

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
  }

  @override
  void initState(){
    getUser();
    super.initState();
  }

  final TextEditingController _itemname = TextEditingController();
  final TextEditingController _itemqty = TextEditingController();
  final TextEditingController _itemvolume = TextEditingController();
  final TextEditingController _itemuse = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> inventoryAdd() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );

    ApiResponse apiResponse = await addInventory(
        _itemname.text, _itemqty.text,
        _itemvolume.text, _itemuse.text,
        token.toString()
    );

    Navigator.pop(context);

    if(apiResponse.error == null){
      await successDialog(context, 'Item has been added.');

        Navigator.pop(context,true);
    } else {
      errorDialog(context, '${apiResponse.error}');
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const ForAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorStyle.tertiary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                    ),
                    child: const Text(
                      'Item Name',
                      style: InvStyle.formTitle,
                    ),
                  ),
                  TextFormField(
                    controller: _itemname,
                    decoration: InvStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: ColorStyle.tertiary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                    ),
                    child: const Text(
                      'Item Quantity',
                      style: InvStyle.formTitle,
                    ),
                  ),
                  TextFormField(
                    controller: _itemqty,
                    keyboardType: TextInputType.number,
                    decoration: InvStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: ColorStyle.tertiary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                    ),
                    child: const Text(
                      'Item Type',
                      style: InvStyle.formTitle,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: SignupStyle.allForm,
                    value: categoryName,
                    items: category.map<DropdownMenuItem<String>>((dynamic category){
                      return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category)
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        categoryName = newValue;
                        print(categoryName);
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: ColorStyle.tertiary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                    ),
                    child: const Text(
                      'Item Volume (ml)',
                      style: InvStyle.formTitle,
                    ),
                  ),
                  TextFormField(
                    controller: _itemvolume,
                    keyboardType: TextInputType.number,
                    decoration: InvStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: ColorStyle.tertiary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                    ),
                    child: const Text(
                      'Item Usage per Load (ml)',
                      style: InvStyle.formTitle,
                    ),
                  ),
                  TextFormField(
                    controller: _itemuse,
                    keyboardType: TextInputType.number,
                    decoration: InvStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: setUse,
                          activeColor: ColorStyle.tertiary,
                          onChanged: (value){
                            setState(() {
                              setUse = value!;
                            });
                          }
                      ),
                      const Text('Set as default')
                    ],
                  ),
                  const Text(
                    'Note: Setting this as default will update the status of this item accordingly per laundry service made.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            )
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorStyle.tertiary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
          onPressed: (){
            if(_formKey.currentState!.validate()){
              setState(() {
                inventoryAdd();
              });
            }
          },
          child: const Text(
            'Add to Inventory',
            style: TextStyle(
                color: Color(0xFFF6F6F6),
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}

class InventoryEditScreen extends StatefulWidget {
  final String itemname;
  final String itemqty;
  final String itemvolume;
  final String volumeuse;
  final String id;
  final VoidCallback onUpdate;
  const InventoryEditScreen({super.key, required this.itemname, required this.itemqty, required this.itemvolume, required this.id, required this.volumeuse, required this.onUpdate});

  @override
  State<InventoryEditScreen> createState() => _InventoryEditScreenState();
}

class _InventoryEditScreenState extends State<InventoryEditScreen> {

  Future<void> updateInv() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );

    ApiResponse apiResponse = await updateInventory(
        widget.id, _itemname.text,
        _itemqty.text, _itemvolume.text,
        _itemuse.text
    );

    Navigator.pop(context);

    if(apiResponse.error == null){
      await successDialog(context, 'Item has been updated.');
      widget.onUpdate();
      Navigator.pop(context,true);
    }else{
      errorDialog(context, '${apiResponse.error}');
    }
  }


  String? id;
  bool isLoading = true;
  String? token;
  int? userid;
  int? shopid;
  int? total;
  int? out;
  bool hasData = false;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');

    });
  }

  @override
  void initState(){
    _itemname.text = widget.itemname;
    _itemqty.text = widget.itemqty;
    _itemvolume.text = widget.itemvolume;
    _itemuse.text = widget.volumeuse;
    widget.id;
    super.initState();
  }

  final TextEditingController _itemname = TextEditingController();
  final TextEditingController _itemqty = TextEditingController();
  final TextEditingController _itemvolume = TextEditingController();
  final TextEditingController _itemuse = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ForAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detergent Name',
                      style: InvStyle.formTitle,
                    ),
                    const SizedBox(height: 5,),
                    TextFormField(
                      controller: _itemname,
                      decoration: InvStyle.emailForm,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15,),

                    const Text(
                      'Detergent Quantity',
                      style: InvStyle.formTitle,
                    ),
                    const SizedBox(height: 5,),
                    TextFormField(
                      controller: _itemqty,
                      keyboardType: TextInputType.number,
                      decoration: InvStyle.emailForm,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15,),

                    const Text(
                      'Detergent Volume',
                      style: InvStyle.formTitle,
                    ),
                    const SizedBox(height: 5,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _itemvolume,
                      decoration: InvStyle.emailForm,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                        return 'Field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15,),

                    const Text(
                      'Volume Usage per Load',
                      style: InvStyle.formTitle,
                    ),
                    const SizedBox(height: 5,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _itemuse,
                      decoration: InvStyle.emailForm,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                    return 'Field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15,)
                  ],
                ),
              )
          ),
        ),
        bottomNavigationBar:
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyle.tertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
          setState(() {
                      updateInv();
                    });
                  }
                },
                child: const Text(
                  'Edit Inventory',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
    );
  }
}


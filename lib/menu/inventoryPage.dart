/*
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:capstone/api_response.dart';
import 'package:capstone/drawer/ownerDrawer.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/loginStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class InventoryDisplayScreen extends StatefulWidget {
  const InventoryDisplayScreen({super.key});

  @override
  State<InventoryDisplayScreen> createState() => _InventoryDisplayScreenState();
}

class _InventoryDisplayScreenState extends State<InventoryDisplayScreen> {
  List<dynamic> inventory = [];
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
    }
  }

  Future<void> inventoryDelete() async{

    ApiResponse apiResponse = await deleteInventory(
        id.toString()
    );

    if(apiResponse.error == null){
      print('deleted');
    }else{
      print(apiResponse.error);
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Text(
                itemName,
                style: InvStyle.modalTitle,
              ),
              SizedBox(height: 20,),
              Expanded(
InvStyle        child: Align(
                    alignment: Alignment.topLeft,
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Detergent Quantity: $itemQty'),
                        Text('Detergent Volume: $itemVol'),
                        Text('Detergent Remaining Volume: $remVol'),
                        Text('Detergent Volume Usage: $volUse'),
                      ],
                    ),
                  )
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
                                fixedSize: Size(150, 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryEditScreen(
                                  itemname: itemName, itemqty: itemQty, itemvolume: itemQty,
                                  id: itemId, volumeuse: volUse)));
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
                                fixedSize: Size(150, 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            onPressed: (){
                              deleteInventory(itemId);
                              Navigator.pop(context);
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

  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(token);
    if(isLoading){
      return Scaffold(
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
          body: Padding(
            padding: const EdgeInsets.all(15),
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
                                  Text(
                                    'total detergent',
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
                                  Text(
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
        floatingActionButton: IconButton.filled(
          color: Color(0xFFF6F6F6),
          iconSize: 50,
          tooltip: 'Add Laundry Detergent',
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryAddScreen()));
          },
          icon: Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
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
                          Text(
                            'total detergent',
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
                          Text(
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
              SizedBox(height: 15,),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: inventory.length,
                  itemBuilder: (context, index){
                    Map inv = inventory[index] as Map;


                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .10,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
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
                                            '${inv['itemVolume']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                              'qty',
                                            style: const TextStyle(
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
                                padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      '${inv['ItemName']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: ColorStyle.primary
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: (){
                                 _bottomModal(
                                     '${inv['ItemName']}', '${inv['ItemQty']}',
                                     '${inv['InventoryID']}', '${inv['itemVolume']}', '${inv['VolumeUse']}',
                                     '${inv['RemainingVolume']}'
                                 );
                                },
                                icon: Icon(Icons.more_vert_rounded),
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
      floatingActionButton: IconButton.filled(
        color: Color(0xFFF6F6F6),
        iconSize: 50,
        tooltip: 'Add Laundry Detergent',
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryAddScreen()));
        },
        icon: Icon(Icons.add),
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
  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
  }

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

    if(apiResponse.error == null){
      _successSnackbar();
      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DrawerInventoryScreen()));
      }
    } else {
      Navigator.pop(context);
      print(apiResponse.error);

    }
  }

  void _successSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Inventory Added!',
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Inventory',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
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

             InvStyleext(
                  'Detergent Quantity',
                  style: InvStyle.formTitle,
                ),
                const SizedBox(height: 5,),
                TextFormFieldInvStyle          controller: _itemqty,
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
        InvStyle'Detergent Volume',
                  style: InvStyle.formTitle,
                ),
                const SizedBox(height: 5,),
                TextFormField(
                  contInvStyletemvolume,
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
                  'Volume UInvStyleoad',
                  style: InvStyle.formTitle,
                ),
                const SizedBox(height: 5,),
                TextFormField(
                  controller: _itemuse,InvStyle         decoration: InvStyle.emailForm,
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
      bottomNavigaInvStyleontainer(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
          InvStylendColor: Color(0xFF597FAF),
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
  const InventoryEditScreen({super.key, required this.itemname, required this.itemqty, required this.itemvolume, required this.id, required this.volumeuse});

  @override
  State<InventoryEditScreen> createState() => _InventoryEditScreenState();
}

class _InventoryEditScreenState extends State<InventoryEditScreen> {

  Future<void> updateInv() async{
    showDialog(
        context: context,
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
        _itemqty.text, _itemvolume.text
    );

    if(apiResponse.error == null){
      _successSnackbar();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InventoryDisplayScreen()));
    }else{
      Navigator.pop(context);
      _errorSnackbar();
    }
  }

  void _successSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Inventory updated',
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  void _errorSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: 'Something went wrong.')
    );
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
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
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
                 InvStyleield(
                    controller: _itemqty,
                    decoration: InvStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  InvStyler: (value) {
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
         InvStyle controller: _itemvolume,
                    decoration: InvStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) InvStyle              if (value == null || value.isEmpty) {
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
                    conInvStyleitemuse,
                    decoration: InvStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                  InvStylelue == null || value.isEmpty) {
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
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
InvStyle  height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF597FAF),
              ),
              onPressed: (InvStyle         if(_formKey.currentState!.validate()){
                  setState(() {
                    updateInv();
                  });
                }
              },
              child: const Text(
                'Edit Inventory',
                style: TextStyle(
                    color: Color(0xFFF6F6F6),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  setState(() {
                    deleteInventory(widget.id);
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text(
                'Delete Inventory',
                style: TextStyle(
                    color: Color(0xFFF6F6F6),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

*/

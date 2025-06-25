import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/ConstWidgets.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/model/Inventory.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/invStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/signupStyle.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewInventoryScreen extends StatefulWidget {
  const NewInventoryScreen({super.key});

  @override
  State<NewInventoryScreen> createState() => _NewInventoryScreenState();
}

class _NewInventoryScreenState extends State<NewInventoryScreen> {
  List<dynamic> inventory = []; bool isLoading = true; String? token; int? total;
  int? out; bool hasData = false; String? categoryName; String? usertype; String? access;
  Map data = {};
  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      usertype = prefs.getString('usertype');
      access = prefs.getString('accesstype');
    });
    inventoryDisplay();
  }

  Future<void> inventoryDisplay() async{
    ApiResponse response = await getInventory(token.toString());
    if(!mounted) return;

    if(response.error == null){
      setState(() {
        data = response.data as Map;
        inventory = data['inventory'];
        isLoading = false;
        hasData = inventory.isNotEmpty;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> inventoryDelete(String itemId) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return loading();
        }
    );
    ApiResponse response = await deleteInventory(itemId, token.toString());

    if(!mounted) return;

    Navigator.pop(context);

    if(response.error == null){
      successDialog(context, '${response.data}');
      inventoryDisplay();
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModal(Inventory inv){
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${inv.itemName}',
                    style: InvStyle.modalTitle,
                  ),
                ),
                const Divider(),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RowItem(
                            title: const Row(
                              children: [
                                Icon(Icons.category, color: Colors.blue,),
                                Text('Category', style: InvStyle.modalSubTitle)
                              ],
                            ),
                            description: Text('${inv.category}',style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          RowItem(
                            title: const Row(
                              children: [
                                Icon(Icons.layers,color: Colors.blue,),
                                Text('Quantity', style: InvStyle.modalSubTitle)
                              ],
                            ),
                            description: Text('${inv.itemQty}',style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          RowItem(
                            title: const Row(
                              children: [
                                Icon(Icons.water_drop, color: Colors.blue,),
                                Text('Volume', style: InvStyle.modalSubTitle)
                              ],
                            ),
                            description: Text('${inv.itemVolume}',style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          RowItem(
                            title: const Row(
                              children: [
                                Icon(Icons.water_drop, color: Colors.blue,),
                                Text('Remaining Volume', style: InvStyle.modalSubTitle,)
                              ],
                            ),
                            description: Text('${inv.remainingVolume}',style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          RowItem(
                            title: const Row(
                              children: [
                                Icon(Icons.filter_alt_sharp,color: Colors.blue,),
                                Text('Volume Usage', style: InvStyle.modalSubTitle)
                              ],
                            ),
                            description: Text('${inv.volummeUse}',style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ),
                Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  fixedSize: const Size(150, 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  )
                              ),
                              onPressed: () async{
                                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryEditScreen(inv: inv,)));

                                if(result == true){
                                  if(!context.mounted) return;
                                  Navigator.pop(context);
                                  inventoryDisplay();
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
                                  backgroundColor: Colors.redAccent,
                                  fixedSize: const Size(150, 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  )
                              ),
                              onPressed: (){
                                inventoryDelete('${inv.id}');
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
    print(data);
    if(isLoading){
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: backAppBar(context, 'Inventory'),
          ),
          body: loading()
      );
    }

    if(!hasData){
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: backAppBar(context, 'Inventory'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: RowItem(
                          title: Column(
                            children: [
                              Text('$total', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: ColorStyle.tertiary),),
                              const Text('Total Item',style: TextStyle(fontSize: 12),)
                            ],
                          ),
                          description: Column(
                            children: [
                              Text('$out',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: ColorStyle.tertiary),),
                              const Text('Empty Stock',style: TextStyle(fontSize: 12))
                            ],
                          ),
                        ),
                      )
                  ),
                  const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            'No detergents are stored. Please add.'
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
              await inventoryDisplay();
            }
          },
          child: const Icon(Icons.add, size: 50),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Inventory'),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 2),
                            blurRadius: 1
                          )
                        ]
                    ),
                    child: RowItem(
                        title: Column(
                          children: [
                            Text('${data['total']}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: ColorStyle.tertiary),),
                            const Text('Total Item',style: TextStyle(fontSize: 12),)
                          ],
                        ),
                        description: Column(
                          children: [
                            Text('${data['out']}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: ColorStyle.tertiary)),
                            const Text('Empty Stock',style: TextStyle(fontSize: 12))
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: 25,),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: inventory.length,
                    itemBuilder: (context, index){
                      Map inv = inventory[index] as Map;
                      bool setUse = inv['IsUse'] == '1';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: IntrinsicHeight(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * .25,
                                    decoration: const BoxDecoration(
                                        color: ColorStyle.tertiary,
                                        borderRadius: BorderRadius.horizontal(left: Radius.circular(5))
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Text('${inv['ItemQty']}',
                                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                        const Text('Qty',style: TextStyle(color: Colors.white),)
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4,),
                                  Expanded(
                                      child: RowItem(
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${inv['ItemName']}',style: const TextStyle(fontSize: 16),),
                                              Text('${inv['Category']}',style: const TextStyle(color: ColorStyle.tertiary,fontSize: 12),)
                                            ],
                                          ),
                                          description: IconButton(
                                            onPressed: (){
                                              Inventory invent = Inventory(
                                                  id: '${inv['InventoryID']}', itemName: '${inv['ItemName']}', category: '${inv['Category']}',
                                                  itemQty: '${inv['ItemQty']}', itemVolume: '${inv['ItemVolume']}', volummeUse: '${inv['VolumeUse']}',
                                                  remainingVolume: '${inv['RemainingVolume']}', isUse: setUse ? '1' : '0'
                                              );
                                              usertype == 'owner' ? _bottomModal(invent) : access == 'full'
                                                  ? _bottomModal(invent)
                                                  : warningTextDialog(context, 'Access Denied', 'Sorry you don\'t have permission to edit the inventory');
                                            },
                                            icon: const Icon(Icons.more_vert),
                                          )
                                      )
                                  )
                                ],
                              )
                          ),
                        )
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
        onPressed: usertype == 'owner' ? () async{
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryAddScreen()));

          if (result == true) {
            await inventoryDisplay();
          }
        } : access == 'full' ? () async{
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryAddScreen()));

          if (result == true) {
            await inventoryDisplay();
          }
        } : (){
          warningTextDialog(context, 'Access Denied', 'Sorry you don\'t have permission to add item to the inventory');
        },
        child: const Icon(Icons.add, size: 50, color: Colors.white,),
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
  String? token; String? categoryName; bool setUse = false; String isDefault = '';
  List<String> category = ['Detergent', 'Fabric Conditioner', 'Bleach', 'Fabric Freshener Spray'];

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  void initState(){
    getUser();
    super.initState();
  }

  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _itemQty = TextEditingController();
  final TextEditingController _itemVolume = TextEditingController();
  final TextEditingController _itemUse = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> inventoryAdd() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return loading();
        }
    );

    if(setUse){
      setState(() {
        isDefault = '1';
      });
    }else{
      setState(() {
        isDefault = '0';
      });
    }

    Inventory inv = Inventory(
        itemName: _itemName.text, category: categoryName!, isUse: isDefault,
        itemQty: _itemQty.text, itemVolume: _itemVolume.text,
        remainingVolume: _itemVolume.text, volummeUse: _itemUse.text);

    ApiResponse apiResponse = await addInventory(inv, token.toString());
    if(!mounted) return;

    Navigator.pop(context);

    if(apiResponse.error == null){
      await successDialog(context, 'Item has been added.');
      if(!mounted) return;
        Navigator.pop(context,true);
    } else {
      await errorDialog(context, '${apiResponse.error}');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Add Item'),
      ),
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
                    decoration: const BoxDecoration(
                      color: ColorStyle.tertiary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                    ),
                    child: const Text(
                      'Item Name',
                      style: InvStyle.formTitle,
                    ),
                  ),
                  TextFormField(
                    controller: _itemName,
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
                    decoration: const BoxDecoration(
                        color: ColorStyle.tertiary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                    ),
                    child: const Text(
                      'Item Quantity',
                      style: InvStyle.formTitle,
                    ),
                  ),
                  TextFormField(
                    controller: _itemQty,
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
                    decoration: const BoxDecoration(
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
                    decoration: const BoxDecoration(
                        color: ColorStyle.tertiary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                    ),
                    child: const Text(
                      'Item Volume (ml)',
                      style: InvStyle.formTitle,
                    ),
                  ),
                  TextFormField(
                    controller: _itemVolume,
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
                    decoration: const BoxDecoration(
                        color: ColorStyle.tertiary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                    ),
                    child: const Text(
                      'Item Usage per Load (ml)',
                      style: InvStyle.formTitle,
                    ),
                  ),
                  TextFormField(
                    controller: _itemUse,
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
                  const SizedBox(height: 10,),
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
                  const Center(
                    child: Text(
                      'Note: Setting this as default will update the status of this item accordingly per laundry service made.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.justify,
                    ),
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
  final Inventory inv;
  const InventoryEditScreen({super.key, required this.inv});

  @override
  State<InventoryEditScreen> createState() => _InventoryEditScreenState();
}

class _InventoryEditScreenState extends State<InventoryEditScreen> {
  bool isLoading = true; String? token; int? total; int? out; bool hasData = false;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  final TextEditingController itemName = TextEditingController();
  final TextEditingController itemQty = TextEditingController();
  final TextEditingController itemVolume = TextEditingController();
  final TextEditingController itemUse = TextEditingController();
  String? categoryName; String isDefault = ''; bool setUse = false;
  List<String> category = ['Detergent', 'Fabric Conditioner', 'Bleach', 'Fabric Freshener Spray'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> updateInv() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!mounted) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return loading();
        }
    );

    if(setUse){
      setState(() {
        isDefault = '1';
      });
    }else{
      setState(() {
        isDefault = '0';
      });
    }

    Inventory inv = Inventory(
    id: widget.inv.id, itemName: itemName.text, itemQty: itemQty.text, itemVolume: itemVolume.text,
    volummeUse: itemUse.text, category: categoryName, isUse: setUse ? '1' : '0');

    ApiResponse response = await updateInventory(inv, '${prefs.getString('token')}');

    if(!mounted) return;
    Navigator.pop(context);

    if(response.error == null){
      await successDialog(context, '${response.data}');
      if(!mounted) return;
      Navigator.pop(context,true);
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  @override
  void initState(){
    itemName.text = widget.inv.itemName ?? '';
    itemQty.text = widget.inv.itemQty ?? '';
    itemVolume.text = widget.inv.itemVolume ?? '';
    itemUse.text = widget.inv.volummeUse ?? '';
    categoryName = widget.inv.category ?? '';
    setUse = widget.inv.isUse == '1';
    widget.inv.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Edit Item'),
      ),
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
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      child: const Text(
                        'Item Name',
                        style: InvStyle.formTitle,
                      ),
                    ),
                    TextFormField(
                      controller: itemName,
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
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      child: const Text(
                        'Item Quantity',
                        style: InvStyle.formTitle,
                      ),
                    ),
                    TextFormField(
                      controller: itemQty,
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
                      decoration: const BoxDecoration(
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
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      child: const Text(
                        'Item Volume (ml)',
                        style: InvStyle.formTitle,
                      ),
                    ),
                    TextFormField(
                      controller: itemVolume,
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
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      child: const Text(
                        'Item Usage per Load (ml)',
                        style: InvStyle.formTitle,
                      ),
                    ),
                    TextFormField(
                      controller: itemUse,
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
                    const SizedBox(height: 10,),
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
                    const Center(
                      child: Text(
                        'Note: Setting this as default will update the status of this item accordingly per laundry service made.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    )
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


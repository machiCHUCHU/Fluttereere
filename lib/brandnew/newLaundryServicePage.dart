import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/model/LaundryServiceInfo.dart';
import 'package:capstone/services/servicesadd.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewLaundryServiceScreen extends StatefulWidget {
  const NewLaundryServiceScreen({super.key});

  @override
  State<NewLaundryServiceScreen> createState() => _NewLaundryServiceScreenState();
}

class _NewLaundryServiceScreenState extends State<NewLaundryServiceScreen> {
  List<dynamic> service = []; bool isLoading = true;
  String? usertype; String? access;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usertype = prefs.getString('usertype');
      access = prefs.getString('accesstype');
    });
  }

  Future<void> serviceDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getLaundryServices('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        service = response.data as List<dynamic>;
        isLoading = false;
      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  @override
  void initState() {
    getUser();
    serviceDisplay();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Services'),
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
          : ListView.builder(
          itemCount: service.length,
          itemBuilder: (context, index){
            Map serve = service[index] as Map;
            String serviceType = ''; String serviceOffer = ''; String loadType = '';

            serve['ServiceType'] == 'full' ? serviceType = 'Full Service' : serviceType = 'Self Service';

            switch(serve['ServiceOffer']){
              case 'full':
                serviceOffer = 'Full Service';
                break;
              case 'wash':
                serviceOffer = 'Wash Only';
                break;
              case 'dry':
                serviceOffer = 'Dry Only';
                break;
              default:
                serviceOffer = 'Wash-Dry';
                break;
            }

            switch(serve['LoadType']){
              case 'light':
                loadType = 'Light Load';
                break;
              case 'heavy':
                loadType = 'Heavy Load';
                break;
              default:
                loadType = 'Comforter';
                break;
            }
            return Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.only(left: 8),
                      child: RowItem(
                          title: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.local_laundry_service,color: ColorStyle.tertiary,)
                              ),
                              Text(' ${serve['ServiceName']}',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                            ],
                          ),
                          description: IconButton(
                              tooltip: 'Edit Service',
                              onPressed: usertype == 'owner'
                                  ? ()async{

                                LaundryServiceInfo service = LaundryServiceInfo(
                                    name: '${serve['ServiceName']}', loadPrice: '${serve['LoadPrice']}', type: serviceType, offer: serviceOffer,
                                    loadWeight: '${serve['LoadWeight']}', description: '${serve['Description']}', loadType: loadType, id: '${serve['ServiceID']}'
                                );
                                final response = await Navigator.push(context, MaterialPageRoute(builder: (context)
                                =>EditServiceScreen(service: service,)));

                                if(response == true){
                                  serviceDisplay();
                                }
                              } : (){
                                warningTextDialog(context, 'Access Denied', 'You don\'t have permission to edit this information');
                              },
                              icon: const Icon(Icons.more_vert_sharp,color: Colors.white,)
                          )
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
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
                                  const Text('Max Weight per Load',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                  Text('${serve['LoadWeight']} kg',style: const TextStyle(fontWeight: FontWeight.bold))
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Service Price   ',style: TextStyle(color: Colors.grey,fontSize: 12)),
                                  Text('₱${serve['LoadPrice']}.00',style: const TextStyle(fontWeight: FontWeight.bold))
                                ],
                              ),
                          ),
                          const SizedBox(height: 10,),
                          RowItem(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Service Option',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                Text(serviceType,style: const TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            description: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Service Type    ',style: TextStyle(color: Colors.grey,fontSize: 12)),
                                Text(serviceOffer,style: const TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          const Text('Load Type:',style: TextStyle(color: Colors.grey,fontSize: 12)),
                          Text(loadType,style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const Text('Description:',style: TextStyle(color: Colors.grey,fontSize: 12)),
                          Text('${serve['Description']}',style: const TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ],
                ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorStyle.tertiary,
        tooltip: 'Add Service',
        onPressed: usertype == 'owner'
            ? ()async{
          final response = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddServiceScreen()));

          if(response == true){
            serviceDisplay();
          }
        } : (){
          warningTextDialog(context, 'Access Denied', 'Sorry you don\'t have permission to add more services');
        },
        child: const Icon(Icons.add, size: 50,color: Colors.white,),
      ),
    );
  }
}

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final TextEditingController _servicename = TextEditingController();
  String _servicetype = ''; String _serviceoffer = ''; String _loadtype = '';
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  List<String> servicetype = ['Full Service','Self Service'];
  List<String> serviceoffer = ['Full Service','Wash Only','Dry Only','Wash-Dry'];
  List<String> loadtype = ['Light Load','Heavy Load','Comforter'];

  Future<void> addServices() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    LaundryServiceInfo service = LaundryServiceInfo(
      name: _servicename.text, loadPrice: _price.text, type: _servicetype, offer: _serviceoffer,
      loadWeight: _weight.text, description: _desc.text, loadType: _loadtype
    );
    ApiResponse response = await addLaundryServices(service, '${prefs.getString('token')}');

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context,true);
    }else{
      await warningDialog(context, '${response.error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Services'),
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context,true);
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
              child: const Text('Laundry Service Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _servicename,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Comforter',
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Laundry Service Type',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *.45,
                      child: DropdownButtonFormField(
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
                          items: serviceoffer.map((value){
                            return DropdownMenuItem(
                                value: value,
                                child: Text(value)
                            );
                          }).toList(),
                          onChanged: (newValue){
                            switch(newValue){
                              case 'Full Service':
                                _serviceoffer = 'full';
                                break;
                              case 'Wash Only':
                                _serviceoffer = 'wash';
                                break;
                              case 'Dry Only':
                                _serviceoffer = 'dry';
                                break;
                              default:
                                _serviceoffer = 'wash-dry';
                                break;
                            }
                          }
                      )
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Service Option',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *.45,
                      child: DropdownButtonFormField(
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
                          items: servicetype.map((value){
                            return DropdownMenuItem(
                                value: value,
                                child: Text(value)
                            );
                          }).toList(),
                          onChanged: (newValue){
                            if(newValue == 'Self Service'){
                              _servicetype = 'self';
                            }else{
                              _servicetype = 'full';
                            }
                          }
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Max weight per Load',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *.45,
                        child: TextField(
                          controller: _weight,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: '1 kg',
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
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Service Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *.45,
                      child: TextField(
                        controller: _price,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: '100',
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
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Laundry Load Type',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            DropdownButtonFormField(
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
                items: loadtype.map((value){
                  return DropdownMenuItem(
                      value: value,
                      child: Text(value)
                  );
                }).toList(),
                onChanged: (newValue){
                  switch(newValue){
                    case 'Light Load':
                      _loadtype = 'light';
                      break;
                    case 'Heavy Load':
                      _loadtype = 'heavy';
                      break;
                    default:
                      _loadtype = 'comforter';
                      break;
                  }
                }
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Description',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _desc,
              maxLines: null,
              minLines: 1,
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
            addServices();
          },
          child: const Text('Add Laundry Service',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}

class EditServiceScreen extends StatefulWidget {
  final LaundryServiceInfo service;
  const EditServiceScreen({super.key, required this.service});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final TextEditingController _servicename = TextEditingController();
  String _servicetype = ''; String _serviceoffer = ''; String _loadtype = '';
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  String _serveType = ''; String _serveOffer = ''; String _loadType = '';

  List<String> servicetype = ['Full Service','Self Service'];
  List<String> serviceoffer = ['Full Service','Wash Only','Dry Only','Wash-Dry'];
  List<String> loadtype = ['Light Load','Heavy Load','Comforter'];

  Future<void> editService() async{
    if(_servicetype == 'Self Service'){
      _servicetype = 'self';
    }else if(_servicetype == 'full'){
      _servicetype = 'full';
    }

    switch(_loadtype){
      case 'Light Load':
        _loadtype = 'light';
        break;
      case 'Heavy Load':
        _loadtype = 'heavy';
        break;
      case 'Comforter':
        _loadtype = 'comforter';
        break;
    }
    switch(_serviceoffer){
      case 'Full Service':
        _serviceoffer = 'full';
        break;
      case 'Wash Only':
        _serviceoffer = 'wash';
        break;
      case 'Dry Only':
        _serviceoffer = 'dry';
        break;
      case 'Wash-Dry':
        _serviceoffer = 'wash-dry';
        break;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    LaundryServiceInfo service = LaundryServiceInfo(
      name: _servicename.text, loadWeight: _weight.text, type: _serveType.isEmpty ? _servicetype : _serveType,
      offer: _serveOffer.isEmpty ? _serviceoffer : _serveOffer, loadPrice: _price.text, description: _desc.text,
      loadType: _loadType.isEmpty ? _loadtype : _loadType, id: widget.service.id
    );
    ApiResponse response = await editLaundryServices(service, '${prefs.getString('token')}');

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context,true);
    }else{
      await warningDialog(context, '${response.error}');
    }
  }

  @override
  void initState() {
    _servicename.text = widget.service.name ?? '';
    _weight.text = widget.service.loadWeight ?? '';
    _servicetype = widget.service.type ?? '';
    _serviceoffer = widget.service.offer ?? '';
    _price.text = widget.service.loadPrice ?? '';
    _desc.text = widget.service.description ?? '';
    _loadtype = widget.service.loadType ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Services'),
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context,true);
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
              child: const Text('Laundry Service Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _servicename,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Laundry Service Type',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *.45,
                        child: DropdownButtonFormField(
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
                            value: _serviceoffer,
                            items: serviceoffer.map((value){
                              return DropdownMenuItem(
                                  value: value,
                                  child: Text(value)
                              );
                            }).toList(),
                            onChanged: (newValue){
                              switch(newValue){
                                case 'Full Service':
                                  _serveOffer = 'full';
                                  break;
                                case 'Wash Only':
                                  _serveOffer = 'wash';
                                  break;
                                case 'Dry Only':
                                  _serveOffer = 'dry';
                                  break;
                                default:
                                  _serveOffer = 'wash-dry';
                                  break;
                              }
                            }
                        )
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Service Option',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *.45,
                      child: DropdownButtonFormField(
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
                          value: _servicetype,
                          items: servicetype.map((value){
                            return DropdownMenuItem(
                                value: value,
                                child: Text(value)
                            );
                          }).toList(),
                          onChanged: (newValue){
                            if(newValue == 'Self Service'){
                              _serveType = 'self';
                            }else{
                              _serveType = 'full';
                            }
                          }
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Max weight per Load',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *.45,
                      child: TextField(
                        controller: _weight,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: '1 kg',
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
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Text('Service Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *.45,
                      child: TextField(
                        controller: _price,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: '100',
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
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Laundry Load Type',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            DropdownButtonFormField(
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
                value: _loadtype,
                items: loadtype.map((value){
                  return DropdownMenuItem(
                      value: value,
                      child: Text(value)
                  );
                }).toList(),
                onChanged: (newValue){
                  switch(newValue){
                    case 'Light Load':
                      _loadType = 'light';
                      break;
                    case 'Heavy Load':
                      _loadType = 'heavy';
                      break;
                    default:
                      _loadtype = 'comforter';
                      break;
                  }
                }
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Description',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _desc,
              maxLines: null,
              minLines: 1,
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
            editService();
          },
          child: const Text('Edit Laundry Service',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}

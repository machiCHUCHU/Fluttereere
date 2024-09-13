import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/material.dart';

class NewProfileEditScreen extends StatefulWidget {
  const NewProfileEditScreen({super.key});

  @override
  State<NewProfileEditScreen> createState() => _NewProfileEditScreenState();
}

class _NewProfileEditScreenState extends State<NewProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(40),
                child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: ColorStyle.tertiary,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage('$picaddress/${prof['CustomerImage']}'),
                          radius: 55,
                        ),
                      ],
                    )
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300)
                    ),
                    color: Colors.white
                ),
                child: RowItem(
                  title: const Text('Name'),
                  description: Text('${prof['CustomerName']}', overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300)
                    ),
                    color: Colors.white
                ),
                child: RowItem(
                  title: const Text('Sex'),
                  description: Text('${prof['CustomerSex']}', overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300)
                    ),
                    color: Colors.white
                ),
                child: RowItem(
                  title: const Text('Address'),
                  description: Text('${prof['CustomerAddress']}', overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300)
                    ),
                    color: Colors.white
                ),
                child: RowItem(
                  title: const Text('Contact'),
                  description: Text('${prof['CustomerContactNumber']}', overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,),),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.tertiary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  onPressed: (){},
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

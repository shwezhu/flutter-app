import 'package:flutter/material.dart';
import '../data/visitor.dart';

class AddInformationPage extends StatefulWidget {
  const AddInformationPage({Key? key}) : super(key: key);

  @override
  _AddInformationPageState createState() => _AddInformationPageState();
}

class _AddInformationPageState extends State<AddInformationPage> {
  TextEditingController nameField = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  TextEditingController idField = TextEditingController();
  TextEditingController locationField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const plainTextStyle = TextStyle(
      fontSize: 12,
      color: Colors.white,
    );
    const clickTextStyle = TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontStyle: FontStyle.italic,
    );
    return Scaffold(
        appBar: AppBar(title: const Text('个人信息填写')),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                          controller: nameField,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Your Name'
                          )
                      )
                  ),
                  Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                          controller: phoneField,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Your phone number'
                          )
                      )
                  ),
                  Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                          controller: idField,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter ID number'
                          )
                      )
                  ),
                  Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                          controller: locationField,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter the city you have been recently'
                          )
                      )
                  ),
                  ElevatedButton(onPressed: () {setState(() {});}, child: const Text('GENERATE QR'))
                ]
            )
        )
    );
  }
}
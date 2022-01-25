import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  TextEditingController nameField = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  TextEditingController idField = TextEditingController();
  TextEditingController locationField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Information Form'),
            backgroundColor: Colors.blueGrey,
            elevation: 0
        ),
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
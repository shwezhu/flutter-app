import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Information Form'),
            backgroundColor: Colors.blueGrey,
            elevation: 0
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(margin: const EdgeInsets.all(20),
                          child: TextField(controller: controller,
                              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Enter URL')
                          )
                      ),
                      ElevatedButton(onPressed: () {setState(() {});}, child: const Text('GENERATE QR'))
                    ]
                )
            )
        )
    );
  }
}
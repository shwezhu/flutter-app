import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({Key? key}) : super(key: key);

  @override
  _GenerateQRPageState createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('QR GENERATOR'),
          backgroundColor: Colors.blueGrey,
          elevation: 0
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImage(data: controller.text, size: 300),
              Container(margin: const EdgeInsets.all(20),
                  child: TextField(controller: controller,
                      decoration: const InputDecoration(border: OutlineInputBorder(),
                          labelText: 'Enter URL'
                      )
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
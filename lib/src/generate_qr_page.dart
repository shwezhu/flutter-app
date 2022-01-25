import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({Key? key}) : super(key: key);

  @override
  _GenerateQRPageState createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('QR GENERATOR'),
          backgroundColor: Colors.blueGrey,
          elevation: 0
      ),
      body: Center(child: QrImage(data: 'https://www.baidu.com/', size: 300))
    );
  }
}
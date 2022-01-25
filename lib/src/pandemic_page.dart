import 'package:flutter/material.dart';
import 'generate_qr_page.dart';

class PandemicPage extends StatefulWidget {
  const PandemicPage({Key? key}) : super(key: key);

  @override
  State createState() {
    return _PandemicPageState();
  }
}

class _PandemicPageState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitors Information'),
        leading: const Icon(Icons.people),
          backgroundColor: Colors.blueGrey.shade300,
        // Set AppBar elevation to 0 to get rid of shadow.
        elevation: 0
      ),
      body: const Text('123'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const GenerateQRPage()),);
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.qr_code),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat
    );
  }
}
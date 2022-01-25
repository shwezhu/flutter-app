import 'package:flutter/material.dart';

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
        title: Text('Visitors Information', style: TextStyle(color: Colors.grey.shade500)),
        leading: Icon(Icons.people, color: Colors.grey.shade500),
        backgroundColor: Colors.white54,
        // Set AppBar elevation to 0 to get rid of shadow.
        elevation: 0
      ),
      body: const Text('123'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.qr_code),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat
    );
  }

}
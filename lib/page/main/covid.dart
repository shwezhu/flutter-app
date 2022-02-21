import 'package:flutter/material.dart';
import 'add_information.dart';

class CovidPage extends StatefulWidget {
  const CovidPage({Key? key}) : super(key: key);

  @override
  State createState() {
    return _CovidPageState();
  }
}

class _CovidPageState extends State {
  void _onPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddInformationPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitors Information'),
        leading: const Icon(Icons.people),
      ),
      body: const Text('this is body'),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressed,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat
    );
  }
}
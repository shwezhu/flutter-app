import 'package:flutter/material.dart';
import '../../data/visitor.dart';
import 'add_information.dart';
import '../../http_utils.dart';

class CovidPage extends StatefulWidget {
  const CovidPage({Key? key}) : super(key: key);

  @override
  State createState() {
    return _CovidPageState();
  }
}

class _CovidPageState extends State {
  var visitors = <Visitor>[];
  var visitorWidget = <Widget>[];

  void init() async {
    visitors = await getVisitors();
    if(visitors.isEmpty) {

    } else {
      for(int i = 0; i < visitors.length; ++i) {
        visitorWidget.add(
            Card(
              child: ListTile(
                leading: Text(visitors[i].name),
                title: Text(visitors[i].city),
                subtitle: Text(visitors[i].phone),
              ),
            ),
        );
      }
    }
  }

  Future _refresh() async {
    return visitors = await getVisitors();
  }

  void _onPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddInformationPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    init();
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
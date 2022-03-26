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
  List<Visitor> visitors = [];
  var visitorWidgets = <Widget>[
    const Card(
      child: ListTile(
        title: Text("请尝试下拉刷新"),
        subtitle: Text("暂无用户数据"),
      ),
    ),
  ];

  void generateList() {
    visitorWidgets = <Widget>[];
    for (var visitor in visitors) {
      visitorWidgets.add(
        Card(
          child: ListTile(
            leading: Text(visitor.name),
            title: Text(visitor.city),
            subtitle: Text(visitor.phone),
          ),
        ),
      );
    }
  }

  Future _refresh() async {
    var tem = await getVisitors() ?? visitors;
    if(tem.isEmpty) {
      return;
    }
   // if no setState, RefreshIndicator below won't work
    setState(() {
      visitors = tem;
    });
    generateList();

    return Future.delayed(const Duration(seconds: 0));
  }

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
      body: RefreshIndicator(
        onRefresh: _refresh,
        // By design, RefreshIndicator only works with ListView.
        child: ListView(
          padding:  const EdgeInsets.all(8),
          children: visitorWidgets,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressed,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat
    );
  }
}
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:flutter/material.dart';
import 'config.dart';

void main() {
  Bmob.init(Config.appHost, Config.appId, Config.apiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return HomePage(key: key);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // The framework calls createState the first time a widget appears at a given location in the tree.
  // If the parent rebuilds and uses the same type of widget (with the same key), the framework re-uses
  // the State object instead of creating a new State object.
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _uiPages = const [
    Text('1'),
    Text('2'),
    Text('3')
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智慧农业',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'MochiyPopPOne'),
      home: Scaffold(
        body: IndexedStack(
          children: _uiPages,
          index: _currentIndex
        ),
        bottomNavigationBar: ConvexAppBar(
          items: const [
            TabItem(icon: Icons.home, title: '主页'),
            TabItem(icon: Icons.monitor, title: '监控'),
            TabItem(icon: Icons.masks, title: 'Covid-19')
          ],
            height: 50,
            initialActiveIndex: 0,
            style: TabStyle.titled,
            onTap: _onTap
        )
      )
    );
  }
}
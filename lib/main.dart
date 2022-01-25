import 'package:flutter/material.dart';
import 'src/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // The framework calls createState the first time a widget appears at a given location in the tree.
  // If the parent rebuilds and uses the same type of widget (with the same key), the framework re-uses
  // the State object instead of creating a new State object.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This method will be called each time your State object changes.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Intelligent Agriculture',
        theme: ThemeData(fontFamily: 'MochiyPopPOne'),
        debugShowCheckedModeBanner: false,
        home: const HomePage()
    );
  }
}
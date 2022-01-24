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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(fontFamily: 'MochiyPopPOne'),
        debugShowCheckedModeBanner: false, home: const HomePage());
  }
}

/*int _selectedIndex = 0;
return Scaffold(
appBar: AppBar(title: const Text('Home page')),
bottomNavigationBar: BottomNavigationBar(
items: const <BottomNavigationBarItem>[
BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
BottomNavigationBarItem(icon: Icon(Icons.monitor), label: 'Monitor'),
BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Lab')],
currentIndex: _selectedIndex,
onTap: _onItemTapped
)
);*/

/*
class MyApp extends StatelessWidget {
  // You can make a variable nullable by putting a question mark (?) at the end of its type.
  // Widget unique identity — Key
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Intelligent Agriculture';

  @override
  Widget build(BuildContext context) {
    // Prefer const with constant constructors.
    return const MaterialApp(
      title: _title,
      home: HomePage(),
    );
  }
}
*/

/*
// Create a stateful widget
class TemperatureInfo extends StatefulWidget {
  const TemperatureInfo({Key? key}) : super(key: key);

  @override
  // The framework calls createState the first time a widget appears at a given location in the tree.
  // If the parent rebuilds and uses the same type of widget (with the same key), the framework re-uses
  // the State object instead of creating a new State object.
  // The=>expr syntax is a shorthand for{ return expr; }
  _TemperatureInfoState createState() => _TemperatureInfoState();
}

// RandomWords's State class, it maintains the state for the RandomWords widget.
// The second part “_RandomWordsState” is the part which varies during the lifetime of the Widget
// and forces this specific instance of the Widget to rebuild each time a modification is applied.
// The ‘_’ character in the beginning of the name makes the class private to the .dart file.
// If you need to make a reference to this class outside the .dart file, do not use the ‘_’ prefix.
// The _RandomWordsState class can access any variable which is stored in the MyStatefulWidget,
//using widget.{name of the variable}. In this example: widget.color
class _TemperatureInfoState extends State<TemperatureInfo> {
  double? _temperature;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // This method will be called each time your State object changes
  // (or when an InheritedWidget needs to notify the “registered” widgets) !!
  // In order to force a rebuild, you may invoke setState((){…}) method.
  @override
  Widget build(BuildContext context) {
    // A widget’s main job is to implement a build()function, which describes the widget in terms of other, lower-level widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature information'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      backgroundColor: Colors.blueGrey.shade200,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: 'Lab',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}*/

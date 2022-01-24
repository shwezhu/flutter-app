import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Scaffold widget has some nice properties for helping us lay out our main screen
  // including adding bottom navigation bars, sliding drawers, and tab bars.
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Home page")),
        body: Center(child: Text('1234$_selectedIndex')),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.monitor), label: 'Monitor'),
              BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Lab')
            ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped
        )
    );
  }
}
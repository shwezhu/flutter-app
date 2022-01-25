import 'package:flutter/material.dart';
import 'pandemic_page.dart';
import 'information_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[const Center(child: Text('1')), const Center(child: InformationPage()), const Center(child: PandemicPage())];

  void _onItemTapped(int index) {
    // // In order to force a rebuild, you may invoke setState((){…}) method.
    setState(() {
      _selectedIndex = index;
    });
  }

  // Scaffold widget has some nice properties for helping us lay out our main screen
  // including adding bottom navigation bars, sliding drawers, and tab bars.
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
            selectedIconTheme: const IconThemeData(color: Colors.blue),
            unselectedIconTheme: IconThemeData(color: Colors.blueGrey.shade500, size: 30),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.monitor), label: 'Monitor'),
              BottomNavigationBarItem(icon: Icon(Icons.masks), label: 'Covid-19')
            ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped
        )
    );
  }
}
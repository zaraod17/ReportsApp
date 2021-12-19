import 'package:flutter/material.dart';
import 'package:projekt/screens/add_report_screen.dart';

import 'package:projekt/screens/reports_list_screen.dart';
import 'package:projekt/screens/user_reports_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  List<Map<String, Object>> _pages;

  @override
  void initState() {
    _pages = [
      {'page': ReportsOverviewScreen(), 'title': Text('Wszystkie zgłoszenia')},
      {'page': UserReportsScreen(), 'title': Text('Moje zgłoszenia')}
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _pages[_selectedIndex]['title'],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddReportScreen.routeName);
              },
              icon: Icon(Icons.add)),
          PopupMenuButton(itemBuilder: (ctx) {
            return [
              PopupMenuItem(
                child: Text('Otwarte'),
                value: 'watched',
              ),
              PopupMenuItem(
                child: Text('Zamknięte'),
                value: 'all',
              ),
              PopupMenuItem(
                child: Text('W trakcie'),
                value: 'all',
              )
            ];
          }),
        ],
      ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Wszystkie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Moje',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
    );
  }
}
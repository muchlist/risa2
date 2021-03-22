import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class BottomNavRisa extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<BottomNavRisa> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  //INSIDE NAVIGATION VIEW
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      if (index == 1) {
        _startAddIncident(context);
      } else {
        _selectedIndex = index;
      }
    });
  }

  void _startAddIncident(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bCtx) {
          return Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Container(
              child: Center(
                child: Text("AJHAHAHA"),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        actions: [
          Icon(
            CupertinoIcons.search,
            size: 25,
          ),
          SizedBox(
            width: 16,
          ),
          Icon(
            CupertinoIcons.app_badge,
            size: 25,
          ),
          SizedBox(
            width: 16,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 50,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      CupertinoIcons.person,
                      size: 25,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          text: TextSpan(
              text: "Hi, Muchlis\n",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
              children: <TextSpan>[
                TextSpan(
                    text: "Welcome to RISA",
                    style: TextStyle(fontSize: 12, color: Colors.white))
              ]),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Ticket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[300],
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}

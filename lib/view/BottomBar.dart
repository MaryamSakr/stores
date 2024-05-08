import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddStores.dart';
import 'FavoritePage.dart';
import 'HomeScreen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  int selectedIndex = 0;
  String? Custid ;
  MyBottomNavigationBar(int s , String cust) {
    selectedIndex = s;
    Custid = cust;
  }
  @override
  MyBottomNavigationBarState createState() =>
      MyBottomNavigationBarState(selectedIndex , Custid!);
}

class MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int selectedIndex = 0;
  String? Custid ;
  MyBottomNavigationBarState(int s , String cust) {
    selectedIndex = s;
    Custid = cust;
  }

  static List<Widget> _widgetOptions(String Cust) => <Widget>[
    HomeScreen(Cust!),
    AddStorePage(),
    FavoriteStoresScreen(Cust!),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions(Custid!)[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite Stores',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: onItemTapped,
      ),
    );
  }
}

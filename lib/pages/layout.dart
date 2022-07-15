import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:hivoyage/pages/profile.dart';
import 'package:hivoyage/pages/purchase.dart';
import 'package:hivoyage/pages/ticket_list.dart';

class Layout extends StatefulWidget {
  const Layout({Key key}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Purchase(),
    const TicketList(),
    const Profile(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: blueAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Achats',
            icon: Icon(CupertinoIcons.qrcode_viewfinder),
          ),
          BottomNavigationBarItem(
            label: 'Ticket',
            icon: Icon(CupertinoIcons.ticket),
          ),
          BottomNavigationBarItem(
            label: 'Profil',
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}

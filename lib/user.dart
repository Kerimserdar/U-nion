import 'package:flutter/material.dart';
import 'package:union/form.dart';
import 'package:union/profile.dart';

class User extends StatefulWidget {
  const User({Key key}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  PageController _controller = PageController(initialPage: 0);

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          CreatingForm(),
          Profile(),
        ],
        onPageChanged: (i) {
          setState(() {
            _selectedIndex = i;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: "Form",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink[700],
        onTap: _onItemTapped,
      ),
    );
  }
}

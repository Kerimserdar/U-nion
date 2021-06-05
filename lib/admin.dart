import 'package:flutter/material.dart';
import 'package:union/approveform.dart';
import 'package:union/channel.dart';

class Admin extends StatefulWidget {
  const Admin({ Key key }) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
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
          ApproveForm(),
          Channel(),
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
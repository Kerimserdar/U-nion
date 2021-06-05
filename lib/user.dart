import 'package:flutter/material.dart';
import 'package:union/createform.dart';
import 'package:union/profile.dart';
import 'connect.dart';
import 'login.dart';
import 'room.dart';
import 'waiting.dart';

class User extends StatefulWidget {
  static int roomId = 0;
  const User({Key key}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  PageController _controller = PageController(initialPage: 0);

  int _selectedIndex = 0;
  bool formSent = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.jumpToPage(index);
    });
  }

  Future checkRoomAndForm() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from form, preference where form.preference_id = preference.preference_id and preference.user_id = ${Login.id}')
              .then((results) => {
                    if (results.isNotEmpty)
                      {
                        setState(() {
                          formSent = true;
                        })
                      }
                  }),
        });
    await db.getConnection().then((conn) => {
          conn
              .query('select * from placement where user_id = ${Login.id}')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          User.roomId = row[1];
                        }),
                      }
                  }),
        });
  }

  @override
  void initState() {
    checkRoomAndForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _controller,
        children: <Widget>[
          User.roomId == 0
              ? (formSent == true ? Waiting() : CreateForm())
              : Room(),
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

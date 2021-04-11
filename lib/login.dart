import 'package:flutter/material.dart';
import 'package:union/mysql.dart';
import 'package:union/pages.dart';
import 'package:union/signup.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();

  var db = Mysql();

  Future<void> checkUser(String mail, String password) async {
    db.getConnection().then((conn) => {
          conn
              .query(
                  "select password from union.user where mail = '$mail'")
              .then((results) => {
                    for (var row in results)
                      {
                        if (row[0].toString() == password.toString())
                          {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Pages())),
                          }
                        else
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Warning"),
                                  content: Text("Mail or password is wrong"),
                                  actions: [
                                    TextButton(
                                      child: Text("Okay"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          }
                      }
                  }),
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink[500], Colors.blue[900]]),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: Text(
                    "Welcome to",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "U-nion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Have fun with new poeple and new activities",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1),
                  child: RotatedBox(
                      quarterTurns: -1,
                      child: Text(
                        'Sing in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: mail,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.1,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: password,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.6),
                ElevatedButton(
                  onPressed: () {
                    checkUser(mail.text, password.text);
                  },
                  child: Row(
                    children: [
                      Text("Okay"),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    primary: Colors.white, // background
                    onPrimary: Colors.pink[900], // foreground
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Are you new among us?',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: Text(
                        'Sing up',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:union/login.dart';
import 'package:union/mysql.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController name = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController age = TextEditingController();

  var db = Mysql();

  Future<void> addUser(String name, String mail, String password, String gender,
      String age) async {
    db.getConnection().then((conn) => {
          conn
              .query(
                  "INSERT INTO `user` (`mail`, `name`, `password`, `age`, `gender`) VALUES ('$mail', '$name', '$password', $age, '$gender')")
              .then((results) => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Notice"),
                          content: Text(
                              "You signed up to U-nion\nNow you can login"),
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
                  }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink[500], Colors.blue[900]]),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                  bottom: MediaQuery.of(context).size.height * 0.05),
              child: Text(
                "Let's start to take the first step to U-nion",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.2,
                      left: MediaQuery.of(context).size.width * 0.1),
                  child: RotatedBox(
                      quarterTurns: -1,
                      child: Text(
                        'Sing up',
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
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: name,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
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
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: password,
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: gender,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Gender',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.05,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: age,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'Age',
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
                    addUser(name.text, mail.text, password.text, gender.text,
                        age.text);
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
                    top: MediaQuery.of(context).size.height * 0.1,
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Do you want to',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        'Turn back to Sign In',
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

import 'package:flutter/material.dart';
import 'package:union/user.dart';
import 'connect.dart';
import 'login.dart';

class Interest extends StatefulWidget {
  @override
  _InterestState createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  TextEditingController gender = new TextEditingController();
  TextEditingController age = new TextEditingController();
  TextEditingController job = new TextEditingController();
  TextEditingController education = new TextEditingController();
  TextEditingController film = new TextEditingController();
  TextEditingController book = new TextEditingController();
  TextEditingController music = new TextEditingController();
  TextEditingController word = new TextEditingController();
  TextEditingController country = new TextEditingController();
  TextEditingController city = new TextEditingController();

  var lastInterest = 0;
  var lastLocation = 0;
  var last = 0;

  Future addValues() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from interest where interest_id = (SELECT MAX(interest_id) FROM interest)')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          lastInterest = row[0];
                        }),
                      },
                    conn
                        .query(
                            'insert into interest (interest_id, film_name, book_name, music_name, word) values (${lastInterest + 1}, "${film.text}", "${book.text}", "${music.text}", "${word.text}")')
                        .then((r) => {}),
                  }),
        });
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from location where location_id = (SELECT MAX(location_id) FROM location)')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          lastLocation = row[0];
                        }),
                      },
                    conn
                        .query(
                            'insert into location (location_id, country, city) values (${lastLocation + 1}, "${country.text}", "${city.text}")')
                        .then((r) => {}),
                  }),
        });
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from person where location_id = (SELECT MAX(location_id) FROM location)')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          last = row[1];
                        }),
                      },
                    conn
                        .query(
                            'insert into person (user_id, location_id, interest_id, gender, age, job, education) values (${Login.id}, ${last + 1}, ${last + 1}, "${gender.text}", ${age.text}, "${job.text}", "${education.text}")')
                        .then((r) => {}),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Let's get to know you better",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w300,
              ),
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      ListTile(
                        title: TextField(
                          controller: gender,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.white,
                            labelText: 'What is your gender',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: age,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'What is your age',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: job,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'What job are you currently working in?',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: education,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.lightBlueAccent,
                            labelText:
                                'The last educational institution you graduated from',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: film,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'What is your favorite film',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: book,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'What is your favorite book',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: music,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'What is your favorite music',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: word,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.white,
                            labelText:
                                'Can you describe yourself with a sentence',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: country,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.white,
                            labelText: 'The country you are in',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: city,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.white,
                            labelText: 'The city you are in',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.6),
                ElevatedButton(
                  onPressed: () async {
                    await addValues();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => User()));
                  },
                  child: Row(
                    children: [
                      Text("Continue"),
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
          ],
        ),
      ),
    );
  }
}

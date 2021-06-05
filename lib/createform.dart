import 'package:flutter/material.dart';
import 'package:union/user.dart';

import 'connect.dart';
import 'login.dart';

class CreateForm extends StatefulWidget {
  const CreateForm({Key key}) : super(key: key);

  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  TextEditingController gender = new TextEditingController();
  TextEditingController age = new TextEditingController();
  TextEditingController language = new TextEditingController();
  TextEditingController education = new TextEditingController();

  List<String> activity = [];
  List activityId = [];
  List<String> location = [];
  List locationId = [];
  int selectedActivityId = 0;
  int selectedLocationId = 0;
  String _selection;
  String _selection2;
  int lastPreference = 0;
  int lastForm = 0;

  DateTime now = DateTime.now();

  Future getActivity() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn.query('select * from activity').then((results) => {
                for (var row in results)
                  {
                    setState(() {
                      activityId.add(row[0]);
                      activity.add(row[1]);
                    })
                  }
              }),
        });
  }

  Future getLocation() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn.query('select * from location').then((results) => {
                for (var row in results)
                  {
                    setState(() {
                      locationId.add(row[0]);
                      location.add(row[1] + " " + row[2]);
                    })
                  }
              }),
        });
  }

  Future addValues() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from preference where preference_id = (SELECT MAX(preference_id) FROM preference)')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          lastPreference = row[0];
                        })
                      },
                    conn
                        .query(
                            'insert into preference (preference_id, user_id, activity_id, location_id, age, gender, language) values (${lastPreference + 1}, ${Login.id}, $selectedActivityId, $selectedLocationId, "${age.text}", "${gender.text}", "${language.text}")')
                        .then((results) => {}),
                  }),
        });
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from form where form_id = (SELECT MAX(form_id) FROM form)')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          lastForm = row[0];
                        })
                      },
                    conn
                        .query(
                            'insert into form (form_id, preference_id, time) values (${lastForm + 1}, ${lastPreference + 1}, ${now.day.toString() + "" + now.month.toString() + "" + now.year.toString()})')
                        .then((results) => {}),
                  }),
        });
  }

  @override
  void initState() {
    getActivity();
    getLocation();
    super.initState();
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
              "Create a form to settle\n          into a room",
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
                    padding: EdgeInsets.all(8),
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: PopupMenuButton<int>(
                            onSelected: (int value) {
                              setState(() {
                                _selection = activity[value];
                                selectedActivityId = activityId[value];
                              });
                            },
                            child: ListTile(
                              title: Column(
                                children: <Widget>[
                                  Text(
                                    _selection == null
                                        ? 'Which activity are you interested in ?'
                                        : _selection.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (BuildContext context) {
                              return List.generate(activity.length, (index) {
                                return PopupMenuItem(
                                  child: PopupMenuItem<int>(
                                    value: index,
                                    child: Text(activity[index]),
                                  ),
                                );
                              });
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: PopupMenuButton<int>(
                            onSelected: (int value) {
                              setState(() {
                                _selection2 = location[value];
                                selectedLocationId = locationId[value];
                              });
                            },
                            child: ListTile(
                              title: Column(
                                children: <Widget>[
                                  Text(
                                    _selection2 == null
                                        ? 'Which location do you want to hang out with people from ?'
                                        : _selection2.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (BuildContext context) {
                              return List.generate(location.length, (index) {
                                return PopupMenuItem(
                                  child: PopupMenuItem<int>(
                                    value: index,
                                    child: Text(location[index]),
                                  ),
                                );
                              });
                            }),
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
                            fillColor: Colors.white,
                            labelText: 'Age of people you want to meet',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
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
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Gender of people you want to meet',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: language,
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
                            labelText: 'Language of people you want to meet',
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
                      Text("Approve"),
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

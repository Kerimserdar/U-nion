import 'package:flutter/material.dart';

class CreatingForm extends StatefulWidget {
  @override
  _CreatingFormState createState() => _CreatingFormState();
}

class _CreatingFormState extends State<CreatingForm> {
  TextEditingController film = new TextEditingController();
  TextEditingController book = new TextEditingController();
  TextEditingController music = new TextEditingController();
  TextEditingController word = new TextEditingController();

  @override
  void initState() {
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
              "Let's get to know you better",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w300,
              ),
            ),
            Column(
              children: [
                Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      ListTile(
                        title: TextField(
                          controller: film,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
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
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.white,
                            labelText: 'Can you describe yourself with a sentence',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.6),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => CreatingForm()));
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

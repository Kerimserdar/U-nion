import 'package:flutter/material.dart';

class Pages extends StatefulWidget {
  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  TextEditingController film = new TextEditingController();
  TextEditingController book = new TextEditingController();
  TextEditingController music = new TextEditingController();
  TextEditingController word = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: Text("Interest")),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
          child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          ListTile(
            title: Center(child: Text("What is your favorite film")),
            subtitle: TextField(
              controller: film,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                fillColor: Colors.lightBlueAccent,
                labelText: 'Film',
                labelStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          ListTile(
            title: Center(child: Text("What is your favorite book")),
            subtitle: TextField(
              controller: book,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                fillColor: Colors.lightBlueAccent,
                labelText: 'Book',
                labelStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          ListTile(
            title: Center(child: Text("What is your favorite music")),
            subtitle: TextField(
              controller: music,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                fillColor: Colors.lightBlueAccent,
                labelText: 'Music',
                labelStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          ListTile(
            title: Center(
                child: Text("Can you describe yourself with a sentence")),
            subtitle: TextField(
              controller: word,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                fillColor: Colors.lightBlueAccent,
                labelText: 'Word',
                labelStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

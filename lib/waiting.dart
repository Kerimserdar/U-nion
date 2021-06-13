import 'package:flutter/material.dart';

class Waiting extends StatefulWidget {
  const Waiting({Key key}) : super(key: key);

  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Waiting for admin approval",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

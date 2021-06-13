import 'package:flutter/material.dart';
import 'connect.dart';
import 'detailpage.dart';
import 'login.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ApproveForm extends StatefulWidget {
  static int lastPrefID;
  const ApproveForm({Key key}) : super(key: key);

  @override
  _ApproveFormState createState() => _ApproveFormState();
}

class _ApproveFormState extends State<ApproveForm> {
  List formIDs = [];
  List preferenceIDs = [];
  List times = [];

  Future getForms() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from form left join receives on form.form_id = receives.form_id where receives.form_id is null')
              .then((r) => {
                    for (var row in r)
                      {
                        setState(() {
                          formIDs.add(row[0]);
                          preferenceIDs.add(row[1]);
                          times.add(row[2]);
                        }),
                      }
                  }),
        });
  }

  Future deleteForm(int id) async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn.query('delete from form where form_id = $id').then((r) => {}),
        });
  }

  @override
  void initState() {
    getForms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Center(
              child: Text(
                "Welcome\n\n" + Login.name + " " + Login.surname,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Center(
              child: Text(
                "The forms are waiting for your approval.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: formIDs.length,
                itemBuilder: (context, i) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: TextButton(
                        child: Text(
                          "ID = " +
                              formIDs[i].toString() +
                              " // created on " +
                              times[i].toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            ApproveForm.lastPrefID = preferenceIDs[i];
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage()));
                        },
                      ),
                    ),
                    secondaryActions: <Widget>[
                      new IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          deleteForm(formIDs[i]);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'connect.dart';

class Activity extends StatefulWidget {
  const Activity({Key key}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  TextEditingController newActivityName = new TextEditingController();

  List activityID = [];
  List activityName = [];
  int lastActivity = 0;

  List commentID = [];
  List commentContent = [];
  List commentRate = [];
  List commentName = [];

  Future getActivity() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn.query('select * from activity').then((results) => {
                for (var row in results)
                  {
                    setState(() {
                      activityID.add(row[0]);
                      activityName.add(row[1]);
                    })
                  }
              }),
        });
  }

  Future getComment() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select comment.comment_id, comment.user_id, comment.comment, comment.rating, user.name from comment natural join user order by comment.comment_id')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          commentID.add(row[0]);
                          commentContent.add(row[2]);
                          commentRate.add(row[3]);
                          commentName.add(row[4]);
                        })
                      },
                  }),
        });
  }

  Future newActivity() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from activity where activity_id = (SELECT MAX(activity_id) FROM activity)')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          lastActivity = row[0];
                        }),
                      },
                    conn
                        .query(
                            'insert into activity (activity_id, type) values (${lastActivity + 1}, "newActivity")')
                        .then((results) => {}),
                  }),
        });
  }

  Future changeActivityName(int id) async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'update activity set type = "${newActivityName.text}" where activity_id = $id')
              .then((results) => {}),
        });
  }

  Future deleteActivity(int id) async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn.query('delete from activity where activity_id = $id').onError(
                (error, stackTrace) => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Notice"),
                      content: Text(
                          "You could not delete, check if anyone is dealing with this activity"),
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
              ),
        });
  }

  @override
  void initState() {
    getActivity();
    getComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 40,
            ),
            Divider(
              height: 10,
              color: Colors.white,
              thickness: 3,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: commentID.length,
                itemBuilder: (context, i) {
                  return Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                            color: Colors.white,
                          ),
                          bottom: BorderSide(
                            color: Colors.white,
                          )),
                    ),
                    child: TextButton(
                      onPressed: () async {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            commentName[i] + ": " + commentRate[i].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6),
                          ),
                          Container(
                            width: 150,
                            child: Center(
                              child: Text(
                                commentContent[i],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(
              height: 10,
              color: Colors.white,
              thickness: 3,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: activityID.length,
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
                        onPressed: () async {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              activityID[i].toString() + ". Activity",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.6),
                            ),
                            Container(
                              width: 150,
                              child: Center(
                                child: Text(
                                  activityName[i],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Rename',
                        color: Colors.blue,
                        icon: Icons.info_outline,
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              contentPadding: EdgeInsets.all(16.0),
                              content: Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new TextField(
                                      controller: newActivityName,
                                      autofocus: true,
                                      decoration: new InputDecoration(
                                        labelText: 'Change Activity Type',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              actions: <Widget>[
                                new ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                new ElevatedButton(
                                    child: const Text('Okay'),
                                    onPressed: () async {
                                      changeActivityName(activityID[i]);
                                      Navigator.pop(context);
                                    })
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          deleteActivity(activityID[i]);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Divider(
              height: 10,
              color: Colors.white,
              thickness: 3,
              indent: 20,
              endIndent: 20,
            ),
            Container(
                margin: EdgeInsets.all(15),
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text("Add new Activity"),
                    ],
                  ),
                  onPressed: () {
                    newActivity();
                  },
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'connect.dart';
import 'login.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Room extends StatefulWidget {
  const Room({Key key}) : super(key: key);

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  TextEditingController comment = new TextEditingController();

  int roomID = 0;
  String roomName = "";
  String discordLink = "";
  String zoomLink = "";
  List userIDs = [];
  List userNames = [];
  bool commentExist = true;
  int rating = 0;
  int lastComment = 0;

  Future getRoomDetail() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query('select * from placement where user_id = ${Login.id}')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          roomID = row[1];
                        })
                      },
                  }),
        });
    await db.getConnection().then((conn) => {
          conn
              .query('select * from room where room_id = $roomID')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          roomName = row[1];
                        })
                      }
                  }),
        });
    await db.getConnection().then((conn) => {
          conn
              .query('select * from social_channel where room_id = $roomID')
              .then((results) => {
                    for (var row in results)
                      {
                        if (row[2] == "discord")
                          {
                            setState(() {
                              discordLink = row[3];
                            })
                          }
                        else if (row[2] == "zoom")
                          {
                            setState(() {
                              zoomLink = row[3];
                            })
                          }
                      }
                  }),
        });
    await db.getConnection().then((conn) => {
          conn
              .query('select * from placement where room_id = $roomID')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          userIDs.add(row[0]);
                        })
                      },
                  }),
        });
    await db.getConnection().then((conn) => {
          for (var i in userIDs)
            {
              conn
                  .query('select * from user where user_id = $i')
                  .then((results) => {
                        for (var row in results)
                          {
                            setState(() {
                              userNames.add(row[1] + " " + row[2]);
                            })
                          },
                      }),
            }
        });
  }

  Future checkComment() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query('select * from comment where user_id = ${Login.id}')
              .then((results) => {
                    if (results.isNotEmpty)
                      {
                        setState(() {
                          commentExist = true;
                        }),
                      }
                    else
                      {
                        setState(() {
                          commentExist = false;
                        }),
                      }
                  }),
        });
  }

  Future sendComment() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from comment where comment_id = (SELECT MAX(comment_id) FROM comment)')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          lastComment = row[0];
                        })
                      },
                    conn
                        .query(
                            'insert into comment (comment_id, user_id, comment, rating) values (${lastComment + 1}, ${Login.id}, "${comment.text}", $rating)')
                        .then((results) => {}),
                  }),
        });
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Send"),
      onPressed: () async {
        await sendComment();
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text('Give a comment to U-nion'),
      ),
      content: Container(
        height: 110,
        child: Column(
          children: [
            RatingBar.builder(
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (r) {
                setState(() {
                  rating = r.toInt();
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: comment,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.white),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    checkComment();
    getRoomDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.pink[500], Colors.blue[900]]),
              shape: BoxShape.rectangle,
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  commentExist == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 150,
                            ),
                            IconButton(
                              icon: Icon(Icons.info),
                              onPressed: () {
                                showAlertDialog(context);
                              },
                            )
                          ],
                        )
                      : SizedBox(),
                  Text(
                    roomName,
                    style: TextStyle(fontSize: 40, color: Colors.blue[900]),
                  ),
                  Column(
                    children: [
                      Text(
                        "Members",
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 3,
                                crossAxisCount: 2,
                              ),
                              itemCount: userNames.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Colors.blue[900],
                                      width: 2.0,
                                    ),
                                  ),
                                  margin: EdgeInsets.all(10),
                                  child: Center(
                                      child: Text(
                                    userNames[index],
                                    style: TextStyle(fontSize: 15),
                                  )),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: Column(
                      children: [
                        discordLink == ""
                            ? SizedBox()
                            : ListTile(
                                leading: Image.asset("assets/discord.jpg"),
                                title: Text("Discord"),
                                subtitle: Row(
                                  children: [
                                    TextButton(
                                      child: Text(discordLink),
                                      onPressed: () async {
                                        await canLaunch(discordLink)
                                            ? await launch(discordLink)
                                            : throw 'Could not launch $discordLink';
                                      },
                                    ),
                                  ],
                                ),
                              ),
                        zoomLink == ""
                            ? SizedBox()
                            : ListTile(
                                leading: Image.asset("assets/zoom.png"),
                                title: Text("Zoom"),
                                subtitle: Row(
                                  children: [
                                    TextButton(
                                      child: Text(zoomLink),
                                      onPressed: () async {
                                        print(zoomLink);
                                        await canLaunch(zoomLink)
                                            ? await launch(zoomLink)
                                            : throw 'Could not launch $zoomLink';
                                      },
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

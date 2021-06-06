import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'connect.dart';
import 'login.dart';

class Room extends StatefulWidget {
  const Room({Key key}) : super(key: key);

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  int roomID = 0;
  String roomName = "";
  String discordLink = "";
  String zoomLink = "";
  List userIDs = [];
  List userNames = [];

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

  @override
  void initState() {
    getRoomDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

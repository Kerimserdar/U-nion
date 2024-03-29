import 'package:flutter/material.dart';
import 'connect.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Channel extends StatefulWidget {
  const Channel({Key key}) : super(key: key);

  @override
  _ChannelState createState() => _ChannelState();
}

class _ChannelState extends State<Channel> {
  TextEditingController discordLink = new TextEditingController();
  TextEditingController zoomLink = new TextEditingController();
  TextEditingController newRoomName = new TextEditingController();

  int selectedDiscordChannelID = 0;
  int selectedZoomChannelID = 0;

  int discordID = 0;
  int zoomID = 0;

  List roomID = [];
  List roomName = [];

  int lastChannel = 0;
  int lastRoom = 0;

  List userIDs = [];
  List<Map<String, dynamic>> allChannelsDiscord = [];
  List<Map<String, dynamic>> allChannelsZoom = [];

  Future getRoom() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn.query('select * from room').then((results) => {
                for (var row in results)
                  {
                    setState(() {
                      roomID.add(row[0]);
                      roomName.add(row[1]);
                    })
                  }
              }),
        });
  }

  Future getChannel({int roomID = 0}) async {
    var db = new Mysql();
    roomID == 0
        ? await db.getConnection().then((conn) => {
              conn.query('select * from social_channel').then((result) => {
                    for (var row in result)
                      {
                        if (row[2] == "discord")
                          {
                            setState(() {
                              allChannelsDiscord.add({
                                "channel_id": row[0],
                                "room_id": row[1],
                                "name": row[2],
                                "link": row[3]
                              });
                            }),
                          }
                        else if (row[2] == "zoom")
                          {
                            setState(() {
                              allChannelsZoom.add({
                                "channel_id": row[0],
                                "room_id": row[1],
                                "name": row[2],
                                "link": row[3]
                              });
                            }),
                          }
                      }
                  }),
            })
        : await db.getConnection().then((conn) => {
              conn
                  .query('select * from social_channel where room_id = $roomID')
                  .then((result) => {
                        for (var row in result)
                          {
                            if (row[2] == "discord")
                              {
                                setState(() {
                                  discordID = row[0];
                                  discordLink.text = row[3];
                                }),
                              }
                            else if (row[2] == "zoom")
                              {
                                setState(() {
                                  zoomID = row[0];
                                  zoomLink.text = row[3];
                                }),
                              }
                          }
                      }),
            });
  }

  Future changeChannel(int id) async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          if (discordID != 0)
            {
              conn
                  .query(
                      'update social_channel set link = "${discordLink.text}" where channel_id = $discordID')
                  .then((result) => {}),
            }
          else
            {
              conn
                  .query(
                      'select * from social_channel where channel_id = (SELECT MAX(channel_id) FROM social_channel)')
                  .then((v) => {
                        for (var row in v)
                          {
                            setState(() {
                              lastChannel = row[0];
                            })
                          },
                        conn
                            .query(
                                'insert into social_channel (channel_id, room_id, name, link) values (${lastChannel + 1}, $id, "discord", "${discordLink.text}")')
                            .then((result) => {}),
                      }),
            }
        });
    await db.getConnection().then((conn) => {
          if (zoomID != 0)
            {
              conn
                  .query(
                      'update social_channel set link = "${zoomLink.text}" where channel_id = $zoomID')
                  .then((result) => {}),
            }
          else
            {
              conn
                  .query(
                      'select * from social_channel where channel_id = (SELECT MAX(channel_id) FROM social_channel)')
                  .then((v) => {
                        for (var row in v)
                          {
                            setState(() {
                              lastChannel = row[0];
                            })
                          },
                        conn
                            .query(
                                'insert into social_channel (channel_id, room_id, name, link) values (${lastChannel + 1}, $id, "zoom", "${zoomLink.text}")')
                            .then((result) => {}),
                      }),
            }
        });
  }

  Future newRoom({int localDiscordID = 0, int localZoomID = 0}) async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from room where room_id = (SELECT MAX(room_id) FROM room)')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          lastRoom = row[0];
                        }),
                      },
                    conn
                        .query(
                            'insert into room (room_id, name, capacity) values (${lastRoom + 1}, "newRoom", 10)')
                        .then((results) => {}),
                  }),
        });
    await db.getConnection().then((conn) => {
          (localDiscordID != 0 && localZoomID != 0)
              ? conn
                  .query(
                      'insert into social_channel (channel_id, room_id, name, link) values (${allChannelsDiscord[localDiscordID - 1]["channel_id"]}, ${lastRoom + 1}, "discord", "${allChannelsDiscord[localDiscordID - 1]["link"]}")')
                  .then((result) => {
                        conn
                            .query(
                                'insert into social_channel (channel_id, room_id, name, link) values (${allChannelsZoom[localZoomID - 1]["channel_id"]}, ${lastRoom + 1}, "zoom", "${allChannelsZoom[localZoomID - 1]["link"]}")')
                            .then((result) => {}),
                      })
              : conn
                  .query(
                      'select * from social_channel where channel_id = (SELECT MAX(channel_id) FROM social_channel)')
                  .then((results) => {
                        for (var row in results)
                          {
                            setState(() {
                              lastChannel = row[0];
                            }),
                          },
                        conn
                            .query(
                                'insert into social_channel (channel_id, room_id, name, link) values (${lastChannel + 1}, ${lastRoom + 1}, "discord", "https://discord.gg")')
                            .then((result) => {
                                  conn
                                      .query(
                                          'insert into social_channel (channel_id, room_id, name, link) values (${lastChannel + 2}, ${lastRoom + 1}, "zoom", "https://zoom.us")')
                                      .then((result) => {}),
                                }),
                      }),
        });
  }

  Future changeRoomName(int id) async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'update room set name = "${newRoomName.text}" where room_id = $id')
              .then((results) => {}),
        });
  }

  Future deleteRoom(int id) async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query('select * from placement where room_id = $id')
              .then((results) => {
                    for (var row in results)
                      {
                        setState(() {
                          userIDs.add(row[0]);
                        }),
                        conn
                            .query(
                                'select * from preference natural join form natural join receives where preference.user_id = ${row[0]}')
                            .then((results1) => {
                                  for (var row1 in results1)
                                    {
                                      conn
                                          .query(
                                              'delete from receives where form_id = ${row1[0]}')
                                          .then((results) => {
                                                conn
                                                    .query(
                                                        'delete from form where form_id = ${row1[0]}')
                                                    .then((results) => {
                                                          conn
                                                              .query(
                                                                  'delete from preference where user_id = ${row1[2]}')
                                                              .then((results) =>
                                                                  {}),
                                                        }),
                                              }),
                                    },
                                }),
                      },
                  }),
        });
    await db.getConnection().then((conn) => {
          conn
              .query('delete from social_channel where room_id = $id')
              .then((results) => {
                    conn
                        .query('delete from placement where room_id = $id')
                        .then((results) => {
                              conn
                                  .query('delete from room where room_id = $id')
                                  .then((results) => {}),
                            }),
                  }),
        });
  }

  @override
  void initState() {
    getRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.amber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: roomID.length,
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
                        onPressed: () async {
                          await getChannel(roomID: roomID[i]);
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.9,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(25.0),
                                        topRight: const Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "Room " + roomID[i].toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 30.0,
                                              child: Image.asset(
                                                  "assets/discord.jpg"),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: TextField(
                                                controller: discordLink,
                                                style: TextStyle(
                                                  color: Colors.amber,
                                                ),
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.amber,
                                                        width: 2.0),
                                                  ),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.amber),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      const Radius.circular(
                                                          10.0),
                                                    ),
                                                  ),
                                                  fillColor: Colors.white,
                                                  labelText: discordLink.text,
                                                  labelStyle: TextStyle(
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 30.0,
                                              child: Image.asset(
                                                  "assets/zoom.png"),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: TextField(
                                                controller: zoomLink,
                                                style: TextStyle(
                                                  color: Colors.amber,
                                                ),
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.amber,
                                                        width: 2.0),
                                                  ),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.amber),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      const Radius.circular(
                                                          10.0),
                                                    ),
                                                  ),
                                                  fillColor: Colors.white,
                                                  labelText: zoomLink.text,
                                                  labelStyle: TextStyle(
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            primary: Colors.amber, // background
                                            onPrimary:
                                                Colors.white, // foreground
                                          ),
                                          child: Text("Save"),
                                          onPressed: () async {
                                            await changeChannel(roomID[i]);
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    ),
                                  ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              roomID[i].toString() + ". Room",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.6),
                            ),
                            Container(
                              width: 150,
                              child: Center(
                                child: Text(
                                  roomName[i],
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
                                      controller: newRoomName,
                                      autofocus: true,
                                      decoration: new InputDecoration(
                                        labelText: 'New Room Name',
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
                                      changeRoomName(roomID[i]);
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
                          deleteRoom(roomID[i]);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Center(
                child: Text(
              "Click on the room to add, delete or edit the link",
              style: TextStyle(color: Colors.white, fontSize: 15),
            )),
            Container(
                margin: EdgeInsets.all(15),
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text("Add new Room"),
                    ],
                  ),
                  onPressed: () async {
                    allChannelsDiscord.clear();
                    allChannelsZoom.clear();
                    await getChannel();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        contentPadding: EdgeInsets.all(16.0),
                        content: Container(
                          height: 210,
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        await newRoom();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Clict to Add new channels to new room",
                                        style: TextStyle(fontSize: 16),
                                      )),
                                  Divider(
                                    color: Colors.amber,
                                    thickness: 3,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("Assign existing channels by clicking"),
                                  PopupMenuButton<int>(
                                      onSelected: (int value) {
                                        setState(() {
                                          selectedDiscordChannelID =
                                              (value + 1);
                                        });
                                        print(value + 1);
                                      },
                                      child: ListTile(
                                        title: Column(
                                          children: <Widget>[
                                            Text(
                                              'Discord',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      itemBuilder: (BuildContext context) {
                                        return List.generate(
                                            allChannelsDiscord.length, (index) {
                                          return PopupMenuItem(
                                            child: PopupMenuItem<int>(
                                              value: index,
                                              child: Text(
                                                  allChannelsDiscord[index]
                                                      ["link"]),
                                            ),
                                          );
                                        });
                                      }),
                                  PopupMenuButton<int>(
                                      onSelected: (int value) {
                                        setState(() {
                                          selectedZoomChannelID = (value + 1);
                                        });
                                        print(value + 1);
                                      },
                                      child: ListTile(
                                        title: Column(
                                          children: <Widget>[
                                            Text(
                                              'Zoom',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      itemBuilder: (BuildContext context) {
                                        return List.generate(
                                            allChannelsZoom.length, (index) {
                                          return PopupMenuItem(
                                            child: PopupMenuItem<int>(
                                              value: index,
                                              child: Text(allChannelsZoom[index]
                                                  ["link"]),
                                            ),
                                          );
                                        });
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          ElevatedButton(
                              child: const Text('Okay'),
                              onPressed: () async {
                                await newRoom(
                                    localDiscordID: selectedDiscordChannelID,
                                    localZoomID: selectedZoomChannelID);
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}

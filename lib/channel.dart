import 'package:flutter/material.dart';
import 'connect.dart';

class Channel extends StatefulWidget {
  const Channel({Key key}) : super(key: key);

  @override
  _ChannelState createState() => _ChannelState();
}

class _ChannelState extends State<Channel> {
  List channelID = [];
  List channelName = [];
  List roomID = [];
  List link = [];

  Future getChannel() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn.query('select * from social_channel').then((rresult) => {
                for (var row in rresult)
                  {
                    setState(() {
                      channelID.add(row[0]);
                      roomID.add(row[1]);
                      channelName.add(row[2]);
                      link.add(row[3]);
                    }),
                  }
              }),
        });
  }

  @override
  void initState() {
    getChannel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

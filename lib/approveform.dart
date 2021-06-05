import 'package:flutter/material.dart';

import 'connect.dart';

class AllForms extends StatefulWidget {
  const AllForms({Key key}) : super(key: key);

  @override
  _AllFormsState createState() => _AllFormsState();
}

class _AllFormsState extends State<AllForms> {
  Future getAllForms() async {
    var db = new Mysql();
    await db.getConnection().then((conn) => {
          conn
              .query(
                  'select * from form, receives where form.form_id = receives.form_id')
              .then((r) => {}),
        });
  }

  @override
  void initState() {
    getAllForms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

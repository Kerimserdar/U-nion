import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = "192.168.0.24",
  //178.233.210.66
  //10.0.0.2
      user = "root",
      password = "2014101kerim",
      db = "union";
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }
}

import 'package:mysql1/mysql1.dart';

class Mysql {
  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: '192.168.0.24',
        port: 3306,
        user: 'root',
        password: '2014101kerim',
        db: 'data');
    return await MySqlConnection.connect(settings);
  }
}

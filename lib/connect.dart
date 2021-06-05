import 'package:mysql1/mysql1.dart';

class Mysql {
  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: '',
        port: 3306,
        user: 'root',
        password: '',
        db: 'data');
    return await MySqlConnection.connect(settings);
  }
}

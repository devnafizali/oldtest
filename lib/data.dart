import 'package:shared_preferences/shared_preferences.dart';

saveList(key, dynamic list) async {
  print(list);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setStringList(key, list);
}

saveEsps(key, String address) async {
  print(address);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString(key, address);
  
}

setLength(key, int num) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setInt(key, num);
}

Future<int?> getLength(key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt(key);
}

Future<List<String>?> getList(key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getStringList(key);
}

deleteData(key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove(key);
}

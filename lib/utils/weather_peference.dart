

import 'package:shared_preferences/shared_preferences.dart';
String tempUnitkey='tempUnit';
String timeFormatKey ='timeFormate';

Future<bool> setBool(String keys, bool status) async{
  final pref = await SharedPreferences.getInstance();
  return pref.setBool(keys, status);
}
Future<bool> getBool(String key) async{
  final pref= await SharedPreferences.getInstance();
  return pref.getBool(key) ?? false;
}
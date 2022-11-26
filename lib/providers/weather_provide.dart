import 'dart:convert';
import 'package:apitest/models/current_weather.dart';
import 'package:apitest/models/forecast.dart';
import 'package:apitest/utils/weatherApI.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  CurrentWeatherResponse? currentWeather;
  Forecast? forecast;
  double latitude =0.0;
  double longitude =0.0;
  String tempUnit =metric;
  String tempUnitSymbol =celsius;
  String timePattern = timePattern12;
  void setNewLocation(double lat , double lng){
    longitude =lng;
    latitude= lat;
  }
  Future<void> convertAdresstolatLng( String city) async{
    try{
final locationList = await locationFromAddress(city);
if(locationList.isNotEmpty){
  final location =locationList.first;
  latitude= location.latitude;
  longitude = location.longitude;
  getData();
}
else{
  ScaffoldMessenger(child: SnackBar(content: Text('City Not Found'),backgroundColor: Colors.red,),);
}
    }catch(error){
      ScaffoldMessenger(child: SnackBar(content: Text(error.toString()),backgroundColor: Colors.red,),);
    }
  }
  bool get hasDataLoaded =>_getweather!=null && _getforecast!=null;
  void getData(){
    _getweather();
    _getforecast();
  }
  Future<void> _getweather() async {
    final urlString =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$tempUnit&appid=$apiKey&units=imperial';
    //http. er por->
    //get diye api data show and fect
    //put api te data rakhtesi
    //patch api er existing data update kora
    final response = await http.get(Uri.parse(urlString));
    final map = json.decode(response.body);
    if (response.statusCode == 200) {
      currentWeather = CurrentWeatherResponse.fromJson(map);
      notifyListeners();
    } else {
     Text( map['message']);
    }
  }
  void setTempUnit(bool status){
    tempUnit = status ? imperial: metric;
    tempUnitSymbol = status ? fahrenheit : celsius;
    getData();
  }
  Future<void> _getforecast() async {
    final urlString =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=$tempUnit&appid=$apiKey&units=imperial';
    //http. er por->
    //get diye api data show and fect
    //put api te data rakhtesi
    //patch api er existing data update kora
    final response = await http.get(Uri.parse(urlString));
    final map = json.decode(response.body);
    if (response.statusCode == 200) {
      forecast = Forecast.fromJson(map);
      notifyListeners();
    } else {
     Text( map['message']);
    }
  }



  void setTimePattern(bool timeFormatStatus) {
    timePattern = timeFormatStatus ? timePattern24 : timePattern12;
    notifyListeners();
  }
}

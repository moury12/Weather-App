import 'package:apitest/providers/weather_provide.dart';
import 'package:apitest/utils/weather_peference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  static const String routeName = '/setting';

  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isTempUnitSwitchedOn = false;
  bool is24HourFormated = false;
  @override
  void initState() {
getBool(tempUnitkey).then((value) {
  setState(() {
    isTempUnitSwitchedOn=value;

  });
}
);
getBool(timeFormatKey).then((value) {
  setState(() {
    is24HourFormated = value;
  });
});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        padding: EdgeInsets.all(6),
        children: [
          SwitchListTile(
            value: isTempUnitSwitchedOn,
            onChanged: (value) async{
              setState(() {
                isTempUnitSwitchedOn = value;
              });
              await setBool(tempUnitkey, value);
              Provider.of<WeatherProvider>(context, listen: false).setTempUnit(value);
            },
            title: const Text(
              'Show temperature in Fahrenheit',
            ),
            subtitle: const Text('Default is Celsius'),
          ),
          SwitchListTile(
            value: is24HourFormated,
            onChanged: (value) async{
              setState(() {
                is24HourFormated = value;
              });
              await setBool(timeFormatKey, value);
              Provider.of<WeatherProvider>(context, listen: false).setTimePattern(value);
            },
            title: const Text('Show time in 24 hour format'),
            subtitle: const Text('Default is 12 hour'),
          ),
        ],
      ),
    );
  }
}

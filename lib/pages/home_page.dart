import 'package:apitest/providers/weather_provide.dart';
import 'package:apitest/pages/settings_page.dart';
import 'package:apitest/utils/helper_function.dart';
import 'package:apitest/utils/weatherApI.dart';
import 'package:apitest/utils/weather_peference.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Home_page extends StatefulWidget {
  static const String routeName = '/';

  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  late WeatherProvider weatherProvider;
  bool calledOnce = true;

  @override
  void didChangeDependencies() {
    if (calledOnce) {
      weatherProvider = Provider.of<WeatherProvider>(context);
      _getData();
    }
    calledOnce = false;
    super.didChangeDependencies();
  }

  void _getData() async {
    final position = await _determinePosition();
    weatherProvider.setNewLocation(position.latitude, position.longitude);
    final tempUnitStatus = await getBool(tempUnitkey);
    final timeFormatStatus = await getBool(timeFormatKey);
    weatherProvider.setTimePattern(timeFormatStatus);
    weatherProvider.setTempUnit(tempUnitStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Weather App'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: _CitySearchDelegate())
                    .then((city) {
                  if (city != null && city.isNotEmpty) {
                    weatherProvider.convertAdresstolatLng(city);
                  }
                });
              },
              icon: Icon(
                Icons.search,
                size: 20,
              )),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Settings.routeName);
              },
              icon: Icon(
                Icons.settings,
                size: 20,
              )),
        ],
      ),
      body: weatherProvider.currentWeather == null|| weatherProvider.forecast==null
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : weatherProvider.hasDataLoaded
              ? ListView(
                  children: [
                    _weatherSection(),
                    _forecastSection(),
                  ],
                )
              : Center(child: const CircularProgressIndicator()),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Widget _weatherSection() {
    final current = weatherProvider.currentWeather;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(alignment: Alignment.topRight,
            child: Column(
              children: [

                    Text(
                      getFormatedDate(current!.dt!, pattern: 'MMM dd yyyy  hh:mm a'),
                      style: txtNormal16White54,
                    ),


                Text(
                  '${current.name}, ${current.sys!.country!}',
                  style: txtNormal16White54,
                ),
              ],
            ),

          ),

          Image.network(
            '$iconPrefix${current.weather![0].icon}$iconSuffix',
          ),

          Text(
            '${current.main!.temp!.round()}$degree${weatherProvider.tempUnitSymbol}',
            style: txtTempBig80,
          ),
          Text(
            current.weather![0].description!,
            style: txtNormalWhite16,
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/f.png',
                  height: 30,
                  width: 30,
                ),
                Text(
                  ' Feels like ${current.main!.feelsLike!.round()}$degree${weatherProvider.tempUnitSymbol}',
                  style: txtNormalWhite16,
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/h.png',
                      height: 15,
                      width: 15,
                    ),
                    Text(
                      ' Humidity ${current.main!.humidity}%',
                      style: txtNormal16White54,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/pp.png',
                      height: 15,
                      width: 15,
                    ),
                    Text(
                      ' Pressure ${current.main!.pressure} mb',
                      style: txtNormal16White54,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/w.png',
                      height: 15,
                      width: 15,
                    ),
                    Text(
                      ' Wind ${current.wind!.speed} km/h',
                      style: txtNormal16White54,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/v.png',
                      height: 15,
                      width: 15,
                    ),
                    Text(
                      ' Visibility ${current.visibility}meter',
                      style: txtNormal16White54,
                    )
                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/sr.png',
                      height: 15,
                      width: 15,
                    ),
                    Text(
                      '  ${getFormatedDate(current.sys!.sunrise!, pattern: weatherProvider.timePattern)} ',
                      style: txtNormalWhite16,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/ss.png',
                      height: 15,
                      width: 15,
                    ),
                    Text(
                      ' ${getFormatedDate(current.sys!.sunset!, pattern: weatherProvider.timePattern)}',
                      style: txtNormalWhite16,
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),

    );

  }

  Widget _forecastSection() {
    final forecastList = weatherProvider.forecast!.list!;
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastList.length,
        itemBuilder: (context, index) {
          final item = forecastList[index];
          return Container(
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.blueGrey.shade300,
            ),
            width: 110,
            height: 160,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getFormatedDate(item.dt!,
                        pattern: 'EEE ${weatherProvider.timePattern}'),
                    style: txtNormalWhite16,
                  ),
                  Image.network(
                    '$iconPrefix${item.weather![0].icon}$iconSuffix',
                    height: 40,
                    width: 40,
                  ),
                  Text(
                    ' ${item.main!.feelsLike!.round()}$degree${weatherProvider.tempUnitSymbol}',
                    style: txtNormalWhite16,
                  ),
                  Text('${item.weather![0].description}',
                      style: txtNormalWhite16)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');

      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: () {
        close(context, query);
      },
      title: Text(query),
      leading: const Icon(Icons.search),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filterdList = query.isEmpty
        ? cities
        : cities
            .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: filterdList.length,
      itemBuilder: (context, index) {
        final item = filterdList[index];
        return ListTile(
          onTap: () {
            query = item;
            close(context, query);
          },
          title: Text(item),
        );
      },
    );
  }
}

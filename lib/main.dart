import 'package:apitest/pages/home_page.dart';
import 'package:apitest/providers/weather_provide.dart';
import 'package:apitest/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => WeatherProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.nanumMyeongjoTextTheme(),
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: Home_page.routeName,
      routes: {Home_page.routeName: (context) => Home_page(),
      Settings.routeName:(context) => Settings()},
    );
  }
}

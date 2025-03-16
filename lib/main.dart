import 'package:flutter/material.dart';
import 'package:manga_tracking_app/views/home.dart';
import 'package:dynamic_color/dynamic_color.dart';


//Main Method
void main() async{
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  //Initial build for main homescreen
  @override
  Widget build(BuildContext context) {
    //DynamicColorBuilder is used for Material You themeing within the app
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Manga Tracker App',
          theme: ThemeData(
            // The question marks indicate that if the device running the app doesn't support dynamic theming, it will 
            // fall back to the light and dark themes written below
            colorScheme: lightDynamic ?? _lightTheme.colorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? _darkTheme.colorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: HomeScreen(),
        );
      },
    );
  }

//Different themes for the application for light and dark in case device doesn't support material you
  final _lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: const Color.fromARGB(255, 87, 178, 231),
    ),
    useMaterial3: true,
  );

  final _darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color.fromARGB(255, 30, 105, 167),
    ),
    useMaterial3: true,
  );
}

import 'package:flutter/material.dart';
import 'package:manga_tracking_app/views/home.dart';

//Main Method
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  //Initial build for main homescreen
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga Tracker App',
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.system,
      home: HomeScreen()
    );
  }
}

//Different themes for the application for light and dark
final _lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 87, 231, 176),
  ),
  useMaterial3: true,
);

final _darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 30, 167, 132),
  ),
  useMaterial3: true,
);

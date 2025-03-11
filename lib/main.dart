import 'package:flutter/material.dart';
import 'package:manga_tracking_app/views/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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

//Different themes for the application

final _lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 231, 133, 87),
  ),
  useMaterial3: true,
);

final _darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 153, 15, 15),
  ),
  useMaterial3: true,
);

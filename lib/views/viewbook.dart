import 'package:flutter/material.dart';

class Viewbook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Viewing a Manga"),
        ),
        body: ScrollbarTheme(
            data: ScrollbarThemeData(
                interactive: true,
                radius: Radius.circular(10),
                thumbColor: WidgetStatePropertyAll(
                  Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.2), // Adjust opacity here
                )),
            child: Scrollbar(
                thickness: 10,
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text("Dingus")
                  )))));
  }
}
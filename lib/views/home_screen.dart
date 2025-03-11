import 'package:flutter/material.dart';
import 'package:manga_tracking_app/widgets/manga_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Manga Tracking App"),
      ),
      body: Center(
          child: GridView(
            padding: EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 20,
          childAspectRatio: 5/8,
        ),
        children: [
          MangaCard(name: "Card 1"),
          MangaCard(name: "Card 2"),
          MangaCard(name: "Card 3"),
        ],
      )),
    );
  }
}

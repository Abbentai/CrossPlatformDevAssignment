import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manga_tracking_app/model/book.dart';
import 'package:manga_tracking_app/views/form.dart';
import 'package:manga_tracking_app/widgets/manga_card.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _bookGridState();
}

class _bookGridState extends State<HomeScreen> {
  List<Book> _books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadItems();
  }

  Future _loadItems() async {
    final url = Uri.https(
        "mangatrackercpdassignment-default-rtdb.europe-west1.firebasedatabase.app",
        'book-list.json');
    final response = await http.get(url);

    final List<Book> loadedList = [];

    final Map<String, dynamic> firebaseData = json.decode(response.body);

    for (final item in firebaseData.entries) {
      loadedList.add(Book(
        id: item.key,
        title: item.value["title"],
        volumeNum: item.value["volumeNum"],
        author: item.value["author"],
        isbn: item.value["isbn"],
        date: DateTime.parse(item.value["date"]),
        demographic: item.value["demographic"],
        publisher: item.value["publisher"],
        chapters: item.value["chapters"],
        pages: item.value["pages"],
        image: item.value["image"],
      ));
    }

    setState(() {
      _books = loadedList;
    });
  }

  void _creationForm(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => FormScreen()));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Manga currently logged'),
    );

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_books.isNotEmpty) {
      content = RefreshIndicator(
          onRefresh: _loadItems,
          child: Center(
              child: GridView(
            padding: EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 5 / 8,
            ),

            //These are temporarily just loaded via parameters for now with discord image links, these will eventually images store locally taken from the camera
            children: [
              for (final book in _books)
                MangaCard(
                  name: book.title,
                  image: book.image, // Assuming book.image holds the image URL
                  onTap: () {
                    () {};
                  },
                ),

              // MangaCard(
              //   name: "FullMetal Alchemist Vol. 1",
              //   imageURL:
              //       'https://cdn.discordapp.com/attachments/758289671591034910/1349865020158119996/PXL_20250313_220130992.jpg?ex=67d4a744&is=67d355c4&hm=510d0bdd6d3e559ae776b7fe9d3dbd06ed74e34163cfaa2ce2208625a06aa0ab&',
              // ),
            ],
          )));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Manga Tracking App"),
      ),
      body: content,

      //FAB button to add a new manga, sized box is for a custom FAB scale
      floatingActionButton: SizedBox(
        height: 72,
        width: 72,
        child: FittedBox(
            child: FloatingActionButton(
          onPressed: () => _creationForm(context),
          tooltip: 'Create New Manga',
          child: const Icon(Icons.add),
        )),
      ),
    );
  }
}

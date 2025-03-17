import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manga_tracking_app/model/book.dart';
import 'package:manga_tracking_app/views/form.dart';
import 'package:manga_tracking_app/views/viewbook.dart';
import 'package:manga_tracking_app/widgets/manga_card.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _bookGridState();
}

class _bookGridState extends State<HomeScreen> {
  List<Book> _books = [];
  bool noManga = false;
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
    try {
      final url = Uri.https(
          "mangatrackercpdassignment-default-rtdb.europe-west1.firebasedatabase.app",
          'book-list.json');
      final response = await http.get(url);

      final List<Book> loadedList = [];

      if (response.body == "null") {
        //If null noManga is set to true to show the proper indicator
        setState(() {
          _books = [];
          noManga = true;
          isLoading = false;
        });
        return;
      }

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
        noManga = _books.isEmpty;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading manga cards $e");
      noManga = true;
      isLoading = false;
    }
  }

  void _creationForm(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => FormScreen()));

    _loadItems();
  }

  void _viewBook(BuildContext context, Book book) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Viewbook(
              book: book,
            )));

    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Manga currently logged'),
    );

    if (noManga) {
      content = RefreshIndicator(
        onRefresh: _loadItems,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *
                0.7, // Adjust for centering
            child: Center(
              child: Text(
                "No Manga currently logged, \nUse the FAB at the bottom to add one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      );
    } else if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_books.isNotEmpty) {
      //content is now seperate due to the refresh indicator, also helps split the application more modularly
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
            children: [
              for (final book in _books)
                MangaCard(
                  name: book.title,
                  image: book.image,
                  volumeNum: book.volumeNum,
                  viewBook: () => _viewBook(context, book),
                ),
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

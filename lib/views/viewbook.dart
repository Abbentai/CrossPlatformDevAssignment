import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manga_tracking_app/model/book.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Viewbook extends StatelessWidget {
  const Viewbook({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    bool isImageLoading = true;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var isSendingData = false;

    if (book.image != null && book.image!.isNotEmpty) {
      try {
        imageBytes = base64Decode(book.image!);
      } catch (e) {
        debugPrint("Error decoding base64 image: $e");
        imageBytes = null;
      }
    }

    void showNotification() async {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your_channel_id', 'your_channel_name',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
          0, 'Book has been deleted', '', platformChannelSpecifics);
    }

    void deleteFromID(String bookId) async {
      try {
        isSendingData = true;

        final url = Uri.https(
          "mangatrackercpdassignment-default-rtdb.europe-west1.firebasedatabase.app",
          'book-list/$bookId.json', // Target the specific book by its ID
        );

        final response = await http.delete(url);

        if (response.statusCode == 200) {
          if (!context.mounted) return;
          Navigator.of(context).pop(true);
        } else {
          throw Exception("Failed to delete book");
        }
      } catch (e) {
        print("Error deleting book: $e");
        isSendingData = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Viewing ${book.title}"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section with proper constraints
              LayoutBuilder(
                builder: (_, constraints) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image container with proper sizing
                    SizedBox(
                      width: constraints.maxWidth * 0.5,
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (isImageLoading)
                              const CircularProgressIndicator(),
                            if (imageBytes != null)
                              Image.memory(
                                imageBytes,
                                width: constraints.maxWidth * 0.5,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: constraints.maxWidth * 0.04),
                    Container(
                      padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                      width: constraints.maxWidth * 0.45,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: ClipRRect(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.auto_stories, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    book.title,
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.person, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    book.author,
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.bookmark, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${book.chapters} Chapters',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.description, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${book.pages} Pages',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.calendar_month, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    DateFormat('d/M/y')
                                        .format(book.date)
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Rest of the book details

              //2nd layout builder
              LayoutBuilder(
                builder: (_, constraints) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                      width: constraints.maxWidth,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'ISBN',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                book.isbn,
                                style: Theme.of(context).textTheme.labelLarge,
                                overflow: TextOverflow.visible,
                              ),
                              const SizedBox(width: 24),
                              Text(
                                'Publisher',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  book.publisher,
                                  style: Theme.of(context).textTheme.labelLarge,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Demographic',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    book.demographic,
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ])
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () => deleteFromID(book.id),
                  child: isSendingData
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator())
                      : const Text('Delete'))
            ],
          ),
        ),
      ),
    );
  }
}

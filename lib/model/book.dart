import 'dart:ffi';

class Book {
  const Book({
    required this.id,
    required this.title,
    required this.volumeNum,
    required this.author,
    required this.isbn,
    required this.date,
    required this.demographic,
    required this.publisher,
    this.chapters,
    this.pages,
    this.image,
  });
  
  final String id;
  final String title;
  final Int volumeNum;
  final String author;
  final Int isbn;
  final DateTime date;
  final String demographic;
  final String publisher;
  final Int? chapters;
  final Int? pages;
  final String? image;
  
}
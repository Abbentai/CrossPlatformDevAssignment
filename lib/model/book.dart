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
  final int volumeNum;
  final String author;
  final String isbn;
  final DateTime date;
  final String demographic;
  final String publisher;
  final int? chapters;
  final int? pages;
  final String? image;
}

class Book {
  const Book(
      {required this.id,
      required this.title,
      required this.bookImg,
      required this.bookdetails});

  final String id;
  final String title;
  final String bookImg;
  final List<String> bookdetails;
}

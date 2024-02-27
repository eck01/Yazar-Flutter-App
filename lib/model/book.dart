class Book {
  Book(this.name, this.publicationYear, this.category);

  dynamic id;
  String name;
  DateTime publicationYear;
  int category;

  Book.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        publicationYear = map['publicationYear'],
        category = map['category'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'publicationYear': publicationYear,
      'category': category,
    };
  }
}

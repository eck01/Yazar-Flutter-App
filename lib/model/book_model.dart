class BookModel {
  BookModel(this.name, this.publicationYear, this.category);

  int? id;
  String name;
  DateTime publicationYear;
  int category;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'publicationYear': publicationYear.millisecondsSinceEpoch,
      'category': category,
    };
  }

  BookModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        publicationYear = DateTime.fromMillisecondsSinceEpoch(map['publicationYear']),
        category = map['category'];
}

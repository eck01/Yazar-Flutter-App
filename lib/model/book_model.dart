class BookModel {
  BookModel(this.name, this.publicationYear);

  int? id;
  String name;
  DateTime publicationYear;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'publicationYear': publicationYear.millisecondsSinceEpoch,
    };
  }

  BookModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        publicationYear = DateTime.fromMillisecondsSinceEpoch(map['publicationYear']);
}

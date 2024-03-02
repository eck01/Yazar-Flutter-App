import 'package:flutter/material.dart';

class Book with ChangeNotifier {
  Book(this.name, this.publicationYear, this.category);

  dynamic id;
  String name;
  DateTime publicationYear;
  int category;

  bool isSelect = false;

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

  void select(bool state) {
    isSelect = state;
    notifyListeners();
  }

  void update(String value, int index) {
    name = value;
    category = index;
    notifyListeners();
  }
}

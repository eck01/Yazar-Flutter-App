import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/constants.dart';
import 'package:yazar/local_database.dart';
import 'package:yazar/model/book.dart';
import 'package:yazar/view/chapters_view.dart';
import 'package:yazar/view_model/chapters_view_model.dart';

class BooksViewModel with ChangeNotifier {
  BooksViewModel() {
    _categories.addAll(Constants.categories.keys);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      readBooks();
    });
  }

  final LocalDatabase _database = LocalDatabase();

  List<Book> _books = [];
  List<Book> get books => _books;

  int _category = -1;
  int get category => _category;
  set category(int index) {
    _category = index;
    notifyListeners();
    readBooks();
  }

  final List<int> _categories = [-1];
  List<int> get categories => _categories;

  final List<int> _checkboxList = [];
  List<int> get checkboxList => _checkboxList;

  Future<void> createBook(BuildContext context) async {
    List<dynamic>? response = await _buildDialog(context, 'Kitap Ekle');

    if (response != null && response.length > 1) {
      String text = response[0];
      int index = response[1];

      Book object = Book(text, DateTime.now(), index);
      int result = await _database.createBook(object);
      if (result > -1) {
        object.id = result;
        _books.add(object);
        notifyListeners();
      }
    }
  }

  Future<void> readBooks() async {
    _books = await _database.readBooks(_category);
    notifyListeners();
  }

  Future<void> updateBook(BuildContext context, int index) async {
    Book object = _books[index];
    List<dynamic>? response = await _buildDialog(context, 'Kitap Güncelle', bookName: object.name, bookCategory: object.category);

    if (response != null && response.length > 1) {
      String text = response[0];
      int index = response[1];

      if (text != object.name || index != object.category) {
        object.update(text, index);
        await _database.updateBook(object);
      }
    }
  }

  Future<void> deleteBooks() async {
    int result = await _database.deleteBooks(_checkboxList);
    if (result > 0) {
      _books.removeWhere((object) => _checkboxList.contains(object.id));
      notifyListeners();
    }
  }

  Future<List<dynamic>?> _buildDialog(BuildContext context, String title, {String bookName = '', int bookCategory = 0}) {
    return showDialog<List<dynamic>?>(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController(text: bookName);
        int category = bookCategory;

        return AlertDialog(
          title: Text(title),
          content: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kategori:'),
                      DropdownButton<int>(
                        value: category,
                        items: Constants.categories.keys.map((index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(Constants.categories[index] ?? ''),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              category = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, [controller.text.trim(), category]);
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  void openView(BuildContext context, Book object) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) {
        return ChangeNotifierProvider(
          create: (context) => ChaptersViewModel(object),
          child: const ChaptersView(),
        );
      },
    );

    Navigator.push(context, route);
  }
}

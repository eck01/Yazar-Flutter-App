import 'package:flutter/material.dart';
import 'package:yazar/constants.dart';
import 'package:yazar/local_database.dart';
import 'package:yazar/model/book_model.dart';
import 'package:yazar/view/chapters_view.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  final LocalDatabase _database = LocalDatabase();
  List<BookModel> _books = [];
  int _category = -1;
  final List<int> _categories = [-1];
  final List<int> _checkboxList = [];

  @override
  void initState() {
    super.initState();

    _categories.addAll(Constants.categories.keys);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Kitaplar'),
      actions: [
        IconButton(
          onPressed: _deleteBooks,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Future<void> _deleteBooks() async {
    int result = await _database.deleteBooks(_checkboxList);
    if (result > 0) {
      setState(() {});
    }
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: _readBooks(),
      builder: _buildListView,
    );
  }

  Future<void> _readBooks() async {
    _books = await _database.readBooks(_category);
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot<void> snapshot) {
    return Column(
      children: [
        _buildCategoryButton(),
        Expanded(
          child: ListView.builder(
            itemCount: _books.length,
            itemBuilder: _buildListItem,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('Kategori:'),
        DropdownButton(
          value: _category,
          items: _categories.map((index) {
            return DropdownMenuItem(
              value: index,
              child: Text(
                index == -1 ? 'Hepsi' : Constants.categories[index] ?? '',
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              if (value != null) {
                _category = value;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(child: Text(_books[index].id.toString())),
      title: Text(_books[index].name),
      subtitle: Text(Constants.categories[_books[index].category] ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _updateBook(index);
            },
            icon: const Icon(Icons.edit),
          ),
          Checkbox(
            value: _checkboxList.contains(_books[index].id),
            onChanged: (bool? state) {
              if (state != null) {
                int? id = _books[index].id;
                if (id != null) {
                  setState(() {
                    if (state) {
                      _checkboxList.add(id);
                    } else {
                      _checkboxList.remove(id);
                    }
                  });
                }
              }
            },
          ),
        ],
      ),
      onTap: () {
        _openView(_books[index]);
      },
    );
  }

  Future<void> _updateBook(int index) async {
    BookModel object = _books[index];
    List<dynamic>? response = await _buildDialog('Kitap Güncelle', bookName: object.name, bookCategory: object.category);

    if (response != null && response.length > 1) {
      String text = response[0];
      int index = response[1];

      if (text != object.name || index != object.category) {
        object.name = text;
        object.category = index;
        int result = await _database.updateBook(object);
        if (result > 0) {
          setState(() {});
        }
      }
    }
  }

  void _openView(BookModel object) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) {
        return ChaptersView(object);
      },
    );

    Navigator.push(context, route);
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _createBook,
      child: const Icon(Icons.add),
    );
  }

  Future<void> _createBook() async {
    List<dynamic>? response = await _buildDialog('Kitap Ekle');

    if (response != null && response.length > 1) {
      String text = response[0];
      int index = response[1];

      BookModel object = BookModel(text, DateTime.now(), index);
      int result = await _database.createBook(object);
      if (result > -1) {
        setState(() {});
      }
    }
  }

  Future<List<dynamic>?> _buildDialog(String title, {String bookName = '', int bookCategory = 0}) {
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
}

import 'package:flutter/material.dart';
import 'package:yazar/local_database.dart';
import 'package:yazar/model/book_model.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  final LocalDatabase _database = LocalDatabase();
  List<BookModel> _books = [];

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
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: _readBooks(),
      builder: _buildListView,
    );
  }

  Future<void> _readBooks() async {
    _books = await _database.read();
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot<void> snapshot) {
    return ListView.builder(
      itemCount: _books.length,
      itemBuilder: _buildListItem,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(child: Text(_books[index].id.toString())),
      title: Text(_books[index].name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _updateBook(index);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _deleteBook(index);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _createBook,
      child: const Icon(Icons.add),
    );
  }

  Future<void> _createBook() async {
    String? text = await _buildDialog('Kitap Ekle');

    if (text != null) {
      BookModel book = BookModel(text, DateTime.now());
      int result = await _database.create(book);
      if (result > -1) {
        setState(() {});
      }
    }
  }

  Future<void> _updateBook(int index) async {
    String? text = await _buildDialog('Kitap Güncelle');

    if (text != null) {
      BookModel book = _books[index];
      book.name = text;
      int result = await _database.update(book);
      if (result > 0) {
        setState(() {});
      }
    }
  }

  Future<String?> _buildDialog(String title) {
    return showDialog(
      context: context,
      builder: (context) {
        String? text;

        return AlertDialog(
          title: Text(title),
          content: TextField(onChanged: (value) {
            text = value;
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, text);
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBook(int index) async {
    BookModel book = _books[index];
    int result = await _database.delete(book);
    if (result > 0) {
      setState(() {});
    }
  }
}

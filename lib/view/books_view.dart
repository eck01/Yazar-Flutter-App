import 'package:flutter/material.dart';
import 'package:yazar/model/book_model.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
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
    return const SizedBox();
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _floatingActionButtonOnPressed,
      child: const Icon(Icons.add),
    );
  }

  Future<void> _floatingActionButtonOnPressed() async {
    String? name = await _buildDialog();
    if (name != null) {
      BookModel book = BookModel(name, DateTime.now());
    }
  }

  Future<String?> _buildDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        String? text;

        return AlertDialog(
          title: const Text('Kitap Ekle'),
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
}

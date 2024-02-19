import 'package:flutter/material.dart';
import 'package:yazar/local_database.dart';
import 'package:yazar/model/book_model.dart';
import 'package:yazar/model/chapter_model.dart';

class ChaptersView extends StatefulWidget {
  const ChaptersView(this._book, {super.key});

  final BookModel _book;

  @override
  State<ChaptersView> createState() => _ChaptersViewState();
}

class _ChaptersViewState extends State<ChaptersView> {
  final LocalDatabase _database = LocalDatabase();
  List<ChapterModel> _chapters = [];

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
      title: Text(widget._book.name),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: readChapters(),
      builder: _buildListView,
    );
  }

  Future<void> readChapters() async {
    int? bookId = widget._book.id;
    if (bookId != null) {
      _chapters = await _database.readChapters(bookId);
    }
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot<void> snapshot) {
    return ListView.builder(
      itemCount: _chapters.length,
      itemBuilder: _buildListItem,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(child: Text(_chapters[index].id.toString())),
      title: Text(_chapters[index].title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _updateChapter(index);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _deleteChapter(index);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _updateChapter(int index) async {
    String? text = await _buildDialog('Bölüm Güncelle');

    if (text != null) {
      ChapterModel object = _chapters[index];
      object.title = text;
      int result = await _database.updateChapter(object);
      if (result > 0) {
        setState(() {});
      }
    }
  }

  Future<void> _deleteChapter(int index) async {
    ChapterModel object = _chapters[index];
    int result = await _database.deleteChapter(object);
    if (result > 0) {
      setState(() {});
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _createChapter,
      child: const Icon(Icons.add),
    );
  }

  Future<void> _createChapter() async {
    int? bookId = widget._book.id;
    String? text = await _buildDialog('Bölüm Ekle');

    if (bookId != null && text != null) {
      ChapterModel object = ChapterModel(bookId, text);
      int result = await _database.createChapter(object);
      if (result > -1) {
        setState(() {});
      }
    }
  }

  Future<String?> _buildDialog(String title) async {
    return await showDialog(
      context: context,
      builder: (context) {
        String? text;

        return AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (String value) {
              text = value;
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

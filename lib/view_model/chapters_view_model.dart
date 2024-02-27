import 'package:flutter/material.dart';
import 'package:yazar/local_database.dart';
import 'package:yazar/model/book.dart';
import 'package:yazar/model/chapter.dart';
import 'package:yazar/view/chapter_detail_view.dart';

class ChaptersViewModel {
  ChaptersViewModel(this._book);

  final Book _book;
  final LocalDatabase _database = LocalDatabase();
  List<Chapter> _chapters = [];

  Future<void> _createChapter(BuildContext context) async {
    int? bookId = _book.id;
    String? text = await _buildDialog(context, 'Bölüm Ekle');

    if (bookId != null && text != null) {
      Chapter object = Chapter(bookId, text);
      int result = await _database.createChapter(object);
      if (result > -1) {
        // setState(() {});
      }
    }
  }

  Future<void> _readChapters() async {
    int? bookId = _book.id;
    if (bookId != null) {
      _chapters = await _database.readChapters(bookId);
    }
  }

  Future<void> _updateChapter(BuildContext context, int index) async {
    String? text = await _buildDialog(context, 'Bölüm Güncelle');

    if (text != null) {
      Chapter object = _chapters[index];
      object.title = text;
      int result = await _database.updateChapter(object);
      if (result > 0) {
        // setState(() {});
      }
    }
  }

  Future<String?> _buildDialog(BuildContext context, String title) async {
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

  Future<void> _deleteChapter(int index) async {
    Chapter object = _chapters[index];
    int result = await _database.deleteChapter(object);
    if (result > 0) {
      // setState(() {});
    }
  }

  void _openView(BuildContext context, Chapter object) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) {
        return ChapterDetailView();
      },
    );

    Navigator.push(context, route);
  }
}

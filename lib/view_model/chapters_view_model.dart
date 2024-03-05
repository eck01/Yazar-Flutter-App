import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/model/book.dart';
import 'package:yazar/model/chapter.dart';
import 'package:yazar/repository/database_repository.dart';
import 'package:yazar/tools/locator.dart';
import 'package:yazar/view/chapter_detail_view.dart';
import 'package:yazar/view_model/chapter_detail_view_model.dart';

class ChaptersViewModel with ChangeNotifier {
  ChaptersViewModel(this._book) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      readChapters();
    });
  }

  final Book _book;
  Book get book => _book;

  final DatabaseRepository _databaseRepository = locator<DatabaseRepository>();

  List<Chapter> _chapters = [];
  List<Chapter> get chapters => _chapters;

  Future<void> createChapter(BuildContext context) async {
    int? bookId = _book.id;
    String? text = await _buildDialog(context, 'Bölüm Ekle');

    if (bookId != null && text != null) {
      Chapter object = Chapter(bookId, text);
      int result = await _databaseRepository.createChapter(object);
      if (result > -1) {
        object.id = result;
        _chapters.add(object);
        notifyListeners();
      }
    }
  }

  Future<void> readChapters() async {
    int? bookId = _book.id;
    if (bookId != null) {
      _chapters = await _databaseRepository.readChapters(bookId);
      notifyListeners();
    }
  }

  Future<void> updateChapter(BuildContext context, int index) async {
    String? text = await _buildDialog(context, 'Bölüm Güncelle');

    if (text != null) {
      Chapter object = _chapters[index];
      object.update(text);
      await _databaseRepository.updateChapter(object);
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

  Future<void> deleteChapter(int index) async {
    Chapter object = _chapters[index];
    int result = await _databaseRepository.deleteChapter(object);
    if (result > 0) {
      _chapters.removeAt(index);
      notifyListeners();
    }
  }

  void openView(BuildContext context, Chapter object) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) {
        return ChangeNotifierProvider(
          create: (context) => ChapterDetailViewModel(object),
          child: ChapterDetailView(),
        );
      },
    );

    Navigator.push(context, route);
  }
}

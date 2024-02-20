import 'package:flutter/material.dart';
import 'package:yazar/local_database.dart';
import 'package:yazar/model/chapter_model.dart';

class ChapterDetailView extends StatelessWidget {
  ChapterDetailView(this._object, {super.key});

  final ChapterModel _object;

  final TextEditingController _controller = TextEditingController();
  final LocalDatabase _database = LocalDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_object.title),
      actions: [
        IconButton(
          onPressed: _updateContent,
          icon: const Icon(Icons.save),
        ),
      ],
    );
  }

  Future<void> _updateContent() async {
    _object.content = _controller.text;
    await _database.updateChapter(_object);
  }

  Widget _buildBody() {
    _controller.text = _object.content;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        maxLines: 1000,
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
      ),
    );
  }
}

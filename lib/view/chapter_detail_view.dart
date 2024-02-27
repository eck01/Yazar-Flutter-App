import 'package:flutter/material.dart';

class ChapterDetailView extends StatelessWidget {
  ChapterDetailView({super.key});

  final TextEditingController _controller = TextEditingController();

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

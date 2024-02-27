import 'package:flutter/material.dart';

class ChaptersView extends StatelessWidget {
  const ChaptersView({super.key});

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
      title: Text(_book.name),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: _readChapters(),
      builder: _buildListView,
    );
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
      onTap: () {
        _openView(_chapters[index]);
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _createChapter,
      child: const Icon(Icons.add),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/model/chapter.dart';
import 'package:yazar/view_model/chapters_view_model.dart';

class ChaptersView extends StatelessWidget {
  const ChaptersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    ChaptersViewModel viewModel = Provider.of<ChaptersViewModel>(context, listen: false);
    return AppBar(
      title: Text(viewModel.book.name),
    );
  }

  Widget _buildBody() {
    return Consumer<ChaptersViewModel>(
      builder: (context, viewModel, child) => ListView.builder(
        itemCount: viewModel.chapters.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: viewModel.chapters[index],
            child: _buildListItem(context, index),
          );
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    ChaptersViewModel viewModel = Provider.of<ChaptersViewModel>(context, listen: false);
    return Consumer<Chapter>(
      builder: (context, object, child) => ListTile(
        leading: CircleAvatar(child: Text(object.id.toString())),
        title: Text(object.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                viewModel.updateChapter(context, index);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                viewModel.deleteChapter(index);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        onTap: () {
          viewModel.openView(context, object);
        },
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    ChaptersViewModel viewModel = Provider.of<ChaptersViewModel>(context, listen: false);
    return FloatingActionButton(
      onPressed: () {
        viewModel.createChapter(context);
      },
      child: const Icon(Icons.add),
    );
  }
}

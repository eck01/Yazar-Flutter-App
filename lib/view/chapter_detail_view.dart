import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/view_model/chapter_detail_view_model.dart';

class ChapterDetailView extends StatelessWidget {
  ChapterDetailView({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    ChapterDetailViewModel viewModel = Provider.of<ChapterDetailViewModel>(context, listen: false);
    return AppBar(
      title: Text(viewModel.object.title),
      actions: [
        IconButton(
          onPressed: () {
            viewModel.updateContent(_controller.text);
          },
          icon: const Icon(Icons.save),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    ChapterDetailViewModel viewModel = Provider.of<ChapterDetailViewModel>(context, listen: false);
    _controller.text = viewModel.object.content;
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

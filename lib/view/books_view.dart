import 'package:flutter/material.dart';

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

  void _floatingActionButtonOnPressed() {}
}

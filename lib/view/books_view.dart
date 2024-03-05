import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/tools/constants.dart';
import 'package:yazar/model/book.dart';
import 'package:yazar/view_model/books_view_model.dart';

class BooksView extends StatelessWidget {
  const BooksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    BooksViewModel viewModel = Provider.of<BooksViewModel>(context, listen: false);
    return AppBar(
      title: const Text('Kitaplar'),
      actions: [
        IconButton(
          onPressed: viewModel.deleteBooks,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildCategoryButton(),
        Expanded(
          child: Consumer<BooksViewModel>(
            builder: (context, viewModel, child) => ListView.builder(
              itemCount: viewModel.books.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: viewModel.books[index],
                  child: _buildListItem(context, index),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('Kategori:'),
        Consumer<BooksViewModel>(
          builder: (context, viewModel, child) => DropdownButton(
            value: viewModel.category,
            items: viewModel.categories.map((index) {
              return DropdownMenuItem(
                value: index,
                child: Text(
                  index == -1 ? 'Hepsi' : Constants.categories[index] ?? '',
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                viewModel.category = value;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    BooksViewModel viewModel = Provider.of<BooksViewModel>(context, listen: false);
    return Consumer<Book>(
      builder: (context, object, child) => ListTile(
        leading: CircleAvatar(child: Text(object.id.toString())),
        title: Text(object.name),
        subtitle: Text(Constants.categories[object.category] ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                viewModel.updateBook(context, index);
              },
              icon: const Icon(Icons.edit),
            ),
            Checkbox(
              value: object.isSelect,
              onChanged: (bool? state) {
                if (state != null) {
                  int? id = object.id;
                  if (id != null) {
                    if (state) {
                      viewModel.checkboxList.add(id);
                    } else {
                      viewModel.checkboxList.remove(id);
                    }
                    object.select(state);
                  }
                }
              },
            ),
          ],
        ),
        onTap: () {
          viewModel.openView(context, viewModel.books[index]);
        },
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    BooksViewModel viewModel = Provider.of<BooksViewModel>(context, listen: false);
    return FloatingActionButton(
      onPressed: () {
        viewModel.createBook(context);
      },
      child: const Icon(Icons.add),
    );
  }
}

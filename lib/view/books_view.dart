import 'package:flutter/material.dart';
import 'package:yazar/constants.dart';

class BooksView extends StatelessWidget {
  const BooksView({super.key});

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
      actions: [
        IconButton(
          onPressed: _deleteBooks,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: _readBooks(),
      builder: _buildListView,
    );
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot<void> snapshot) {
    return Column(
      children: [
        _buildCategoryButton(),
        Expanded(
          child: ListView.builder(
            itemCount: _books.length,
            itemBuilder: _buildListItem,
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
        DropdownButton(
          value: _category,
          items: _categories.map((index) {
            return DropdownMenuItem(
              value: index,
              child: Text(
                index == -1 ? 'Hepsi' : Constants.categories[index] ?? '',
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              if (value != null) {
                _category = value;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(child: Text(_books[index].id.toString())),
      title: Text(_books[index].name),
      subtitle: Text(Constants.categories[_books[index].category] ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _updateBook(index);
            },
            icon: const Icon(Icons.edit),
          ),
          Checkbox(
            value: _checkboxList.contains(_books[index].id),
            onChanged: (bool? state) {
              if (state != null) {
                int? id = _books[index].id;
                if (id != null) {
                  setState(() {
                    if (state) {
                      _checkboxList.add(id);
                    } else {
                      _checkboxList.remove(id);
                    }
                  });
                }
              }
            },
          ),
        ],
      ),
      onTap: () {
        _openView(_books[index]);
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _createBook,
      child: const Icon(Icons.add),
    );
  }
}

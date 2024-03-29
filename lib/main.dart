import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/tools/locator.dart';
import 'package:yazar/view/books_view.dart';
import 'package:yazar/view_model/books_view_model.dart';

void main() {
  setupLocator();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => BooksViewModel(),
        child: const BooksView(),
      ),
    );
  }
}

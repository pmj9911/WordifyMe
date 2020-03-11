import 'add_new_word_screen.dart';
import 'package:flutter/material.dart';
import 'revise_words.dart';
import 'view_words_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordify Me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Wordify ME!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, Object>> _pages;
  bool refreshed = false;
  @override
  void initState() {
    _pages = [
      {
        'page': ViewWords(),
        'title': 'View Words',
      },
      {
        'page': AddNewWord(),
        'title': 'Add New',
      },
      {
        'page': ReviseWords(),
        'title': 'Revise',
      },
    ];
    super.initState();
  }

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(_pages[_selectedPageIndex]['title']),
        ),
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellow,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_carousel),
            title: Text("View Words"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_new),
            title: Text("Add new"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text("Revise"),
          ),
        ],
      ),
    );
  }
}

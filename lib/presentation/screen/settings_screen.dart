import 'package:money_control/data/models/tabs_screen_arguments.dart';
import 'package:flutter/material.dart';

import 'cards_screen.dart';
import 'categories_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var currentIndex = 0;
  List<Map<String, Object>> _pages = [];
  var _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = '';

    _pages = [
      {
        'page': CardsScreen(),
        'title': 'Ваши карточки',
      },
      {
        'page': Container(),
        'title': '',
      },
      {
        'page': CategoriesScreen(),
        'title': 'Ваши категории',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final TabsScreenArguments args =
        ModalRoute.of(context)?.settings.arguments as TabsScreenArguments;

    if (args.page != null) currentIndex = args.page!;

    var appBar = AppBar(
      brightness: Brightness.dark,
      backgroundColor: Colors.transparent,
      title: Text(_pages[currentIndex]['title'] as String),
      elevation: 0,
      centerTitle: true,
    );

    print('hi');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff1d2671),
            Color(0xffaa076b),
          ],
        ),
      ),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: Colors.transparent,
        body: _pages[currentIndex]['page'] as Widget,
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                border:
                    Border(top: BorderSide(color: Colors.white, width: 1.0))),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: currentIndex,
              selectedLabelStyle: TextStyle(color: Colors.white),
              unselectedLabelStyle: TextStyle(color: Colors.white),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_to_photos,
                    color: Colors.white,
                  ),
                  label: 'Карточки',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white),
                  label: 'Домой',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category, color: Colors.white),
                  label: 'Категории',
                ),
              ],
              onTap: (index) {
                setState(() {
                  if (index == 1) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  } else {
                    currentIndex = index;
                    args.page = index;
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

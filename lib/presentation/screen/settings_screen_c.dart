import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/domain/cubit/settings_cubit.dart';
import 'package:money_control/presentation/pages/categories_page.dart';
import 'package:money_control/presentation/pages/planner_page.dart';

class SettingsScreenC extends StatelessWidget {
  const SettingsScreenC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsCubit = BlocProvider.of<SettingsCubit>(context);
    final dataCubit = BlocProvider.of<DataCubit>(context);

    List<Map<String, dynamic>> _pages = [
      {
        'page': CategoriesPage(dataCubit: dataCubit),
        'title': 'Ваши категории',
      },
      {
        'page': Container(),
        'title': '',
      },
      {
        'page': PlannerPage(dataCubit: dataCubit),
        'title': 'Цели',
      },
    ];

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
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Colors.transparent,
              title: Text(
                _pages[settingsCubit.state.indexPage.index]['title'],
              ),
              elevation: 0,
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            body: _pages[settingsCubit.state.indexPage.index]['page'],
            bottomNavigationBar: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    top: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedLabelStyle: TextStyle(color: Colors.white),
                  unselectedLabelStyle: TextStyle(color: Colors.white),
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.category, color: Colors.white),
                      label: 'Категории',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: Colors.white),
                      label: 'Домой',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.task,
                        color: Colors.white,
                      ),
                      label: 'Цели',
                    ),
                  ],
                  currentIndex: (state).indexPage.index,
                  onTap: (int index) {
                    settingsCubit.changePage(context, index);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

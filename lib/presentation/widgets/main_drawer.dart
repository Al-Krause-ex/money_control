import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/domain/cubit/settings_cubit.dart';
import 'package:money_control/helpers/constants/app_screen_routes.dart';
import 'package:money_control/presentation/screen/generate_report_screen.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  final DataCubit dataCubit;

  MainDrawer({required this.dataCubit});

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List<Map<String, dynamic>> availableIcons = [];
  List<Map<String, dynamic>> temporarilyTakenIcons = [];

  final myController = TextEditingController();

  void pushToSettings(IndexPage indexPage) {
    Navigator.pushNamed(
      context,
      AppScreenRoutes.settingsScreen,
      arguments: {
        'cats': widget.dataCubit.state.customUser.categories.length,
        'indexPage': indexPage
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xffaa076b),
              Color(0xff1d2671),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, bottom: 25.0, left: 25.0),
              child: Text(
                'Настройки',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: buildContainerEntities(
                context: context,
                title: 'целей',
                titleFirstFace: 'цели',
                created: '${widget.dataCubit.state.customUser.goals.length}',
                available: null,
                func: () => pushToSettings(IndexPage.goals),
              ),
              // child: buildContainerEntities(
              //   context: context,
              //   title: 'карточек',
              //   titleFirstFace: 'карточки',
              //   created: '${widget.dataCubit.state.customUser.cards.length}',
              //   available:
              //       '${widget.dataCubit.state.customUser.categories.length - widget.dataCubit.state.customUser.cards.length}',
              //   func: () => pushToSettings(IndexPage.cards),
              // ),
            ),
            buildContainerEntities(
              context: context,
              title: 'категорий',
              titleFirstFace: 'категории',
              created: '${widget.dataCubit.state.customUser.categories.length}',
              available:
                  '${DUMMY_ICONS.length - widget.dataCubit.state.customUser.categories.length}',
              func: () => pushToSettings(IndexPage.categories),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                top: 130.0,
                bottom: 20.0,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Статистика',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppScreenRoutes.statisticsScreen);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                bottom: 20.0,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Сформировать отчёт',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppScreenRoutes.generateReportScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainerEntities({
    required BuildContext context,
    required String title,
    required String titleFirstFace,
    required String created,
    required String? available,
    required Function func,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Text(
                'Создано $title: $created',
                style: TextStyle(
                  fontSize: 21.0,
                  color: Colors.white,
                ),
              ),
            ),
            if (available != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Доступно $title: $available',
                  style: TextStyle(
                    fontSize: 21.0,
                    color: Colors.white,
                  ),
                ),
              ),
            if (available == null) SizedBox(height: 8.0),
            Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                // shape: RoundedRectangleBorder(
                //   side: BorderSide(
                //       color: Colors.white, width: 1, style: BorderStyle.solid),
                //   borderRadius: BorderRadius.circular(50),
                // ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 6.0,
                    right: 6.0,
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  child: Text(
                    'Настроить $titleFirstFace',
                    style: TextStyle(
                      fontSize: 19.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () {
                  func();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

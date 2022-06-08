import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/data/models/custom_card.dart';
import 'package:money_control/data/models/data_storage.dart';
import 'package:money_control/presentation/widgets/alert_dialog_card.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  var uuid = Uuid();

  List<dynamic> allCategories = [];
  List<Map<String, dynamic>> availableCategories = [];

  var now = DateTime.now();
  var lastDayInMonth = 30;

  DateTime beginningNextMonth  = DateTime.now();

  TypeCard currentTypeCard = TypeCard.Other;
  String currentCategory = '';

  @override
  void initState() {
    super.initState();

    beginningNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    lastDayInMonth = beginningNextMonth.subtract(Duration(days: 1)).day;

    allCategories = dataStorage.appliedCategories.map((category) {
      if (dataStorage.appliedCards.isNotEmpty) {
        dataStorage.appliedCards.forEach((card) {
          if (card.categoryId != category.id) {
            var mapAvailableCategory = {
              'id': category.id,
              'iconId': category.iconId,
              'title': category.title,
              'bgColorOne': category.bgColorOne,
              'bgColorTwo': category.bgColorTwo,
              'fgColor': category.fgColor,
              'colorId': category.colorId,
            };

            availableCategories.add(mapAvailableCategory);
          }
        });
      } else {
        var mapAvailableCategory = {
          'id': category.id,
          'iconId': category.iconId,
          'title': category.title,
          'bgColorOne': category.bgColorOne,
          'bgColorTwo': category.bgColorTwo,
          'fgColor': category.fgColor,
          'colorId': category.colorId,
        };

        availableCategories.add(mapAvailableCategory);
      }

      return {
        'id': category.id,
        'iconId': category.iconId,
        'title': category.title,
        'bgColorOne': category.bgColorOne,
        'bgColorTwo': category.bgColorTwo,
        'fgColor': category.fgColor,
        'colorId': category.colorId,
      };
    }).toList();

    currentCategory =
        availableCategories.isNotEmpty ? availableCategories[0]['id'] : '';
  }

  @override
  Widget build(BuildContext context) {
    if (availableCategories.isNotEmpty && dataStorage.appliedCards.isNotEmpty) {
      availableCategories.clear();

      for (var category in allCategories) {
        var isEqual = false;
        Map<String, dynamic> mapAvailableCategory = {};

        for (var card in dataStorage.appliedCards) {
          if (card.categoryId != category['id']) {
            isEqual = false;

            mapAvailableCategory = {
              'id': category['id'],
              'iconId': category['iconId'],
              'title': category['title'],
              'bgColorOne': category['bgColorOne'],
              'bgColorTwo': category['bgColorTwo'],
              'fgColor': category['fgColor'],
              'colorId': category['colorId'],
            };
          } else {
            isEqual = true;
            break;
          }
        }

        if (!isEqual) availableCategories.add(mapAvailableCategory);
      }
    }

    currentCategory =
        availableCategories.isNotEmpty ? availableCategories[0]['id'] : '';

    return Column(
      children: [
        buildCount(),
        buildContainerCards(context),
        buildButtonAdd(),
      ],
    );
  }

  Widget buildCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Text(
        'Количество: ${dataStorage.appliedCards.length}/${dataStorage.appliedCategories.length}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget buildContainerCards(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          var icon = DUMMY_ICONS.firstWhere((data) {
            var dummyIconId = allCategories.firstWhere((category) {
              return dataStorage.appliedCards[index].categoryId ==
                  category['id'];
            })['iconId'];

            return data['id'] == dummyIconId;
          })['icon'];

          return Dismissible(
            key: GlobalKey(),
            onDismissed: (direction) {
              setState(() {
                var removedCard = dataStorage.appliedCards[index];
                var category = allCategories.firstWhere(
                    (category) => category['id'] == removedCard.categoryId);

                availableCategories.add(category);

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                //Scaffold.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('Карточка "${removedCard.title}" удалена'),
                  ),
                );

                dataStorage.appliedCards
                    .removeWhere((card) => card.id == removedCard.id);
                dataStorage.saveData();
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: () {
                  var appliedCard = dataStorage.appliedCards[index];
                  var category = allCategories.firstWhere(
                      (category) => category['id'] == appliedCard.categoryId);

                  availableCategories.add(category);

                  Color colorOne;
                  Color colorTwo;

                  switch (dataStorage.appliedCards[index].type) {
                    case TypeCard.Weekly:
                      colorOne = Color(0xffFFD1D4);
                      colorTwo = Color(0xffffafbd);
                      break;
                    case TypeCard.Monthly:
                      colorOne = Color(0xffB4F6F7);
                      colorTwo = Color(0xff87BBFF);
                      break;
                    case TypeCard.Other:
                      colorOne = Color(0xfffbc2eb);
                      colorTwo = Color(0xffa6c1ee);
                      break;
                  }

                  showDialogCreateEditCard(
                    card: appliedCard,
                    //id: appliedCard.id,
                    type: appliedCard.type,
                    currentCategory: category,
                    isEdit: true,
                    colorOne: colorOne,
                    colorTwo: colorTwo,
                    //cycleSum: appliedCard.allSum.toString(),
                    //currentDay: appliedCard.currentDay.toString(),
                    //resetDay: appliedCard.lastDay.toString(),
                  );
                },
                child: buildCard(icon, index),
              ),
            ),
          );
        },
        itemCount: dataStorage.appliedCards.length,
      ),
    );
  }

  Widget buildCard(icon, int index) {
    var currentCard = dataStorage.appliedCards[index];
    var currAction = dataStorage.appliedCategories
        .firstWhere((cat) => cat.id == currentCard.categoryId)
        .action;
    var textSum =
        currAction == 0 ? 'Целевая сумма расхода' : 'Целевая сумма дохода';

    return Card(
      child: Container(
        //height: 147.0,
        //height: widget.height * 0.2238,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15.0, bottom: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Категория: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 7.0),
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      child: icon,
                    ),
                  ),
                  Text(
                    currentCard.title,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    '$textSum: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(currentCard.allSum.toString()),
                  Text(' руб'),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    'Текущий день: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  Row(
                    children: [
                      Text(currentCard.currentDay.toString()),
                      if (currentCard.type == TypeCard.Weekly)
                        Text(' (${DateFormat('EEEE').format(now)})'),
                      if (currentCard.type == TypeCard.Monthly)
                        Text(
                            ' (${getDeclinedMonth(DateFormat('MMMM').format(now))})'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
              child: Row(
                children: [
                  Text(
                    'День сброса: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(currentCard.lastDay.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonAdd() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 15.0, top: 15.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: dataStorage.appliedCards.length ==
                      dataStorage.appliedCategories.length
                  ? Colors.grey
                  : Color(0xffFF934B),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onPressed: dataStorage.appliedCards.length ==
                        dataStorage.appliedCategories.length
                    ? null
                    : () {
                        setState(() {
                          var countCards = dataStorage.appliedCards.length;

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Выберите тип карточки',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: buildTypeCard(
                                          'Недельная',
                                          'Дата этой карточки синхронна с календарём.\nИнтервал даты с 1 по 7',
                                          TypeCard.Weekly,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: buildTypeCard(
                                          'Месячная',
                                          'Дата этой карточки синхронна с календарём.\nИнтервал даты с 1-го числа месяца по последний день месяца',
                                          TypeCard.Monthly,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: buildTypeCard(
                                          'Другая',
                                          'Дата этой карточки устанавливается вами',
                                          TypeCard.Other,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).then((value) {
                            setState(() {
                              if (countCards <
                                  dataStorage.appliedCards.length) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                        'Карточка "${dataStorage.appliedCards.last.title}" создана'),
                                  ),
                                );
                              }
                            });
                          });
                        });
                      },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTypeCard(String title, String info, TypeCard type) {
    Color colorOne;
    Color colorTwo;

    switch (type) {
      case TypeCard.Weekly:
        colorOne = Color(0xffFFD1D4);
        colorTwo = Color(0xffffafbd);
        break;
      case TypeCard.Monthly:
        colorOne = Color(0xffB4F6F7);
        colorTwo = Color(0xff87BBFF);
        break;
      case TypeCard.Other:
        colorOne = Color(0xfffbc2eb);
        colorTwo = Color(0xffa6c1ee);
        break;
    }

    return InkWell(
      child: Container(
        width: double.infinity,
        child: Card(
          elevation: 3.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorOne,
                  colorTwo,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    title,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(info),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          showDialogCreateEditCard(
            type: type,
            currentCategory: availableCategories[0],
            isEdit: false,
            colorOne: colorOne,
            colorTwo: colorTwo,
            card: null,
          );
        });
      },
    );
  }

  void showDialogCreateEditCard({
    required CustomCard? card,
    required TypeCard type,
    required Map<String, dynamic> currentCategory,
    required bool isEdit,
    required Color colorOne,
    required Color colorTwo,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogCard(
          card: card!,
          availableCategories: availableCategories,
          currentCategory: currentCategory,
          currentType: type,
          isEdit: isEdit,
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  String getDeclinedMonth(String month) {
    if (month[month.length - 1] == 'т')
      month += 'а';
    else
      month = month.substring(0, month.length - 1) + 'я';

    return month;
  }
}

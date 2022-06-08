import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/data/models/custom_card.dart';
import 'package:money_control/data/models/data_storage.dart';
import 'package:money_control/helpers/extensions/custom_date.dart';
import 'package:money_control/presentation/screen/settings_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AlertDialogCard extends StatefulWidget {
  final CustomCard card;
  final List<Map<String, dynamic>> availableCategories;
  final Map<String, dynamic> currentCategory;
  final TypeCard currentType;
  final bool isEdit;

  AlertDialogCard({
    required this.card,
    required this.availableCategories,
    required this.currentCategory,
    required this.currentType,
    required this.isEdit,
  });

  @override
  _AlertDialogCardState createState() => _AlertDialogCardState();
}

class _AlertDialogCardState extends State<AlertDialogCard> {
  final _sumFocusNode = FocusNode();
  final _currentDayFocusNode = FocusNode();
  final _lastDayFocusNode = FocusNode();

  List<Map<String, dynamic>> availableCategories = [];
  CustomCard? currentCard;
  String currentCategoryId = '';
  TypeCard? currentType;

  String id = '';
  String cycleSumValue = '';
  String currentDayValue = '';
  String resetDayValue = '';

  var uuid = Uuid();

  var tecCycleSum = TextEditingController();
  var tecResetDay = TextEditingController();
  var tecCurrentDay = TextEditingController();

  Color? colorOne;
  Color? colorTwo;

  String intervalDaysView = '';
  String currentDayViewNum = '';
  String currentDayViewStr = '';

  String cycleSum = '';
  String currentDay = '';
  String resetDay = '';

  var isEnabledDone = false;

  var isHaveCategory = false;
  var isParseCycleSum = false;
  var isParseCurrentDay = false;
  var isParseResetDay = false;

  DateTime beginningNextMonth = DateTime.now();

  var now = DateTime.now();
  var lastDayInMonth = 0;

  Text textCycleSum = Text('');
  Text textCurrentDay = Text('');
  Text textResetDate = Text('');

  String textSum = '';

  @override
  void initState() {
    super.initState();

    //delete from cats
    for (var cat in widget.availableCategories) {
      var mapAvailableCategory = {
        'id': cat['id'],
        'iconId': cat['iconId'],
        'title': cat['title'],
        'bgColorOne': cat['bgColorOne'],
        'bgColorTwo': cat['bgColorTwo'],
        'fgColor': cat['fgColor'],
        'colorId': cat['colorId'],
      };

      availableCategories.add(mapAvailableCategory);
    }

    if (widget.isEdit) {
      currentCard = CustomCard(
        id: widget.card.id,
        categoryId: widget.card.categoryId,
        title: widget.card.title,
        markId: widget.card.markId,
        allSum: widget.card.allSum,
        passedSum: widget.card.passedSum,
        currentDay: widget.card.currentDay,
        lastDay: widget.card.lastDay,
        isLastDay: widget.card.isLastDay,
        type: widget.card.type,
        bgColorOne: widget.card.bgColorOne,
        bgColorTwo: widget.card.bgColorTwo,
        fgColor: widget.card.fgColor,
        colorId: widget.card.colorId,
        createdDate: widget.card.createdDate,
        lastDayDate: widget.card.lastDayDate,
      );

      id = currentCard!.id;
      cycleSumValue = currentCard!.allSum.toString();
      currentDayValue = currentCard!.currentDay.toString();
      resetDayValue = currentCard!.lastDay.toString();

      var currAction = dataStorage.appliedCategories
          .firstWhere((cat) => cat.id == widget.card.categoryId)
          .action;
      textSum =
          currAction == 0 ? 'Целевая сумма расхода' : 'Целевая сумма дохода';
    } else {
      currentCard = CustomCard.empty();

      id = '';
      cycleSumValue = '';
      currentDayValue = '';
      resetDayValue = '';

      var currAction = dataStorage.appliedCategories
          .firstWhere((cat) => cat.id == widget.currentCategory['id'])
          .action;
      textSum =
          currAction == 0 ? 'Целевая сумма расхода' : 'Целевая сумма дохода';
    }

    currentCategoryId = widget.currentCategory['id'];
    currentType = widget.currentType;

    beginningNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    lastDayInMonth = beginningNextMonth.subtract(Duration(days: 1)).day;

    textCycleSum = Text(
      '$textSum *',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
    );
    textCurrentDay = Text(
      'Текущий день *',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
    );
    textResetDate = Text(
      'День сброса даты *',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tecCycleSum.dispose();
    tecResetDay.dispose();
    tecCurrentDay.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initInBuild();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();

          setState(() {
            checkTec();
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorOne!, colorTwo!],
          ),
        ),
        child: AlertDialog(
          title: Text(
            widget.isEdit ? 'Редактирование карточки' : 'Создание карточки',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDropdownButtonCategory(),
                buildCycleSum(context),
                buildTypeCard(),
                if (currentType == TypeCard.Weekly ||
                    currentType == TypeCard.Monthly)
                  buildIntervalOrCurrentDaysText(
                    title: 'Интервал дней',
                    info: intervalDaysView,
                    isCurrentDay: false,
                  ),
                if (currentType == TypeCard.Weekly ||
                    currentType == TypeCard.Monthly)
                  buildIntervalOrCurrentDaysText(
                    title: 'Текущий день',
                    info: currentDayViewNum,
                    additionalInfo: currentDayViewStr,
                    isCurrentDay: true,
                  ),
                if (currentType == TypeCard.Other)
                  buildIntervalOrCurrentDaysTextField(
                    context: context,
                    title: 'Текущий день',
                    tec: tecCurrentDay,
                  ),
                if (currentType == TypeCard.Other)
                  buildIntervalOrCurrentDaysTextField(
                    context: context,
                    title: 'День сброса даты',
                    tec: tecResetDay,
                  ),
                buildRowBottomButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIntervalOrCurrentDaysTextField({
    required BuildContext context,
    required String title,
    required TextEditingController tec,
  }) {
    Text text;
    if (title == 'Текущий день')
      text = textCurrentDay;
    else
      text = textResetDate;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text,
          // Text(
          //   '$title *',
          //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          // ),
          Container(
            child: TextField(
              maxLength: 2,
              controller: tec,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              focusNode: title == 'Текущий день'
                  ? _currentDayFocusNode
                  : _lastDayFocusNode,
              textInputAction: title == 'Текущий день'
                  ? TextInputAction.next
                  : TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'День',
                hintStyle: TextStyle(fontSize: 14.0),
                counterText: "",
              ),
              onSubmitted: (str) {
                setState(() {
                  checkTec();
                  if (title == 'Текущий день')
                    FocusScope.of(context).requestFocus(_lastDayFocusNode);
                  else
                    FocusScope.of(context).requestFocus(FocusNode());
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIntervalOrCurrentDaysText({
    required String title,
    required String info,
    String? additionalInfo,
    required bool isCurrentDay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
          Text(info),
          if (isCurrentDay)
            Text(additionalInfo!, style: TextStyle(fontSize: 14.0)),
        ],
      ),
    );
  }

  Widget buildTypeCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                'Тип карточки',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
            ),
            buildDropDownTypeCard(),
          ],
        ),
      ),
    );
  }

  Widget buildCycleSum(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textCycleSum,
            // Text(
            //   '$textSum *',
            //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
            // ),
            Container(
              child: TextField(
                maxLength: 7,
                controller: tecCycleSum,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                focusNode: _sumFocusNode,
                textInputAction: currentType == TypeCard.Other
                    ? TextInputAction.next
                    : TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Сумма',
                  hintStyle: TextStyle(fontSize: 14.0),
                  counterText: "",
                ),
                onSubmitted: (str) {
                  setState(() {
                    checkTec();
                    if (currentType == TypeCard.Other)
                      FocusScope.of(context).requestFocus(_currentDayFocusNode);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownButtonCategory() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                'Категория',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
            ),
            widget.currentCategory.isNotEmpty
                ? buildDropDownCategory()
                : Text(
                    'Нет доступных категорий',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildRowBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colorTwo,
          ),
          //color: colorTwo,
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: colorTwo,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.black,
              ),
              onPressed: () {
                checkTec();

                if (isEnabledDone) {
                  setState(() {
                    if (int.parse(currentDayValue) <= 0) currentDayValue = '1';

                    if (int.parse(resetDayValue) <= 0) resetDayValue = '1';

                    // if (int.parse(widget.resetDayInt) > lastDayInMonth)
                    //   widget.resetDayInt = lastDayInMonth.toString();

                    if (int.parse(currentDayValue) > int.parse(resetDayValue))
                      currentDayValue = resetDayValue;

                    var category = availableCategories.firstWhere(
                        (category) => category['id'] == currentCategoryId);

                    var isLastDay = currentDayValue == resetDayValue;

                    DateTime lastDayDate;
                    if (isLastDay)
                      lastDayDate = DateTime.now().withoutTime();
                    else {
                      lastDayDate = DateTime(2099, 1, 1);
                    }

                    if (widget.isEdit) {
                      var card = dataStorage.appliedCards.firstWhere((card) {
                        return card.id == id;
                      });

                      card.categoryId = currentCategoryId;
                      card.markId = uuid.v4();
                      card.allSum = int.parse(cycleSumValue);
                      card.title = category['title'];
                      card.currentDay = int.parse(currentDayValue);
                      card.lastDay = int.parse(resetDayValue);
                      card.isLastDay = isLastDay;
                      card.type = currentType!;
                      card.bgColorOne = category['bgColorOne'];
                      card.bgColorTwo = category['bgColorTwo'];
                      card.fgColor = category['fgColor'];
                      card.colorId = category['colorId'];
                      card.createdDate = DateTime.now();
                      card.lastDayDate = lastDayDate;

                      dataStorage.saveData();
                    } else {
                      var card = CustomCard(
                        id: uuid.v4(),
                        categoryId: currentCategoryId,
                        markId: uuid.v4(),
                        allSum: int.parse(cycleSumValue),
                        title: category['title'],
                        passedSum: 0,
                        currentDay: int.parse(currentDayValue),
                        lastDay: int.parse(resetDayValue),
                        isLastDay: isLastDay,
                        type: currentType!,
                        bgColorOne: category['bgColorOne'],
                        bgColorTwo: category['bgColorTwo'],
                        fgColor: category['fgColor'],
                        colorId: category['colorId'],
                        createdDate: DateTime.now(),
                        lastDayDate: lastDayDate,
                      );

                      dataStorage.appliedCards.add(card);
                      dataStorage.saveData();
                    }
                    Navigator.popUntil(
                        context, ModalRoute.withName(SettingsScreen.routeName));
                  });
                } else {
                  setState(() {
                    checkTec();
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void initInBuild() {
    tecCycleSum.text = cycleSumValue;

    tecCycleSum.addListener(() {
      cycleSumValue = tecCycleSum.text;
    });

    switch (currentType) {
      case TypeCard.Weekly:
        colorOne = Color(0xffFFD1D4);
        colorTwo = Color(0xffffafbd);

        intervalDaysView = 'от 1 до 7';
        currentDayViewNum = '${now.weekday}';
        currentDayViewStr = ' (${DateFormat('EEEE').format(now)})';

        resetDay = '7';
        currentDay = now.weekday.toString();

        resetDayValue = '7';
        currentDayValue = now.weekday.toString();
        break;
      case TypeCard.Monthly:
        colorOne = Color(0xffB4F6F7);
        colorTwo = Color(0xff87BBFF);

        intervalDaysView = 'от 1 до $lastDayInMonth';
        currentDayViewNum = '${now.day}';
        currentDayViewStr = ' (${DateFormat('MMMM').format(now)})';

        resetDay = lastDayInMonth.toString();
        currentDay = now.day.toString();

        resetDayValue = lastDayInMonth.toString();
        currentDayValue = now.day.toString();
        break;
      case TypeCard.Other:
        colorOne = Color(0xfffbc2eb);
        colorTwo = Color(0xffa6c1ee);

        tecResetDay.text = resetDayValue;
        tecCurrentDay.text = currentDayValue;

        tecResetDay.addListener(() {
          resetDayValue = tecResetDay.text;

          // setState(() {
          //   if (int.tryParse(tecResetDay.text) == null)
          //     isParseResetDay = false;
          //   else
          //     isParseResetDay = true;
          //
          //   if (isParseCycleSum &&
          //       isParseResetDay &&
          //       isParseCurrentDay &&
          //       isHaveCategory)
          //     isEnabledDone = true;
          //   else
          //     isEnabledDone = false;
          // });
        });

        tecCurrentDay.addListener(() {
          //currentDay = tecCurrentDay.text;
          currentDayValue = tecCurrentDay.text;

          // setState(() {
          //   if (int.tryParse(tecCurrentDay.text) == null)
          //     isParseCurrentDay = false;
          //   else
          //     isParseCurrentDay = true;
          //
          //   if (isParseCycleSum &&
          //       isParseResetDay &&
          //       isParseCurrentDay &&
          //       isHaveCategory)
          //     isEnabledDone = true;
          //   else
          //     isEnabledDone = false;
          // });
        });

        break;
      default:
        break;
    }

    tecCycleSum.selection = TextSelection.fromPosition(
        TextPosition(offset: tecCycleSum.text.length));
    tecResetDay.selection = TextSelection.fromPosition(
        TextPosition(offset: tecResetDay.text.length));
    tecCurrentDay.selection = TextSelection.fromPosition(
        TextPosition(offset: tecCurrentDay.text.length));
  }

  void checkTec() {
    if (availableCategories.isNotEmpty && widget.currentCategory.isNotEmpty)
      isHaveCategory = true;
    else
      isHaveCategory = false;

    if (int.tryParse(tecCycleSum.text) == null)
      isParseCycleSum = false;
    else
      isParseCycleSum = true;

    if (int.tryParse(tecCurrentDay.text) == null)
      isParseCurrentDay = false;
    else
      isParseCurrentDay = true;

    if (int.tryParse(tecResetDay.text) == null)
      isParseResetDay = false;
    else
      isParseResetDay = true;

    if (currentType == TypeCard.Weekly || currentType == TypeCard.Monthly) {
      if (isParseCycleSum && isHaveCategory)
        isEnabledDone = true;
      else
        isEnabledDone = false;
    }

    if (currentType == TypeCard.Other) {
      if (isParseCycleSum &&
          isParseResetDay &&
          isParseCurrentDay &&
          isHaveCategory)
        isEnabledDone = true;
      else
        isEnabledDone = false;
    }

    if (!isParseCycleSum)
      textCycleSum = Text('$textSum *',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ));
    else
      textCycleSum = Text('$textSum *',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16.0));

    if (!isParseCurrentDay)
      textCurrentDay = Text(
        'Текущий день *',
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16.0),
      );
    else
      textCurrentDay = Text(
        'Текущий день *',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16.0),
      );

    if (!isParseResetDay)
      textResetDate = Text(
        'День сброса даты *',
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16.0),
      );
    else
      textResetDate = Text(
        'День сброса даты *',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16.0),
      );
  }

  Widget buildDropDownCategory() {
    return Container(
      height: 25.0,
      //height: widget.height * 0.0381,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          dropdownColor: Colors.white,
          value: currentCategoryId,
          items: availableCategories.map((category) {
            var icon = DUMMY_ICONS
                .firstWhere((data) => data['id'] == category['iconId'])['icon'];

            return DropdownMenuItem(
              value: category['id'],
              child: Row(
                children: [
                  icon,
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(category['title']),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (nValue) {
            setState(() {
              currentCategoryId = nValue as String;

              var currAction = dataStorage.appliedCategories
                  .firstWhere((cat) => cat.id == currentCategoryId)
                  .action;
              textSum = currAction == 0
                  ? 'Целевая сумма расхода'
                  : 'Целевая сумма дохода';

              textCycleSum = Text(
                '$textSum *',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget buildDropDownTypeCard() {
    return Container(
      //width: 140.0,
      height: 25.0,
      // width: widget.width * 0.3889,
      // height: widget.height * 0.0381,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          dropdownColor: Colors.white,
          value: currentType,
          items: [
            DropdownMenuItem(
              value: TypeCard.Weekly,
              child: Text('Недельная'),
            ),
            DropdownMenuItem(
              value: TypeCard.Monthly,
              child: Text('Месячная'),
            ),
            DropdownMenuItem(
              value: TypeCard.Other,
              child: Text('Другая'),
            ),
          ],
          onChanged: (nValue) {
            setState(() {
              currentType = nValue as TypeCard;

              if (currentType == TypeCard.Other) {
                currentDay = '';
                resetDay = '';
                isEnabledDone = false;
              }
            });
          },
        ),
      ),
    );
  }
}

import 'package:money_control/data/models/category.dart';
import 'package:money_control/data/models/data_storage.dart';
import 'package:money_control/data/models/item.dart';
import 'package:money_control/data/models/position_item.dart';
import 'package:money_control/data/models/transaction.dart';
import 'package:money_control/domain/cubit/common_cubit.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/app_icons.dart';
import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/helpers/extensions/custom_date.dart';
import 'package:money_control/helpers/show_helper.dart';
import 'package:money_control/presentation/screen/add_positions_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';
import 'package:date_time_picker/date_time_picker.dart';

class NewTransaction extends StatefulWidget {
  final Transaction? transaction;
  final DataCubit dataCubit;
  final CommonCubit commonCubit;

  NewTransaction({
    this.transaction,
    required this.dataCubit,
    required this.commonCubit,
  });

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final List<Map<String, dynamic>> availableCategories = [];
  Map<String, Object> mapResult = {};

  DateTime? dateTimeTx;

  var displayText = '';
  var uuid = Uuid();

  Category? currCategory;

  var positions = <PositionItem>[];

  @override
  void initState() {
    super.initState();

    for (var category in widget.dataCubit.state.customUser.categories) {
      availableCategories.add(category.toJson());
      availableCategories
              .firstWhere((cat) => cat['id'] == category.id)['icon'] =
          DUMMY_ICONS.firstWhere(
              (dummyIcon) => dummyIcon['id'] == category.iconId)['icon'];
    }

    if (widget.transaction != null) {
      var currTx = widget.transaction!;
      currCategory = widget.dataCubit.state.customUser.categories
          .firstWhere((c) => c.id == currTx.categoryId)
          .copyWith();
      positions = currTx.positions.toList();
      dateTimeTx = currTx.date;
      displayText = currTx.sum.toString();
    } else {
      if (availableCategories.isNotEmpty) {
        currCategory = Category.fromJson(availableCategories.first).copyWith();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var textButtonAddPosition = positions.isNotEmpty
        ? 'Добавить позиции (${positions.length})'
        : 'Добавить позиции';

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildExpandedMoney(),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  color: Colors.white.withOpacity(0.5),
                  width: 1,
                )),
                color: Color.fromRGBO(23, 35, 49, 1),
              ),
              padding: EdgeInsets.only(left: 5.0, bottom: 15.0, top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildDropdownButtonCategories(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: TextButton(
                      child: Text(
                        textButtonAddPosition,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => AddPositionsScreen(positions),
                          ),
                        )
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              positions = value;
                              int sumPrice = 0;

                              for (var position in positions) {
                                sumPrice += (position.price * position.amount);
                              }

                              if (sumPrice > 9999999)
                                displayText = '9999999';
                              else
                                displayText = sumPrice.toString();
                            });
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(23, 35, 49, 1),
              ),
              padding: EdgeInsets.only(
                left: 40.0,
                right: 40.0,
                bottom: 10.0,
                top: 10.0,
              ),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Color.fromRGBO(23, 35, 49, 1),
                  side: BorderSide(color: Colors.white),
                ),
                child: Text(
                  dateTimeTx != null
                      ? DateFormat('dd-MM-yyyy HH:mm').format(dateTimeTx!)
                      : 'Выбрать дату',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                onPressed: () {
                  DateTime? newDt;

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        'Выбор даты',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Ок'),
                          onPressed: () {
                            setState(() {
                              if (newDt != null)
                                dateTimeTx = newDt;
                              else
                                dateTimeTx = DateTime.now();

                              var dtTx = dateTimeTx!.copyWith();
                              var dtNow = DateTime.now().withoutSecond();

                              if (dtTx.isAfter(dtNow)) {
                                dateTimeTx = DateTime.now();
                              }

                              Navigator.of(context).pop();
                            });
                          },
                        )
                      ],
                      content: Container(
                        child: DateTimePicker(
                          locale: const Locale('ru', 'RU'),
                          type: DateTimePickerType.dateTimeSeparate,
                          dateMask: 'dd MMM, yyyy',
                          initialValue: dateTimeTx.toString(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Дата',
                          timeLabelText: 'Время',
                          selectableDayPredicate: (date) {
                            return true;
                          },
                          onChanged: (val) {
                            newDt = DateTime.parse(val);
                          },
                          validator: (val) {
                            return null;
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              width: double.infinity,
              color: Color.fromRGBO(23, 35, 49, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildButtonRow('1', '2', '3'),
                  buildButtonRow('4', '5', '6'),
                  buildButtonRow('7', '8', '9'),
                  buildButtonRow('remove', '0', 'done'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownButtonCategories() {
    return DropdownButton(
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      dropdownColor: Color.fromRGBO(23, 35, 49, 1),
      underline: SizedBox(),
      value: currCategory!.iconId.index,
      items: availableCategories.map((category) {
        return DropdownMenuItem(
          value: category['iconId'],
          child: Row(
            children: [
              //crutches (I need change color icon)
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  child: category['icon'],
                ),
              ),
              Text(
                category['title'],
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          var newCategory = availableCategories
              .firstWhere((category) => category['iconId'] == value);

          currCategory = Category.fromJson(newCategory).copyWith();
        });
      },
    );
  }

  Widget buildExpandedMoney() {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          color: Color.fromRGBO(23, 35, 49, 1),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: Icon(
                  AppIcons.rouble,
                  color: Colors.white,
                ),
              ),
              Center(
                child: Text(
                  displayText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonRow(
    String firstButton,
    String secondButton,
    String thirdButton,
  ) {
    return Expanded(
      child: Row(
        children: [
          buildButton(firstButton),
          buildButton(secondButton),
          buildButton(thirdButton),
        ],
      ),
    );
  }

  Widget buildButton(String buttonText) {
    Icon? icon;
    if (buttonText == 'done') {
      icon = Icon(Icons.done);
    } else if (buttonText == 'remove') {
      icon = Icon(Icons.backspace);
    }

    return Expanded(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
          color: Color.fromRGBO(23, 35, 49, 1),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(23, 35, 49, 1),
              spreadRadius: 5,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: buttonText == 'done'
                ? Colors.green
                : Color.fromRGBO(28, 42, 59, 1),
            textStyle: TextStyle(color: Colors.white),
            onPrimary: Colors.white,
          ),
          onPressed: () => pressButton(buttonText),
          onLongPress: () {
            if (buttonText == 'remove') {
              setState(() {
                displayText = '';
              });
            }
          },
          child: buttonText == 'remove' || buttonText == 'done'
              ? icon!
              : Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void pressButton(String buttonText) {
    int? sum;
    if (int.tryParse(displayText) != null) {
      sum = int.parse(displayText);

      if (sum > 9999999) sum = 9999999;
    }

    setState(() {
      switch (buttonText) {
        case 'remove':
          if (displayText.length > 0)
            displayText = displayText.substring(0, displayText.length - 1);
          break;
        case 'done':
          if (displayText.isNotEmpty) {
            var isEdit = widget.transaction != null;

            if (isEdit) {
              widget.dataCubit.editTransaction(widget.transaction!.id, {
                'id': widget.transaction!.id,
                'bill': sum!,
                'category': currCategory!,
                'date': dateTimeTx ?? DateTime.now(),
                'positions': positions
              });
            } else {
              widget.dataCubit.addTransaction({
                'id': uuid.v4(),
                'bill': sum!,
                'category': currCategory!,
                'date': dateTimeTx ?? DateTime.now(),
                'positions': positions
              });
            }

            widget.commonCubit.changeData(widget.dataCubit);

            ShowHelper.showMessage(
              context,
              title: isEdit ? 'Транзакция изменена' : 'Транзакция создана',
              duration: Duration(seconds: 2),
            );

            Navigator.of(context).pop();
          }
          break;
        default:
          if (displayText.length < 7) displayText += buttonText;
          break;
      }
    });
  }
}

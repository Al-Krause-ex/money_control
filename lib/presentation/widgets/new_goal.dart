import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_control/data/models/goal.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/app_icons.dart';
import 'package:money_control/helpers/extensions/custom_date.dart';
import 'package:money_control/helpers/show_helper.dart';
import 'package:uuid/uuid.dart';

class NewGoal extends StatefulWidget {
  final DataCubit dataCubit;
  final Goal? goal;

  const NewGoal({Key? key, required this.dataCubit, this.goal})
      : super(key: key);

  @override
  State<NewGoal> createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {
  final uuid = Uuid();
  final tecName = TextEditingController();

  var displayText = '';
  DateTime? dateTimeTx;

  @override
  void initState() {
    super.initState();

    if (widget.goal != null) {
      displayText = '${widget.goal!.sum}';
      dateTimeTx = widget.goal!.date;
      tecName.text = widget.goal!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color.fromRGBO(23, 35, 49, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                bottom: 10.0,
                top: 7.0,
              ),
              child: TextField(
                controller: tecName,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 3)),
                ),
              ),
            ),
          ),
          buildExpandedMoney(),
          Expanded(
            flex: 2,
            child: Container(
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
                          lastDate: DateTime.now().add(Duration(days: 6000)),
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
            var isEdit = widget.goal != null;

            Goal? goal;

            if (isEdit) {
              goal = Goal(
                id: widget.goal!.id,
                name: tecName.text.trim(),
                sum: sum!,
                date: dateTimeTx ?? DateTime.now(),
                isDone: widget.goal!.isDone,
              );

              widget.dataCubit.editGoal(widget.goal!.id, goal);
            } else {
              goal = Goal(
                id: uuid.v4(),
                name: tecName.text.trim(),
                sum: sum!,
                date: dateTimeTx ?? DateTime.now(),
                isDone: false,
              );

              widget.dataCubit.addGoal(goal);
            }

            ShowHelper.showMessage(
              context,
              title: isEdit ? 'Цель изменена' : 'Цель создана',
              duration: Duration(seconds: 2),
            );

            Navigator.of(context).pop(goal);
          }
          break;
        default:
          if (displayText.length < 7) displayText += buttonText;
          break;
      }
    });
  }
}

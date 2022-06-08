import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:money_control/data/models/goal.dart';

import 'package:money_control/domain/cubit/common_cubit.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/extensions/custom_date.dart';
import 'package:money_control/helpers/get_item.dart';
import 'package:money_control/helpers/show_helper.dart';
import 'package:money_control/presentation/widgets/new_goal.dart';

class PlannerPage extends StatefulWidget {
  final DataCubit dataCubit;

  const PlannerPage({Key? key, required this.dataCubit}) : super(key: key);

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  var visibleGoals = <Goal>[];
  var selectedTypeDate = TypeDate.week;
  var dtStart = DateTime.now();
  var dtEnd = DateTime.now();
  var isEndedTasks = false;

  @override
  void initState() {
    super.initState();

    var today = DateTime.now().weekday;
    var endNum = 7 - today;

    dtEnd = DateTime.now().add(Duration(days: endNum)).withoutTime();
    dtStart = dtEnd.subtract(Duration(days: 6)).withoutTime();

    getVisibleGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdownButtonDates(),
                      Row(
                        children: [
                          _buildRaisedButtonDate(context, true),
                          _buildRaisedButtonDate(context, false),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              pressedStatus(isEndedTasks);
                            },
                            child: Text('Незавершённые'),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 40.0),
                              primary: !isEndedTasks
                                  ? Color(0xffEC8C4C)
                                  : Colors.transparent,
                              elevation: !isEndedTasks ? null : 0.0,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              pressedStatus(!isEndedTasks);
                            },
                            child: Text('Завершённые'),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 40.0),
                              primary: isEndedTasks
                                  ? Color(0xffEC8C4C)
                                  : Colors.transparent,
                              elevation: isEndedTasks ? null : 0.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (ctx, i) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: i == 14 ? 50.0 : 0.0),
                      child: _buildCardGoal(visibleGoals[i]),
                    );
                  },
                  itemCount: visibleGoals.length,
                )),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              addEditGoal();
            },
          ),
        ),
      ],
    );
  }

  void pressedStatus(bool canUse) {
    if (canUse) {
      setState(() {
        isEndedTasks = !isEndedTasks;

        getVisibleGoals();
      });
    }
  }

  Widget _buildCardGoal(Goal goal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Dismissible(
        key: Key(goal.id),
        onDismissed: (direction) {
          setState(() {
            widget.dataCubit.removeGoal(goal.id);
            visibleGoals.removeWhere((g) => g.id == goal.id);

            sortGoals();

            ShowHelper.showMessage(
              context,
              title: 'Цель удалена',
              duration: Duration(seconds: 2),
            );
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                addEditGoal(goal: goal);
              },
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120.0,
                        child: Row(
                          children: [
                            Text(
                              goal.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${goal.sum} ₽',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        '${DateFormat('dd.MM.yyyy').format(goal.date)} '
                        '(${goal.date.hour}ч ${goal.date.minute}мин)',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Transform.scale(
              scale: 1.8,
              child: Checkbox(
                side: MaterialStateBorderSide.resolveWith(
                  (_) => const BorderSide(
                    width: 1,
                    color: Colors.white,
                  ),
                ),
                activeColor: Colors.white,
                checkColor: Color.fromRGBO(23, 35, 49, 1),
                value: goal.isDone,
                onChanged: (val) {
                  var isOldCheckedGoal = goal.isDone;
                  setState(() {
                    widget.dataCubit.changeCheckGoal(goal.id);

                    getVisibleGoals();

                    ShowHelper.showMessage(
                      context,
                      title: isOldCheckedGoal
                          ? 'Статус "${goal.name}" изменён на "Не завершён"'
                          : 'Статус "${goal.name}" изменён на "Завершён"',
                      duration: const Duration(seconds: 2),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButtonDates() {
    List<TypeDate> datesSelection = [
      TypeDate.week,
      TypeDate.previousWeek,
      TypeDate.month,
      TypeDate.previousMonth,
      TypeDate.all,
    ];

    return DropdownButton(
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      dropdownColor: Color(0xff1d2671).withOpacity(0.7),
      value: selectedTypeDate,
      items: datesSelection.map((typeDateItem) {
        return DropdownMenuItem(
          value: typeDateItem,
          child: Row(
            children: [
              Text(
                GetItem.getTypeDateName(typeDateItem),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (nValue) {
        setState(() {
          selectedTypeDate =
              datesSelection.firstWhere((date) => date == nValue);
          Map<String, dynamic> mapDates = GetItem.getDatesByTypeDate(
            nValue as TypeDate,
            dataCubit: widget.dataCubit,
            isTransaction: false,
          );

          dtStart = mapDates['dtStart'];
          dtEnd = mapDates['dtEnd'];

          getVisibleGoals();
        });
      },
    );
  }

  Widget _buildRaisedButtonDate(context, bool isDateStart) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 5.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              primary: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 14.0),
              child: Text(
                DateFormat('dd.MM.yyyy').format(
                  isDateStart ? dtStart : dtEnd,
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
            onPressed: () {
              showDatePicker(
                locale: const Locale('ru', 'RU'),
                context: context,
                initialDate: isDateStart ? dtStart : dtEnd,
                firstDate: DateTime(2020),
                lastDate: DateTime(2099),
              ).then((dateValue) {
                if (dateValue != null) {
                  setState(() {
                    if (isDateStart) {
                      dtStart = dateValue.withoutTime();
                    } else {
                      dtEnd = dateValue.withoutTime();
                    }

                    getVisibleGoals();
                  });
                }
              });
            },
          ),
        ),
      ],
    );
  }

  void addEditGoal({Goal? goal}) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return GestureDetector(
          onTap: () {},
          child: NewGoal(dataCubit: widget.dataCubit, goal: goal),
          behavior: HitTestBehavior.opaque,
        );
      },
    ).then((value) {
      setState(() {
        if (value == null) return;

        if (goal != null) {
          var index = visibleGoals.indexWhere((g) => g.id == goal.id);
          visibleGoals[index] = (value as Goal).copyWith();
          getVisibleGoals();

          return;
        }

        visibleGoals.add(value);

        getVisibleGoals();
      });
    });
  }

  void sortGoals() {
    visibleGoals.sort((a, b) {
      return b.date.compareTo(a.date);
    });
  }

  void getVisibleGoals() {
    visibleGoals.clear();

    visibleGoals.addAll(widget.dataCubit.state.customUser.goals.where((g) {
      var start = g.date.withoutTime().isAtSameMomentAs(dtStart) ||
          g.date.withoutTime().isAfter(dtStart);
      var end = g.date.withoutTime().isAtSameMomentAs(dtEnd) ||
          g.date.withoutTime().isBefore(dtEnd);

      if (start && end) {
        return true;
      } else {
        return false;
      }
    }).toList());

    visibleGoals = visibleGoals.where((g) => g.isDone == isEndedTasks).toList();

    sortGoals();
  }
}

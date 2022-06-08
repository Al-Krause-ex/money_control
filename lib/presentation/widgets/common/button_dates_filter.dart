import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_control/domain/cubit/common_cubit.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/extensions/custom_date.dart';
import 'package:money_control/helpers/get_item.dart';
import 'package:money_control/presentation/widgets/alert_dialog_filter.dart';

class ButtonDatesFilter extends StatefulWidget {
  final DataCubit dataCubit;
  final CommonCubit commonCubit;

  const ButtonDatesFilter({
    Key? key,
    required this.dataCubit,
    required this.commonCubit,
  }) : super(key: key);

  @override
  _ButtonDatesFilterState createState() => _ButtonDatesFilterState();
}

class _ButtonDatesFilterState extends State<ButtonDatesFilter> {
  TypeDate? currentDateSelection;
  DateTime? currDtStart;
  DateTime? currDtEnd;

  @override
  void initState() {
    currentDateSelection = widget.commonCubit.state.typeDate;
    currDtStart = widget.commonCubit.state.dtStart;
    currDtEnd = widget.commonCubit.state.dtEnd;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 7.0, bottom: 4.0),
            child: Stack(
              children: [
                Center(child: _buildDropdownButtonDates()),
                _buildFilterButton(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRaisedButtonDate(true),
              _buildRaisedButtonDate(false),
            ],
          ),
        ],
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
      value: currentDateSelection,
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
        currentDateSelection =
            datesSelection.firstWhere((date) => date == nValue);

        Map<String, dynamic> mapDates = GetItem.getDatesByTypeDate(
          nValue as TypeDate,
          dataCubit: widget.dataCubit,
          commonCubit: widget.commonCubit,
        );

        setState(() {
          currDtStart = mapDates['dtStart'];
          currDtEnd = mapDates['dtEnd'];
        });
      },
    );
  }

  Widget _buildRaisedButtonDate(bool isDateStart) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            isDateStart ? 'От' : 'До',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                DateFormat('dd.MM.yyyy')
                    .format(isDateStart ? currDtStart! : currDtEnd!),
                style: TextStyle(color: Colors.black),
              ),
            ),
            onPressed: () {
              showDatePicker(
                locale: const Locale('ru', 'RU'),
                context: context,
                initialDate: isDateStart ? currDtStart! : currDtEnd!,
                firstDate: DateTime(2020),
                lastDate: DateTime(2099),
              ).then((dateValue) {
                if (dateValue != null) {
                  setState(() {
                    if (isDateStart) {
                      currDtStart = dateValue.withoutTime();
                    } else {
                      currDtEnd = dateValue.withoutTime();
                    }
                  });

                  widget.commonCubit.changeData(
                    widget.dataCubit,
                    dateStart: currDtStart!,
                    dateEnd: currDtEnd!,
                  );
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 33.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            border: widget.commonCubit.state.categoriesId.first == 'None'
                ? Border.all(color: Colors.black, width: 1)
                : Border.all(color: Colors.green, width: 3),
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
          ),
          child: GestureDetector(
            child: Icon(Icons.filter_list),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogFilter(
                    dataCubit: widget.dataCubit,
                    filterTransactionsByCategoryId:
                        widget.commonCubit.state.categoriesId,
                  );
                },
              ).then((value) {
                if (value != null && value.length > 0) {
                  setState(() {
                    widget.commonCubit.changeFilter(
                      value as List<String>,
                      widget.dataCubit,
                    );
                  });
                } else {
                  widget.commonCubit.changeFilter(['None'], widget.dataCubit);
                }
              });
            },
          ),
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_control/data/repositories/repository.dart';
import 'package:money_control/domain/cubit/common_cubit.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/extensions/custom_date.dart';
import 'package:money_control/helpers/get_item.dart';
import 'package:money_control/presentation/widgets/alert_dialog_filter.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  var touchedIndex = -1;
  var selectedTypeDate = TypeDate.week;
  var selectedTypeCategory = 'None';
  var dtStart = DateTime.now();
  var dtEnd = DateTime.now();

  DataCubit? dataCubit;

  @override
  void initState() {
    super.initState();

    dataCubit = BlocProvider.of<DataCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Статистика',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'В процессе разработки :)',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: Colors.black),
        ),
      ),
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      //       child: Row(
      //         children: [
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Row(
      //                 children: [
      //                   _buildDropdownButtonDates(),
      //                   const SizedBox(width: 16.0),
      //                   _buildFilterButton()
      //                 ],
      //               ),
      //               Row(
      //                 children: [
      //                   _buildRaisedButtonDate(context, true),
      //                   _buildRaisedButtonDate(context, false),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //     ElevatedButton(
      //         onPressed: () {
      //           var transactions = dataCubit!.state.customUser.transactions;
      //
      //           var listMapCats = <Map<String, dynamic>>[];
      //           var listGroupMap = <Map<String, dynamic>>[];
      //
      //           for (var tx in transactions) {
      //             var cat = dataCubit!.state.customUser.categories
      //                 .firstWhere((c) => c.id == tx.categoryId);
      //             var mapCat = {
      //               'category': tx.title,
      //               'sum': tx.sum,
      //               'action': cat.action,
      //             };
      //             listMapCats.add(mapCat);
      //           }
      //
      //           var newMap = groupBy(
      //               listMapCats, (Map<String, dynamic> obj) => obj['category']);
      //           for (var k = 0; k < newMap.keys.length; k++) {
      //             listGroupMap.add({
      //               'category': newMap.keys.toList()[k],
      //               'sum': 0,
      //               'action': -1,
      //             });
      //             for (var v in newMap[newMap.keys.toList()[k]]!) {
      //               listGroupMap[k]['sum'] += v['sum'];
      //               listGroupMap[k]['action'] = v['action'];
      //             }
      //           }
      //
      //           print(listGroupMap);
      //         },
      //         child: Text('Generate')),
      //     Row(
      //       children: [
      //         Expanded(
      //           child: AspectRatio(
      //             aspectRatio: 1,
      //             child: PieChart(
      //               PieChartData(
      //                   pieTouchData: PieTouchData(touchCallback:
      //                       (FlTouchEvent event, pieTouchResponse) {
      //                     setState(() {
      //                       if (!event.isInterestedForInteractions ||
      //                           pieTouchResponse == null ||
      //                           pieTouchResponse.touchedSection == null) {
      //                         touchedIndex = -1;
      //                         return;
      //                       }
      //                       touchedIndex = pieTouchResponse
      //                           .touchedSection!.touchedSectionIndex;
      //                     });
      //                   }),
      //                   borderData: FlBorderData(
      //                     show: false,
      //                   ),
      //                   sectionsSpace: 0,
      //                   centerSpaceRadius: 0,
      //                   sections: showingSections()),
      //             ),
      //           ),
      //         ),
      //         Column(
      //           mainAxisSize: MainAxisSize.max,
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             Row(
      //               children: [
      //                 Container(
      //                   width: 10.0,
      //                   height: 10.0,
      //                   color: Color(0xff0293ee),
      //                 ),
      //                 const SizedBox(width: 10.0),
      //                 Text('First')
      //               ],
      //             ),
      //             SizedBox(
      //               height: 4,
      //             ),
      //             Row(
      //               children: [
      //                 Container(
      //                   width: 10.0,
      //                   height: 10.0,
      //                   color: Color(0xfff8b250),
      //                 ),
      //                 const SizedBox(width: 10.0),
      //                 Text('Second')
      //               ],
      //             ),
      //             SizedBox(
      //               height: 4,
      //             ),
      //             Row(
      //               children: [
      //                 Container(
      //                   width: 10.0,
      //                   height: 10.0,
      //                   color: Color(0xff845bef),
      //                 ),
      //                 const SizedBox(width: 10.0),
      //                 Text('Third')
      //               ],
      //             ),
      //             SizedBox(
      //               height: 4,
      //             ),
      //             Row(
      //               children: [
      //                 Container(
      //                   width: 10.0,
      //                   height: 10.0,
      //                   color: Color(0xff13d38e),
      //                 ),
      //                 const SizedBox(width: 10.0),
      //                 Text('Fourth')
      //               ],
      //             ),
      //             SizedBox(
      //               height: 18,
      //             ),
      //           ],
      //         ),
      //         const SizedBox(
      //           width: 28,
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 100.0 : 80.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }

  Widget _buildDropdownButtonDates() {
    List<TypeDate> datesSelection = [
      TypeDate.week,
      TypeDate.month,
      TypeDate.year,
      TypeDate.all,
    ];

    return DropdownButton(
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
      ),
      value: selectedTypeDate,
      items: datesSelection.map((typeDateItem) {
        return DropdownMenuItem(
          value: typeDateItem,
          child: Row(
            children: [
              Text(
                GetItem.getTypeDateName(typeDateItem),
                style: TextStyle(color: Colors.black),
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
          );

          dtStart = mapDates['dtStart'];
          dtEnd = mapDates['dtEnd'];
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
                  });
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
            border: selectedTypeCategory == 'None'
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
                    dataCubit: DataCubit(repository: Repository()),
                    filterTransactionsByCategoryId: [],
                  );
                },
              ).then((value) {
                if (value != null && value.length > 0) {
                  setState(() {});
                } else {}
              });
            },
          ),
        ),
      ),
    );
  }
}

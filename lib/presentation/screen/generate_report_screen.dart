import 'dart:io';

import 'package:money_control/data/models/data_storage.dart';
import 'package:money_control/data/models/transaction.dart';
import 'package:money_control/helpers/extensions/custom_date.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:simple_tooltip/simple_tooltip.dart';
// import 'package:excel/excel.dart';

class GenerateReportScreen extends StatefulWidget {
  @override
  _GenerateReportScreenState createState() => _GenerateReportScreenState();
}

class _GenerateReportScreenState extends State<GenerateReportScreen> {
  var tecFileName = TextEditingController();
  List<bool> isShowTooltips = [false, false, false];

  var isGenerateReportExtended = false;
  var isGenerateReportMonthly = false;
  var isGenerateReportWeekly = false;
  var isGenerating = false;

  var dateStart = DateTime.now();
  var dateEnd = DateTime.now();

  var transactions = <Transaction>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: !isGenerating,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Формирование отчёта',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextAndDates(context),
            buildInfoTooltipAndCheckBoxes(context),
            buildRowButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildTextAndDates(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 30.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Путь файла',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17.0,
            ),
          ),
          SizedBox(
            height: 13.0,
          ),
          Text(
            'Phone/CostAccountingReports',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            'Имя файла',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17.0,
            ),
          ),
          Container(
            child: TextField(
              style: TextStyle(fontSize: 16.0),
              controller: tecFileName,
              decoration: InputDecoration(
                hintText: 'Название',
                counterText: "",
              ),
              onChanged: (str) {},
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Дата начала',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
              _buildRaisedButtonDate(context, true),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Row(
            children: [
              Text(
                'Дата окончания',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
              _buildRaisedButtonDate(context, false),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }

  Widget buildInfoTooltipAndCheckBoxes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              buildSimpleTooltip(context, 0),
              Text(
                'Отчёт с позициями',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 117.0),
              Checkbox(
                value: isGenerateReportExtended,
                onChanged: (v) {
                  setState(() {
                    isGenerateReportExtended = v as bool;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              buildSimpleTooltip(context, 1),
              Text(
                'Отчёт с ежемесячным интервалом',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10.0),
              Checkbox(
                value: isGenerateReportMonthly,
                onChanged: (v) {
                  setState(() {
                    isGenerateReportMonthly = v as bool;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              buildSimpleTooltip(context, 2),
              Text(
                'Отчёт с еженедельным интервалом',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 3.0),
              Checkbox(
                value: isGenerateReportWeekly,
                onChanged: (v) {
                  setState(() {
                    isGenerateReportWeekly = v as bool;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Widget buildSimpleTooltip(BuildContext context, index) {
    var info = '';

    switch (index) {
      case 0:
        info = 'В отчёте будут отображены все позиции за промежуток времени, '
            'который вы указали\n\nСтраница в excel - "Extended"';
        break;
      case 1:
        info = 'В отчёте будут отображены данные за каждую неделю '
            '(с даты начала по дату окончания)\n\nСтраница в excel - "Monthly"';
        break;
      case 2:
        info = 'В отчёте будут отображены данные за каждый месяц '
            '(с даты начала по дату окончания)\n\nСтраница в excel - "Weekly"';
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            setState(() {
              for (var i = 0; i < isShowTooltips.length; i++)
                if (i != index) isShowTooltips[i] = false;
              isShowTooltips[index] = !isShowTooltips[index];
            });
          },
        ),
        // SimpleTooltip(
        //   tooltipTap: () {
        //     setState(() {
        //       isShowTooltips[index] = !isShowTooltips[index];
        //     });
        //   },
        //   child: SizedBox(),
        //   animationDuration: Duration(seconds: 1),
        //   show: isShowTooltips[index],
        //   tooltipDirection: TooltipDirection.right,
        //   content: Text(
        //     info,
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontFamily: 'Roboto',
        //       fontWeight: FontWeight.normal,
        //       fontSize: 14,
        //       decoration: TextDecoration.none,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildRaisedButtonDate(BuildContext context, bool isDateStart) {
    return Padding(
      padding: EdgeInsets.only(left: isDateStart ? 47.0 : 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          primary: Colors.white,
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        // color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 14.0, bottom: 14.0),
          child: Text(
            DateFormat.yMd().format(isDateStart ? dateStart : dateEnd),
            style: TextStyle(color: Colors.black),
          ),
        ),
        onPressed: () {
          showDatePicker(
            locale: const Locale('ru', 'RU'),
            context: context,
            initialDate: isDateStart ? dateStart : dateEnd,
            firstDate: DateTime(2020),
            lastDate: DateTime(2099),
          ).then((dateValue) {
            if (dateValue != null) {
              setState(() {
                if (isDateStart) {
                  dateStart = DateTime(
                    dateValue.year,
                    dateValue.month,
                    dateValue.day,
                  );
                } else {
                  dateEnd = DateTime(dateValue.year, dateValue.month,
                      dateValue.day, 23, 59, 59);
                }
              });
            }
          });
        },
      ),
    );
  }

  Widget buildRowButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 40.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              primary: Color(0xff66A8FF),
            ),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
            // color: Color(0xff66A8FF'),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 11.0,
                horizontal: 18.0,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              primary: Color(0xff42DD95),
            ),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
            //color: Color(0xff42DD95'),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 12.0,
              ),
              child: Text(
                'Выбрать',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              // showDialog(
              //     barrierDismissible: false,
              //     context: context,
              //     builder: (BuildContext context) {
              //       return AlertDialog(
              //         title: Text(
              //           'Генерация отчёта',
              //           style: TextStyle(
              //               color: Colors.black, fontFamily: 'Roboto'),
              //         ),
              //         content: LinearProgressIndicator(
              //           valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              //         ),
              //       );
              //     });

              // createFolderAndFile().then((value) {
              //   if (value) {
              //     setState(() {
              //       isGenerating = false;
              //       Navigator.of(context).pop();
              //       showDialog(
              //         barrierDismissible: false,
              //         context: context,
              //         builder: (BuildContext context) {
              //           return buildAlertDialogGenerate(context);
              //         },
              //       );
              //     });
              //   }
              // });
            },
          ),
        ],
      ),
    );
  }

  Widget buildAlertDialogGenerate(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Генерация отчёта',
        style: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Row(
              children: [
                Text(
                  'Отчёт сгенерирован!',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 40.0,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            'Ok',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  // Future<String> getExternalStorageReportsDirectory() async {
  //   final Directory? extDir = await getExternalStorageDirectory();
  //   String dirPath = '${extDir!.path}/CostAccountingReports';
  //   dirPath = dirPath.replaceAll("Android/data/k4s.money_control/files/", "");
  //
  //   return dirPath;
  // }

  // List<Transaction> getTxByDate(firstDate, secondDate) {
  //   return dataStorage.transactions.where((transaction) {
  //     var start = transaction.date.dateNow().isAtSameMomentAs(firstDate) ||
  //         transaction.date.dateNow().isAfter(firstDate);
  //     var end = transaction.date.dateNow().isAtSameMomentAs(secondDate) ||
  //         transaction.date.dateNow().isBefore(secondDate);
  //
  //     if (start && end) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }).toList();
  // }

  // void generateReportGeneral(Excel excel) {
  //   transactions = getTxByDate(dateStart, dateEnd);
  //
  //   var listMapCats = <Map<String, dynamic>>[];
  //   var listGroupMap = <Map<String, dynamic>>[];
  //
  //   var totalCost = 0;
  //   var totalIncome = 0;
  //
  //   for (var tx in transactions) {
  //     if (tx.category.action == 0)
  //       totalCost += tx.sum;
  //     else
  //       totalIncome += tx.sum;
  //
  //     var mapCat = {
  //       'category': tx.title,
  //       'sum': tx.sum,
  //       'action': tx.category.action,
  //     };
  //
  //     listMapCats.add(mapCat);
  //   }
  //
  //   var newMap =
  //       groupBy(listMapCats, (Map<String, dynamic> obj) => obj['category']);
  //
  //   for (var k = 0; k < newMap.keys.length; k++) {
  //     listGroupMap.add({
  //       'category': newMap.keys.toList()[k],
  //       'sum': 0,
  //       'action': -1,
  //     });
  //
  //     for (var v in newMap[newMap.keys.toList()[k]]!) {
  //       listGroupMap[k]['sum'] += v['sum'];
  //       listGroupMap[k]['action'] = v['action'];
  //     }
  //   }
  //
  //   excel.rename('Sheet1', 'General');
  //
  //   Sheet sheetObject = excel['General'];
  //   sheetObject.appendRow([
  //     'Дата начала',
  //     'Дата окончания',
  //     'Тип',
  //     'Сумма',
  //   ]);
  //
  //   sheetObject.appendRow([
  //     '${DateFormat.yMd().format(dateStart.dateNow()).toString()}',
  //     '${DateFormat.yMd().format(dateEnd.dateNow()).toString()}',
  //     'Расходы',
  //     '$totalCost',
  //   ]);
  //
  //   sheetObject.appendRow([
  //     '${DateFormat.yMd().format(dateStart.dateNow()).toString()}',
  //     '${DateFormat.yMd().format(dateEnd.dateNow()).toString()}',
  //     'Доходы',
  //     '$totalIncome',
  //   ]);
  //
  //   sheetObject.appendRow(['']);
  //
  //   sheetObject.appendRow(['Категория', 'Тип', 'Сумма']);
  //
  //   for (var item in listGroupMap) {
  //     String actionStr = '';
  //     if (item['action'] == 0)
  //       actionStr = 'Расходы';
  //     else
  //       actionStr = 'Доходы';
  //
  //     sheetObject.appendRow([
  //       '${item['category']}',
  //       actionStr,
  //       '${item['sum']}',
  //     ]);
  //   }
  // }

  // void generateReportWithPositions(Excel excel) {
  //   transactions = getTxByDate(dateStart, dateEnd);
  //
  //   var listMapCats = <Map<String, dynamic>>[];
  //   List<Map<String, dynamic>> listPositions = [];
  //
  //   for (var tx in transactions) {
  //     for (var position in tx.positions) {
  //       Map<String, dynamic> mapPosition = {
  //         'title': position.title,
  //         'price': position.price,
  //         'amount': position.amount
  //       };
  //
  //       listPositions.add(mapPosition);
  //     }
  //
  //     var mapCat = {
  //       'category': tx.title,
  //       'sum': tx.sum,
  //       'action': tx.category.action,
  //       'date': tx.date,
  //       'positions': listPositions,
  //     };
  //
  //     listPositions = [];
  //     listMapCats.add(mapCat);
  //   }
  //
  //   Sheet sheetObject = excel['Extended'];
  //   sheetObject.appendRow([
  //     'Категория',
  //     'Тип',
  //     'Дата',
  //     'Позиция',
  //     'Количество',
  //     'Сумма',
  //   ]);
  //
  //   for (var tx in listMapCats) {
  //     sheetObject.appendRow([
  //       tx['category'],
  //       tx['action'] == 0 ? 'Расходы' : 'Доходы',
  //       tx['date'].toString(),
  //       'Итого',
  //       'Итого',
  //       tx['sum'],
  //     ]);
  //
  //     if (tx['positions'].length != 0) {
  //       for (var pos in tx['positions']) {
  //         sheetObject.appendRow([
  //           '',
  //           '',
  //           '',
  //           pos['title'],
  //           pos['amount'],
  //           pos['price'],
  //         ]);
  //       }
  //     }
  //   }
  // }

  // void generateReportMonthlyOrWeekly(Excel excel, bool isMonthly) {
  //   var listFinalMap = <Map<String, dynamic>>[];
  //
  //   if (dateStart != null && dateEnd != null) {
  //     var lastDateIsBeforeDateEnd = true;
  //
  //     var firstDate = dateStart;
  //     var lastDate = dateStart;
  //
  //     while (lastDateIsBeforeDateEnd) {
  //       var listMapCats = <Map<String, dynamic>>[];
  //       var listGroupMap = <Map<String, dynamic>>[];
  //
  //       var totalCost = 0;
  //       var totalIncome = 0;
  //
  //       if (isMonthly) {
  //         var beginningNextMonth = (lastDate.month < 12)
  //             ? DateTime(lastDate.year, lastDate.month + 1, 1)
  //             : DateTime(lastDate.year + 1, 1, 1);
  //
  //         var lastDayInMonth =
  //             beginningNextMonth.subtract(Duration(days: 1)).day;
  //
  //         lastDate = lastDate.add(Duration(days: lastDayInMonth));
  //       } else
  //         lastDate = lastDate.add(Duration(days: 6));
  //
  //       if (lastDate.isAfter(dateEnd)) {
  //         lastDate = dateEnd;
  //         lastDateIsBeforeDateEnd = false;
  //       }
  //
  //       transactions = getTxByDate(firstDate, lastDate);
  //
  //       for (var tx in transactions) {
  //         if (tx.category.action == 0) {
  //           totalCost += tx.sum;
  //         } else {
  //           totalIncome += tx.sum;
  //         }
  //
  //         var mapCat = {
  //           'category': tx.title,
  //           'action': tx.category.action,
  //           'sum': tx.sum,
  //         };
  //
  //         listMapCats.add(mapCat);
  //       }
  //
  //       var newMap =
  //           groupBy(listMapCats, (Map<String, dynamic> obj) => obj['category']);
  //
  //       for (var k = 0; k < newMap.keys.length; k++) {
  //         listGroupMap.add({
  //           'category': newMap.keys.toList()[k],
  //           'sum': 0,
  //           'action': -1,
  //         });
  //
  //         for (var v in newMap[newMap.keys.toList()[k]]!) {
  //           listGroupMap[k]['sum'] += v['sum'];
  //           listGroupMap[k]['action'] = v['action'];
  //         }
  //       }
  //
  //       listFinalMap.add({
  //         'category': 'Итого',
  //         'action': 'Расходы',
  //         'dateStart': firstDate,
  //         'dateEnd': lastDate,
  //         'sum': totalCost
  //       });
  //
  //       listFinalMap.add({
  //         'category': 'Итого',
  //         'action': 'Доходы',
  //         'dateStart': firstDate,
  //         'dateEnd': lastDate,
  //         'sum': totalIncome
  //       });
  //
  //       for (var m in listGroupMap) {
  //         var nMap = {
  //           'category': m['category'],
  //           'action': m['action'] == 0 ? 'Расходы' : 'Доходы',
  //           'dateStart': firstDate,
  //           'dateEnd': lastDate,
  //           'sum': m['sum'],
  //         };
  //
  //         listFinalMap.add(nMap);
  //       }
  //
  //       if (!isMonthly) lastDate = lastDate.add(Duration(days: 1));
  //
  //       firstDate = lastDate;
  //
  //       if (firstDate.isAfter(dateEnd)) lastDateIsBeforeDateEnd = false;
  //     }
  //   }
  //
  //   Sheet sheetObject;
  //
  //   if (isMonthly)
  //     sheetObject = excel['Monthly'];
  //   else
  //     sheetObject = excel['Weekly'];
  //
  //   sheetObject.appendRow([
  //     'Категория',
  //     'Тип',
  //     'Дата начала',
  //     'Дата окончания',
  //     'Сумма',
  //   ]);
  //
  //   for (var itemMap in listFinalMap) {
  //     sheetObject.appendRow([
  //       itemMap['category'],
  //       itemMap['action'],
  //       DateFormat.yMd().format(itemMap['dateStart']).toString(),
  //       DateFormat.yMd().format(itemMap['dateEnd']).toString(),
  //       itemMap['sum'],
  //     ]);
  //   }
  // }

  // Future<bool> createFolderAndFile() async {
  //   var isDuplicate = false;
  //   var countCopies = 0;
  //   String? path;
  //
  //   await getExternalStorageReportsDirectory()
  //       .then((String result) => path = result);
  //
  //   var nameFile = tecFileName.text;
  //
  //   if (tecFileName.text == '') nameFile = 'report';
  //
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     await Permission.storage.request().then((newStatus) {
  //       status = newStatus;
  //     });
  //   }
  //
  //   if (path != null) {
  //     if (status.isGranted) {
  //       await Directory(path!).create(recursive: true);
  //
  //       showDialog(
  //           barrierDismissible: false,
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text(
  //                 'Генерация отчёта',
  //                 style: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
  //               ),
  //               content: LinearProgressIndicator(
  //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
  //               ),
  //             );
  //           });
  //
  //       File file = File('$path/$nameFile.xlsx');
  //       await file.exists().then((value) => isDuplicate = value);
  //
  //       while (isDuplicate) {
  //         countCopies++;
  //         file = File('$path/${nameFile}_$countCopies.xlsx');
  //
  //         await file.exists().then((value) => isDuplicate = value);
  //       }
  //
  //       setState(() {
  //         isGenerating = true;
  //       });
  //
  //       var excel = Excel.createExcel();
  //       generateReportGeneral(excel);
  //
  //       if (isGenerateReportExtended) generateReportWithPositions(excel);
  //
  //       if (isGenerateReportMonthly) generateReportMonthlyOrWeekly(excel, true);
  //
  //       if (isGenerateReportWeekly) generateReportMonthlyOrWeekly(excel, false);
  //
  //       excel.encode().then((onValue) {
  //         file.createSync(recursive: true);
  //         file.writeAsBytesSync(onValue);
  //         // File(join('$path/excel.xlsx'))
  //         //   ..createSync(recursive: true)
  //         //   ..writeAsBytesSync(onValue);
  //       });
  //     }
  //   }
  //
  //   return status.isGranted;
  // }
}

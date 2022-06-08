import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:simple_tooltip/simple_tooltip.dart';

class AlertDialogGenerateReport extends StatefulWidget {
  @override
  _AlertDialogGenerateReportState createState() =>
      _AlertDialogGenerateReportState();
}

class _AlertDialogGenerateReportState extends State<AlertDialogGenerateReport> {
  var tecFileName = TextEditingController();
  List<bool> isShowTooltips = [false, false, false];

  var cbOne = false;
  var cbTwo = false;
  var cbThree = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Формирование отчёта',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto',
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Путь файла',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text('Phone/CostAccountingReports'),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Имя файла',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          TextField(
            controller: tecFileName,
            decoration: InputDecoration(
              hintText: 'Название',
              counterText: "",
            ),
            onChanged: (str) {},
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Дата начала',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Дата окончания',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              buildSimpleTooltip(context, 0),
              Text(
                'Общий интервал',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Checkbox(
                value: cbOne,
                onChanged: (v) {},
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          // Row(
          //   children: [
          //     buildSimpleTooltip(context, isShowTooltipTwo),
          //     Text(
          //       'Ежемесячный интервал',
          //       style: TextStyle(fontWeight: FontWeight.w500),
          //     ),
          //     Checkbox(
          //       value: cbTwo,
          //       onChanged: (v) {},
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: 10.0,
          // ),
          // Row(
          //   children: [
          //     buildSimpleTooltip(context, isShowTooltipThree),
          //     Text(
          //       'Еженедельный интервал',
          //       style: TextStyle(fontWeight: FontWeight.w500),
          //     ),
          //     Checkbox(
          //       value: cbThree,
          //       onChanged: (v) {},
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: 10.0,
          // ),
          buildRowButtons(context),
        ],
      ),
    );
  }

  Widget buildSimpleTooltip(BuildContext context, index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            setState(() {
              isShowTooltips[index] = !isShowTooltips[index];
            });
          },
        ),
        // SimpleTooltip(
        //   tooltipTap: () {
        //     print("Tooltip tap");
        //   },
        //   child: SizedBox(),
        //   animationDuration: Duration(seconds: 1),
        //   show: isShowTooltips[index],
        //   tooltipDirection: TooltipDirection.down,
        //   content: Text(
        //     "Информация про интервал\n"
        //     "Дефолтный интервал ЙОУ.",
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

  Widget buildRowButtons(BuildContext context) {
    return Row(
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
          // color: Color(0xff66A8FF),
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
            // color: Color(0xff42DD95),
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
              //getExternalStorageReportsDirectory();
              createFolderAndFile();
              //Navigator.of(context).pop();
            }),
      ],
    );
  }

  // void readFile() async {
  //   File file = File(await getFilePath()); // 1
  //   String fileContent = await file.readAsString(); // 2
  //
  //   print('File Content: $fileContent');
  // }

  void createFolderAndFile() async {
    var isDuplicate = false;
    var countCopies = 0;
    String? path;

    await getExternalStorageReportsDirectory()
        .then((String result) => path = result);

    if (path != null) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      if (status.isGranted) await Directory(path!).create(recursive: true);

      File file = File('$path/${tecFileName.text}.txt');
      await file.exists().then((value) => isDuplicate = value);

      while (isDuplicate) {
        countCopies++;
        file = File('$path/${tecFileName.text}_$countCopies.txt');

        await file.exists().then((value) => isDuplicate = value);
      }

      await file.writeAsString('THAT A TEST STRING IN TEXT FILE!');
    }
  }

  Future<String> getExternalStorageReportsDirectory() async {
    final Directory? extDir = await getExternalStorageDirectory();
    String dirPath = '${extDir!.path}/CostAccountingReports';
    dirPath = dirPath.replaceAll("Android/data/k4s.cost_accounting/files/", "");

    return dirPath;
  }
}

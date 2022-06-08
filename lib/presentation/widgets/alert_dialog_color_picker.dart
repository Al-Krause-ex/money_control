import 'package:flutter/material.dart';

import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/data/models/category.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AlertDialogColorPicker extends StatefulWidget {
  final Category category;

  AlertDialogColorPicker({
    required this.category,
  });

  @override
  _AlertDialogColorPickerState createState() => _AlertDialogColorPickerState();
}

class _AlertDialogColorPickerState extends State<AlertDialogColorPicker> {
  var listColorClicked = <Map<String, dynamic>>[];
  Map<String, dynamic> chosenColor = {};

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < DUMMY_GRADIENT_COLORS.length; i++) {
      listColorClicked
          .add({'id': DUMMY_GRADIENT_COLORS[i]['id'], 'clicked': false});
    }

    listColorClicked.firstWhere(
        (data) => data['id'] == widget.category.colorId)['clicked'] = true;
    chosenColor = listColorClicked
        .firstWhere((data) => data['id'] == widget.category.colorId);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          'Выберите цвет фона',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto',
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 415.0,
                //height: widget.height * 0.5632,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: DUMMY_GRADIENT_COLORS.map((data) {
                    var currentColorData = listColorClicked.firstWhere(
                        (dataColor) => dataColor['id'] == data['id']);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          for (var colorData in listColorClicked) {
                            colorData.update('clicked', (value) => false);
                          }
                          currentColorData.update('clicked', (value) => true);
                          chosenColor = currentColorData;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.0),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(data['hexColorOne']),
                                Color(data['hexColorTwo'])
                              ],
                            ),
                          ),
                          child: currentColorData['clicked']
                              ? Icon(Icons.done)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
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
                      //color: Color(0xff66A8FF),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 18.0,
                        ),
                        child: Text(
                          'RGB',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        showDialogPickerRGB(context);
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
                      //color: Color(0xff42DD95),
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
                      onPressed: chosenColor['clicked']
                          ? () {
                              setState(() {
                                var dataColor =
                                    DUMMY_GRADIENT_COLORS.firstWhere((data) =>
                                        chosenColor['id'] == data['id']);

                                widget.category.bgColorOne =
                                    Color(dataColor['hexColorOne']);
                                widget.category.bgColorTwo =
                                    Color(dataColor['hexColorTwo']);
                                widget.category.fgColor = Colors.black;

                                widget.category.colorId = dataColor['id'];
                              });

                              Navigator.of(context).pop();
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void showDialogPickerRGB(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(20.0),
            contentPadding:
                const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
            title: Text(
              'Настройте цвет фона',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ColorPicker(
                    pickerColor: widget.category.bgColorOne,
                    onColorChanged: (pickedColor) {
                      widget.category.bgColorOne = pickedColor;

                      widget.category.fgColor =
                          useWhiteForeground(widget.category.bgColorOne)
                              ? const Color(0xffffffff)
                              : const Color(0xff000000);
                    },
                    colorPickerWidth: 400.0,
                    //colorPickerWidth: widget.width * 0.8334,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: true,
                    displayThumbColor: true,
                    showLabel: true,
                    paletteType: PaletteType.hsv,
                    pickerAreaBorderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(2.0),
                      topRight: const Radius.circular(2.0),
                    ),
                  ),
                  Row(
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
                        //color: Color(0xff66A8FF),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, top: 15.0),
                          child: Text(
                            'Готовые цвета',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          //showDialogPickerColor(context);
                        },
                      ),
                      //Spacer(),
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
                        //color: Color(0xff42DD95),
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
                          setState(() {
                            print('clicked');
                            widget.category.colorId = DummyColorId.none;

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

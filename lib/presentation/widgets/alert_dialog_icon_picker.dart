import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/data/models/category.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AlertDialogIconPicker extends StatefulWidget {
  Category category;
  List<dynamic> availableCategories;

  AlertDialogIconPicker({
    required this.category,
    required this.availableCategories,
  });

  @override
  _AlertDialogIconPickerState createState() => _AlertDialogIconPickerState();
}

class _AlertDialogIconPickerState extends State<AlertDialogIconPicker> {
  var listIconClicked = <Map<String, dynamic>>[];
  Map<String, dynamic> chosenIcon = {};

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < DUMMY_ICONS.length; i++) {
      listIconClicked.add({'id': DUMMY_ICONS[i]['id'], 'clicked': false});
    }

    if (widget.category.iconId != null) {
      listIconClicked.firstWhere(
          (data) => data['id'] == widget.category.iconId)['clicked'] = true;
      chosenIcon = listIconClicked
          .firstWhere((data) => data['id'] == widget.category.iconId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          'Выберите иконку',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto',
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              buildGridViewIcons(),
              buildRowButtons(context),
            ],
          ),
        ));
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
          onPressed: chosenIcon != null && chosenIcon['clicked']
              ? () {
                  setState(() {
                    var dataIcon = DUMMY_ICONS
                        .firstWhere((data) => chosenIcon['id'] == data['id']);

                    widget.category.iconId = dataIcon['id'];
                  });

                  Navigator.of(context).pop();
                }
              : null,
        ),
      ],
    );
  }

  Widget buildGridViewIcons() {
    return Container(
      height: 360.0,
      //height: widget.height * 0.5632,
      child: GridView.count(
        crossAxisCount: 4,
        children: widget.availableCategories.map((data) {
          var currentIconData = listIconClicked
              .firstWhere((dataColor) => dataColor['id'] == data['id']);

          var currIcon = DUMMY_ICONS.firstWhere(
              (data) => data['id'] == currentIconData['id'])['icon'];

          return GestureDetector(
            onTap: () {
              setState(() {
                for (var iconData in listIconClicked) {
                  iconData.update('clicked', (value) => false);
                }
                currentIconData.update('clicked', (value) => true);
                chosenIcon = currentIconData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(60.0),
                  color: currentIconData['clicked']
                      ? Color(0xff42DD95)
                      : Colors.white,
                ),
                child: currIcon,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

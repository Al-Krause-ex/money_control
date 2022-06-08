import 'package:flutter/material.dart';
import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/data/models/category.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/presentation/widgets/alert_dialog_color_picker.dart';
import 'package:money_control/presentation/widgets/alert_dialog_icon_picker.dart';

import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

class AlertDialogCategory extends StatefulWidget {
  final DataCubit dataCubit;
  final Function function;
  final String? categoryId;
  final bool isEdit;

  AlertDialogCategory({
    required this.dataCubit,
    required this.function,
    required this.categoryId,
    required this.isEdit,
  });

  @override
  _AlertDialogCategoryState createState() => _AlertDialogCategoryState();
}

class _AlertDialogCategoryState extends State<AlertDialogCategory> {
  final List<dynamic> availableCategories = [];

  Category? currentCategory;

  final uuid = Uuid();
  final tecCategory = TextEditingController();

  var coordinateX = 0.0;
  Map<String, dynamic> currIconMap = {};

  @override
  void initState() {
    super.initState();

    for (var data in DUMMY_ICONS) {
      var isExists = false;

      for (var category in widget.dataCubit.state.customUser.categories) {
        if (category.iconId == data['id']) isExists = true;
      }

      if (!isExists) availableCategories.add(data);
    }

    if (widget.isEdit) {
      currentCategory = widget.dataCubit.state.customUser.categories
          .firstWhere((cat) => cat.id == widget.categoryId!)
          .copyWith();

      availableCategories.add(DUMMY_ICONS
          .firstWhere((data) => currentCategory!.iconId == data['id']));
    } else {
      currentCategory = Category.empty(
        iconId: availableCategories[0]['id'],
        bgColorOne: Color(DUMMY_GRADIENT_COLORS[0]['hexColorOne']),
        bgColorTwo: Color(DUMMY_GRADIENT_COLORS[0]['hexColorTwo']),
        fgColor: Colors.black,
        colorId: DUMMY_GRADIENT_COLORS.first['id'],
        action: 0,
      );
    }

    tecCategory.text = currentCategory!.title;
  }

  @override
  Widget build(BuildContext context) {
    settingCoordinateAndIcon();

    return AlertDialog(
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
            buildCategory(),
            buildType(),
            buildDropdownButtonIcon(currIconMap['icon']),
            buildChoseColor(coordinateX, currIconMap['icon'], context),
            buildButtonDone(context),
          ],
        ),
      ),
    );
  }

  Widget buildButtonDone(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xffFF934B),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              pressedDone();
            },
          ),
        ),
      ),
    );
  }

  Widget buildChoseColor(double coordinateX, currIcon, BuildContext context) {
    Color colorOne;
    Color colorTwo;

    if (currentCategory!.colorId != DummyColorId.none) {
      var currentDummyColor = DUMMY_GRADIENT_COLORS
          .firstWhere((data) => data['id'] == currentCategory!.colorId);

      colorOne = Color(currentDummyColor['hexColorOne']);
      colorTwo = Color(currentDummyColor['hexColorTwo']);
    } else {
      colorOne = currentCategory!.bgColorOne;
      colorTwo = currentCategory!.bgColorOne;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
          child: Text(
            'Выбор цвета',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
        ),
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorOne, colorTwo],
            ),
          ),
          child: Align(
            alignment: Alignment(coordinateX, 0),
            child: GestureDetector(
              child: IconTheme(
                data: IconThemeData(
                  color: currentCategory!.fgColor,
                ),
                child: currIcon,
              ),
              onTap: () {
                showDialogPickerColor(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdownButtonIcon(currIcon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
          child: Text(
            'Выбор иконки',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
        ),
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
          ),
          child: GestureDetector(
            child: IconTheme(
              data: IconThemeData(
                color: currentCategory!.fgColor,
              ),
              child: currIcon,
            ),
            onTap: () {
              showDialogPickerIcon(context, availableCategories);
            },
          ),
        ),
      ],
    );
  }

  Widget buildType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0, top: 20.0),
          child: Text(
            'Тип',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              border: Border.all(color: Colors.black)),
          child: ToggleSwitch(
            cornerRadius: 8.0,
            initialLabelIndex: currentCategory!.action,
            activeBgColor: [Colors.lightGreen],
            activeFgColor: Colors.black,
            inactiveBgColor: Colors.transparent,
            inactiveFgColor: Colors.black87,
            labels: ['Расход', 'Доход'],
            onToggle: (indexToggle) {
              currentCategory!.action = indexToggle!;
            },
          ),
        ),
      ],
    );
  }

  Widget buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Text(
            'Категория',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
        ),
        TextField(
          controller: tecCategory,
          maxLength: 10,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Название',
            counterText: "",
          ),
          onChanged: (str) {},
        ),
      ],
    );
  }

  void showDialogPickerIcon(
      BuildContext context, List<dynamic> availableCategories) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogIconPicker(
          category: currentCategory!,
          availableCategories: availableCategories,
        );
      },
    ).then((value) {
      setState(() {
        currentCategory!.fgColor =
            useWhiteForeground(currentCategory!.bgColorOne)
                ? const Color(0xffffffff)
                : const Color(0xff000000);
      });
    });
  }

  void showDialogPickerColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogColorPicker(
          category: currentCategory!,
        );
      },
    ).then((value) {
      setState(() {
        currentCategory!.fgColor =
            useWhiteForeground(currentCategory!.bgColorOne)
                ? const Color(0xffffffff)
                : const Color(0xff000000);
      });
    });
  }

  void pressedDone() {
    if (tecCategory.text.isNotEmpty) {
      var isSave = false;

      setState(() {
        currentCategory!.title = tecCategory.text.trim();

        if (widget.isEdit) {
          var cards = widget.dataCubit.state.customUser.cards.where((card) {
            return card.categoryId == currentCategory!.id;
          }).toList();

          var transactions =
              widget.dataCubit.state.customUser.transactions.where((tx) {
            return tx.categoryId == currentCategory!.id;
          }).toList();

          for (var card in cards) {
            card.title = currentCategory!.title;
            card.bgColorOne = currentCategory!.bgColorOne;
            card.bgColorTwo = currentCategory!.bgColorTwo;
            card.fgColor = currentCategory!.fgColor;
            card.colorId = currentCategory!.colorId;
          }

          for (var tx in transactions) {
            var cat = widget.dataCubit.state.customUser.categories
                .firstWhere((c) => c.id == tx.categoryId);
            var previousAction = cat.action;

            tx.title = currentCategory!.title;
            cat = currentCategory!.copyWith(id: tx.categoryId);

            if (cat.action != previousAction) {
              if (cat.action == 0) {
                widget.dataCubit.state.customUser.totalBalance -= tx.sum * 2;
              } else {
                widget.dataCubit.state.customUser.totalBalance += tx.sum * 2;
              }
            }
          }

          bool isChanged = widget.dataCubit
              .isChangedCat(widget.categoryId!, currentCategory!);

          if (isChanged) {
            widget.dataCubit.editCat(
              widget.categoryId!,
              currentCategory!,
            );

            isSave = true;
          }
        } else {
          currentCategory!.id = uuid.v4();

          widget.dataCubit.addCategory(currentCategory!);

          isSave = true;
        }

        if (isSave) {
          widget.dataCubit.saveData(isCategories: true);

          widget.function();
        }

        Navigator.of(context).pop();
        // Navigator.popUntil(
        //     context, ModalRoute.withName(settingsScreen));
      });
    }
  }

  void settingCoordinateAndIcon() {
    currIconMap =
        DUMMY_ICONS.firstWhere((data) => data['id'] == currentCategory!.iconId);

    if (currIconMap['id'] == DummyIconId.tshirt_icon ||
        currIconMap['id'] == DummyIconId.piggy_bank_icon) {
      coordinateX = -0.3;
    } else if (currIconMap['id'] == DummyIconId.shopping_basket_icon) {
      coordinateX = -0.15;
    }
  }
}

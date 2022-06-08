import 'package:flutter/material.dart';
import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/data/models/category.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/domain/cubit/settings_cubit.dart';
import 'package:money_control/helpers/show_helper.dart';
import 'package:money_control/presentation/widgets/alert_dialog_category.dart';

class ButtonAddCat extends StatelessWidget {
  final DataCubit dataCubit;
  final Function function;


  const ButtonAddCat({
    Key? key,
    required this.dataCubit,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 15.0, top: 15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: dataCubit.state.customUser.categories.length ==
                    DUMMY_ICONS.length
                ? Colors.grey
                : Color(0xffFF934B),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: dataCubit.state.customUser.categories.length ==
                      DUMMY_ICONS.length
                  ? null
                  : () {
                      pressedAdd(context);
                    },
            ),
          ),
        ),
      ),
    );
  }

  void pressedAdd(context) {
    var countCategories = dataCubit.state.customUser.categories.length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogCategory(
          dataCubit: dataCubit,
          function: function,
          categoryId: null,
          isEdit: false,
        );
      },
    ).then((value) {
      if (countCategories < dataCubit.state.customUser.categories.length) {
        ShowHelper.showMessage(
          context,
          title: 'Категория "${dataCubit.state.customUser.categories.last.title}" создана',
          duration: Duration(seconds: 2),
        );
      }
    });
  }
}

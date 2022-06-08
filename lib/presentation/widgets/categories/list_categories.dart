import 'package:flutter/material.dart';
import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/show_helper.dart';
import 'package:money_control/presentation/widgets/alert_dialog_category.dart';

class ListCategories extends StatefulWidget {
  final DataCubit dataCubit;
  final Function function;

  const ListCategories({
    Key? key,
    required this.dataCubit,
    required this.function,
  }) : super(key: key);

  @override
  State<ListCategories> createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          var currentCategory =
              widget.dataCubit.state.customUser.categories[index];

          var icon = DUMMY_ICONS.firstWhere(
              (data) => currentCategory.iconId == data['id'])['icon'];

          var coordinateX = 0.0;
          var currIconId = DUMMY_ICONS
              .firstWhere((data) => data['id'] == currentCategory.iconId)['id'];

          if (currIconId == DummyIconId.tshirt_icon ||
              currIconId == DummyIconId.piggy_bank_icon) {
            coordinateX = -0.3;
          } else if (currIconId == DummyIconId.shopping_basket_icon) {
            coordinateX = -0.15;
          }

          var symbolAction = currentCategory.action == 0 ? '-' : '+';
          var colorAction =
              currentCategory.action == 0 ? Colors.red : Colors.green;

          Color colorOne;
          Color colorTwo;

          if (currentCategory.colorId != DummyColorId.none) {
            var currentDummyColor = DUMMY_GRADIENT_COLORS
                .firstWhere((data) => data['id'] == currentCategory.colorId);

            colorOne = Color(currentDummyColor['hexColorOne']);
            colorTwo = Color(currentDummyColor['hexColorTwo']);
          } else {
            colorOne = currentCategory.bgColorOne;
            colorTwo = currentCategory.bgColorOne;
          }

          return Padding(
            padding: const EdgeInsets.only(
              bottom: 5.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Dismissible(
              key: Key(widget.dataCubit.state.customUser.categories[index].id),
              onDismissed: (direction) {
                var currentCategory =
                    widget.dataCubit.state.customUser.categories[index];

                widget.dataCubit.removeCat(currentCategory.id);
                widget.dataCubit.saveData(
                  isCategories: true,
                  isTransactions: true,
                  isMoney: true,
                );

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    content:
                        Text('Категория "${currentCategory.title}" удалена'),
                  ),
                );

                setState(() {});
              },
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialogCategory(
                        dataCubit: widget.dataCubit,
                        function: widget.function,
                        categoryId: currentCategory.id,
                        isEdit: true,
                      );
                    },
                  ).then((value) {
                    if (value != null)
                      setState(() {
                        ShowHelper.showMessage(
                          context,
                          title: 'Категория изменена',
                          duration: Duration(seconds: 2),
                        );
                      });
                  });
                },
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0, bottom: 10.0, top: 10.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: currentCategory.bgColorOne,
                              foregroundColor: currentCategory.fgColor,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [colorOne, colorTwo],
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment(coordinateX, 0),
                                  child: icon,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            currentCategory.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '$symbolAction сумма',
                            style: TextStyle(
                              color: colorAction,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: widget.dataCubit.state.customUser.categories.length,
      ),
    );
  }
}

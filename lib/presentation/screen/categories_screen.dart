import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/data/models/category.dart';
import 'package:money_control/data/models/data_storage.dart';
import 'package:money_control/data/repositories/repository.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/presentation/widgets/alert_dialog_category.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<dynamic> availableCategories = [];
  List<Category> displayedCategories = [];
  List<Category> temporarilyCategories = [];

  List<TextEditingController> tecCategories = [];
  List<Icon> iconCategories = [];

  List<String> errorsList = [];

  var uuid = Uuid();
  var canBeSaved = true;
  Color currentColor = Colors.limeAccent;

  @override
  void initState() {
    super.initState();

    displayedCategories.clear();
    for (var category in dataStorage.appliedCategories) {
      var cat = Category(
        id: category.id,
        title: category.title,
        iconId: category.iconId,
        action: category.action,
        bgColorOne: category.bgColorOne,
        fgColor: category.fgColor,
        bgColorTwo: category.bgColorTwo,
        colorId: category.colorId,
      );

      displayedCategories.add(cat);
    }

    availableCategories = DUMMY_ICONS;

    for (int i = 0; i < displayedCategories.length; i++) {
      var tecCategory =
          TextEditingController(text: displayedCategories[i].title);

      tecCategories.add(tecCategory);
    }
  }

  @override
  void dispose() {
    for (var tecCategory in tecCategories) {
      tecCategory.dispose();
    }
    super.dispose();
  }

  void changeColor(color, pickedColor) => color = pickedColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              'Количество: ${dataStorage.appliedCategories.length}/${DUMMY_ICONS.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          buildContainerCategories(context),
          buildIconButtonAdd(context),
        ],
      ),
    );
  }

  Widget buildIconButtonAdd(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 15.0, top: 15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: dataStorage.appliedCategories.length == DUMMY_ICONS.length
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
              onPressed:
                  dataStorage.appliedCategories.length == DUMMY_ICONS.length
                      ? null
                      : () {
                          setState(() {
                            var countCategories =
                                dataStorage.appliedCategories.length;

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox();
                                // return AlertDialogCategory(
                                //   dataCubit: DataCubit(repository: Repository()),
                                //   categoryId: 'Category.empty()',
                                //   isEdit: false,
                                // );
                              },
                            ).then((value) {
                              setState(() {
                                if (countCategories <
                                    dataStorage.appliedCategories.length) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                          'Категория "${dataStorage.appliedCategories.last.title}" создана'),
                                    ),
                                  );
                                }
                              });
                            });
                          });
                        },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContainerCategories(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          var currentCategory = dataStorage.appliedCategories[index];

          var icon = DUMMY_ICONS.firstWhere(
              (data) => currentCategory.iconId == data['id'])['icon'];

          var coordinateX = 0.0;
          var currIconId = DUMMY_ICONS
              .firstWhere((data) => data['id'] == currentCategory.iconId)['id'];

          if (currIconId == 'tshirt_icon' || currIconId == 'piggy_bank_icon') {
            coordinateX = -0.3;
          } else if (currIconId == 'shopping_basket_icon') {
            coordinateX = -0.15;
          }

          var symbolAction = currentCategory.action == 0 ? '-' : '+';
          var colorAction =
              currentCategory.action == 0 ? Colors.red : Colors.green;

          Color colorOne;
          Color colorTwo;

          if (currentCategory.colorId != null) {
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
              key: GlobalKey(),
              onDismissed: (direction) {
                setState(() {
                  var currentCategory = dataStorage.appliedCategories[index];

                  dataStorage.appliedCards.removeWhere((card) {
                    return card.categoryId == currentCategory.id;
                  });

                  dataStorage.transactions.removeWhere((tx) {
                    if (tx.categoryId == currentCategory.id) {
                      if (currentCategory.action == 0)
                        dataStorage.totalBalance += tx.sum;
                      else
                        dataStorage.totalBalance -= tx.sum;
                      return true;
                    } else
                      return false;
                  });

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content:
                          Text('Категория "${currentCategory.title}" удалена'),
                    ),
                  );

                  dataStorage.appliedCategories.removeAt(index);
                  dataStorage.saveData();
                });
              },
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox();
                      // return AlertDialogCategory(
                      //   dataCubit: DataCubit(repository: Repository()),
                      //   categoryId: currentCategory.id,
                      //   isEdit: true,
                      // );
                    },
                  ).then((value) {
                    setState(() {
                      // Scaffold.of(context).showSnackBar(
                      //   SnackBar(
                      //     content:
                      //     Text('Категория изменена'),
                      //   ),
                      // );
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
        itemCount: dataStorage.appliedCategories.length,
      ),
    );
  }
}

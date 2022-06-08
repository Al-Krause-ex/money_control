import 'package:flutter/material.dart';
import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/data/models/category.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/presentation/widgets/categories/button_add_cat.dart';
import 'package:money_control/presentation/widgets/categories/list_categories.dart';
import 'package:uuid/uuid.dart';

class CategoriesPage extends StatefulWidget {
  final DataCubit dataCubit;

  CategoriesPage({Key? key, required this.dataCubit}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<dynamic> availableCategories = [];
  final List<Category> displayedCategories = [];
  final List<Category> temporarilyCategories = [];

  final List<TextEditingController> tecCategories = [];
  final List<Icon> iconCategories = [];
  final List<String> errorsList = [];

  final uuid = Uuid();
  var canBeSaved = true;
  var currentColor = Colors.limeAccent;

  @override
  void initState() {
    super.initState();

    initLists();
  }

  @override
  void dispose() {
    for (var tecCategory in tecCategories) {
      tecCategory.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              'Количество: ${widget.dataCubit.state.customUser.categories.length}/${availableCategories.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          ListCategories(
            dataCubit: widget.dataCubit,
            function: () {
              setState(() {});
            },
          ),
          ButtonAddCat(
            dataCubit: widget.dataCubit,
            function: () {
              setState(() {});
            },
          ),
          // buildIconButtonAdd(context),
        ],
      ),
    );
  }

  void initLists() {
    displayedCategories.clear();

    for (var category in widget.dataCubit.state.customUser.categories) {
      var cat = category.copyWith();

      displayedCategories.add(cat);
    }

    if (availableCategories.isNotEmpty) availableCategories.clear();
    availableCategories.addAll(DUMMY_ICONS);

    for (int i = 0; i < displayedCategories.length; i++) {
      var tecCategory =
          TextEditingController(text: displayedCategories[i].title);

      tecCategories.add(tecCategory);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';

class AlertDialogFilter extends StatefulWidget {
  final DataCubit dataCubit;
  final List<String> filterTransactionsByCategoryId;

  AlertDialogFilter({
    required this.dataCubit,
    required this.filterTransactionsByCategoryId,
  });

  @override
  _AlertDialogFilterState createState() => _AlertDialogFilterState();
}

class _AlertDialogFilterState extends State<AlertDialogFilter> {
  var allCategoriesFlag = false;
  var categoryIds = <String>[];
  var categories = <Map<String, dynamic>>[];

  @override
  void initState() {
    for (var tx in widget.dataCubit.state.customUser.transactions) {
      categoryIds.add(tx.categoryId);
    }

    categoryIds = categoryIds.toSet().toList();

    for (var catId in categoryIds) {
      var title = widget.dataCubit.state.customUser.categories
          .where((cat) => cat.id == catId)
          .first
          .title;

      categories.add({'id': catId, 'title': title, 'flag': false});
    }

    for (var cat in categories) {
      if (widget.filterTransactionsByCategoryId.contains(cat['id']))
        cat['flag'] = true;
    }

    categories.sort((c1, c2) {
      var r = c1['title'].compareTo(c2['title']);
      return r;
    });

    checkTrueCategories();

    super.initState();
  }

  void checkTrueCategories() {
    var countTrueCategories = 0;
    for (var cat in categories) {
      if (cat['flag']) countTrueCategories++;
    }

    if (countTrueCategories == categories.length)
      allCategoriesFlag = true;
    else
      allCategoriesFlag = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Фильтр по категориям',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto',
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Все категории'),
              Switch(
                value: allCategoriesFlag,
                onChanged: (v) {
                  setState(() {
                    allCategoriesFlag = v;

                    for (var i = 0; i < categories.length; i++) {
                      categories[i]['flag'] = allCategoriesFlag;
                    }
                  });
                },
              ),
            ],
          ),
          Container(
            height: 300.0,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Row(
                  children: [
                    Checkbox(
                      value: categories[index]['flag'],
                      onChanged: (v) {
                        setState(() {
                          categories[index]['flag'] = v;
                          checkTrueCategories();
                        });
                      },
                    ),
                    Text(categories[index]['title']),
                  ],
                );
              },
              itemCount: categories.length,
            ),
          ),
          buildRowButtons(context),
        ],
      ),
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
          //color: Color(0xff66A8FF),
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
              //Navigator.of(context).pop();

              var l = <String>[];
              for (var t in categories) {
                if (t['flag']) l.add(t['id']);
              }

              Navigator.of(context).pop(l);
            }),
      ],
    );
  }
}

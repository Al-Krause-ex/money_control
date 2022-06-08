import 'package:money_control/data/models/category.dart';
import 'package:money_control/data/models/position_item.dart';
import 'package:money_control/helpers/app_icons.dart';
import 'package:money_control/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final int sum;
  final DateTime date;
  final Category category;
  final List<PositionItem> positions;

  TransactionItem(
    this.title,
    this.sum,
    this.date,
    this.category,
    this.positions,
  );

  Widget buildCircleAvatarIcon(Category category) {
    Icon icon;
    var align = 0.0;

    icon =
        DUMMY_ICONS.firstWhere((data) => data['id'] == category.iconId)['icon'];

    Color colorOne;
    Color colorTwo;

    if (category.colorId != null) {
      var currentDummyColor = DUMMY_GRADIENT_COLORS
          .firstWhere((data) => data['id'] == category.colorId);

      colorOne = Color(currentDummyColor['hexColorOne']);
      colorTwo = Color(currentDummyColor['hexColorTwo']);
    } else {
      colorOne = category.bgColorOne;
      colorTwo = category.bgColorOne;
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: category.bgColorOne,
      foregroundColor: category.fgColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorOne, colorTwo],
          ),
        ),
        child: Align(
          alignment: Alignment(align, 0),
          child: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var symbol = category.action == 1 ? '+' : '-';
    var colorToMoney = symbol == '+' ? Colors.green : Colors.red;

    var hour = DateFormat('H').format(date);
    var minute = DateFormat('mm').format(date);

    var heightCard = positions.length * 50.0;
    if (heightCard > 150) heightCard = 150;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 4.0,
        child: Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.black),
          child: IgnorePointer(
            ignoring: positions.length > 0 ? false : true,
            child: ExpansionTile(
              leading: buildCircleAvatarIcon(category),
              tilePadding: EdgeInsets.symmetric(horizontal: 15.0),
              textColor: Colors.black,
              trailing: positions.length > 0 ? null : SizedBox(),
              iconColor: Colors.black,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          FittedBox(
                            child: Text(
                              '$symbol $sum',
                              style: TextStyle(
                                color: colorToMoney,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            AppIcons.rouble,
                            size: 16.0,
                            color: colorToMoney,
                          ),
                        ],
                      ),
                      Text(
                        '${DateFormat('dd.MM.yyyy').format(date)} '
                        '($hourч $minuteмин)',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              children: [
                Container(
                  height: heightCard,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          bottom: 5.0,
                          top: 15.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    positions[index].title,
                                    //textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    '$symbol ${positions[index].price} р',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: colorToMoney,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'x${positions[index].amount}',
                                    textAlign: TextAlign.end,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    },
                    itemCount: positions.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    // return Container(
    //   margin: const EdgeInsets.symmetric(horizontal: 10.0),
    //   child: Card(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(15.0),
    //     ),
    //     elevation: 3.0,
    //     child: Padding(
    //       padding: const EdgeInsets.all(10.0),
    //       child: Row(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(right: 10.0),
    //             child: buildCircleAvatarIcon(category),
    //           ),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 title,
    //                 style: TextStyle(
    //                   fontSize: 16.0,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //               Text(
    //                 '${DateFormat('dd.MM.yyyy').format(date)} '
    //                 '($hourч $minuteмин)',
    //                 style: TextStyle(
    //                   color: Colors.black54,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Spacer(),
    //           Text(
    //             '$symbol $sum',
    //             style: TextStyle(
    //               color: colorToMoney,
    //               fontSize: 16.0,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(right: 10.0),
    //             child: Icon(
    //               AppIcons.rouble,
    //               size: 16.0,
    //               color: colorToMoney,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

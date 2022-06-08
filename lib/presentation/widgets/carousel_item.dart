import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/data/models/data_storage.dart';
import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  final String id;
  final String categoryId;
  final String title;
  final int allMoney;
  final int passedMoney;
  final int today;
  final int lastDay;
  final int passedDays;
  final Color bgColor;
  final Color fgColor;
  final DummyColorId? colorId;
  final bool isEmpty;
  final double width;

  CarouselItem({
    this.id = '',
    this.categoryId = '',
    this.title = '',
    this.allMoney = 0,
    this.passedMoney = 0,
    this.today = 0,
    this.lastDay = 0,
    this.passedDays = 0,
    this.bgColor = Colors.white,
    this.fgColor = Colors.white,
    this.colorId,
    this.isEmpty = false,
    this.width = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    Color? colorOne;
    Color? colorTwo;

    if (!isEmpty) {
      if (colorId != null) {
        var currentDummyColor =
            DUMMY_GRADIENT_COLORS.firstWhere((data) => data['id'] == colorId);

        colorOne = Color(currentDummyColor['hexColorOne']);
        colorTwo = Color(currentDummyColor['hexColorTwo']);
      } else {
        colorOne = bgColor;
        colorTwo = bgColor;
      }
    }

    if (isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5.0,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.7),
          ),
          padding: EdgeInsets.only(left: 10.0),
          //width: 160.0,
          width: width * 0.4444,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '',
              ),
              SizedBox(
                height: 7.0,
              ),
              Text(
                '',
              ),
              SizedBox(
                height: 7.0,
              ),
              Text(
                '',
              ),
            ],
          ),
        ),
      );
    } else {
      var action = dataStorage.appliedCategories
          .firstWhere((cat) => cat.id == categoryId)
          .action;
      var actionStr = '';
      int diff = allMoney - passedMoney;

      if (diff < 0) {
        diff *= -1;
        actionStr = action == 0 ? '-' : '+';
      }

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5.0,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorOne!, colorTwo!],
            ),
            //color: bgColor,
          ),
          padding: EdgeInsets.only(left: 10.0),
          //width: 160.0,
          width: width * 0.4444,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: fgColor,
                ),
              ),
              SizedBox(
                height: 7.0,
              ),
              Text(
                '$passedMoney/$allMoneyр ($actionStr$diffр)',
                style: TextStyle(
                  fontSize: 16.0,
                  color: fgColor,
                ),
              ),
              SizedBox(
                height: 7.0,
              ),
              Text(
                '$passedDays/$lastDay (ещё ${lastDay - passedDays} дн)',
                style: TextStyle(
                    color: fgColor.value == 4294967295
                        ? Colors.grey
                        : Colors.black.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      );
    }
  }
}

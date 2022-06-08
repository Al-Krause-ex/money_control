import 'package:flutter/material.dart';
import 'package:money_control/data/dummy_data.dart';
import 'package:money_control/helpers/get_item.dart';

enum TypeCard { Weekly, Monthly, Other }

class CustomCard {
  final String id;
  String categoryId;
  String title;
  String markId;
  int allSum;
  int passedSum;
  int currentDay;
  int lastDay;
  bool isLastDay;
  TypeCard type;
  Color bgColorOne;
  Color bgColorTwo;
  Color fgColor;
  DummyColorId? colorId;
  DateTime createdDate;
  DateTime lastDayDate;

  CustomCard({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.markId,
    required this.allSum,
    required this.passedSum,
    required this.currentDay,
    required this.lastDay,
    required this.isLastDay,
    required this.type,
    required this.bgColorOne,
    required this.bgColorTwo,
    required this.fgColor,
    required this.colorId,
    required this.createdDate,
    required this.lastDayDate,
  });

  CustomCard.empty()
      : id = '',
        categoryId = '',
        title = '',
        markId = '',
        allSum = 0,
        passedSum = 0,
        currentDay = 0,
        lastDay = 0,
        isLastDay = false,
        type = TypeCard.Other,
        bgColorOne = Colors.white,
        bgColorTwo = Colors.white,
        fgColor = Colors.white,
        colorId = null,
        createdDate = DateTime.now(),
        lastDayDate = DateTime.now();

  CustomCard.fromJson(Map<String, dynamic> jsonCard)
      : id = jsonCard['id'],
        categoryId = jsonCard['categoryId'],
        title = jsonCard['title'],
        markId = jsonCard['markId'],
        allSum = jsonCard['allSum'],
        passedSum = jsonCard['passedSum'],
        currentDay = jsonCard['passedDays'],
        lastDay = jsonCard['lastDay'],
        isLastDay = jsonCard['isLastDay'],
        type = GetItem.getStatusFromString(jsonCard['type'])!,
        bgColorOne = Color(jsonCard['bgColorOne']),
        bgColorTwo = Color(jsonCard['bgColorTwo']),
        fgColor = Color(jsonCard['fgColor']),
        colorId = jsonCard['colorId'],
        createdDate = DateTime.parse(jsonCard['createdDate']),
        lastDayDate = DateTime.parse(jsonCard['lastDayDate']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': title,
        'title': title,
        'markId': markId,
        'allSum': allSum,
        'passedSum': passedSum,
        'currentDay': currentDay,
        'lastDay': lastDay,
        'isLastDay': isLastDay,
        'type': type.toString(),
        'bgColorOne': bgColorOne.value,
        'bgColorTwo': bgColorTwo.value,
        'fgColor': fgColor.value,
        'colorId': colorId,
        'createdDate': createdDate.toString(),
        'lastDayDate': lastDayDate.toString(),
      };
}

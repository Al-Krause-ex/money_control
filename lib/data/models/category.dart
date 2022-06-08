import 'package:flutter/material.dart';
import 'package:money_control/data/dummy_data.dart';

class Category {
  String id;
  String title;
  DummyIconId iconId;
  int action;
  Color bgColorOne;
  Color bgColorTwo;
  Color fgColor;
  DummyColorId colorId;

  Category({
    required this.id,
    required this.title,
    required this.iconId,
    required this.action,
    required this.bgColorOne,
    required this.bgColorTwo,
    required this.fgColor,
    required this.colorId,
  });

  Category.empty({
    this.id = '',
    this.title = '',
    this.iconId = DummyIconId.none,
    this.action = 0,
    this.bgColorOne = Colors.white,
    this.bgColorTwo = Colors.white,
    this.fgColor = Colors.white,
    this.colorId = DummyColorId.none,
  });

  Category.fromJson(Map<String, dynamic> jsonCategory)
      : id = jsonCategory['id'],
        title = jsonCategory['title'],
        iconId = DummyIconId.values[jsonCategory['iconId']],
        action = jsonCategory['action'],
        bgColorOne = Color(jsonCategory['bgColorOne']),
        bgColorTwo = Color(jsonCategory['bgColorTwo']),
        fgColor = Color(jsonCategory['fgColor']),
        colorId = DummyColorId.values[jsonCategory['colorId']];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'iconId': iconId.index,
        'action': action,
        'bgColorOne': bgColorOne.value,
        'bgColorTwo': bgColorTwo.value,
        'fgColor': fgColor.value,
        'colorId': colorId.index,
      };

  Category copyWith({
    String? id,
    String? title,
    DummyIconId? iconId,
    int? action,
    Color? bgColorOne,
    Color? bgColorTwo,
    Color? fgColor,
    DummyColorId? colorId,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      iconId: iconId ?? this.iconId,
      action: action ?? this.action,
      bgColorOne: bgColorOne ?? this.bgColorOne,
      bgColorTwo: bgColorTwo ?? this.bgColorTwo,
      fgColor: fgColor ?? this.fgColor,
      colorId: colorId ?? this.colorId,
    );
  }
}

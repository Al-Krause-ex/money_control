import 'package:flutter/material.dart';

enum CategoryEnum {
  Products,
  AdditionalCosts,
  Utilities,
  Credit,
  Income,
  Other,
}

class Item {
  const Item(this.name, this.icon, this.category);

  final String name;
  final Icon icon;
  final CategoryEnum category;
}

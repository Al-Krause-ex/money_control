import 'package:flutter/material.dart';

import '../helpers/app_icons.dart';

const List<Map<String, dynamic>> DUMMY_ICONS = [
  {
    'icon': Icon(Icons.attach_money),
    'id': DummyIconId.attach_money_icon,
  },
  {
    'icon': Icon(Icons.money_off),
    'id': DummyIconId.money_off_icon,
  },
  {
    'icon': Icon(Icons.shopping_cart),
    'id': DummyIconId.shopping_cart_icon,
  },
  {
    'icon': Icon(Icons.credit_card),
    'id': DummyIconId.credit_card_icon,
  },
  {
    'icon': Icon(Icons.home),
    'id': DummyIconId.home_icon,
  },
  {
    'icon': Icon(Icons.fastfood),
    'id': DummyIconId.fastfood_icon,
  },
  {
    'icon': Icon(Icons.account_balance_wallet),
    'id': DummyIconId.account_balance_wallet_icon
  },
  {
    'icon': Icon(AppIcons.food),
    'id': DummyIconId.food_icon,
  },
  {
    'icon': Icon(AppIcons.local_cafe),
    'id': DummyIconId.local_cafe_icon,
  },
  {
    'icon': Icon(AppIcons.tram),
    'id': DummyIconId.tram_icon,
  },
  {
    'icon': Icon(
      AppIcons.shopping_basket,
      size: 22.0,
    ),
    'id': DummyIconId.shopping_basket_icon,
  },
  {
    'icon': Icon(AppIcons.airport_shuttle),
    'id': DummyIconId.airport_shuttle_icon,
  },
  {
    'icon': Icon(AppIcons.local_car_wash),
    'id': DummyIconId.local_car_wash_icon,
  },
  {
    'icon': Icon(AppIcons.train),
    'id': DummyIconId.train_icon,
  },
  {
    'icon': Icon(AppIcons.user),
    'id': DummyIconId.user_icon,
  },
  {
    'icon': Icon(AppIcons.flight_takeoff),
    'id': DummyIconId.flight_takeoff_icon,
  },
  {
    'icon': Icon(AppIcons.pets),
    'id': DummyIconId.pets_icon,
  },
  {
    'icon': Icon(AppIcons.local_dining),
    'id': DummyIconId.local_dining_icon,
  },
  {
    'icon': Icon(AppIcons.piggy_bank),
    'id': DummyIconId.piggy_bank_icon,
  },
  {
    'icon': Icon(AppIcons.healing),
    'id': DummyIconId.healing_icon,
  },
  {
    'icon': Icon(AppIcons.school),
    'id': DummyIconId.school_icon,
  },
  {
    'icon': Icon(AppIcons.language),
    'id': DummyIconId.language_icon,
  },
  {
    'icon': Icon(
      AppIcons.tshirt,
      size: 22.0,
    ),
    'id': DummyIconId.tshirt_icon,
  },
];

// const List<Map<String, dynamic>> DUMMY_COLORS_OLD = [
//   {'id': 'green', 'hexColor': 0xffD3EAC0},
//   {'id': 'red', 'hexColor': 0xffE58B96},
//   {'id': 'yellow', 'hexColor': 0xffF9F3BB},
//   {'id': 'orange', 'hexColor': 0xffF2BC9B},
//   {'id': 'brown', 'hexColor': 0xffB2967E},
//   {'id': 'orange_saturated', 'hexColor': 0xffEF8A62},
//   {'id': 'blue', 'hexColor': 0xff99D1F7},
//   {'id': 'orange_middle', 'hexColor': 0xffFF9E8C},
//   {'id': 'green_tea', 'hexColor': 0xff9CC082},
//   {'id': 'grey', 'hexColor': 0xffCBCDC8},
//   {'id': 'red_saturated', 'hexColor': 0xffFF6549},
//   {'id': 'grey_blue', 'hexColor': 0xff8F8FD3},
//   {'id': 'light_blue', 'hexColor': 0xff84C3FF},
//   {'id': 'light_orange', 'hexColor': 0xffFEA610},
//   {'id': 'baby_pink', 'hexColor': 0xffF5C3C2},
//   {'id': 'sky', 'hexColor': 0xff95C8D9},
//   {'id': 'brown_animal', 'hexColor': 0xff998164},
//   {'id': 'blue_some_saturated', 'hexColor': 0xff8DB0F4},
//   {'id': 'green_saturated', 'hexColor': 0xff4FC878},
//   {'id': 'medical_blue', 'hexColor': 0xff50CBF4},
//   {'id': 'orange_saturated', 'hexColor': 0xffFF9900},
//   {'id': 'very_light_blue', 'hexColor': 0xffB9E2F6},
//   {'id': 'violet', 'hexColor': 0xffCD94E8},
// ];

//

const List<Map<String, dynamic>> DUMMY_COLORS = [
  {'id': DummyColorId.warm, 'hexColor': 0xffEDB28F},
  {'id': DummyColorId.pinky, 'hexColor': 0xffEA9FAA},
  {'id': DummyColorId.blue_sky, 'hexColor': 0xffCCC4FD},
  {'id': DummyColorId.cold_green, 'hexColor': 0xff87E2BA},
  {'id': DummyColorId.pretty_pinky, 'hexColor': 0xffFF9699},
  {'id': DummyColorId.violet, 'hexColor': 0xffBC89D3},
  {'id': DummyColorId.pink_to_red, 'hexColor': 0xffF699FF},
  {'id': DummyColorId.light_warm, 'hexColor': 0xffF7B4A0},
  {'id': DummyColorId.strange_yellow, 'hexColor': 0xffFFED98},
  {'id': DummyColorId.strange_blue, 'hexColor': 0xff6FE8ED},
  {'id': DummyColorId.red_to_yellow, 'hexColor': 0xffCE737B},
  {'id': DummyColorId.blue_to_red, 'hexColor': 0xffF93195},
  {'id': DummyColorId.green_to_blue, 'hexColor': 0xff66FF99},
  {'id': DummyColorId.light_to_deep_blue, 'hexColor': 0xff66EFFF},
  {'id': DummyColorId.very_warm, 'hexColor': 0xffFF5959},
  {'id': DummyColorId.pinky_violet, 'hexColor': 0xffFF93EE},
  {'id': DummyColorId.red_to_violet, 'hexColor': 0xffFF66A5},
  {'id': DummyColorId.strange_green, 'hexColor': 0xffFFED89},
  {'id': DummyColorId.warm_to_pinky, 'hexColor': 0xffFFEF89},
  {'id': DummyColorId.light_pinky_violet, 'hexColor': 0xffD1BAD8},
  {'id': DummyColorId.pretty_green, 'hexColor': 0xff75F9C9},
  {'id': DummyColorId.pretty_yellow, 'hexColor': 0xffFFF0A5},
  {'id': DummyColorId.light_red_blue, 'hexColor': 0xffFF8E7F},
];

const List<Map<String, dynamic>> DUMMY_GRADIENT_COLORS = [
  {
    'id': DummyColorId.warm,
    'hexColorOne': 0xffEDB28F,
    'hexColorTwo': 0xffF9C890
  },
  {
    'id': DummyColorId.pinky,
    'hexColorOne': 0xffEA9FAA,
    'hexColorTwo': 0xffFFD1D7
  },
  {
    'id': DummyColorId.blue_sky,
    'hexColorOne': 0xffCCC4FD,
    'hexColorTwo': 0xffD5E9FB
  },
  {
    'id': DummyColorId.cold_green,
    'hexColorOne': 0xff87E2BA,
    'hexColorTwo': 0xffD4E5C9
  },
  {
    'id': DummyColorId.pretty_pinky,
    'hexColorOne': 0xffFF9699,
    'hexColorTwo': 0xffFFCAB2
  },
  {
    'id': DummyColorId.violet,
    'hexColorOne': 0xffBC89D3,
    'hexColorTwo': 0xffC6B4C6
  },
  {
    'id': DummyColorId.pink_to_red,
    'hexColorOne': 0xffF699FF,
    'hexColorTwo': 0xffDB4C6B
  },
  {
    'id': DummyColorId.light_warm,
    'hexColorOne': 0xffF7B4A0,
    'hexColorTwo': 0xffFFE1BF
  },
  {
    'id': DummyColorId.strange_yellow,
    'hexColorOne': 0xffFFED98,
    'hexColorTwo': 0xff8D5CA8
  },
  {
    'id': DummyColorId.strange_blue,
    'hexColorOne': 0xff6FE8ED,
    'hexColorTwo': 0xffD4F8F9
  },
  {
    'id': DummyColorId.red_to_yellow,
    'hexColorOne': 0xffCE737B,
    'hexColorTwo': 0xffEDD282
  },
  {
    'id': DummyColorId.blue_to_red,
    'hexColorOne': 0xff32E8FC,
    'hexColorTwo': 0xffF93195
  },
  {
    'id': DummyColorId.green_to_blue,
    'hexColorOne': 0xff66FF99,
    'hexColorTwo': 0xff6675FF
  },
  {
    'id': DummyColorId.light_to_deep_blue,
    'hexColorOne': 0xff66EFFF,
    'hexColorTwo': 0xff7066FF
  },
  {
    'id': DummyColorId.very_warm,
    'hexColorOne': 0xffFFED89,
    'hexColorTwo': 0xffFF5959
  },
  {
    'id': DummyColorId.pinky_violet,
    'hexColorOne': 0xffFF93EE,
    'hexColorTwo': 0xff596CFF
  },
  {
    'id': DummyColorId.red_to_violet,
    'hexColorOne': 0xffFF66A5,
    'hexColorTwo': 0xff7272FF
  },
  {
    'id': DummyColorId.strange_green,
    'hexColorOne': 0xffFFED89,
    'hexColorTwo': 0xff4CFFFF
  },
  {
    'id': DummyColorId.warm_to_pinky,
    'hexColorOne': 0xffFFEF89,
    'hexColorTwo': 0xffFF327D
  },
  {
    'id': DummyColorId.light_pinky_violet,
    'hexColorOne': 0xffD1BAD8,
    'hexColorTwo': 0xff9272F9
  },
  {
    'id': DummyColorId.pretty_green,
    'hexColorOne': 0xff75F9C9,
    'hexColorTwo': 0xff44C4A0
  },
  {
    'id': DummyColorId.pretty_yellow,
    'hexColorOne': 0xffFFF0A5,
    'hexColorTwo': 0xffFFC666
  },
  {
    'id': DummyColorId.light_red_blue,
    'hexColorOne': 0xffFF8E7F,
    'hexColorTwo': 0xff21DDFF
  },
];

enum DummyIconId {
  attach_money_icon,
  money_off_icon,
  shopping_cart_icon,
  credit_card_icon,
  home_icon,
  fastfood_icon,
  account_balance_wallet_icon,
  food_icon,
  local_cafe_icon,
  tram_icon,
  shopping_basket_icon,
  airport_shuttle_icon,
  local_car_wash_icon,
  train_icon,
  user_icon,
  flight_takeoff_icon,
  pets_icon,
  local_dining_icon,
  piggy_bank_icon,
  healing_icon,
  school_icon,
  language_icon,
  tshirt_icon,
  none,
}

enum DummyColorId {
  warm,
  pinky,
  blue_sky,
  cold_green,
  pretty_pinky,
  violet,
  pink_to_red,
  light_warm,
  strange_yellow,
  strange_blue,
  red_to_yellow,
  blue_to_red,
  green_to_blue,
  light_to_deep_blue,
  very_warm,
  pinky_violet,
  red_to_violet,
  strange_green,
  warm_to_pinky,
  light_pinky_violet,
  pretty_green,
  pretty_yellow,
  light_red_blue,
  none,
}
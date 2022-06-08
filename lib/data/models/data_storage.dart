import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/category.dart';
import '../models/custom_card.dart';
import 'transaction.dart';
import 'position_item.dart';

class DataStorage {
  List<Transaction> transactions = [];
  List<Category> appliedCategories = [];
  List<CustomCard> appliedCards = [];
  List<String> filterCategoryIds = [];

  int totalBalance = 0;
  int moneyOfProducts = 0;
  int moneyOfAdditionalCosts = 0;
  int moneyOfCredit = 0;
  int moneyOfUtilities = 0;

  TypeCard? getStatusFromString(String statusAsString) {
    for (TypeCard element in TypeCard.values) {
      if (element.toString() == statusAsString) {
        return element;
      }
    }
    return null;
  }

  void saveData() async {
    List<Map<String, dynamic>> listTransactionsOfMap = [];
    List<Map<String, dynamic>> listCategoriesOfMap = [];
    List<Map<String, dynamic>> listCardsOfMap = [];
    List<Map<String, dynamic>> listPositions = [];

    for (Transaction transaction in transactions) {
      Map<String, dynamic> mapCategoryInTransaction = {
        // 'id': transaction.category.id,
        // 'title': transaction.category.title,
        // 'iconId': transaction.category.iconId,
        // 'action': transaction.category.action,
        // 'bgColorOne': transaction.category.bgColorOne.value,
        // 'bgColorTwo': transaction.category.bgColorTwo.value,
        // 'fgColor': transaction.category.fgColor.value,
        // 'colorId': transaction.category.colorId,
      };

      for (var position in transaction.positions) {
        Map<String, dynamic> mapPosition = {
          'id': position.id,
          'title': position.title,
          'price': position.price,
          'amount': position.amount
        };

        listPositions.add(mapPosition);
      }

      Map<String, dynamic> mapTransaction = {
        'id': transaction.id,
        'title': transaction.title,
        'markId': transaction.markId,
        'sum': transaction.sum,
        'date': transaction.date.toString(),
        'category': mapCategoryInTransaction,
        'positions': listPositions,
      };

      listTransactionsOfMap.add(mapTransaction);
      listPositions = [];
    }

    for (Category category in appliedCategories) {
      Map<String, dynamic> mapCategory = {
        'id': category.id,
        'title': category.title,
        'iconId': category.iconId,
        'action': category.action,
        'bgColorOne': category.bgColorOne.value,
        'bgColorTwo': category.bgColorTwo.value,
        'fgColor': category.fgColor.value,
        'colorId': category.colorId,
      };

      listCategoriesOfMap.add(mapCategory);
    }

    for (CustomCard card in appliedCards) {
      Map<String, dynamic> mapCard = {
        'id': card.id,
        'categoryId': card.categoryId,
        'title': card.title,
        'markId': card.markId,
        'allSum': card.allSum,
        'passedSum': card.passedSum,
        'passedDays': card.currentDay,
        'lastDay': card.lastDay,
        'isLastDay': card.isLastDay,
        'type': card.type.toString(),
        'bgColorOne': card.bgColorOne.value,
        'bgColorTwo': card.bgColorTwo.value,
        'fgColor': card.fgColor.value,
        'colorId': card.colorId,
        'createdDate': card.createdDate.toString(),
        'lastDayDate': card.lastDayDate.toString(),
      };

      listCardsOfMap.add(mapCard);
    }

    Map<String, int> mapMoney = {
      'balance': totalBalance,
      'moneyOfProducts': moneyOfProducts,
      'moneyOfAdditionalCosts': moneyOfAdditionalCosts,
      'moneyOfCredit': moneyOfCredit,
      'moneyOfUtilities': moneyOfUtilities
    };

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('KeyTransactionsData', json.encode(listTransactionsOfMap));
    prefs.setString('KeyMoneyData', json.encode(mapMoney));
    prefs.setString('KeyCategoriesData', json.encode(listCategoriesOfMap));
    prefs.setString('KeyCardsData', json.encode(listCardsOfMap));

    var jsonTransactionsString = json.encode(listTransactionsOfMap);
    var jsonMoneyString = json.encode(mapMoney);
    var jsonCategoriesString = json.encode(listCategoriesOfMap);
    var jsonCardsString = json.encode(listCardsOfMap);

    print('=================TRANSACTIONS=================');
    print('$jsonTransactionsString  \n');
    print('=================MONEY=================');
    print('$jsonMoneyString  \n');
    print('=================CATEGORIES=================');
    print('$jsonCategoriesString  \n');
    print('=================CARDS=================');
    print('$jsonCardsString  \n');
    print('==================================');
  }

  void saveFilterData() async {
    List<Map<String, dynamic>> listFilterCategoryIds = [];

    for (var filter in filterCategoryIds){
      Map<String, dynamic> mapFilter = {
        'id': filter
      };

      listFilterCategoryIds.add(mapFilter);
    }

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('KeyFiltersData', json.encode(listFilterCategoryIds));
  }

  Future<void> loadData() async {
    print('LOADING DATA');

    final prefs = await SharedPreferences.getInstance();

    if (transactions.isNotEmpty) {
      return;
    } else {
      if (prefs.containsKey('KeyTransactionsData')) {
        var listTransactionsOfMap =
            json.decode(prefs.getString('KeyTransactionsData')!);

        for (var i = 0; i < listTransactionsOfMap.length; i++) {
          var positions = <PositionItem>[];

          var category = Category(
            id: listTransactionsOfMap[i]['category']['id'],
            title: listTransactionsOfMap[i]['category']['title'],
            iconId: listTransactionsOfMap[i]['category']['iconId'],
            action: listTransactionsOfMap[i]['category']['action'],
            bgColorOne:
                Color(listTransactionsOfMap[i]['category']['bgColorOne']),
            bgColorTwo:
                Color(listTransactionsOfMap[i]['category']['bgColorTwo']),
            fgColor: Color(listTransactionsOfMap[i]['category']['fgColor']),
            colorId: listTransactionsOfMap[i]['category']['colorId'],
          );

          for (var positionData in listTransactionsOfMap[i]['positions']) {
            positions.add(PositionItem(
              id: positionData['id'],
              title: positionData['title'],
              price: positionData['price'],
              amount: positionData['amount'],
            ));
          }

          // var transaction = Transaction(
          //   positions,
          //   id: listTransactionsOfMap[i]['id'],
          //   title: listTransactionsOfMap[i]['title'],
          //   markId: listTransactionsOfMap[i]['markId'],
          //   sum: listTransactionsOfMap[i]['sum'],
          //   category: category,
          //   date: DateTime.parse(listTransactionsOfMap[i]['date']),
          // );
          //
          // transactions.add(transaction);
        }
      }
    }

    if (prefs.containsKey('KeyMoneyData')) {
      var mapMoney = json.decode(prefs.getString('KeyMoneyData')!);

      totalBalance = mapMoney['balance'];
      moneyOfProducts = mapMoney['moneyOfProducts'];
      moneyOfAdditionalCosts = mapMoney['moneyOfAdditionalCosts'];
      moneyOfCredit = mapMoney['moneyOfCredit'];
      moneyOfUtilities = mapMoney['moneyOfUtilities'];
    } else {
      totalBalance = 0;
      moneyOfProducts = 0;
      moneyOfAdditionalCosts = 0;
      moneyOfCredit = 0;
      moneyOfUtilities = 0;
    }

    if (prefs.containsKey('KeyFiltersData')) {
      var mapFilter = json.decode(prefs.getString('KeyFiltersData')!);

      for (var m in mapFilter){
        filterCategoryIds.add(m['id']);
      }
    } else {
      filterCategoryIds = ['None'];
    }

    if (appliedCategories.isNotEmpty) {
      return;
    } else {
      if (prefs.containsKey('KeyCategoriesData')) {
        var listCategoryOfMap =
            json.decode(prefs.getString('KeyCategoriesData')!);

        for (var i = 0; i < listCategoryOfMap.length; i++) {
          Category category = Category(
            id: listCategoryOfMap[i]['id'],
            title: listCategoryOfMap[i]['title'],
            iconId: listCategoryOfMap[i]['iconId'],
            action: listCategoryOfMap[i]['action'],
            bgColorOne: Color(listCategoryOfMap[i]['bgColorOne']),
            bgColorTwo: Color(listCategoryOfMap[i]['bgColorTwo']),
            fgColor: Color(listCategoryOfMap[i]['fgColor']),
            colorId: listCategoryOfMap[i]['colorId'],
          );

          appliedCategories.add(category);
        }
      }
    }

    if (appliedCards.isNotEmpty) {
      return;
    } else {
      if (prefs.containsKey('KeyCardsData')) {
        var listCardsOfMap = json.decode(prefs.getString('KeyCardsData')!);

        for (var i = 0; i < listCardsOfMap.length; i++) {
          CustomCard card = CustomCard(
            id: listCardsOfMap[i]['id'],
            categoryId: listCardsOfMap[i]['categoryId'],
            title: listCardsOfMap[i]['title'],
            markId: listCardsOfMap[i]['markId'],
            allSum: listCardsOfMap[i]['allSum'],
            passedSum: listCardsOfMap[i]['passedSum'],
            currentDay: listCardsOfMap[i]['passedDays'],
            lastDay: listCardsOfMap[i]['lastDay'],
            isLastDay: listCardsOfMap[i]['isLastDay'],
            type: getStatusFromString(listCardsOfMap[i]['type'])!,
            bgColorOne: Color(listCardsOfMap[i]['bgColorOne']),
            bgColorTwo: Color(listCardsOfMap[i]['bgColorTwo']),
            fgColor: Color(listCardsOfMap[i]['fgColor']),
            colorId: listCardsOfMap[i]['colorId'],
            createdDate: DateTime.parse(listCardsOfMap[i]['createdDate']),
            lastDayDate: DateTime.parse(listCardsOfMap[i]['lastDayDate']),
          );

          appliedCards.add(card);
        }
      }
    }
  }
}

DataStorage dataStorage = DataStorage();

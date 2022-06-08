import 'dart:convert';

import 'package:async/async.dart';
import 'package:money_control/data/models/custom_card.dart';
import 'package:money_control/data/models/category.dart';
import 'package:money_control/data/models/custom_user.dart';
import 'package:money_control/data/models/goal.dart';
import 'package:money_control/data/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  saveData({
    List<Transaction>? transactions,
    List<Category>? categories,
    List<CustomCard>? cards,
    List<Goal>? goals,
    int? totalBalance,
    required bool isTransactions,
    required bool isCategories,
    required bool isCards,
    required bool isMoney,
    required bool isGoals,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (isTransactions) saveTransactions(prefs, transactions!);
    if (isCategories) saveCategories(prefs, categories!);
    if (isCards) saveCards(prefs, cards!);
    if (isMoney) saveMoney(prefs, totalBalance!);
    if (isGoals) saveGoals(prefs, goals!);

    print('\n');
  }

  saveTransactions(
    SharedPreferences prefs,
    List<Transaction> transactions,
  ) async {
    List<Map<String, dynamic>> jsonTransactions = [];
    List<Map<String, dynamic>> jsonPositions = [];

    for (Transaction transaction in transactions) {
      for (var position in transaction.positions) {
        jsonPositions.add(position.toJson());
      }

      var jsonTransaction = transaction.toJson(jsonPositions);

      jsonTransactions.add(jsonTransaction);
      jsonPositions = [];
    }

    await prefs.setString('KeyTransactionsData', json.encode(jsonTransactions));
    // logPrint('TRANSACTIONS', jsonTransactions);
  }

  saveCategories(
    SharedPreferences prefs,
    List<Category> categories,
  ) async {
    List<Map<String, dynamic>> jsonCategories = [];

    for (Category category in categories) {
      jsonCategories.add(category.toJson());
    }

    await prefs.setString('KeyCategoriesData', json.encode(jsonCategories));
    // logPrint('CATEGORIES', jsonCategories);
  }

  saveCards(SharedPreferences prefs, List<CustomCard> cards) async {
    List<Map<String, dynamic>> jsonCards = [];

    for (CustomCard card in cards) {
      var jsonCard = card.toJson();

      jsonCards.add(jsonCard);
    }

    await prefs.setString('KeyCardsData', json.encode(jsonCards));
    // logPrint('CARDS', jsonCards);
  }

  saveMoney(SharedPreferences prefs, int totalBalance) async {
    Map<String, int> mapMoney = {'balance': totalBalance};

    await prefs.setString('KeyMoneyData', json.encode(mapMoney));
    // logPrint('MONEY', [mapMoney]);
  }

  saveGoals(SharedPreferences prefs, List<Goal> goals) async {
    List<Map<String, dynamic>> jsonGoals = [];

    for (Goal goal in goals) {
      var jsonGoal = goal.toJson();

      jsonGoals.add(jsonGoal);
    }

    await prefs.setString('KeyGoalsData', json.encode(jsonGoals));
    logPrint('GOALS', jsonGoals);
  }

  Future<CustomUser> loadData({
    List<Transaction>? transactions,
    List<Category>? categories,
    List<CustomCard>? cards,
    int? totalBalance,
    required bool isTransactions,
    required bool isCategories,
    required bool isCards,
    required bool isMoney,
    required bool isGoals,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final futureGroup = FutureGroup();

    List<Map<String, dynamic>> jsonTransactions = [{}];
    List<Map<String, dynamic>> jsonCategories = [{}];
    List<Map<String, dynamic>> jsonCards = [{}];
    List<Map<String, dynamic>> jsonGoals = [{}];

    Map<String, dynamic> jsonMoney = {};

    if (isTransactions) futureGroup.add(loadTransactions(prefs, transactions!));
    if (isCategories) futureGroup.add(loadCategories(prefs, categories!));
    if (isCards) futureGroup.add(loadCards(prefs, cards!));
    if (isMoney) futureGroup.add(loadMoney(prefs));
    if (isGoals) futureGroup.add(loadGoals(prefs));

    futureGroup.close();
    await futureGroup.future.then((value) => {
          jsonTransactions = value[0],
          jsonCategories = value[1],
          jsonCards = value[2],
          jsonMoney = value[3],
          jsonGoals = value[4],
        });

    logPrint('Load TX', jsonTransactions);
    logPrint('Load Cats', jsonCategories);
    logPrint('Load Cards', jsonCards);
    logPrint('Load Money', jsonMoney);
    logPrint('Load Goals', jsonGoals);

    return CustomUser.fromJson(
      jsonTransactions: jsonTransactions,
      jsonCategories: jsonCategories,
      jsonCards: jsonCards,
      jsonMoney: jsonMoney,
      jsonGoals: jsonGoals,
    );
  }

  Future<List<Map<String, dynamic>>> loadTransactions(
    SharedPreferences prefs,
    List<Transaction> transactions,
  ) async {
    if (prefs.containsKey('KeyTransactionsData') && transactions.isEmpty) {
      final listMapTx = <Map<String, dynamic>>[];
      var listDynamicTx = json.decode(prefs.getString('KeyTransactionsData')!);

      for (Map<String, dynamic> cat in listDynamicTx) {
        listMapTx.add(cat);
      }

      return listMapTx;
    }

    return [{}];
  }

  Future<List<Map<String, dynamic>>> loadCategories(
    SharedPreferences prefs,
    List<Category> categories,
  ) async {
    if (prefs.containsKey('KeyCategoriesData') && categories.isEmpty) {
      final listMapCats = <Map<String, dynamic>>[];
      var listDynamicCats = json.decode(prefs.getString('KeyCategoriesData')!);

      for (Map<String, dynamic> cat in listDynamicCats) {
        listMapCats.add(cat);
      }

      return listMapCats;
    }

    return [{}];
  }

  Future<List<Map<String, dynamic>>> loadCards(
    SharedPreferences prefs,
    List<CustomCard> cards,
  ) async {
    if (prefs.containsKey('KeyCardsData')) {
      final listMapCards = <Map<String, dynamic>>[];
      var listDynamicCards = json.decode(prefs.getString('KeyCardsData')!);

      for (Map<String, dynamic> cat in listDynamicCards) {
        listMapCards.add(cat);
      }

      return listMapCards;
    }

    return [{}];
  }

  Future<Map<String, dynamic>> loadMoney(SharedPreferences prefs) async {
    if (prefs.containsKey('KeyMoneyData')) {
      return json.decode(prefs.getString('KeyMoneyData')!);
    }

    return {'balance': 0};
  }

  Future<List<Map<String, dynamic>>> loadGoals(SharedPreferences prefs) async {
    if (prefs.containsKey('KeyGoalsData')) {
      final listMapGoals = <Map<String, dynamic>>[];
      var listDynamicGoals = json.decode(prefs.getString('KeyGoalsData')!);

      for (Map<String, dynamic> goal in listDynamicGoals) {
        listMapGoals.add(goal);
      }

      return listMapGoals;
    }

    return [{}];
  }

  void logPrint(String title, dynamic listMap) {
    var jsonItem = json.encode(listMap);

    print('**$title**');
    print('$jsonItem  \n');
  }
}

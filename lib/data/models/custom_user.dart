import 'package:money_control/data/models/category.dart';
import 'package:money_control/data/models/custom_card.dart';
import 'package:money_control/data/models/goal.dart';
import 'package:money_control/data/models/position_item.dart';
import 'package:money_control/data/models/transaction.dart';

class CustomUser {
  final List<Transaction> transactions;
  final List<Category> categories;
  final List<CustomCard> cards;
  final List<Goal> goals;
  int totalBalance;

  CustomUser({
    required this.transactions,
    required this.categories,
    required this.cards,
    required this.goals,
    required this.totalBalance,
  });

  CustomUser.empty()
      : transactions = [],
        categories = [],
        cards = [],
        goals = [],
        totalBalance = 0;

  factory CustomUser.fromJson({
    required List<Map<String, dynamic>> jsonTransactions,
    required List<Map<String, dynamic>> jsonCategories,
    required List<Map<String, dynamic>> jsonCards,
    required Map<String, dynamic> jsonMoney,
    required List<Map<String, dynamic>> jsonGoals,
  }) {
    List<Transaction> currTransactions = [];
    List<Category> currCategories = [];
    List<CustomCard> currCards = [];
    List<Goal> currGoals = [];
    int currBalance = 0;

    try {
      //Заполнение транзакций
      for (Map<String, dynamic> jsonTransaction in jsonTransactions) {
        var positions = <PositionItem>[];

        if (jsonTransaction.containsKey('positions')) {
          for (var positionData in jsonTransaction['positions']) {
            positions.add(PositionItem.fromJson(positionData));
          }
        }

        if (jsonTransaction.isNotEmpty) {
          var transaction = Transaction.fromJson(positions, jsonTransaction);

          currTransactions.add(transaction);
        }
      }

      //Заполнение категорий
      if (jsonCategories.isNotEmpty) {
        for (var jsonCategory in jsonCategories) {
          if (jsonCategory.isNotEmpty) {
            currCategories.add(Category.fromJson(jsonCategory));
          }
        }
      }

      //Заполнение карточек
      if (jsonCards.isNotEmpty) {
        for (var jsonCard in jsonCards) {
          if (jsonCard.isNotEmpty) {
            currCards.add(CustomCard.fromJson(jsonCard));
          }
        }
      }

      //Заполнение бюджета
      currBalance = jsonMoney['balance'];

      //Заполнение целей
      if (jsonGoals.isNotEmpty) {
        for (var jsonGoal in jsonGoals) {
          if (jsonGoal.isNotEmpty) {
            currGoals.add(Goal.fromJson(jsonGoal));
          }
        }
      }
    } catch (e) {
      print('err us: $e');
    }

    return CustomUser(
        transactions: currTransactions,
        categories: currCategories,
        cards: currCards,
        totalBalance: currBalance,
        goals: currGoals);
  }
}

import 'package:money_control/data/models/custom_user.dart';
import 'package:money_control/data/services/shared_preference_service.dart';

class Repository {
  final SharedPreferenceService _spService = SharedPreferenceService();

  void saveData({
    required CustomUser customUser,
    required bool isTransactions,
    required bool isCategories,
    required bool isCards,
    required bool isMoney,
    required bool isGoals,
  }) {
    _spService.saveData(
      transactions: customUser.transactions,
      categories: customUser.categories,
      cards: customUser.cards,
      totalBalance: customUser.totalBalance,
      goals: customUser.goals,
      isTransactions: isTransactions,
      isCategories: isCategories,
      isCards: isCards,
      isMoney: isMoney,
      isGoals: isGoals,
    );
  }

  Future<CustomUser> loadData({
    required CustomUser customUser,
    required bool isTransactions,
    required bool isCategories,
    required bool isCards,
    required bool isMoney,
    required bool isGoals,
  }) async {
    return await _spService.loadData(
      transactions: customUser.transactions,
      categories: customUser.categories,
      cards: customUser.cards,
      totalBalance: customUser.totalBalance,
      isTransactions: isTransactions,
      isCategories: isCategories,
      isCards: isCards,
      isMoney: isMoney,
      isGoals: isGoals,
    );
  }
}

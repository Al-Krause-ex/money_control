import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_control/data/models/category.dart';
import 'package:money_control/data/models/custom_user.dart';
import 'package:money_control/data/models/goal.dart';
import 'package:money_control/data/models/transaction.dart';
import 'package:money_control/data/repositories/repository.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  final Repository repository;

  DataCubit({required this.repository})
      : super(DataInitial(customUser: CustomUser.empty()));

  void saveData({
    bool isTransactions = false,
    bool isCategories = false,
    bool isCards = false,
    bool isMoney = false,
    bool isGoals = false,
  }) {
    repository.saveData(
      customUser: state.customUser,
      isTransactions: isTransactions,
      isCategories: isCategories,
      isCards: isCards,
      isMoney: isMoney,
      isGoals: isGoals,
    );
  }

  Future<void> loadData({
    bool isTransactions = true,
    bool isCategories = true,
    bool isCards = true,
    bool isMoney = true,
    bool isGoals = true,
  }) async {
    emit(
      DataInitialized(
        customUser: await repository.loadData(
          customUser: state.customUser,
          isTransactions: isTransactions,
          isCategories: isCategories,
          isCards: isCards,
          isMoney: isMoney,
          isGoals: isGoals,
        ),
      ),
    );
  }

  void addCategory(Category category) {
    state.customUser.categories.add(category);
  }

  void editCat(String catId, Category changedCat) {
    var catIndex =
        state.customUser.categories.indexWhere((cat) => cat.id == catId);

    state.customUser.categories[catIndex] = changedCat.copyWith();
  }

  void removeCat(String catId) {
    var deletedCatIndex =
        state.customUser.categories.indexWhere((cat) => cat.id == catId);

    state.customUser.transactions.removeWhere((tx) {
      if (tx.categoryId == state.customUser.categories[deletedCatIndex].id) {
        var cat = state.customUser.categories[deletedCatIndex];

        if (cat.action == 0)
          state.customUser.totalBalance += tx.sum;
        else
          state.customUser.totalBalance -= tx.sum;
        return true;
      } else
        return false;
    });

    state.customUser.categories.removeAt(deletedCatIndex);
  }

  bool isChangedCat(String catId, Category changedCat) {
    var isChanged = false;
    var currCat =
        state.customUser.categories.firstWhere((cat) => cat.id == catId);

    if (currCat.title != changedCat.title ||
        currCat.iconId != changedCat.iconId ||
        currCat.action != changedCat.action ||
        currCat.bgColorOne != changedCat.bgColorOne ||
        currCat.bgColorTwo != changedCat.bgColorTwo ||
        currCat.fgColor != changedCat.fgColor ||
        currCat.colorId != changedCat.colorId) {
      isChanged = true;
    }

    return isChanged;
  }

  void addTransaction(Map<String, dynamic> transactionMap) {
    var titleTransaction = '';
    var markIdToTx = '';

    // var currCat = state.customUser.categories.firstWhere((cat) => cat.id == transactionMap['categoryId']);

    // for (var card in state.customUser.cards) {
    // if (transactionMap['category'].id == card.categoryId) {
    //   card.passedSum += transactionMap['bill'] as int;
    //   markIdToTx = card.markId;
    // }
    // }

    titleTransaction = transactionMap['category'].title;

    state.customUser.transactions.add(
      Transaction(
        transactionMap['positions'],
        id: transactionMap['id'],
        title: titleTransaction,
        markId: markIdToTx,
        sum: transactionMap['bill'],
        date: transactionMap['date'],
        categoryId: transactionMap['category'].id,
      ),
    );

    if (transactionMap['category'].action == 0) {
      state.customUser.totalBalance -= transactionMap['bill'] as int;
    } else {
      state.customUser.totalBalance += transactionMap['bill'] as int;
    }

    saveData(isTransactions: true, isMoney: true);
  }

  void removeTransaction(String id) {
    // for (var card in widget.dataCubit.state.customUser.cards) {
    //   if (card.categoryId == deletedTransaction.category.id &&
    //       card.markId == deletedTransaction.markId) {
    //     card.passedSum -= deletedTransaction.sum;
    //   }
    // }

    var deletedTransaction =
        state.customUser.transactions.firstWhere((tx) => tx.id == id);

    var cat = state.customUser.categories
        .firstWhere((c) => c.id == deletedTransaction.categoryId);

    if (cat.action == 0) {
      state.customUser.totalBalance += deletedTransaction.sum;
      // balance += deletedTransaction.sum;
    } else {
      state.customUser.totalBalance -= deletedTransaction.sum;
      // balance -= deletedTransaction.sum;
    }

    state.customUser.transactions
        .removeWhere((transaction) => transaction.id == deletedTransaction.id);

    saveData(isTransactions: true, isMoney: true);
  }

  void editTransaction(String id, Map<String, dynamic> changedTransactionMap) {
    var index = state.customUser.transactions.indexWhere((tx) => tx.id == id);

    var titleTransaction = changedTransactionMap['category'].title;
    var markIdToTx = '';
    var oldSumTx = state.customUser.transactions[index].sum;

    for (var card in state.customUser.cards) {
      if (changedTransactionMap['category'].id == card.categoryId) {
        card.passedSum += changedTransactionMap['bill'] as int;
        markIdToTx = card.markId;
      }
    }

    var oldCat = state.customUser.categories.firstWhere(
        (c) => c.id == state.customUser.transactions[index].categoryId);
    var isChangedAction =
        oldCat.action != changedTransactionMap['category'].action;

    if (isChangedAction) {
      if (oldCat.action == 0)
        state.customUser.totalBalance += oldSumTx;
      else
        state.customUser.totalBalance -= oldSumTx;
    }

    if (changedTransactionMap['category'].action == 0) {
      if (!isChangedAction) state.customUser.totalBalance += oldSumTx;
      state.customUser.totalBalance -= changedTransactionMap['bill'] as int;
    } else {
      if (!isChangedAction) state.customUser.totalBalance -= oldSumTx;
      state.customUser.totalBalance += changedTransactionMap['bill'] as int;
    }

    state.customUser.transactions[index]
      ..title = titleTransaction
      ..markId = markIdToTx
      ..sum = changedTransactionMap['bill']
      ..date = changedTransactionMap['date']
      ..categoryId = changedTransactionMap['category'].id
      ..positions = changedTransactionMap['positions'];

    saveData(isTransactions: true, isMoney: true);
  }

  void addGoal(Goal goal) {
    state.customUser.goals.add(goal);

    saveData(isGoals: true);
  }

  void editGoal(String id, Goal goal) {
    var index = state.customUser.goals.indexWhere((goal) => goal.id == id);

    state.customUser.goals[index] = goal.copyWith();

    saveData(isGoals: true);
  }

  void removeGoal(String id) {
    var deletedIndex = state.customUser.goals.indexWhere((g) => g.id == id);

    state.customUser.goals.removeAt(deletedIndex);

    saveData(isGoals: true);
  }

  List<Goal> getSortedGoals() {
    var sortedGoals = state.customUser.goals.toList();

    sortedGoals.sort((a, b) {
      return a.date.compareTo(b.date);
    });

    return sortedGoals;
  }

  List<Transaction> getSortedTransactions() {
    var sortedTransactions = state.customUser.transactions.toList();

    sortedTransactions.sort((a, b) {
      return a.date.compareTo(b.date);
    });

    return sortedTransactions;
  }

  void changeCheckGoal(String id) {
    var index = state.customUser.goals.indexWhere((g) => g.id == id);

    state.customUser.goals[index].isDone =
        !state.customUser.goals[index].isDone;

    saveData(isGoals: true);
  }
}

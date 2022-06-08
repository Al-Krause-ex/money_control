import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_control/data/models/transaction.dart';
import 'package:money_control/helpers/extensions/custom_date.dart';

import 'data_cubit.dart';

part 'common_state.dart';

class CommonCubit extends Cubit<CommonState> {
  CommonCubit()
      : super(CommonInitial(
          typeShowDate: TypeDate.week,
          dtStart: DateTime.now(),
          dtEnd: DateTime.now(),
          transactions: [],
          categoriesId: ['None'],
        ));

  void initialize(DataCubit dataCubit) {
    var transactionsBool = <bool>[];
    final today = DateTime.now().withoutTime().weekday;
    final endNum = 7 - today;

    var dateEnd =
        DateTime.now().withoutTime().add(Duration(days: endNum)).withoutTime();
    var dateStart = dateEnd.subtract(Duration(days: 6)).withoutTime();

    var transactions = filterTransactions(dataCubit: dataCubit);

    transactions = getVisibleTransaction(
      dataCubit,
      transactions: transactions,
      dtStart: dateStart,
      dtEnd: dateEnd,
    );

    transactions.sort((a, b) {
      var aD = a.date;
      var bD = b.date;

      return bD.compareTo(aD);
    });

    for (var t in transactions) {
      transactionsBool.add(false);
    }

    emit(CommonInitialized(
      typeShowDate: state.typeDate,
      dtStart: dateStart,
      dtEnd: dateEnd,
      transactions: transactions,
      categoriesId: ['None'],
    ));
  }

  void changeData(
    DataCubit dataCubit, {
    DateTime? dateStart,
    DateTime? dateEnd,
  }) {
    var currState = state;

    var transactions = filterTransactions(
      categoriesId: state.categoriesId,
      dataCubit: dataCubit,
    );

    transactions = getVisibleTransaction(
      dataCubit,
      transactions: transactions,
      dtStart: dateStart,
      dtEnd: dateEnd,
    );

    transactions.sort((a, b) {
      var aD = a.date;
      var bD = b.date;

      return bD.compareTo(aD);
    });

    if (transactions.length == currState.transactions.length) {
      if (currState is CommonChangedData)
        emit(CommonEditedData(
            typeShowDate: currState.typeDate,
            dtStart: dateStart ?? state.dtStart,
            dtEnd: dateEnd ?? state.dtEnd,
            transactions: transactions,
            categoriesId: state.categoriesId));
      else
        emit(CommonChangedData(
            typeShowDate: currState.typeDate,
            dtStart: dateStart ?? state.dtStart,
            dtEnd: dateEnd ?? state.dtEnd,
            transactions: transactions,
            categoriesId: state.categoriesId));
    } else {
      emit(CommonChangedData(
          typeShowDate: currState.typeDate,
          dtStart: dateStart ?? state.dtStart,
          dtEnd: dateEnd ?? state.dtEnd,
          transactions: transactions,
          categoriesId: state.categoriesId));
    }
  }

  void changeFilter(List<String> categoriesId, DataCubit dataCubit) {
    var currTransactions = state.transactions;

    currTransactions = filterTransactions(
      categoriesId: categoriesId,
      dataCubit: dataCubit,
    );

    currTransactions = getVisibleTransaction(
      dataCubit,
      transactions: currTransactions,
      dtStart: state.dtStart,
      dtEnd: state.dtEnd,
    );

    currTransactions.sort((a, b) {
      var aD = a.date;
      var bD = b.date;

      return bD.compareTo(aD);
    });

    emit(CommonChangedFilter(
      typeShowDate: state.typeDate,
      dtStart: state.dtStart,
      dtEnd: state.dtEnd,
      transactions: currTransactions,
      categoriesId: categoriesId,
    ));
  }

  List<Transaction> getVisibleTransaction(
    DataCubit dataCubit, {
    List<Transaction>? transactions,
    DateTime? dtStart,
    DateTime? dtEnd,
  }) {
    return (transactions ?? dataCubit.state.customUser.transactions).where((transaction) {
      var start = transaction.date
              .withoutTime()
              .isAtSameMomentAs(dtStart ?? state.dtStart) ||
          transaction.date.withoutTime().isAfter(dtStart ?? state.dtStart);
      var end = transaction.date
              .withoutTime()
              .isAtSameMomentAs(dtEnd ?? state.dtEnd) ||
          transaction.date.withoutTime().isBefore(dtEnd ?? state.dtEnd);

      if (start && end) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  List<Transaction> filterTransactions({
    List<String>? categoriesId,
    required DataCubit dataCubit,
  }) {
    var filteredTransactions = <Transaction>[];

    filteredTransactions = getFilteredCategories(
      categoriesId: categoriesId ?? state.categoriesId,
      dataCubit: dataCubit,
    );

    return filteredTransactions;
  }

  List<Transaction> getFilteredCategories({
    required List<String> categoriesId,
    required DataCubit dataCubit,
  }) {
    var filteredTransactions = <Transaction>[];
    var transactions = dataCubit.state.customUser.transactions;

    if (categoriesId.first != 'None') {
      var sortedTx = <Transaction>[];

      for (var tx in transactions) {
        if (categoriesId.contains(tx.categoryId)) {
          sortedTx.add(tx);
        }
      }

      filteredTransactions = sortedTx.toList();
    } else {
      filteredTransactions = transactions.toList();
    }

    return filteredTransactions;
  }
}

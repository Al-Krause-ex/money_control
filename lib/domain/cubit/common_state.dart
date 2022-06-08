part of 'common_cubit.dart';

enum TypeDate { week, previousWeek, month, previousMonth, year, all }

abstract class CommonState extends Equatable {
  final TypeDate typeDate;
  final DateTime dtStart;
  final DateTime dtEnd;
  final List<String> categoriesId;
  final List<Transaction> transactions;
  final int transactionsLength;

  const CommonState(
    this.typeDate,
    this.dtStart,
    this.dtEnd,
    this.categoriesId,
    this.transactions,
    this.transactionsLength,
  );
}

class CommonInitial extends CommonState {
  CommonInitial({
    required TypeDate typeShowDate,
    required DateTime dtStart,
    required DateTime dtEnd,
    required List<Transaction> transactions,
    required List<String> categoriesId,
  }) : super(typeShowDate, dtStart, dtEnd, categoriesId, transactions,
            transactions.length);

  @override
  List<Object> get props => [
        typeDate,
        dtStart,
        dtEnd,
        transactions,
        transactionsLength,
        categoriesId,
      ];
}

class CommonInitialized extends CommonState {
  CommonInitialized({
    required TypeDate typeShowDate,
    required DateTime dtStart,
    required DateTime dtEnd,
    required List<Transaction> transactions,
    required List<String> categoriesId,
  }) : super(typeShowDate, dtStart, dtEnd, categoriesId, transactions,
            transactions.length);

  @override
  List<Object> get props => [
        typeDate,
        dtStart,
        dtEnd,
        transactions,
        transactionsLength,
        categoriesId
      ];
}

class CommonChangedTypeShowDate extends CommonState {
  CommonChangedTypeShowDate({
    required TypeDate typeShowDate,
    required DateTime dtStart,
    required DateTime dtEnd,
    required List<Transaction> transactions,
    required List<String> categoriesId,
  }) : super(typeShowDate, dtStart, dtEnd, categoriesId, transactions,
            transactions.length);

  @override
  List<Object> get props => [
        typeDate,
        dtStart,
        dtEnd,
        transactions,
        transactionsLength,
        categoriesId
      ];
}

class CommonChangedFilter extends CommonState {
  CommonChangedFilter({
    required TypeDate typeShowDate,
    required DateTime dtStart,
    required DateTime dtEnd,
    required List<Transaction> transactions,
    required List<String> categoriesId,
  }) : super(typeShowDate, dtStart, dtEnd, categoriesId, transactions,
      transactions.length);

  @override
  List<Object> get props => [
    typeDate,
    dtStart,
    dtEnd,
    transactions,
    transactionsLength,
    categoriesId
  ];
}

class CommonChangedData extends CommonState {
  CommonChangedData({
    required TypeDate typeShowDate,
    required DateTime dtStart,
    required DateTime dtEnd,
    required List<Transaction> transactions,
    required List<String> categoriesId,
  }) : super(typeShowDate, dtStart, dtEnd, categoriesId, transactions,
            transactions.length);

  @override
  List<Object> get props => [
        typeDate,
        dtStart,
        dtEnd,
        transactions,
        transactionsLength,
        categoriesId
      ];
}

class CommonEditedData extends CommonState {
  CommonEditedData({
    required TypeDate typeShowDate,
    required DateTime dtStart,
    required DateTime dtEnd,
    required List<Transaction> transactions,
    required List<String> categoriesId,
  }) : super(typeShowDate, dtStart, dtEnd, categoriesId, transactions,
            transactions.length);

  @override
  List<Object> get props => [
        typeDate,
        dtStart,
        dtEnd,
        transactions,
        transactionsLength,
        categoriesId
      ];
}

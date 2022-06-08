import 'package:money_control/data/models/custom_card.dart';
import 'package:money_control/domain/cubit/common_cubit.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/extensions/custom_date.dart';

class GetItem {
  static String getTypeDateName(TypeDate typeDate) {
    switch (typeDate) {
      case TypeDate.week:
        return 'Неделя';
      case TypeDate.previousWeek:
        return 'Пред. неделя';
      case TypeDate.month:
        return 'Месяц';
      case TypeDate.previousMonth:
        return 'Пред. месяц';
      case TypeDate.year:
        return 'Год';
      case TypeDate.all:
        return 'За всё время';
      default:
        return '';
    }
  }

  static TypeCard? getStatusFromString(String statusAsString) {
    for (TypeCard element in TypeCard.values) {
      if (element.toString() == statusAsString) {
        return element;
      }
    }
    return null;
  }

  static Map<String, dynamic> getDatesByTypeDate(
    TypeDate typeDate, {
    DataCubit? dataCubit,
    CommonCubit? commonCubit,
    bool isTransaction = true,
  }) {
    var dateTimeNow = DateTime.now().withoutTime();
    DateTime dateStart = dateTimeNow;
    DateTime dateEnd = dateTimeNow;

    switch (typeDate) {
      case TypeDate.week:
        var today = dateTimeNow.weekday;
        var endNum = 7 - today;

        dateEnd = dateTimeNow.add(Duration(days: endNum)).withoutTime();
        dateStart = dateEnd.subtract(Duration(days: 6)).withoutTime();
        break;
      case TypeDate.previousWeek:
        var today = dateTimeNow.weekday;
        var endNum = 7 - today;

        dateEnd = (dateTimeNow.add(Duration(days: endNum)))
            .subtract(Duration(days: 7))
            .withoutTime();
        dateStart = dateEnd.subtract(Duration(days: 6)).withoutTime();
        break;
      case TypeDate.month:
        var currentMonth = dateTimeNow.month;

        dateStart = DateTime(dateTimeNow.year, currentMonth, 1).withoutTime();
        dateEnd = DateTime(dateTimeNow.year, currentMonth + 1, 0).withoutTime();
        break;
      case TypeDate.previousMonth:
        var month = dateTimeNow.month;
        var year = dateTimeNow.year;

        if (month - 1 == 0) {
          month = 12;
          year -= 1;
        } else {
          month -= 1;
        }

        dateStart = DateTime(year, month, 1).withoutTime();
        dateEnd = DateTime(year, month + 1, 0).withoutTime();
        break;
      case TypeDate.year:
        var year = dateTimeNow.year;

        dateStart = DateTime(year, 1, 1).withoutTime();
        dateEnd = DateTime(year, 12, 31).withoutTime();
        break;
      case TypeDate.all:
        if (dataCubit != null) {
          if (isTransaction) {
            var allTransactions = dataCubit.getSortedTransactions();

            dateStart = allTransactions.first.date.withoutTime();
            dateEnd = allTransactions.last.date.withoutTime();
          } else {
            var allGoals = dataCubit.getSortedGoals();

            dateStart = allGoals.first.date.withoutTime();
            dateEnd = allGoals.last.date.withoutTime();
          }
        }

        break;
    }

    if (commonCubit != null) {
      commonCubit.changeData(
        dataCubit!,
        dateStart: dateStart,
        dateEnd: dateEnd,
      );
    }

    return {
      'dtStart': dateStart,
      'dtEnd': dateEnd,
    };
  }
}

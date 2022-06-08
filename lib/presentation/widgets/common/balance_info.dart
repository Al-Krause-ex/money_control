import 'package:flutter/material.dart';
import 'package:money_control/data/models/transaction.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/string_helper.dart';

class BalanceInfo extends StatelessWidget {
  final DataCubit dataCubit;
  final List<Transaction> visibleTransactions;
  final int balance;

  const BalanceInfo({
    Key? key,
    required this.dataCubit,
    required this.visibleTransactions,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var income = 0;
    var costs = 0;

    visibleTransactions.forEach((tx) {
      var cat = dataCubit.state.customUser.categories
          .firstWhere((c) => c.id == tx.categoryId);

      if (cat.action == 1)
        income += tx.sum;
      else
        costs += tx.sum;
    });

    return Container(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 5.0),
          //   child: Text(
          //     'Баланс',
          //     style: TextStyle(
          //       fontSize: 16.0,
          //       color: Colors.white70,
          //     ),
          //   ),
          // ),
          Text(
            '${StringHelper.getSeparatedDigits(balance)} ₽',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '+ $income ₽',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Color(0xff57DB8F),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            '- $costs ₽',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Color(0xffFF6D88),
            ),
          ),
        ],
      ),
    );
  }
}

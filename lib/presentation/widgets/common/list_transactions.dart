import 'package:flutter/material.dart';
import 'package:money_control/data/models/data_storage.dart';
import 'package:money_control/data/models/transaction.dart';
import 'package:money_control/domain/cubit/common_cubit.dart';
import 'package:money_control/domain/cubit/data_cubit.dart';
import 'package:money_control/helpers/show_helper.dart';
import 'package:money_control/presentation/widgets/new_transaction.dart';
import 'package:money_control/presentation/widgets/transaction_item.dart';

class ListTransactions extends StatefulWidget {
  final DataCubit dataCubit;
  final CommonCubit commonCubit;
  final List<Transaction> visibleTransactions;

  const ListTransactions({
    Key? key,
    required this.dataCubit,
    required this.commonCubit,
    required this.visibleTransactions,
  }) : super(key: key);

  @override
  State<ListTransactions> createState() => _ListTransactionsState();
}

class _ListTransactionsState extends State<ListTransactions> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: ctx,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {},
                    child: NewTransaction(
                      transaction: widget.visibleTransactions[index],
                      dataCubit: widget.dataCubit,
                      commonCubit: widget.commonCubit,
                    ),
                    behavior: HitTestBehavior.opaque,
                  );
                },
              );
            },
            child: Dismissible(
              key: Key(widget.visibleTransactions[index].id),
              onDismissed: (direction) {
                setState(() {
                  var deletedTransaction = widget.visibleTransactions[index];

                  widget.dataCubit.removeTransaction(deletedTransaction.id);
                  widget.visibleTransactions.removeAt(index);
                  widget.commonCubit.changeData(widget.dataCubit);

                  ShowHelper.showMessage(
                    context,
                    title: 'Транзакция удалена',
                    duration: Duration(seconds: 2),
                  );
                });
              },
              child: Column(
                children: [
                  TransactionItem(
                    widget.visibleTransactions[index].title,
                    widget.visibleTransactions[index].sum,
                    widget.visibleTransactions[index].date,
                    widget.dataCubit.state.customUser.categories.firstWhere(
                        (cat) =>
                            cat.id ==
                            widget.visibleTransactions[index].categoryId),
                    widget.visibleTransactions[index].positions,
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: widget.visibleTransactions.length,
      ),
    );
  }
}

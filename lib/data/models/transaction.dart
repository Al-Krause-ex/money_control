import 'package:money_control/data/models/position_item.dart';

class Transaction {
  String id;
  String title;
  String markId;
  int sum;
  DateTime date;
  String categoryId;
  List<PositionItem> positions = [];

  Transaction(
    this.positions, {
    required this.id,
    required this.title,
    required this.markId,
    required this.sum,
    required this.date,
    required this.categoryId,
  });

  Transaction.fromJson(
    List<PositionItem> positions,
    Map<String, dynamic> jsonTransaction,
  )   : id = jsonTransaction['id'],
        title = jsonTransaction['title'],
        markId = jsonTransaction['markId'],
        sum = jsonTransaction['sum'],
        categoryId = jsonTransaction['categoryId'],
        date = DateTime.parse(jsonTransaction['date']);

  Map<String, dynamic> toJson(List<Map<String, dynamic>> jsonPositions) => {
        'id': id,
        'title': title,
        'markId': markId,
        'sum': sum,
        'date': date.toString(),
        'categoryId': categoryId,
        'positions': jsonPositions,
      };
}

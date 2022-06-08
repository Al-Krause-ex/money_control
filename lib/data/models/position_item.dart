class PositionItem {
  final String id;
  final String title;
  final int price;
  final int amount;

  PositionItem({
    required this.id,
    required this.title,
    required this.price,
    required this.amount,
  });

  PositionItem.fromJson(Map<String, dynamic> jsonPositionItem)
      : id = jsonPositionItem['id'],
        title = jsonPositionItem['title'],
        price = jsonPositionItem['price'],
        amount = jsonPositionItem['amount'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'amount': amount,
      };
}

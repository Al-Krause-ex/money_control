class Goal {
  final String id;
  String name;
  int sum;
  DateTime date;
  bool isDone;

  Goal({
    required this.id,
    required this.name,
    required this.sum,
    required this.date,
    required this.isDone,
  });

  Goal copyWith({
    String? id,
    String? name,
    int? sum,
    DateTime? dt,
    bool? isDone,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      sum: sum ?? this.sum,
      date: dt ?? this.date,
      isDone: isDone ?? this.isDone,
    );
  }

  Goal.fromJson(Map<String, dynamic> jsonGoal)
      : id = jsonGoal['id'],
        name = jsonGoal['name'],
        sum = jsonGoal['sum'],
        date = DateTime.parse(jsonGoal['date']),
        isDone = jsonGoal['isDone'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sum': sum,
        'date': date.toString(),
        'isDone': isDone,
      };
}

class Shop {
  final String title;
  final DateTime dateTime;
  final String banco;
  final String pessoa;

  Shop({
    required this.title,
    required this.dateTime,
    required this.banco,
    required this.pessoa,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      title: json['title'],
      dateTime: DateTime.parse(json['datetime']),
      banco: json['banco'],
      pessoa: json['pessoa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'datetime': dateTime.toIso8601String(),
      'banco': banco,
      'pessoa': pessoa,
    };
  }
}

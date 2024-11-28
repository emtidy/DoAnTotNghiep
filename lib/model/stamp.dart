class Stamp {
  final String id;
  final DateTime date;
  final String productName;
  final double amount;
  final String customerName;
  final String designUrl;  // URL của hình tem cho ngày đó

  Stamp({
    required this.id,
    required this.date,
    required this.productName,
    required this.amount,
    required this.customerName,
    required this.designUrl,
  });

  factory Stamp.fromJson(Map<String, dynamic> json) {
    return Stamp(
      id: json['id'],
      date: DateTime.parse(json['date']),
      productName: json['productName'],
      amount: json['amount'].toDouble(),
      customerName: json['customerName'],
      designUrl: json['designUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'productName': productName,
      'amount': amount,
      'customerName': customerName,
      'designUrl': designUrl,
    };
  }
} 
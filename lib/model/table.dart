class TableModel {
  final String id;
  final String name;
  final String floor;
  bool isOccupied;
  int numberOfPeople;
  List<OrderItem> orders;
  double totalAmount;

  TableModel({
    required this.id,
    required this.name,
    required this.floor,
    this.isOccupied = false,
    this.numberOfPeople = 0,
    List<OrderItem>? orders,
    this.totalAmount = 0,
  }) : orders = orders ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'floor': floor,
      'isOccupied': isOccupied,
      'numberOfPeople': numberOfPeople,
      'orders': orders.map((order) => order.toMap()).toList(),
      'totalAmount': totalAmount,
    };
  }

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map['id'],
      name: map['name'],
      floor: map['floor'],
      isOccupied: map['isOccupied'] ?? false,
      numberOfPeople: map['numberOfPeople'] ?? 0,
      orders: (map['orders'] as List?)
          ?.map((item) => OrderItem.fromMap(item))
          .toList() ?? [],
      totalAmount: map['totalAmount'] ?? 0.0,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final List<String> options;
  final String note;
  final DateTime orderTime;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.options = const [],
    this.note = '',
    DateTime? orderTime,
  }) : orderTime = orderTime ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'options': options,
      'note': note,
      'orderTime': orderTime.toIso8601String(),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'],
      options: List<String>.from(map['options'] ?? []),
      note: map['note'] ?? '',
      orderTime: DateTime.parse(map['orderTime']),
    );
  }
} 
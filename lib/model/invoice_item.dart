// Cập nhật Invoice model
class Invoice {
  final String id;
  final String date;
  final String employee;
  final String table;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double vat;
  final double total;
  final bool isTableInvoice;

  Invoice({
    required this.id,
    required this.date,
    required this.employee,
    required this.table,
    required this.items,
    required this.subtotal,
    required this.vat,
    required this.total,
    this.isTableInvoice = false,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      employee: json['employee'] ?? '',
      table: json['table'] ?? '',
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      vat: (json['vat'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      isTableInvoice: json['isTableInvoice'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'employee': employee,
      'table': table,
      'items': items,
      'subtotal': subtotal,
      'vat': vat,
      'total': total,
      'isTableInvoice': isTableInvoice,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items,
      'date': date,
     };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      employee: map['employee'] ?? '',
      table: map['table'] ?? '',
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
      vat: (map['vat'] ?? 0.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      isTableInvoice: map['isTableInvoice'] ?? false,
    );
  }
}

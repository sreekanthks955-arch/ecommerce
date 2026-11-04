class OrderModel {
  const OrderModel({
    required this.id,
    required this.date,
    required this.total,
    required this.itemCount,
    required this.status,
    this.productIds = const [],
  });

  final String id;
  final String date;
  final double total;
  final int itemCount;
  final String status;
  final List<String> productIds;

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'total': total,
        'itemCount': itemCount,
        'status': status,
        'productIds': productIds,
      };

  factory OrderModel.fromMap(Map<dynamic, dynamic> map) => OrderModel(
        id: map['id'] as String,
        date: map['date'] as String,
        total: (map['total'] as num).toDouble(),
        itemCount: map['itemCount'] as int,
        status: map['status'] as String,
        productIds: (map['productIds'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
      );
}

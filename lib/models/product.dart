class ProductReview {
  final String id;
  final String author;
  final double rating;
  final String comment;
  final String date;

  const ProductReview({
    required this.id,
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'author': author,
        'rating': rating,
        'comment': comment,
        'date': date,
      };

  factory ProductReview.fromMap(Map<dynamic, dynamic> map) => ProductReview(
        id: map['id']?.toString() ?? '',
        author: map['author']?.toString() ?? 'Verified Buyer',
        rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
        comment: map['comment']?.toString() ?? '',
        date: map['date']?.toString() ?? 'Recently',
      );
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.imageUrl,
    required this.description,
    this.colors = const ['#1E293B', '#3B82F6', '#64748B'],
    this.sizes = const ['Standard', 'Pro'],
    this.reviews = const [],
    this.stockCount = 15,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final double oldPrice;
  final double rating;
  final String imageUrl;
  final String description;
  final List<String> colors;
  final List<String> sizes;
  final List<ProductReview> reviews;
  final int stockCount;
  final bool isFeatured;

  int get discountPercent =>
      oldPrice > price ? (((oldPrice - price) / oldPrice) * 100).round() : 0;

  double get savings => (oldPrice - price).clamp(0.0, double.infinity);

  bool get inStock => stockCount > 0;

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    double? oldPrice,
    double? rating,
    String? imageUrl,
    String? description,
    List<String>? colors,
    List<String>? sizes,
    List<ProductReview>? reviews,
    int? stockCount,
    bool? isFeatured,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      reviews: reviews ?? this.reviews,
      stockCount: stockCount ?? this.stockCount,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'oldPrice': oldPrice,
        'rating': rating,
        'imageUrl': imageUrl,
        'description': description,
        'colors': colors,
        'sizes': sizes,
        'reviews': reviews.map((r) => r.toMap()).toList(),
        'stockCount': stockCount,
        'isFeatured': isFeatured,
      };

  factory Product.fromMap(Map<dynamic, dynamic> map) => Product(
        id: map['id'] as String,
        name: map['name'] as String,
        category: map['category'] as String,
        price: (map['price'] as num).toDouble(),
        oldPrice: (map['oldPrice'] as num).toDouble(),
        rating: (map['rating'] as num).toDouble(),
        imageUrl: map['imageUrl'] as String,
        description: map['description'] as String,
        colors: (map['colors'] as List?)?.map((e) => e.toString()).toList() ??
            const ['#1E293B', '#3B82F6', '#64748B'],
        sizes: (map['sizes'] as List?)?.map((e) => e.toString()).toList() ??
            const ['Standard', 'Pro'],
        reviews: (map['reviews'] as List?)
                ?.map((e) => ProductReview.fromMap(
                    Map<dynamic, dynamic>.from(e as Map)))
                .toList() ??
            const [],
        stockCount: (map['stockCount'] as num?)?.toInt() ?? 15,
        isFeatured: (map['isFeatured'] as bool?) ?? false,
      );
}

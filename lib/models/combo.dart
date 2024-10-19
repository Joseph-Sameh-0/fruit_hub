class Combo {
  final int? id;
  final String name;
  final String image;
  final int price;
  final int count;

  Combo(
      {this.id,
      required this.name,
      required this.image,
      required this.price,
      this.count = 1});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'price': price,
        'count': count,
      };

  Combo copyWith({
    int? id,
    String? name,
    String? image,
    int? price,
    int? count,
  }) {
    return Combo(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      count: count ?? this.count,
    );
  }

  static Combo fromJson(Map<String, dynamic> json) => Combo(
        id: json['id'] as int?,
        name: json['name'],
        image: json['image'],
        price: json['price'],
        count: json['count'] ?? 1,
      );
}

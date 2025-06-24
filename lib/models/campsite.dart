class Campsite {
  final int id;
  final String name;
  final String address;
  final String description;
  final String imageUrl;
  final int price;

  Campsite({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory Campsite.fromJson(Map<String, dynamic> json) {
    return Campsite(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: json['price'] ?? 0,
    );
  }
}

class Campsite {
  final int id;
  final String name;
  final String address;
  final int price;
  final String description;
  final double latitude;
  final double longitude;

  Campsite({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory Campsite.fromJson(Map<String, dynamic> json) {
    return Campsite(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      price: (json['price'] as num).toInt(),
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

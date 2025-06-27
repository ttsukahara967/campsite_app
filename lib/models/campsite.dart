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
      id: json['id'],
      name: json['name'],
      address: json['address'],
      price: json['price'],
      description: json['description'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
}

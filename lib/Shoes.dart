class Shoes {
  final int id;
  final String name;
  final int price;
  final String imagelocation;
  final String description;
  final int stockQuantity;

  Shoes({
    required this.id,
    required this.name,
    required this.price,
    required this.imagelocation,
    required this.description,
    required this.stockQuantity,
  });

  // Converts the JSON response from API into a Shoes object
  // API sends: {"id":1,"name":"Charm Walk Beige","price":200,...}
  // This method maps each JSON field to the correct class property
  factory Shoes.fromJson(Map<String, dynamic> json) {
    return Shoes(
      id:            json['id'] as int,
      name:          json['name'] as String,
      price:         json['price'] as int,
      imagelocation: 'assets/images/${json['image'] as String}',
      description:   json['description'] as String,
      stockQuantity: json['stock_quantity'] as int,
    );
  }
}
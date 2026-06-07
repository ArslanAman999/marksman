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
      id:            int.parse(json['id'].toString()),
      name:          json['name'].toString(),
      price:         int.parse(json['price'].toString()),
      imagelocation: 'assets/images/${json['image']}',
      description:   json['description'].toString(),
      stockQuantity: int.parse(json['stock_quantity'].toString()),
    );
  }
}
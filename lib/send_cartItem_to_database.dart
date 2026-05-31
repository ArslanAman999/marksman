import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Shoes.dart';
import 'Shoes_data.dart';

// Sends the cart items to the MySQL database via our Node.js API
// Takes the list of Shoes objects from the cart
// Converts them into the format the API expects
// Returns true if successful, false if failed
Future<bool> sendOrderToDatabase(List<Shoes> cartItems) async {
  // Count how many of each shoe is in the cart
  // because cart stores duplicates as separate entries
  // e.g. [Shoe1, Shoe1, Shoe2] → {Shoe1: 2, Shoe2: 1}
  Map<int, Map<String, dynamic>> itemMap = {};

  for (Shoes shoe in cartItems) {
    if (itemMap.containsKey(shoe.id)) {
      // Shoe already in map — increment quantity
      itemMap[shoe.id]!['quantity'] += 1;
    } else {
      // First time seeing this shoe — add it to map
      itemMap[shoe.id] = {
        'shoe_id':    shoe.id,
        'name':       shoe.name,
        'quantity':   1,
        'unit_price': shoe.price,
      };
    }
  }

  // Convert map to list for the API request
  final List<Map<String, dynamic>> items = itemMap.values.toList();

  // Build the request body
  // user_id is hardcoded to 1 for now (no login system yet)
  final Map<String, dynamic> orderData = {
    'user_id': 1,
    'items':   items,
  };

  try {
    final response = await http.post(
      Uri.parse('$apiUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print('Order placed successfully. Order ID: ${result['order_id']}');
      print('Revenue: ${result['total_revenue']}');
      print('Profit: ${result['profit']}');
      return true;
    } else {
      print('Order failed: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Network error: $e');
    return false;
  }
}

/*import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add product data to Firestore
  Future<void> addProductToCart(String productId, int quantity) async {
    try {
      // Reference to the 'carts' collection
      CollectionReference cartCollection = _firestore.collection('carts');

      await cartCollection.add({
        'productId': productId,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(), // Optional
      });
      print("Product added to cart");
    } catch (error) {
      print("Failed to add product: $error");
    }
  }
}
*/
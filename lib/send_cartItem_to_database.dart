import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Shoes.dart';
import 'Shoes_data.dart';

// Returns order_id if successful, -1 if failed
Future<int> sendOrderToDatabase(List<Shoes> cartItems) async {
  Map<int, Map<String, dynamic>> itemMap = {};

  for (Shoes shoe in cartItems) {
    if (itemMap.containsKey(shoe.id)) {
      itemMap[shoe.id]!['quantity'] += 1;
    } else {
      itemMap[shoe.id] = {
        'shoe_id':    shoe.id,
        'name':       shoe.name,
        'quantity':   1,
        'unit_price': shoe.price,
      };
    }
  }

  final List<Map<String, dynamic>> items = itemMap.values.toList();

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
      print('Order placed. ID: ${result['order_id']}');
      return result['order_id']; // return order ID instead of bool
    } else {
      print('Order failed: ${response.body}');
      return -1;
    }
  } catch (e) {
    print('Network error: $e');
    return -1;
  }
}

// Cancels an order by ID
// Calls DELETE /orders/:id
// Returns true if successful
Future<bool> cancelOrder(int orderId) async {
  try {
    final response = await http.delete(
      Uri.parse('$apiUrl/orders/$orderId'),
    );

    if (response.statusCode == 200) {
      print('Order $orderId cancelled successfully');
      return true;
    } else {
      print('Cancel failed: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Network error: $e');
    return false;
  }
}
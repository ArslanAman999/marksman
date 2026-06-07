import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Shoes.dart';
import 'Shoes_data.dart';
import 'cart_model.dart';

// Returns order_id if successful, -1 if failed
Future<int> sendOrderToDatabase(List<CartItem> cartItems) async {
  // CartItem already has quantity grouped, convert directly to API format
  final List<Map<String, dynamic>> items = cartItems.map((cartItem) => {
    'shoe_id':    cartItem.shoe.id,
    'name':       cartItem.shoe.name,
    'quantity':   cartItem.quantity,
    'unit_price': cartItem.shoe.price,
  }).toList();

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
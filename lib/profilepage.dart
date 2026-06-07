import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Shoes_data.dart';
import 'send_cartItem_to_database.dart';



class profilepage extends StatefulWidget {
  const profilepage({super.key});

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {

  // Stores the fetched order history
  List<dynamic> _orderHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderHistory();
  }

  // Fetches order history for user_id = 1
  // Same hardcoded user as cart — will be dynamic when login is added
  Future<void> _fetchOrderHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/orders/user/1'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _orderHistory = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() { _isLoading = false; });
      }
    } catch (e) {
      print('Error fetching history: $e');
      setState(() { _isLoading = false; });
    }
  }

  // Cancels an order and refreshes the history list
  Future<void> _cancelOrder(int orderId) async {
    bool success = await cancelOrder(orderId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order #$orderId cancelled successfully'),
          backgroundColor: Colors.red,
        ),
      );
      // Refresh the history list
      _fetchOrderHistory();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel order')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9D2E0),
      appBar: AppBar(
        backgroundColor: Color(0xFFDBD2E0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ourlogo.png',
              height: 45,
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.account_circle),
              iconSize: 35,
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Profile Section ──
            Center(
              child: CircleAvatar(
                radius: 70,
                child: Icon(Icons.person, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            Text('Full Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(decoration: InputDecoration(hintText: 'Enter your full name')),
            SizedBox(height: 20),
            Text('Email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(decoration: InputDecoration(hintText: 'Enter your email')),
            SizedBox(height: 20),
            Text('Phone No',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(decoration: InputDecoration(hintText: 'Enter your phone number')),
            SizedBox(height: 20),
            Text('Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(decoration: InputDecoration(hintText: 'Enter your address')),
            SizedBox(height: 30),

            // ── Order History Section ──
            Text(
              'Order History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Show spinner while loading
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _orderHistory.isEmpty
                ? Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'No orders yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
                : Column(
              children: _orderHistory.map((order) {
                final isPending = order['status'] == 'pending';
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isPending
                          ? Colors.black12
                          : Colors.green,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order header
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order placed on ${order['created_at'].toString().substring(0, 10)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPending
                                  ? Colors.orange[100]
                                  : Colors.green[100],
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Text(
                              order['status'].toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isPending
                                    ? Colors.orange[800]
                                    : Colors.green[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Items
                      Text(
                        'Items: ${order['item_names']}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 4),

                      // Total
                      Text(
                        'Total: \$${order['total_spent']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),

                      // Date
                      // Text(
                      //   'Placed: ${order['created_at'].toString().substring(0, 16)}',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.grey,
                      //   ),
                      // ),

                      // Cancel button — only for pending orders
                      if (isPending)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _cancelOrder(int.parse(
                                    order['order_id'].toString()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'CANCEL ORDER',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
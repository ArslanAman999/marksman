import 'package:cloud_firestore/cloud_firestore.dart';

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

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/product.dart';

class ProductService extends ChangeNotifier {
  ProductService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'products';

  Stream<List<Product>> streamProducts({int? limit}) {
    Query<Map<String, dynamic>> query = _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true);
    if (limit != null) query = query.limit(limit);
    return query.snapshots().map((snap) => snap.docs.map(_fromDoc).toList());
  }

  Future<List<Product>> fetchOnce({int? limit}) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true);
    if (limit != null) query = query.limit(limit);
    final res = await query.get();
    return res.docs.map(_fromDoc).toList();
  }

  Future<String> addProduct(Product product) async {
    final data = product.toJson();
    data['createdAt'] = FieldValue.serverTimestamp();
    final doc = await _firestore.collection(_collection).add(data);
    return doc.id;
  }

  Future<void> updateProduct(String id, Map<String, dynamic> updates) async {
    updates['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection(_collection).doc(id).update(updates);
  }

  Future<void> deleteProduct(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  Future<String> uploadImage(
      {required String path, required Uint8List bytes}) async {
    // Image upload functionality - requires firebase_storage package
    // For now, return a placeholder URL
    // TODO: Implement Firebase Storage upload when needed
    throw UnimplementedError('Image upload requires firebase_storage package');
  }

  // Helper used by seeders/tests
  Future<void> seed(List<Product> products) async {
    final batch = _firestore.batch();
    for (final p in products) {
      final doc =
          _firestore.collection(_collection).doc(p.id.isEmpty ? null : p.id);
      final data = p.toJson();
      data['createdAt'] = FieldValue.serverTimestamp();
      batch.set(doc, data, SetOptions(merge: true));
    }
    await batch.commit();
  }

  Product _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    // Ensure id comes from document id when not present
    data['id'] = data['id'] ?? doc.id;
    // Fallbacks for optional fields expected by model
    data['additionalImages'] = data['additionalImages'] ?? [];
    data['specifications'] = data['specifications'] ?? {};
    data['tags'] = data['tags'] ?? [];
    data['isAvailable'] = data['isAvailable'] ?? true;
    data['stockQuantity'] = data['stockQuantity'] ?? 0;
    return Product.fromJson(data);
  }
}

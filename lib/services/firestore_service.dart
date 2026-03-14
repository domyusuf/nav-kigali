import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add listing
  Future<void> addListing(ListingModel listing) async {
    await _db.collection('listings').add(listing.toMap());
  }

  // Update listing
  Future<void> updateListing(ListingModel listing) async {
    await _db.collection('listings').doc(listing.id).update(listing.toMap());
  }

  // Delete listing
  Future<void> deleteListing(String id) async {
    await _db.collection('listings').doc(id).delete();
  }

  // Get all listings
  Stream<List<ListingModel>> getListings() {
    return _db.collection('listings')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ListingModel.fromFirestore(doc))
            .toList());
  }

  // Get user specific listings
  Stream<List<ListingModel>> getUserListings(String uid) {
    return _db.collection('listings')
        .where('createdBy', isEqualTo: uid)
        // Note: You might need a composite index for both where and orderBy, 
        // starting simple for now.
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ListingModel.fromFirestore(doc))
            .toList());
  }
}

import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class ListingProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<ListingModel> _allListings = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<ListingModel> get allListings => _allListings;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<ListingModel> get filteredListings {
    final query = _searchQuery.toLowerCase().trim();
    return _allListings.where((listing) {
      final matchesSearch = query.isEmpty || 
                            listing.name.toLowerCase().contains(query) ||
                            listing.description.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' || listing.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  ListingProvider() {
    _firestoreService.getListings().listen((listings) {
      _allListings = listings;
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<String?> addListing(ListingModel listing) async {
    try {
      await _firestoreService.addListing(listing);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateListing(ListingModel listing) async {
    try {
      await _firestoreService.updateListing(listing);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteListing(String id) async {
    try {
      await _firestoreService.deleteListing(id);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

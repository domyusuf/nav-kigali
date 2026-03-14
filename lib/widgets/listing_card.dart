import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../screens/directory/listing_detail_screen.dart';

class ListingCard extends StatelessWidget {
  final ListingModel listing;
  final Widget? trailing;

  const ListingCard({
    super.key, 
    required this.listing,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListingDetailScreen(listing: listing),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EFFF), // Very light Waymo Blue
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_getIconForCategory(listing.category), color: const Color(0xFF0061FF), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.name, 
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listing.category.toUpperCase(), 
                      style: const TextStyle(
                        color: Color(0xFF00D1FF), 
                        fontSize: 12, 
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            listing.address, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ] else ...[
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
              ]
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Hospital': return Icons.local_hospital_outlined;
      case 'Police Station': return Icons.security_outlined;
      case 'Library': return Icons.menu_book_outlined;
      case 'Restaurant': return Icons.restaurant_outlined;
      case 'Café': return Icons.coffee_outlined;
      case 'Park': return Icons.nature_people_outlined;
      case 'Tourist Attraction': return Icons.explore_outlined;
      default: return Icons.place_outlined;
    }
  }
}

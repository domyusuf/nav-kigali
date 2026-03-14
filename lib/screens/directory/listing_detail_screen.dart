import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/listing_model.dart';

class ListingDetailScreen extends StatelessWidget {
  final ListingModel listing;
  const ListingDetailScreen({super.key, required this.listing});

  Future<void> _launchNavigation() async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch \$url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(listing.name),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.grey.shade200),
              ),
              clipBehavior: Clip.antiAlias,
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(listing.latitude, listing.longitude),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(listing.id),
                    position: LatLng(listing.latitude, listing.longitude),
                  ),
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0061FF).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      listing.category.toUpperCase(), 
                      style: const TextStyle(
                        color: Color(0xFF0061FF), 
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    listing.name, 
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black, letterSpacing: -1.0),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'About this location', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    listing.description,
                    style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 32),
                  _buildDetailRow(Icons.location_on_rounded, listing.address),
                  const SizedBox(height: 20),
                  _buildDetailRow(Icons.phone_rounded, listing.contactNumber),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: _launchNavigation,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 64),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_rounded),
                        SizedBox(width: 12),
                        Text('GO TO LOCATION'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.grey.shade700, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value, 
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

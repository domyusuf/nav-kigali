import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/listing_provider.dart';
import '../directory/listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  // ignore: unused_field
  GoogleMapController? _controller;

  static const CameraPosition _kigaliCenter = CameraPosition(
    target: LatLng(-1.9441, 30.0619),
    zoom: 12.5,
  );

  @override
  Widget build(BuildContext context) {
    final listingProvider = Provider.of<ListingProvider>(context);
    final listings = listingProvider.allListings;

    Set<Marker> markers = listings.map((l) {
      return Marker(
        markerId: MarkerId(l.id),
        position: LatLng(l.latitude, l.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(_getHue(l.category)),
        infoWindow: InfoWindow(
          title: l.name,
          snippet: '${l.category} - Tap to view details',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: l)),
            );
          },
        ),
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kigaliCenter,
        markers: markers,
        onMapCreated: (controller) => _controller = controller,
        myLocationEnabled: false, // Set to true if geolocator permission is handled
        zoomControlsEnabled: true,
        mapToolbarEnabled: true,
      ),
    );
  }

  double _getHue(String category) {
    switch (category) {
      case 'Hospital': return BitmapDescriptor.hueRed;
      case 'Police Station': return BitmapDescriptor.hueAzure;
      case 'Library': return BitmapDescriptor.hueViolet;
      case 'Restaurant': return BitmapDescriptor.hueOrange;
      case 'Café': return BitmapDescriptor.hueYellow;
      case 'Park': return BitmapDescriptor.hueGreen;
      case 'Tourist Attraction': return BitmapDescriptor.hueRose;
      default: return BitmapDescriptor.hueBlue;
    }
  }
}

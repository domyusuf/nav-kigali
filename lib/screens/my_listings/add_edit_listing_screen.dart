import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/listing_provider.dart';

class AddEditListingScreen extends StatefulWidget {
  final ListingModel? listing;
  const AddEditListingScreen({super.key, this.listing});

  @override
  State<AddEditListingScreen> createState() => _AddEditListingScreenState();
}

class _AddEditListingScreenState extends State<AddEditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _category;
  late String _address;
  late String _contactNumber;
  late String _description;
  late double _latitude;
  late double _longitude;
  bool _isLoading = false;

  final List<String> categories = const [
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'Tourist Attraction',
  ];

  @override
  void initState() {
    super.initState();
    _name = widget.listing?.name ?? '';
    _category = widget.listing?.category ?? 'Hospital';
    _address = widget.listing?.address ?? '';
    _contactNumber = widget.listing?.contactNumber ?? '';
    _description = widget.listing?.description ?? '';
    _latitude = widget.listing?.latitude ?? -1.9441; // Default Kigali
    _longitude = widget.listing?.longitude ?? 30.0619;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final listingProvider = Provider.of<ListingProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listing == null ? 'Add Place' : 'Edit Place'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.business)),
                onSaved: (val) => _name = val!.trim(),
                validator: (val) => (val == null || val.isEmpty) ? 'Enter place name' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category)),
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on)),
                onSaved: (val) => _address = val!.trim(),
                validator: (val) => (val == null || val.isEmpty) ? 'Enter address' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _contactNumber,
                decoration: const InputDecoration(labelText: 'Contact Number', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                onSaved: (val) => _contactNumber = val!.trim(),
                validator: (val) => (val == null || val.isEmpty) ? 'Enter contact number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description)),
                maxLines: 4,
                onSaved: (val) => _description = val!.trim(),
                validator: (val) => (val == null || val.isEmpty) ? 'Enter description' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _latitude.toString(),
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _latitude = double.parse(val!),
                      validator: (val) => (val == null || double.tryParse(val) == null) ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _longitude.toString(),
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _longitude = double.parse(val!),
                      validator: (val) => (val == null || double.tryParse(val) == null) ? 'Invalid' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() => _isLoading = true);
                        
                        final listingToSave = ListingModel(
                          id: widget.listing?.id ?? '',
                          name: _name,
                          category: _category,
                          address: _address,
                          contactNumber: _contactNumber,
                          description: _description,
                          latitude: _latitude,
                          longitude: _longitude,
                          createdBy: widget.listing?.createdBy ?? authProvider.user!.uid,
                          timestamp: widget.listing?.timestamp ?? DateTime.now(),
                        );

                        String? error;
                        if (widget.listing == null) {
                          error = await listingProvider.addListing(listingToSave);
                        } else {
                          error = await listingProvider.updateListing(listingToSave);
                        }

                        if (!context.mounted) return;
                        setState(() => _isLoading = false);
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text(widget.listing == null ? 'Add Place' : 'Save Changes'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

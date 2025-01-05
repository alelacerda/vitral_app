import 'package:flutter/material.dart';
import '../components/location_card.dart';
import '../components/search_bar.dart';
import '../models/location.dart';
import '../uikit/ui_colors.dart';
import '../view_models/locations_view_model.dart';

class LocationsView extends StatefulWidget {

  final Function(BuildContext, Location) openLocationDetails;
  const LocationsView({super.key, required this.openLocationDetails});

  @override
  LocationsViewState createState() => LocationsViewState();
}

class LocationsViewState extends State<LocationsView> {
  final LocationsViewModel viewModel = LocationsViewModel();
  bool isLoading = true;
  String searchQuery = "";
  List<Location> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    viewModel.fetchLocations().then((_) {
      setState(() {
        isLoading = false;
        filteredLocations = viewModel.locations;
      });
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredLocations = viewModel.locations
          .where((location) =>
              location.name.toLowerCase().contains(query.toLowerCase()) ||
              location.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void openLocationDetails(Location location) {
    widget.openLocationDetails(context, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: UIColor.white,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomSearchBar(
                        hintText: 'Pesquise aqui',
                        onChanged: updateSearchQuery,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredLocations.length,
                        itemBuilder: (context, index) {
                          final location = filteredLocations[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: LocationCard(
                              name: location.name,
                              address: location.address,
                              phone: location.phone,
                              workingHours: location.workingHours,
                              onPressed: () => openLocationDetails(location),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

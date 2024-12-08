import 'package:flutter/material.dart';
import 'package:vitral_app/views/internal_map_view.dart';
import '../uikit/ui_colors.dart';
import '../models/location.dart';
import '../view_models/locations_view_model.dart';
import '../components/location_card.dart';
import '../components/search_bar.dart';
import '../components/rounded_button.dart';
import '../uikit/text_style.dart';
import '../uikit/custom_icons.dart';
import '../navigation_page.dart';
import 'ar_view.dart';

class LocationsView extends StatefulWidget {
  const LocationsView({super.key});

  @override
  _LocationsViewState createState() => _LocationsViewState();
}

class _LocationsViewState extends State<LocationsView> {
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

  void _onOpenInternalMap(Location location) {
    final navigatorKey = context.findAncestorStateOfType<NavigationPageState>()?.navigatorKeys[1];

    navigatorKey?.currentState?.push(
      MaterialPageRoute(
        builder: (context) => InternalMapView(imageUrl: location.internalMapUrl),
      ),
    );
    _updateParentBackButtonState();
  }

  void _updateParentBackButtonState() {
    final navPageState = context.findAncestorStateOfType<NavigationPageState>();
    if (navPageState != null) {
      navPageState.updateBackButtonState();
    }
  }

  void openLocationDetails(Location location) {
    final navPageState = context.findAncestorStateOfType<NavigationPageState>();
    navPageState?.showLocationDetailsBottomSheet(context, location);
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

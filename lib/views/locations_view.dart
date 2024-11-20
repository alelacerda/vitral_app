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
        builder: (context) => InternalMapView(),
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
    showBottomSheet(
      context: context, 
      showDragHandle: true,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 64,
      ),
      elevation: 2.0,
      backgroundColor: UIColor.lightLilac,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), 
        child: Container(
          padding: const EdgeInsets.all(0), 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: CustomTextStyle.title2.copyWith(
                      color: UIColor.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.address,
                    style: CustomTextStyle.body2.copyWith(
                      color: UIColor.black,
                    ),
                  ),
                ],  
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundedButton(
                    text: 'Iniciar',
                    iconName: CustomIcons.start,
                    onPressed: () {},
                    color: UIColor.purple,
                    textColor: UIColor.white,
                  ),
                  RoundedButton(
                    text: 'Ver mapa interno',
                    onPressed: () {
                      Navigator.of(context).pop();
                      _onOpenInternalMap(location);
                    },
                    color: UIColor.white,
                    textColor: UIColor.purple,
                    borderColor: UIColor.purple,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ]
          ),
        ),
      ),
    );
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

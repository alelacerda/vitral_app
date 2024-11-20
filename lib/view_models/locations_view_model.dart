import '../models/location.dart';
import '../api.dart';

class LocationsViewModel {
  List<Location> locations = [];

  Future<void> fetchLocations() async {
    locations = await Api.fetchLocations();
  }
}
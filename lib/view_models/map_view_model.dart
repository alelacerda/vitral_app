import '../models/map_model.dart';

class MapViewModel {
  final MapModel model = MapModel();

  String get title => model.title;
}

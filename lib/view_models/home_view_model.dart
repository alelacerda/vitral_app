import '../models/home_model.dart';

class HomeViewModel {
  final HomeModel model = HomeModel();

  String get title => model.title;
}

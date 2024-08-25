import '../models/camera_model.dart';

class CameraViewModel {
  final CameraModel model = CameraModel();

  String get title => model.title;
}

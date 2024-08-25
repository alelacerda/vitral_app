import '../models/articles_model.dart';

class ArticlesViewModel {
  final ArticlesModel model = ArticlesModel();

  String get title => model.title;
}

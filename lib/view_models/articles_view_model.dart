import '../models/article.dart';
import '../api.dart';

class ArticlesViewModel {
  String title = "Conheça sobre vitrais";
  List<Article> articles = [];

  Future<void> fetchArticles() async {
    articles = await Api.fetchArticles();
  }
}
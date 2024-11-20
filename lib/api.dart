import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/article.dart';

class  Api {

  static Future<List<Article>> fetchArticles() async {
    CollectionReference articles = FirebaseFirestore.instance.collection('articles');
    List<Article> articlesList = [];
    
    await articles.get()
      .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          articlesList.add(Article.fromMap(doc.data() as Map<String, dynamic>));
        });
      })
      .catchError((error) => print("Failed to fetch users: $error"));

    return articlesList;
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/article.dart';
import 'models/location.dart';

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
      .catchError((error) {
        print("Failed to fetch articles: $error");
        return null;
      });

    return articlesList;
  }

  static Future<List<Location>> fetchLocations() async {
    CollectionReference locations = FirebaseFirestore.instance.collection('locations');
    List<Location> locationsList = [];
    
    await locations.get()
      .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          locationsList.add(Location.fromMap(doc.data() as Map<String, dynamic>));
        });
      })
      .catchError((error) {
        print("Failed to fetch locations: $error");
        return null;
      });

    return locationsList;
  }

}
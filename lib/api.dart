import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitral_app/models/stained_glass.dart';
import 'package:vitral_app/models/stained_glass_info.dart';
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

  static Future<Article> fetchArticleWithId(String id) async {
    DocumentReference article = FirebaseFirestore.instance.collection('articles').doc(id);
    
    try {
      DocumentSnapshot snapshot = await article.get();
      if (snapshot.exists && snapshot.data() != null) {
        return Article.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        print("Document does not exist or contains no data.");
        return Article.empty(); // Return an empty article if the document doesn't exist or has no data.
      }
    } catch (error) {
      print("Failed to fetch article: $error");
      return Article.empty(); // Return an empty article if there's an error.
    }
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

  static Future<StainedGlass?> fetchStainedGlass(String id) async {
    DocumentReference stainedGlass = FirebaseFirestore.instance.collection('stained-glasses').doc(id);
    
    try {
      DocumentSnapshot snapshot = await stainedGlass.get();
      if (snapshot.exists && snapshot.data() != null) {
        return StainedGlass.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        print("Document does not exist or contains no data.");
        return null; // Return null if the document doesn't exist or has no data.
      }
    } catch (error) {
      print("Failed to fetch stained glass: $error");
      return null; // Return null if there's an error.
    }
  }

  static Future<List<StainedGlassInfo>> fetchStainedGlassesInfo(List<String> ids) async {
    if (ids.isEmpty) {
      print("Error: IDs list is empty");
      return [];
    }

    CollectionReference stainedGlasses = FirebaseFirestore.instance.collection('stained-glass-info');
    List<StainedGlassInfo> stainedGlassesList = [];

    try {
      final snapshot = await stainedGlasses.where(FieldPath.documentId, whereIn: ids).get();

      snapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;

        try {
          stainedGlassesList.add(StainedGlassInfo.fromMap(data));
        } catch (e) {
          print("Error parsing document: $e");
        }
      });
    } catch (error) {
      print("Failed to fetch stained glasses info: $error");
      return [];
    }

    return stainedGlassesList;
  }
}
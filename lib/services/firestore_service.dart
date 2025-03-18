import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_part.dart';
import '../models/tutorial.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<List<CarPart>> fetchCarParts() async {
    try {
      QuerySnapshot snapshot = await _db.collection('car_parts').get();
      return snapshot.docs.map((doc) => CarPart.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching car parts: $e');
      return [];
    }
  }

  Future<List<Tutorial>> fetchTutorials(String carPartId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('car_parts')
          .doc(carPartId)
          .collection('tutorials')
          .get();
      return snapshot.docs.map((doc) => Tutorial.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching tutorials: $e');
      return [];
    }
  }

  Future<List<Tutorial>> searchTutorialsLocal(String query) async {
    try {
      QuerySnapshot snapshot = await _db.collectionGroup('tutorials').get();
      List<Tutorial> allTutorials =
          snapshot.docs.map((doc) => Tutorial.fromDocument(doc)).toList();
      final lowerCaseQuery = query.toLowerCase();
      return allTutorials
          .where((tutorial) =>
              tutorial.title.toLowerCase().contains(lowerCaseQuery))
          .toList();
    } catch (e) {
      print('Error searching tutorials: $e');
      return [];
    }
  }
}

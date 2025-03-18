import 'package:cloud_firestore/cloud_firestore.dart';

class CarPart {
  final String id;
  final String name;
  final String imageUrl;

  CarPart({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  // Factory constructor to create a CarPart from a Firestore document.
  factory CarPart.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CarPart(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

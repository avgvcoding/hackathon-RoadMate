import 'package:cloud_firestore/cloud_firestore.dart';

class Tutorial {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String youtubeVideoUrl;
  final String description;

  Tutorial({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.youtubeVideoUrl,
    required this.description,
  });

  // Factory constructor to create a Tutorial from a Firestore document.
  factory Tutorial.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tutorial(
      id: doc.id,
      title: data['title'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      youtubeVideoUrl: data['youtubeVideoUrl'] ?? '',
      description: data['description'] ?? '',
    );
  }
}

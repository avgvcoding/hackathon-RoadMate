import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tutorial.dart';
import '../services/firestore_service.dart';
import 'tutorial_detail_screen.dart';

class TutorialsScreen extends StatefulWidget {
  final String carPartId;
  final String carPartName;

  const TutorialsScreen({
    Key? key,
    required this.carPartId,
    required this.carPartName,
  }) : super(key: key);

  @override
  _TutorialsScreenState createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Tutorial> _tutorials = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTutorials();
  }

  Future<void> _fetchTutorials() async {
    List<Tutorial> tutorials =
        await _firestoreService.fetchTutorials(widget.carPartId);
    setState(() {
      _tutorials = tutorials;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carPartName),
        backgroundColor: const Color.fromARGB(255, 130, 138, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              const Color.fromARGB(186, 211, 255, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? Container()
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _tutorials.length,
                itemBuilder: (context, index) {
                  Tutorial tutorial = _tutorials[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TutorialDetailScreen(tutorial: tutorial),
                            ),
                          );
                        },
                        child: Container(
                          height: 250, // Large card height
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                // Big thumbnail image with caching support (changed from Image.network to CachedNetworkImage)
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: tutorial.thumbnailUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                // Gradient overlay from bottom for text clarity
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ),
                                // Title and description text at the bottom
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tutorial.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          tutorial.description.length > 50
                                              ? tutorial.description
                                                      .substring(0, 50) +
                                                  '...'
                                              : tutorial.description,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

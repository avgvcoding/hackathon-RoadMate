import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/car_part.dart';
import '../services/firestore_service.dart';
import 'tutorials_screen.dart';

class FixItYourselfScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const FixItYourselfScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FixItYourselfScreenState createState() => _FixItYourselfScreenState();
}

class _FixItYourselfScreenState extends State<FixItYourselfScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<CarPart> _carParts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCarParts();
  }

  Future<void> _fetchCarParts() async {
    List<CarPart> parts = await _firestoreService.fetchCarParts();
    setState(() {
      _carParts = parts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fix It Yourself'),
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
            : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // two columns
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio:
                      3 / 4, // taller cards for a larger image display
                ),
                itemCount: _carParts.length,
                itemBuilder: (context, index) {
                  CarPart part = _carParts[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TutorialsScreen(
                              carPartId: part.id,
                              carPartName: part.name,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 4),
                              blurRadius: 6,
                            ),
                          ],
                          gradient: const LinearGradient(
                            colors: [Colors.white, Colors.white70],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              // Background image with caching support (changed from Image.network to CachedNetworkImage)
                              Positioned.fill(
                                child: CachedNetworkImage(
                                  imageUrl: part.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              // Gradient overlay for better contrast with the text
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        // ignore: deprecated_member_use
                                        Colors.black.withOpacity(0.6),
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                              // Title text at the bottom center
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    part.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'LillitaOne',
                                      color: Colors.white,
                                      fontSize: 20,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

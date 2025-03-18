import 'package:flutter/material.dart';
import 'police.dart';
import 'ambulance.dart';
import 'towing.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  // Define the three emergency options
  static const List<Map<String, String>> emergencyOptions = [
    {
      'title': 'Police',
      'description': 'Need Police help in case of robbery or road rage',
      'image': 'assets/images/police.jpg',
    },
    {
      'title': 'Ambulance',
      'description': 'Need Ambulance help in case of car accident or injury',
      'image': 'assets/images/ambulance.jpg',
    },
    {
      'title': 'Towing',
      'description': 'Need towing help in case car got stuck somewhere',
      'image': 'assets/images/towing.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: emergencyOptions.length,
          itemBuilder: (context, index) {
            final option = emergencyOptions[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    if (option['title'] == 'Police') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PoliceScreen(),
                        ),
                      );
                    } else if (option['title'] == 'Ambulance') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AmbulanceScreen(),
                        ),
                      );
                    } else if (option['title'] == 'Towing') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TowingServiceScreen(),
                        ),
                      );
                    } else {
                      // Handle other emergency options as needed.
                      print('${option['title']} tapped');
                    }
                  },
                  child: Container(
                    height: 250, // Same height as in the tutorials screen
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
                          // Image from assets as background
                          Positioned.fill(
                            child: Image.asset(
                              option['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Gradient overlay for text clarity
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option['title']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    option['description']!,
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

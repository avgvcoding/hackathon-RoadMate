import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'map/mechanics_map.dart';
import 'fix_it_yourself/fix_it_yourself_screen.dart';
import 'navigation_bar/nav_bar.dart';
import 'navigation_bar/my_profile.dart';
import 'emergency/emergency_screen.dart';
import 'mechanic/mechanic_screen.dart';
import 'ai_chatbot/chatbot.dart';
import 'services/firestore_service.dart';
import 'models/tutorial.dart';
import 'fix_it_yourself/tutorial_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  List<Tutorial> _searchResults = [];
  bool _isSearching = false;

  // New state variables to store mechanics fetched dynamically.
  List<dynamic> _mechanics = [];
  bool _isFetchingMechanics = true;
  final String _apiKey = 'AIzaSyA1qSgbW21nTPHh0WNCDCMn8hyshpflmYo';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
    _fetchMechanics(); // Fetch mechanics dynamically on init.
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _isSearching = true;
    });
    try {
      List<Tutorial> results =
          await _firestoreService.searchTutorialsLocal(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  Future<void> _fetchMechanics() async {
    try {
      // Get user's current location.
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }
      final position = await Geolocator.getCurrentPosition();
      final userLocation = {
        'latitude': position.latitude,
        'longitude': position.longitude
      };

      // Build the text search request for "car mechanic".
      final String url = 'https://places.googleapis.com/v1/places:searchText';
      final Map<String, dynamic> bodyData = {
        "textQuery": "car mechanic",
        "locationBias": {
          "circle": {"center": userLocation, "radius": 10000.0}
        },
        "pageSize": 6
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': 'places.displayName'
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final results = jsonResponse['places'] as List;
        setState(() {
          _mechanics = results;
          _isFetchingMechanics = false;
        });
      } else {
        throw Exception('Failed to load mechanics: ${response.body}');
      }
    } catch (e) {
      print('Error fetching mechanics: $e');
      setState(() {
        _mechanics = [];
        _isFetchingMechanics = false;
      });
    }
  }

  // Added function to open Google Maps with the given query.
  Future<void> _openInGoogleMaps(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$encodedQuery';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Widget _buildContent(Size size) {
    if (_searchController.text.isNotEmpty) {
      if (_isSearching) {
        return Center(child: CircularProgressIndicator());
      } else if (_searchResults.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("No tutorials found."),
        );
      } else {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final tutorial = _searchResults[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: tutorial.thumbnailUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(tutorial.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TutorialDetailScreen(tutorial: tutorial),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      }
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 205, 246, 255),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  iconPath: 'assets/icons/tools.png',
                  label: 'Fix it Yourself',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FixItYourselfScreen(),
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  iconPath: 'assets/icons/mechanic.png',
                  label: 'Find Mechanic',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MechanicScreen(),
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  iconPath: 'assets/icons/emergency_services.png',
                  label: 'Emergency',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmergencyScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nearby Repair Centres',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: size.width,
            height: size.height * 0.35,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: MechanicsMap(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Mechanics Near You',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _isFetchingMechanics
              ? Center(child: CircularProgressIndicator())
              : _mechanics.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("No mechanics found."),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _mechanics.map<Widget>((mechanic) {
                          String name =
                              mechanic['displayName']?['text'] ?? 'Unnamed';
                          return _buildMechanicAvatar(name: name);
                        }).toList(),
                      ),
                    ),
          const SizedBox(height: 40),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SideNavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/home_screen_background.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.42),
                        BlendMode.dstATop,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 42,
                  left: 23,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/icons/profile-user.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                ),
                Positioned(
                  top: 42,
                  right: 23,
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    child: Image.asset(
                      'assets/icons/nav_icon.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 75.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'RoadMate',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for Guides...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: _buildContent(size),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(),
            ),
          );
        },
        child: Icon(Icons.chat),
      ),
    );
  }

  Widget _buildActionButton({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  // Modified to include onTap that opens Google Maps for the mechanic's shop.
  Widget _buildMechanicAvatar({required String name}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: () {
          _openInGoogleMaps(name);
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueGrey,
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 6),
            Text(name),
          ],
        ),
      ),
    );
  }
}

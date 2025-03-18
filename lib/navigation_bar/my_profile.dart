import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../login/login_screen.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  // Fetch user data from Firestore for non‑anonymous users
  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  }

  void _showEditDialog(String field, String title, String currentValue) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({field: controller.text});
                  setState(() {
                    _userDataFuture = _getUserData();
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrangeAccent),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    // For guest users, show a dummy profile
    if (user.isAnonymous) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("My Profile"),
          backgroundColor: const Color.fromARGB(255, 113, 123, 255),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _authService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color.fromARGB(255, 217, 232, 255)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                // Header with dummy data
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 113, 123, 255),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 55,
                          backgroundImage:
                              AssetImage('assets/icons/profile-user-2.jpg'),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Guest User',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Car Model: Not Provided",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Personal Details Card with dummy details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.email,
                                color: Colors.deepOrangeAccent),
                            title: const Text("Email"),
                            subtitle: Text(user.email ?? "Not Provided"),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.phone,
                                color: Colors.deepOrangeAccent),
                            title: const Text("Phone"),
                            subtitle: Text(user.phoneNumber ?? "Not Provided"),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.directions_car,
                                color: Colors.deepOrangeAccent),
                            title: const Text("Car Model"),
                            subtitle: const Text("Not Provided"),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.location_on,
                                color: Colors.deepOrangeAccent),
                            title: const Text("Address"),
                            subtitle: const Text("Not Provided"),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.confirmation_number,
                                color: Colors.deepOrangeAccent),
                            title: const Text("Registration No."),
                            subtitle: const Text("Not Provided"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Statistics Card with dummy values
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem("Repairs", "0"),
                          _buildStatItem("Emergencies", "0"),
                          _buildStatItem("Ratings", "0"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }

    // For authenticated (non‑anonymous) users, show real data from Firestore
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color.fromARGB(255, 113, 123, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No user data available"));
          }
          final userData = snapshot.data!.data()!;
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color.fromARGB(255, 217, 232, 255)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Header Section with profile image and name
                  Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 113, 123, 255),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 55,
                            backgroundImage:
                                AssetImage('assets/icons/profile-user-2.jpg'),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            user.displayName ?? userData['name'] ?? "No Name",
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Car Model: ${userData['carModel'] ?? "Not Provided"}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Personal Details Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.email,
                                  color: Colors.deepOrangeAccent),
                              title: const Text("Email"),
                              subtitle: Text(user.email ??
                                  userData['email'] ??
                                  "No Email"),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.phone,
                                  color: Colors.deepOrangeAccent),
                              title: const Text("Phone"),
                              subtitle: Text(user.phoneNumber ??
                                  userData['phone'] ??
                                  "Not Provided"),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.directions_car,
                                  color: Colors.deepOrangeAccent),
                              title: const Text("Car Model"),
                              subtitle:
                                  Text(userData['carModel'] ?? "Not Provided"),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit, size: 16),
                                onPressed: () {
                                  _showEditDialog("carModel", "Car Model",
                                      userData['carModel'] ?? "");
                                },
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.location_on,
                                  color: Colors.deepOrangeAccent),
                              title: const Text("Address"),
                              subtitle:
                                  Text(userData['address'] ?? "Not Provided"),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit, size: 16),
                                onPressed: () {
                                  _showEditDialog("address", "Address",
                                      userData['address'] ?? "");
                                },
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.confirmation_number,
                                  color: Colors.deepOrangeAccent),
                              title: const Text("Registration No."),
                              subtitle: Text(
                                  userData['registrationNo'] ?? "Not Provided"),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit, size: 16),
                                onPressed: () {
                                  _showEditDialog(
                                      "registrationNo",
                                      "Registration No.",
                                      userData['registrationNo'] ?? "");
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Statistics Card (Optional additional info)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem("Repairs", "15"),
                            _buildStatItem("Emergencies", "3"),
                            _buildStatItem("Ratings", "4.8"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

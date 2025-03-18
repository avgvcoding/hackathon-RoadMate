import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'contact_us.dart';
import 'my_profile.dart';
import 'sos.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({Key? key}) : super(key: key);

  // Fetch the user's name from Firestore; fallback to displayName or default text.
  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists && doc.data() != null) {
          final userData = doc.data() as Map<String, dynamic>;
          return userData['name'] ?? user.displayName ?? "User";
        }
      } catch (e) {
        return user.displayName ?? "User";
      }
    }
    return "Anonymous User";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.67, // Adjusted width
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(235, 246, 255, 254),
            Color.fromARGB(213, 170, 255, 255)
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 80),
          ClipOval(
            child: Image.asset(
              'assets/icons/profile-user-2.jpg',
              fit: BoxFit.cover,
              width: 80,
              height: 80,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<String>(
            future: _getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                  'Loading...',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              } else if (snapshot.hasError) {
                return const Text(
                  'User',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              } else {
                return Text(
                  snapshot.data ?? 'User',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
          const SizedBox(height: 30),
          _navItem(Icons.person, 'Profile', context),
          _divider(),
          _navItem(Icons.sos, 'SOS', context),
          _divider(),
          _navItem(Icons.contact_mail, 'Contact Us', context),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String title, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          switch (title) {
            case 'Profile':
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
              break;
            case 'SOS':
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EmergencyPage()));
              break;
            case 'Contact Us':
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactUsPage()));
              break;
            default:
              Navigator.pop(context);
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home_screen.dart';

class EmergencyPage extends StatelessWidget {
  // The SOS phone number for car emergencies (using India's unified emergency number)
  final String sosNumber = '1033';

  // Additional roadside contacts for emergency vehicle assistance
  final List<String> additionalRoadsideContacts = [
    'Delhi: 25844444',
    'Pune: 020-2545-6789',
    'Ahmedabad: 079-2545-6789',
    'Lucknow: 0522-2545-6789',
    'Jaipur: 0141-2545-6789',
    'Chandigarh: 0172-2545-6789',
    'Bhopal: 0755-2545-6789',
    'Indore: 0731-2545-6789',
    'Coimbatore: 0422-2545-6789',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text('SOS - Car Safety India'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 122, 110, 255),
                Color.fromARGB(255, 161, 155, 255)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom:
                  10.0), // Increased padding to prevent content behind the button
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emergency Contacts Section
                SectionTitle(title: '1. Emergency Contacts'),
                ContactInfo(
                  label: 'Police:',
                  phoneNumber: '100',
                ),
                ContactInfo(
                  label: 'Ambulance:',
                  phoneNumber: '108',
                ),
                RegionalContacts(
                  title: 'Roadside Assistance & Highway Patrol:',
                  contacts: [
                    'NHAI Helpline: 1033',
                    'Delhi: 011-2300-1234',
                    'Mumbai: 022-2300-1234',
                    'Chennai: 044-2300-1234',
                    'Kolkata: 033-2300-1234',
                    'Bangalore: 080-2300-1234',
                    'Hyderabad: 040-2300-1234',
                    ...additionalRoadsideContacts,
                  ],
                ),
                SizedBox(height: 20),

                // First Aid & Emergency Guidance Section
                SectionTitle(title: '2. First Aid & Emergency Guidance'),
                FirstAidInfo(
                  title: 'Car Accident Response:',
                  content:
                      '• If safe to do so, move your vehicle to the side of the road.\n• Check yourself and passengers for injuries.\n• Call emergency services immediately.',
                ),
                FirstAidInfo(
                  title: 'Injury Care:',
                  content:
                      '• For minor injuries: clean the wound and apply pressure.\n• For severe injuries: avoid moving the victim and seek medical help.\n• Keep calm and provide reassurance until help arrives.',
                ),
                FirstAidInfo(
                  title: 'Vehicle Breakdown Assistance:',
                  content:
                      '• If experiencing a breakdown, safely pull over and turn on hazard lights.\n• Stay inside your vehicle if on a busy road until help arrives.\n• Contact roadside assistance immediately.',
                ),
                SizedBox(height: 20),

                // Safety Tips Section
                SectionTitle(title: '3. Safety Tips for Common Hazards'),
                SafetyTip(
                  title: 'Skidding on Wet Roads:',
                  content:
                      '• Reduce speed and avoid sudden braking.\n• Steer gently to regain control.\n• Maintain a safe distance from other vehicles.',
                ),
                SafetyTip(
                  title: 'Handling Tire Puncture:',
                  content:
                      '• Safely pull over and activate your hazard lights.\n• Use a spare tire if available or call for assistance.\n• Do not drive on a damaged tire.',
                ),
                SafetyTip(
                  title: 'Engine Failure & Overheating:',
                  content:
                      '• Turn off the engine immediately and move to a safe area.\n• Allow the engine to cool before checking under the hood.\n• Seek professional help if needed.',
                ),
                SafetyTip(
                  title: 'Accident Safety:',
                  content:
                      '• Remain calm and assess the situation.\n• Avoid moving injured persons unless absolutely necessary.\n• Call emergency services and wait for assistance.',
                ),
                SizedBox(height: 20),

                // Recognizing Dangerous Driving Conditions Section
                SectionTitle(title: '4. Dangerous Driving Conditions'),
                SafetyTip(
                  title: 'Poor Visibility:',
                  content:
                      '• Fog, heavy rain, or smoke can impair vision.\n• Reduce speed and use appropriate lighting.\n• Maintain extra distance from the vehicle ahead.',
                ),
                SafetyTip(
                  title: 'Road Obstructions:',
                  content:
                      '• Stay alert for unexpected obstacles or debris on the road.\n• Slow down and avoid sudden maneuvers.\n• Use hazard signals to warn other drivers.',
                ),
                SizedBox(height: 20),

                // General Driving Safety Advice Section
                SectionTitle(title: '5. General Driving Safety Advice'),
                SafetyTip(
                  title: 'General Tips:',
                  content:
                      '• Always wear your seatbelt and ensure all passengers do too.\n• Follow traffic rules and speed limits.\n• Regularly maintain your vehicle for optimal performance.',
                ),
                SafetyTip(
                  title: 'Emergency Preparedness:',
                  content:
                      '• Keep a first aid kit and basic tools in your vehicle.\n• Save emergency numbers on your phone.\n• Ensure your mobile phone is fully charged before long trips.',
                ),
                SafetyTip(
                  title: 'Stay Calm:',
                  content:
                      '• In emergencies, remain calm and follow safety protocols.\n• Avoid panicking to make clear decisions.\n• Wait for professional help if necessary.',
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      // SOS Button as a Bottom Fixed Full-Width Button
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A3093), Color.fromARGB(255, 148, 130, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 60, // Fixed height for the button
          child: ElevatedButton.icon(
            onPressed: () => _launchCaller(context, sosNumber),
            icon: Icon(
              Icons.call,
              size: 28,
              color: Colors.white,
            ),
            label: Text(
              'One-Click SOS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  Colors.transparent, // Make the button background transparent
              shadowColor: Colors.transparent, // Remove shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // More rounded corners
              ),
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
            ).copyWith(
              // Apply gradient to the button
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) => Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method to launch the phone dialer with the specified number
  void _launchCaller(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      bool launched = await launchUrl(launchUri);
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not launch the dialer.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print('Could not launch $phoneNumber');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred while trying to make the call.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

// Widget for Section Titles
class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(Icons.warning, color: Color(0xFF3A1C71)),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B2A86),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for Contact Information
class ContactInfo extends StatelessWidget {
  final String label;
  final String phoneNumber;

  ContactInfo({required this.label, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE0F7FA),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(Icons.phone, color: Color(0xFF00695C)),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          phoneNumber,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        onTap: () {
          // Optionally, allow tapping to call
          _launchCaller(context, phoneNumber);
        },
      ),
    );
  }

  // Helper method to launch the caller
  void _launchCaller(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      bool launched = await launchUrl(launchUri);
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not launch the dialer.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print('Could not launch $phoneNumber');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred while trying to make the call.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

// Widget for Regional Contacts
class RegionalContacts extends StatelessWidget {
  final String title;
  final List<String> contacts;

  RegionalContacts({required this.title, required this.contacts});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE3F2FD),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        leading: Icon(Icons.map, color: Color(0xFF3A1C71)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5B2A86),
          ),
        ),
        children: contacts
            .map(
              (contact) => ListTile(
                leading: Icon(Icons.phone, color: Color(0xFF283593)),
                title: Text(
                  contact,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  // Optionally, allow tapping to call
                  _launchCaller(context, contact.split(': ').last);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  // Helper method to launch the caller
  void _launchCaller(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      bool launched = await launchUrl(launchUri);
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not launch the dialer.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print('Could not launch $phoneNumber');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred while trying to make the call.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

// Widget for First Aid Information
class FirstAidInfo extends StatelessWidget {
  final String title;
  final String content;

  FirstAidInfo({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE8EAF6),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        leading: Icon(Icons.health_and_safety, color: Color(0xFF1E88E5)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3949AB),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for Safety Tips
class SafetyTip extends StatelessWidget {
  final String title;
  final String content;

  SafetyTip({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE8EAF6),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        leading: Icon(Icons.security, color: Color(0xFF1E88E5)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3949AB),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

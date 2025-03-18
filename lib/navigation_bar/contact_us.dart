import 'package:flutter/material.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String _subject = '';
  // ignore: unused_field
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Color.fromARGB(255, 113, 123, 255),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, const Color.fromARGB(186, 211, 255, 255)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Icon and Title
              Icon(
                Icons.car_repair,
                size: 100,
                color: Color.fromARGB(255, 113, 123, 255),
              ),
              SizedBox(height: 10),
              Text(
                'We are here to help you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 30),
              // Contact Details Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person,
                            color: Color.fromARGB(255, 113, 123, 255),
                            size: 30),
                        title: Text(
                          'Aviral Gupta',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.email,
                            color: Color.fromARGB(255, 113, 123, 255),
                            size: 30),
                        title: Text(
                          'aviral.ceo.123@gmail.com',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.phone,
                            color: Color.fromARGB(255, 113, 123, 255),
                            size: 30),
                        title: Text(
                          '+91 8299585776',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Feedback Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Send us your Feedback or Query',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.subject,
                            color: Color.fromARGB(255, 113, 123, 255)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _subject = value ?? '';
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '\n\nMessage',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.message,
                            color: Color.fromARGB(255, 113, 123, 255)),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _message = value ?? '';
                      },
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 113, 123, 255),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(Icons.send, size: 24, color: Colors.white),
                      label: Text(
                        'Submit',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          // Here you can add the logic to send feedback
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Feedback Received'),
                              content: Text(
                                  'Thank you for reaching out to us. We will get back to you soon!'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

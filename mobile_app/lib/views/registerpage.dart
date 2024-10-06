import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_app/views/homepage.dart';
import 'package:image_picker/image_picker.dart'; // Import for picking image
import 'dart:io';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _surnameController = TextEditingController();
  final _otherNamesController = TextEditingController();
  final _dobController = TextEditingController();
  final _uniqueCodeController = TextEditingController();
  File? idPhoto; // Optional file for ID photo

  bool _isLoading = false;

  final AuthService _authService = AuthService();

  // Function to handle registration process
  void handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Call the registerUser function from ApiService
        final response = await _authService.registerUser(
          surname: _surnameController.text,
          otherNames: _otherNamesController.text,
          dob: _dobController.text,
          uniqueCode: _uniqueCodeController.text,
          idPhoto: idPhoto, // Optional ID photo
        );

        if (response.statusCode == 201) {
          final data = jsonDecode(response.body);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Registration Successful"),
              content: Text("Welcome, ${_surnameController.text}!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
          print('Registration successful: ${data['message']}');
        } else {
          print('Failed to register: ${response.body}');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Failed'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to pick image from gallery (Optional)
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        idPhoto = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _otherNamesController.dispose();
    _dobController.dispose();
    _uniqueCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/background.jpg",
                ),
                fit: BoxFit.cover)),
        child: ListView(children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                iconSize: 25,
                color: Colors.white,
              ),
              const SizedBox(
                width: 100,
              ),
              const Center(
                child: Text("Staff Registration",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )),
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 143, 187, 209),
                          spreadRadius: 1)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _surnameController,
                            decoration: const InputDecoration(
                                labelText: "Surname",
                                labelStyle:
                                    TextStyle(color: Colors.blueAccent)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your surname";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _otherNamesController,
                            decoration: const InputDecoration(
                                labelText: "Other Names",
                                labelStyle:
                                    TextStyle(color: Colors.blueAccent)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your other names";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _dobController,
                            decoration: const InputDecoration(
                              labelText: "Date of Birth",
                              labelStyle: TextStyle(color: Colors.blueAccent),
                              hintText: "YYYY-MM-DD",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your date of birth";
                              }
                              // You can also add a regex check here for proper date format
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _uniqueCodeController,
                            decoration: const InputDecoration(
                                labelText: "Unique Code",
                                labelStyle:
                                    TextStyle(color: Colors.blueAccent)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your unique code";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: pickImage,
                            child: Text(
                                idPhoto == null
                                    ? 'Pick ID Photo'
                                    : 'Change ID Photo',
                                style:
                                    const TextStyle(color: Colors.blueAccent)),
                          ),
                          const SizedBox(height: 32),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: handleRegister,
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

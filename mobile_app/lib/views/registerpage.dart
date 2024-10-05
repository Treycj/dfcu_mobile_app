import 'package:flutter/material.dart';
import 'package:mobile_app/views/homepage.dart';

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
  final _employeeNumberController = TextEditingController();
  final _uniqueCodeController = TextEditingController();
  bool _isLoading = false;

  // Function to simulate registration process
  void _register() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a registration process by waiting for a few seconds
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Handle registration logic here (e.g., sending data to an API)
        // For now, just showing a success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Registration Successful"),
            content: Text("Welcome, ${_surnameController.text}!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _otherNamesController.dispose();
    _dobController.dispose();
    _employeeNumberController.dispose();
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                  iconSize: 25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 100,
              ),
              const Text("Register Staff",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )),
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
                              labelStyle: TextStyle(color: Colors.blueAccent)),
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
                              labelStyle: TextStyle(color: Colors.blueAccent)),
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
                          controller: _employeeNumberController,
                          decoration: const InputDecoration(
                              labelText: "Employee Number",
                              labelStyle: TextStyle(color: Colors.blueAccent)),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your employee number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _uniqueCodeController,
                          decoration: const InputDecoration(
                              labelText: "Unique Code",
                              labelStyle: TextStyle(color: Colors.blueAccent)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your unique code";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _register,
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
        ]),
      ),
    );
  }
}

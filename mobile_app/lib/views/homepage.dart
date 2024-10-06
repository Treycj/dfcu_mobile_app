import 'package:flutter/material.dart';
import 'package:mobile_app/views/registerpage.dart';
import 'package:mobile_app/views/staff_listpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

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
          const SizedBox(height: 200),
          Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 143, 187, 209),
                          spreadRadius: 1)
                    ]),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 123, 182, 211),
                          fontSize: 20,
                        ),
                        "HR Management System"),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()));
                            },
                            child: Container(
                              height: 80,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 143, 187, 209),
                                        spreadRadius: 1)
                                  ]),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 13,
                                      ),
                                      "Register Staff"),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const StaffListPage()));
                            },
                            child: Container(
                              height: 80,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 143, 187, 209),
                                        spreadRadius: 1)
                                  ]),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.people_alt,
                                      size: 25, color: Colors.blue),
                                  Text(
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 13,
                                      ),
                                      "View Staff"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}

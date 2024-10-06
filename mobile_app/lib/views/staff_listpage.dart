import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/services/staff_service.dart';
import 'package:mobile_app/views/homepage.dart';
import 'package:mobile_app/views/staff_detailspage.dart';

class StaffListPage extends StatefulWidget {
  const StaffListPage({super.key});

  @override
  _StaffListPageState createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  final StaffService _staffService = StaffService();
  List<dynamic>? _staffList;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchStaffList(); // Fetch initial staff list
  }

  void debounce(void Function() action,
      {Duration duration = const Duration(milliseconds: 300)}) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, action);
  }

  Future<void> _fetchStaffList({String? employeeNumber}) async {
    try {
      final staffData =
          await _staffService.fetchStaffList(employeeNumber: employeeNumber);

      if (staffData is Map) {
        // Handle a single staff member
        if (mounted) {
          setState(() {
            _staffList = [staffData]; // Wrap the single staff object in a list
          });
        }
      } else if (staffData is List) {
        // Handle the list of staff
        if (mounted) {
          setState(() {
            _staffList = staffData;
          });
        }
      }
    } catch (e) {
      // Handle error
      print('Error fetching staff list: $e');
      if (mounted) {
        setState(() {
          _staffList = []; // Reset staff list on error
        });
      }
    }
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      debounce(() {
        _fetchStaffList(employeeNumber: query);
      });
    } else {
      setState(() {
        _staffList = []; // Clear the staff list if the input is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 20,
        ),
        // backgroundColor: const Color.fromARGB(255, 163, 195, 222),
        backgroundColor: Colors.transparent,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearch,
              decoration: const InputDecoration(
                hintText: 'Search by employee number',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 143, 187, 209), spreadRadius: 1)
              ]),
          child: _staffList == null
              ? const Center(child: CircularProgressIndicator())
              : _staffList!.isEmpty
                  ? const Center(child: Text('No staff members found.'))
                  : ListView.builder(
                      itemCount: _staffList!.length,
                      itemBuilder: (context, index) {
                        final staff = _staffList![index];
                        return Card(
                          child: ListTile(
                            leading: staff['idPhoto'] == ''
                                ? const Icon(Icons
                                    .person) // Use person icon if idPhoto is empty
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(staff['idPhoto']),
                                  ),
                            title: Text(staff['surname']),
                            subtitle: Text(staff['otherNames']),
                            onTap: () {
                              // Navigate to details page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StaffDetailPage(staff: staff),
                                ),
                              );
                            },
                            trailing: Text(staff['employeeNumber']),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}

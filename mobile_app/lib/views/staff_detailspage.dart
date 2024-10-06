import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mobile_app/services/staff_service.dart';

class StaffDetailPage extends StatefulWidget {
  final Map<String, dynamic> staff;

  const StaffDetailPage({super.key, required this.staff});

  @override
  _StaffDetailPageState createState() => _StaffDetailPageState();
}

class _StaffDetailPageState extends State<StaffDetailPage> {
  final TextEditingController _dobController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dobController.text = widget.staff['dob'];
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateStaff() async {
    setState(() {
      _isLoading = true;
    });

    // Convert image to Base64 if available
    String? base64Image;
    if (_selectedImage != null) {
      base64Image = base64Encode(_selectedImage!.readAsBytesSync());
    }

    try {
      // Call the update API
      await StaffService.updateStaff(
        widget.staff['employeeNumber'],
        _dobController.text,
        base64Image,
      );

      // Handle successful update (e.g., show success message)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Staff details updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 20,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Employee Details',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            // fontWeight: FontWeight.bold,
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
                color: Color.fromARGB(255, 143, 187, 209),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : (widget.staff['idPhoto'] != ''
                          ? Image.network(widget.staff['idPhoto'])
                          : SizedBox(
                              width: 100,
                              height: 100,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey[300],
                                ),
                              ),
                            )),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Surname:', style: TextStyle(fontSize: 20)),
                    Text('${widget.staff['surname']}',
                        style: const TextStyle(fontSize: 20))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Other Names:', style: TextStyle(fontSize: 20)),
                    Text('${widget.staff['otherNames']}',
                        style: const TextStyle(fontSize: 20))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Employee Number:',
                        style: TextStyle(fontSize: 20)),
                    Text('${widget.staff['employeeNumber']}',
                        style: const TextStyle(fontSize: 20))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _dobController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text(
                    'Change ID Photo',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateStaff,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Update Staff',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

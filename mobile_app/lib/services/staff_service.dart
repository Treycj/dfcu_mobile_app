import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_app/services/shared_preferences.dart';

class StaffService {
  // Define the base URL of the API

  final String _baseUrl = 'http://localhost:3000/api';

  Future<dynamic> fetchStaffList({String? employeeNumber}) async {
    String? token = await StorageManager.getToken();

    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    try {
      final uri = employeeNumber != null && employeeNumber.isNotEmpty
          ? Uri.parse('$_baseUrl/retrieve?employeeNumber=$employeeNumber')
          : Uri.parse('$_baseUrl/retrieve');

      final response = await http.get(uri, headers: {
        'Authorization':
            'Bearer $token', // Use the token retrieved from SharedPreferences
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if employeeNumber was provided
        if (employeeNumber != null && employeeNumber.isNotEmpty) {
          return data['staff']; // Return the staff object directly
        }

        // If no employeeNumber is provided, return the list of all staff
        if (data['staff'] is List) {
          return data['staff'] as List<dynamic>;
        } else {
          throw Exception('Staff data is not a list.');
        }
      } else if (response.statusCode == 404) {
        throw Exception('No staff members found.');
      } else {
        throw Exception('Failed to load staff data');
      }
    } catch (error) {
      throw Exception('Error fetching staff data: $error');
    }
  }

// Function to update staff details (DOB and ID photo)
  static Future<Map<String, dynamic>> updateStaff(
      String employeeNumber, String dob, String? idPhoto) async {
    String _baseUrl = 'http://localhost:3000/api';

    String? token = await StorageManager.getToken();

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include token if needed
        },
        body: jsonEncode({
          'employeeNumber': employeeNumber,
          'dob': dob,
          'idPhoto': idPhoto, // Send idPhoto if it's not null
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update staff');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

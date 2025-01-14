import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cache_manager.dart';

class DaemonService {
  final String baseUrl = "https://api.opendental.com"; // Replace with actual URL
  final String apiKey = "NFF6i0KrXrxDkZHt"; // Replace with actual API key
  final CacheManager cacheManager = CacheManager();

  // 🔐 Authenticate with Open Dental API
  Future<String> authenticate() async {
    try {
      final url = '$baseUrl/authenticate';
      print('Sending POST request to: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'apiKey': apiKey}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; // Return the token
      } else {
        throw Exception('Authentication failed: ${response.body}');
      }
    } catch (e) {
      print('Error in authenticate(): $e');
      throw Exception('Failed to authenticate');
    }
  }

  // 🧾 Fetch Patient Demographics
  Future<List<Map<String, dynamic>>> fetchPatients([String? patientId]) async {
    try {
      final cachedData = cacheManager.getCache("patients");
      if (cachedData != null) {
        return cachedData;
      }

      final url = '$baseUrl/patients';
      final response = await http.get(Uri.parse(url), headers: _getAuthHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        cacheManager.setCache("patients", data);
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch patients: ${response.body}');
      }
    } catch (e) {
      print('Error in fetchPatients(): $e');
      throw Exception('Failed to fetch patients');
    }
  }

  // 📅 Fetch Appointments
  Future<List<Map<String, dynamic>>> fetchAppointments(String patientId) async {
    try {
      final cachedData = cacheManager.getCache("appointments_$patientId");
      if (cachedData != null) {
        return cachedData;
      }

      final url = '$baseUrl/appointments/$patientId';
      final response = await http.get(Uri.parse(url), headers: _getAuthHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        cacheManager.setCache("appointments_$patientId", data);
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch appointments: ${response.body}');
      }
    } catch (e) {
      print('Error in fetchAppointments(): $e');
      throw Exception('Failed to fetch appointments');
    }
  }

  // 📋 Fetch Treatment Plans
  Future<List<Map<String, dynamic>>> fetchTreatmentPlans(String patientId) async {
    try {
      final cachedData = cacheManager.getCache("treatment_plans_$patientId");
      if (cachedData != null) {
        return cachedData;
      }

      final url = '$baseUrl/treatment-plans/$patientId';
      final response = await http.get(Uri.parse(url), headers: _getAuthHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        cacheManager.setCache("treatment_plans_$patientId", data);
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch treatment plans: ${response.body}');
      }
    } catch (e) {
      print('Error in fetchTreatmentPlans(): $e');
      throw Exception('Failed to fetch treatment plans');
    }
  }

  // 🖼 Upload Patient Imaging Data
  Future<void> uploadImage(String patientId, dynamic imageFile) async {
    try {
      final url = '$baseUrl/images/$patientId';
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(_getAuthHeaders())
        ..files.add(await http.MultipartFile.fromPath('file', imageFile));

      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in uploadImage(): $e');
      throw Exception('Failed to upload image');
    }
  }

  // 💰 Fetch Billing Information
  Future<List<Map<String, dynamic>>> fetchBillingInfo(String patientId) async {
    try {
      final cachedData = cacheManager.getCache("billing_$patientId");
      if (cachedData != null) {
        return cachedData;
      }

      final url = '$baseUrl/billing/$patientId';
      final response = await http.get(Uri.parse(url), headers: _getAuthHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        cacheManager.setCache("billing_$patientId", data);
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch billing info: ${response.body}');
      }
    } catch (e) {
      print('Error in fetchBillingInfo(): $e');
      throw Exception('Failed to fetch billing info');
    }
  }

  // 🔐 Helper to Get Auth Headers
  Map<String, String> _getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
  }
}

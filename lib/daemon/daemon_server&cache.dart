import 'dart:convert';
import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// Cache storage with a TTL of 5 minutes
final Map<String, dynamic> _cache = {};
const Duration cacheTTL = Duration(minutes: 5);

// Function to check if the cache is still valid
bool _isCacheValid(String key) {
  if (!_cache.containsKey(key)) return false;
  final cacheEntry = _cache[key];
  final DateTime expiry = cacheEntry['expiry'];
  return DateTime.now().isBefore(expiry);
}

// Function to get data from cache or fetch it from API

Future<Response> _getPatientsHandler(Request req) async {
  const cacheKey = 'patients';

  // Return cached data if it's still valid
  if (_isCacheValid(cacheKey)) {
    print('Returning cached patients data.');
    return Response.ok(jsonEncode(_cache[cacheKey]['data']),
        headers: {'Content-Type': 'application/json'});
  }

  // Fetch data from Open Dental API
  final response = await http.get(
    Uri.parse('https://api.opendental.com/api/v1/patients'),
    headers: {'Authorization': 'ODFHIR NFF6i0KrXrxDkZHt/VzkmZEaUWOjnQX2z'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Store response in cache with expiry time
    _cache[cacheKey] = {
      'data': data,
      'expiry': DateTime.now().add(cacheTTL),
    };

    print('Fetched new patients data from API.');
    return Response.ok(response.body, headers: {'Content-Type': 'application/json'});
  } else {
    return Response(response.statusCode, body: 'Failed to fetch patients from Open Dental API.');
  }
}

void main() async {
  final app = Router();

  // API Endpoints
  app.get('/api/patients', _getPatientsHandler);

  // Enable CORS
  final handler = const Pipeline()
      .addMiddleware(corsHeaders()) // Add CORS middleware
      .addHandler(app);

  // Start the server
  var server = await shelf_io.serve(
    handler,
    '0.0.0.0',
    8080,
  );

  print('Daemon is running at http://${server.address.host}:${server.port}');
}

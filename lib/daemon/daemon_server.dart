import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<Response> _getPatientsHandler(Request req) async {
  final response = await http.get(
    Uri.parse('https://api.opendental.com/api/v1/patients'),
    headers: {'Authorization': 'ODFHIR NFF6i0KrXrxDkZHt/VzkmZEaUWOjnQX2z'},
  );

  if (response.statusCode == 200) {
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

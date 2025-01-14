import 'package:flutter/material.dart';
import 'daemon_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DaemonService _daemonService = DaemonService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Daemon Example')),
        body: Center(
          child: FutureBuilder(
            future: _daemonService.authenticate(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Authenticated with token: ${snapshot.data}');
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

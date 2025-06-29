import 'package:flutter/material.dart';
import 'api_client.dart';
import 'screens/login_screen.dart';

void main() {
  final apiClient = ApiClient();
  runApp(MyApp(apiClient: apiClient));
}

class MyApp extends StatelessWidget {
  final ApiClientBase apiClient;

  const MyApp({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campsite App',
      home: LoginScreen(apiClient: apiClient),
    );
  }
}

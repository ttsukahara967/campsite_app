import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// APIから取得するキャンプ場データのモデル
class Campsite {
  final int id;
  final String name;
  final String address;

  Campsite({required this.id, required this.name, required this.address});

  factory Campsite.fromJson(Map<String, dynamic> json) {
    return Campsite(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CampsiteListPage(),
    );
  }
}

class CampsiteListPage extends StatefulWidget {
  const CampsiteListPage({super.key});

  @override
  State<CampsiteListPage> createState() => _CampsiteListPageState();
}

class _CampsiteListPageState extends State<CampsiteListPage> {
  late Future<List<Campsite>> campsites;

  @override
  void initState() {
    super.initState();
    campsites = fetchCampsites();
  }

  Future<List<Campsite>> fetchCampsites() async {
    final response = await http.get(Uri.parse('http://localhost:8080/campsites'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Campsite.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load campsites');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campsite List')),
      body: FutureBuilder<List<Campsite>>(
        future: campsites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No campsites found.'));
          }
          final campsites = snapshot.data!;
          return ListView.builder(
            itemCount: campsites.length,
            itemBuilder: (context, index) {
              final c = campsites[index];
              return ListTile(
                title: Text(c.name),
                subtitle: Text(c.address),
              );
            },
          );
        },
      ),
    );
  }
}


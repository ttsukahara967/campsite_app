import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import '../api_client.dart';
import '../models/campsite.dart';

class CampsiteDetailPage extends StatefulWidget {
  final int id;
  const CampsiteDetailPage({super.key, required this.id});

  @override
  State<CampsiteDetailPage> createState() => _CampsiteDetailPageState();
}

class _CampsiteDetailPageState extends State<CampsiteDetailPage> {
  late Future<Campsite> campsite;

  @override
  void initState() {
    super.initState();
    campsite = fetchCampsiteDetail();
  }

  Future<Campsite> fetchCampsiteDetail() async {
    final response = await ApiClient.get('/campsites/${widget.id}');
    if (response.statusCode == 200) {
      return Campsite.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load campsite');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('キャンプ場詳細'),
        backgroundColor: Colors.green[400],
      ),
      body: FutureBuilder<Campsite>(
        future: campsite,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('エラー: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('データなし'));
          }
          final c = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'img/campsite/sample.png',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(c.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(c.address, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 8),
                Text('￥${c.price}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.green)),
                const SizedBox(height: 16),
                // 🌍 OSM MAP
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(c.latitude, c.longitude),
                      zoom: 14,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(c.latitude, c.longitude),
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.location_on, size: 40, color: Colors.red),
                          ),                        
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(c.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('一覧に戻る'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(160, 48),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

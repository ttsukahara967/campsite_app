import 'package:flutter/material.dart';
import 'dart:convert';
import '../api_client.dart';
import '../models/campsite.dart';
import 'campsite_detail.dart';

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
    refresh();
  }

  void refresh() {
    setState(() {
      campsites = fetchCampsites();
    });
  }

  Future<List<Campsite>> fetchCampsites() async {
    final response = await ApiClient.get('/campsites');
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
      appBar: AppBar(
        title: const Text('キャンプ場一覧'),
        backgroundColor: Colors.green[400],
      ),
      body: FutureBuilder<List<Campsite>>(
        future: campsites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('エラー: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('キャンプ場がありません。'));
          }
          final campsites = snapshot.data!;
          return ListView.builder(
            itemCount: campsites.length,
            itemBuilder: (context, index) {
              final c = campsites[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: c.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            c.imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 56),
                          ),
                        )
                      : const Icon(Icons.terrain, size: 48, color: Colors.green),
                  title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.address),
                      Text('￥${c.price}', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    // 詳細画面へ遷移＆戻ったらrefresh
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CampsiteDetailPage(id: c.id)),
                    );
                    refresh();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

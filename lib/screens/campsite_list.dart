import 'package:flutter/material.dart';
import 'dart:convert';

import '../api_client.dart';
import '../models/campsite.dart';
import 'campsite_detail.dart';

class CampsiteListPage extends StatefulWidget {
  final ApiClientBase apiClient;

  const CampsiteListPage({super.key, required this.apiClient});

  @override
  State<CampsiteListPage> createState() => _CampsiteListPageState();
}

class _CampsiteListPageState extends State<CampsiteListPage> {
  late final Future<List<Campsite>> campsites;

  @override
  void initState() {
    super.initState();
    campsites = fetchCampsites();
  }

  Future<List<Campsite>> fetchCampsites() async {
    print('[FETCH] called');
    await Future.delayed(const Duration(milliseconds: 50)); // 必須！
    final response = await widget.apiClient.get('/campsites');
    print('[FETCH] status: ${response.statusCode}');
    print('[FETCH] body: ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('[FETCH] decoded: $data');
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
        future: campsites.timeout(const Duration(seconds: 5)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('FutureBuilder Error: ${snapshot.error}');
            return Center(child: Text('エラー: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('キャンプ場がありません。'));
          }
          final campsites = snapshot.data!;
          return ListView.builder(
            itemCount: campsites.length,
            itemBuilder: (context, index) {
              final c = campsites[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'img/campsite/sample.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
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
                  print('[TAP] go to detail ${c.id}');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CampsiteDetailPage(
                        apiClient: widget.apiClient,
                        id: c.id,
                      ),
                    ),
                  );
                  print('[TAP] back from detail');
                  setState(() {
                    // 詳細画面から戻った後にリロードしたいならここ
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}

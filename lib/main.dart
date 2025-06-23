import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ▼ APIから取得するキャンプ場データのモデルクラス
class Campsite {
  final int id;
  final String name;
  final String address;

  // コンストラクタ
  Campsite({required this.id, required this.name, required this.address});

  // JSONデータをCampsite型に変換するファクトリ
  factory Campsite.fromJson(Map<String, dynamic> json) {
    return Campsite(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }
}

void main() {
  // ▼ アプリのエントリーポイント。MyAppを起動
  runApp(const MyApp());
}

// ▼ アプリ全体のWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // ▼ MaterialApp：マテリアルデザインのアプリ全体設定
    return const MaterialApp(
      home: CampsiteListPage(), // 最初に表示するページ
    );
  }
}

// ▼ キャンプ場リスト画面用のStatefulWidget（状態管理する画面）
class CampsiteListPage extends StatefulWidget {
  const CampsiteListPage({super.key});

  @override
  State<CampsiteListPage> createState() => _CampsiteListPageState();
}

// ▼ 実際の状態・UIを持つクラス
class _CampsiteListPageState extends State<CampsiteListPage> {
  late Future<List<Campsite>> campsites; // 非同期で取得したキャンプ場リスト

  @override
  void initState() {
    super.initState();
    // ▼ 初回ビルド時にAPIからキャンプ場データを取得
    campsites = fetchCampsites();
  }

  // ▼ APIを叩いてキャンプ場リストを取得する非同期関数
  Future<List<Campsite>> fetchCampsites() async {
    final response = await http.get(Uri.parse('http://localhost:8080/campsites'));
    if (response.statusCode == 200) {
      // 成功したらJSONデータをデコードしてリストに変換
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Campsite.fromJson(json)).toList();
    } else {
      // エラー時は例外
      throw Exception('Failed to load campsites');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ▼ 画面全体のレイアウト
    return Scaffold(
      appBar: AppBar(title: const Text('Campsite List')), // 上部のタイトルバー
      // ▼ 非同期データ取得後にリスト表示
      body: FutureBuilder<List<Campsite>>(
        future: campsites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // データ取得中はぐるぐる（ローディング表示）
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // エラー発生時
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // データが空だった場合
            return const Center(child: Text('No campsites found.'));
          }
          // ▼ 正常時はリスト表示
          final campsites = snapshot.data!;
          return ListView.builder(
            itemCount: campsites.length,
            itemBuilder: (context, index) {
              final c = campsites[index];
              // ▼ 1件ごとにListTileで表示（タップも可能な見た目）
              return ListTile(
                title: Text(c.name),      // キャンプ場名
                subtitle: Text(c.address), // キャンプ場住所
              );
            },
          );
        },
      ),
    );
  }
}

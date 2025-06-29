import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:campsite_app/api_client.dart';

class ApiClientMock implements ApiClientBase {
  final Database db;

  ApiClientMock(this.db);

  @override
  Future<void> login() async {}

  @override
  Future<http.Response> get(String path) async {
    print('[MOCK] get called: $path');

    await Future.delayed(const Duration(milliseconds: 50)); // 安定化

    if (path == '/campsites') {
      final rows = await db.query('campsite');
      await Future.delayed(const Duration(milliseconds: 50));
      print('[MOCK] rows: $rows (${rows.runtimeType})');

      final fixedRows = rows.map((row) => row.map((k, v) => MapEntry(k.toString(), v))).toList();
      print('[MOCK] fixedRows: $fixedRows');

      return http.Response(jsonEncode(fixedRows), 200);
    }

    return http.Response('Not Implemented', 501);
  }
}

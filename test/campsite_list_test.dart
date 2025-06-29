import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:campsite_app/screens/campsite_list.dart';
import '../test/api_client_mock.dart';

void main() {
  sqfliteFfiInit();

  late Database db;
  late ApiClientMock apiClientMock;

  setUp(() async {
    final databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    await db.execute('''
      CREATE TABLE campsite (
        id INTEGER PRIMARY KEY,
        name TEXT,
        address TEXT,
        price INTEGER,
        description TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');

    await db.insert('campsite', {
      'id': 1,
      'name': 'Test Camp',
      'address': 'Test Address',
      'price': 1000,
      'description': 'A test campsite',
      'latitude': 35.0,
      'longitude': 139.0,
    });

    final checkRows = await db.query('campsite');
    print('[SETUP] checkRows: $checkRows');

    apiClientMock = ApiClientMock(db);
  });

  testWidgets('Campsite list shows data from SQLite mock', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: CampsiteListPage(apiClient: apiClientMock),
      ));
      // ✅ `pump` は runAsync の中
      await tester.pump();
      await Future.delayed(const Duration(milliseconds: 200));
    });

    // ✅ これだけ外で `pumpAndSettle`
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Test Camp'), findsOneWidget);
  });
}

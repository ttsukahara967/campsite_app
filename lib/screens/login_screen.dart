import 'package:flutter/material.dart';
import 'dart:convert';
import '../api_client.dart';
import 'campsite_list.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _handleLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ApiClient.login();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CampsiteListPage()),
      );
    } catch (e) {
      setState(() {
        _error = 'ログインに失敗しました';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Campsite App', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                const Text('ユーザー名：admin\nパスワード：password', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _handleLogin,
                        icon: const Icon(Icons.login),
                        label: const Text('ログイン'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(160, 48),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

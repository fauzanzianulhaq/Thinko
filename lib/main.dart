import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- BAGIAN INI DIPERBARUI ---
  // Kita pasang "jaring pengaman" (Try-Catch)
  try {
    await Firebase.initializeApp();
    print("✅ FIREBASE SUKSES TERHUBUNG!"); // Cek tulisan ini di Debug Console nanti
  } catch (e) {
    print("❌ FIREBASE GAGAL: $e"); // Kalau error, alasannya akan muncul di sini
  }
  // -----------------------------

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thinko App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}
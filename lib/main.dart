import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Tambah ini (Buat ngecek user)
import 'pages/welcome_page.dart';
import 'pages/home_page.dart'; // 2. Tambah ini (Buat arahin ke Home)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print("✅ FIREBASE SUKSES TERHUBUNG!"); 
  } catch (e) {
    print("❌ FIREBASE GAGAL: $e"); 
  }

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
      // --- BAGIAN INI SANGAT PENTING (SATPAM PINTU MASUK) ---
      // Logic: Apakah User ada datanya (currentUser != null)?
      // Jika YA (?) -> Masuk HomePage
      // Jika TIDAK (:) -> Masuk WelcomePage
      home: FirebaseAuth.instance.currentUser != null 
          ? const HomePage() 
          : const WelcomePage(),
      // -----------------------------------------------------
    );
  }
}
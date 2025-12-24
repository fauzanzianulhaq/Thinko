import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Container untuk background gradient hijau muda
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD0F8CE), // Hijau muda (atas)
              Colors.white,      // Putih (bawah)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60), // Jarak dari atas

              // 1. Gambar Logo
              // Pastikan file gambar sudah ada di assets/images/
              Image.asset(
                'assets/images/logo_thinko.png',
                height: 200, // Sesuaikan ukuran gambar
              ),

              const SizedBox(height: 40),

              // 2. Teks Judul
              const Text(
                'Petualangan Menuju\nJago Matematika\nbersama Thinko',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2, // Jarak antar baris teks
                ),
              ),

              const Spacer(), // Mendorong tombol ke bawah

              // 3. Tombol "Buat akun"
              SizedBox(
                width: double.infinity, // Lebar tombol memenuhi layar
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1CC600), // Warna hijau tombol
                    foregroundColor: Colors.white, // Warna teks tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0, // Menghilangkan bayangan agar flat
                  ),
                  child: const Text(
                    'Buat akun',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 4. Teks Link "Aku sudah punya akun"
              TextButton(
      onPressed: () {
    // Navigasi pindah ke halaman Login
      Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => const LoginPage()),
      );
        },
  child: const Text(
    'Aku sudah punya akun',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 30), // Jarak aman dari bawah layar
            ],
          ),
        ),
      ),
    );
  }
}
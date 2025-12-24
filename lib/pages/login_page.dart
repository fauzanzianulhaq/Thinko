import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk menyimpan text yang diketik (nanti berguna untuk backend)
  final TextEditingController _usernameController = TextEditingController();
  
  // Kita siapkan 4 controller untuk PIN (opsional, untuk tahap UI ini kita fokus tampilan dulu)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD0F8CE), // Hijau muda
              Colors.white,
            ],
          ),
        ),
        // SingleChildScrollView agar aman saat keyboard muncul
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri untuk label form
              children: [
                const SizedBox(height: 60),
                
                // 1. Gambar & Judul (Rata Tengah)
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_thinko2.png', // Pakai gambar yang sama dulu
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Hai, Senang bisa\nketemu lagi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 2. Input Username
                const Text(
                  'username',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200], // Warna abu-abu muda
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none, // Hilangkan garis border
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Input PIN (4 Kotak)
                const Text(
                  'PIN',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Jarak antar kotak
                  children: List.generate(4, (index) {
                    return Container(
                      width: 70, // Lebar kotak
                      height: 70, // Tinggi kotak
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center, // Angka di tengah
                        keyboardType: TextInputType.number,
                        obscureText: true, // Sembunyikan angka jadi bintang/titik
                        maxLength: 1, // Hanya 1 digit per kotak
                        decoration: const InputDecoration(
                          counterText: "", // Hilangkan hitungan karakter di bawah
                          border: InputBorder.none, // Hilangkan garis bawah default
                        ),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 50),

                // 4. Tombol Masuk
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Tombol Masuk ditekan");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1CC600),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
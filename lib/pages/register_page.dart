import 'package:flutter/material.dart';
import 'avatar_selection_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();

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
              Color(0xFFD0F8CE), // Hijau muda background
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Progress Bar di bagian paling atas (INI YANG TADI HILANG)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Row(
                  children: [
                    // Garis 1 (Aktif/Sedang diisi)
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1CC600), // Hijau Aktif
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Jarak antar garis
                    // Garis 2 (Belum)
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Garis 3 (Belum)
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Konten Utama (Scrollable biar aman di HP kecil)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // 2. Gambar Robot (INI JUGA TADI HILANG)
                      Image.asset(
                        'assets/images/logo_thinko2.png',
                        height: 120,
                      ),
                      
                      const SizedBox(height: 20),

                      // 3. Teks Sapaan
                      const Text(
                        'Haiii! Aku Thinko\nSebelum mulai, aku mau kenal kamu dulu~',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      
                      const SizedBox(height: 10),

                      // 4. Judul Besar
                      const Text(
                        'Siapa nama panggilanmu?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 5. Input Field Username
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Username',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF0F0F0), // Abu-abu sangat muda
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. Tombol Lanjut (Ditaruh di bawah)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validasi sederhana (pastikan nama tidak kosong)
                      if (_nameController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvatarSelectionPage(
                              username: _nameController.text.trim(), // Kirim Data Username
                            ),
                          ),
                        );
                      } else {
                        // Tampilkan pesan error jika nama kosong
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Isi nama panggilanmu dulu ya!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1CC600), // Hijau tombol
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Lanjut',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
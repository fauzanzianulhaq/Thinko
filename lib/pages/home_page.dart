import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita pakai Stack karena ada elemen yang menumpuk (Peta di bawah, Profil di atas)
      body: Stack(
        children: [
          // --- LAPISAN 1: PETA SCROLLABLE ---
          SingleChildScrollView(
            // physics: ClampingScrollPhysics() agar scrollnya tidak memantul berlebihan
            child: Stack(
              children: [
                // 1. Gambar Background Peta Panjang
                Image.asset(
                  'assets/images/map_background.png', // Pastikan nama file sesuai
                  width: double.infinity,
                  fit: BoxFit.fitWidth, // Agar lebar gambar menyesuaikan lebar HP
                ),

                // 2. Tombol-tombol Level (CONTOH)
                // Nanti kamu harus atur posisi top & left ini manual sesuai gambar petanya
                
                // Contoh Level 1 (Paling bawah)
                Positioned(
                  bottom: 100, // Jarak dari bawah gambar
                  left: 180,   // Jarak dari kiri
                  child: _buildLevelButton(1, true), // Level 1 (Aktif)
                ),

                // Contoh Level 2 (Agak ke atas)
                Positioned(
                  bottom: 250,
                  left: 100,
                  child: _buildLevelButton(2, false), // Level 2 (Terkunci)
                ),
                
                // Contoh Level 3
                 Positioned(
                  bottom: 380,
                  left: 250,
                  child: _buildLevelButton(3, false), 
                ),
                
                // TIPS: Kamu harus tambah Positioned lainnya sampai level 30
                // dengan mengira-ngira koordinat bottom & left-nya.
              ],
            ),
          ),

          // --- LAPISAN 2: HEADER PROFIL (HUD) ---
          // Ini posisinya tetap (fixed) di atas layar walau peta di-scroll
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Agar kotak tidak lebar full
                  children: [
                    // Avatar Kecil
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/avatar_1.png'), // Avatar user
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    // Nama & Level
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Lumi", // Nama user
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Level 1",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membuat tombol bulat level
  Widget _buildLevelButton(int level, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (isActive) {
          print("Masuk ke Level $level");
          // Navigasi ke halaman soal kuis nanti disini
        } else {
          print("Level $level masih terkunci");
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? const Color(0xFF1CC600) : Colors.grey, // Hijau jika aktif, Abu jika kunci
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Center(
          child: isActive 
            ? Text(
                "$level",
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              )
            : const Icon(Icons.lock, color: Colors.white70, size: 20), // Ikon gembok jika terkunci
        ),
      ),
    );
  }
}
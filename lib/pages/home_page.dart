import 'package:flutter/material.dart';
import 'region_1/level_1_page.dart';
import 'region_1/level_2_page.dart';
import 'region_1/level_3_page.dart';
import 'region_1/level_4_page.dart';
import 'region_1/level_5_page.dart';
import 'region_2/level_6_page.dart';
import 'region_2/level_7_page.dart';
import 'region_2/level_8_page.dart';
import 'region_2/level_9_page.dart';
import 'region_2/level_10_page.dart';
import 'region_2/level_11_page.dart';
import 'region_2/level_12_page.dart';
import 'region_2/level_13_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- DATA LEVEL USER ---
  // Ganti angka ini untuk mengetes posisi (misal ganti jadi 2, tombol akan pindah)
  int currentLevel = 1; 

  // --- DAFTAR KOORDINAT (PENTING!) ---
  // Kamu harus sesuaikan angka dx (kiri-kanan) dan dy (atas-bawah) 
  // agar pas dengan gambar petamu.
  final List<Offset> levelLocations = [
    const Offset(130, 160), // Posisi Level 1 (dx, dy)
    const Offset(200, 230), // Posisi Level 2
    const Offset(90, 310),  // Posisi Level 3
    const Offset(210, 500), // Posisi Level 4
    const Offset(110, 620), // Posisi Level 5
    const Offset(160, 750), // Posisi Level 6
  ];

  @override
  Widget build(BuildContext context) {
    // Ambil koordinat sesuai level user saat ini
    // Kita pakai (currentLevel - 1) karena List dimulai dari index 0
    // Pastikan tidak error jika level melebihi jumlah lokasi yang ada
    int safeIndex = (currentLevel - 1).clamp(0, levelLocations.length - 1);
    Offset currentPos = levelLocations[safeIndex];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // FITUR TEST: Klik tombol merah kecil untuk menaikkan level
          setState(() {
            if (currentLevel < levelLocations.length) {
              currentLevel++;
            } else {
              currentLevel = 1; // Reset ke 1
            }
          });
        },
      ),
      body: Stack(
        children: [
          // --- LAPISAN 1: PETA SCROLLABLE ---
          SingleChildScrollView(
            child: SizedBox(
              // Pastikan container punya tinggi yang cukup agar peta bisa di-scroll
              height: 1500, // Sesuaikan dengan panjang gambar petamu
              child: Stack(
                children: [
                  // 1. Gambar Background Peta
                  Image.asset(
                    'assets/images/map_background.png', 
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),

                  // 2. Button Player (Dinamis)
                  // Button ini akan berpindah sesuai variabel currentPos
                  Positioned(
                    left: currentPos.dx,
                    top: currentPos.dy,
                    child: _buildActiveLevelButton(currentLevel),
                  ),
                  
                  // Opsional: Menampilkan Level yang sudah lewat sebagai titik kecil/ceklis
                  // (Bisa ditambahkan nanti)
                ],
              ),
            ),
          ),

          // --- LAPISAN 2: HEADER PROFIL (HUD) ---
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/mc.png'),
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Lumi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text("Level $currentLevel", style: TextStyle(fontSize: 12, color: Colors.green)),
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

  // Widget Tombol Aktif (Besar & Animasi)
  Widget _buildActiveLevelButton(int level) {
    return GestureDetector(
      onTap: () {
  print("Masuk ke Level $level");
  
  if (level == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level1Page()),
      );
  } 
  // --- TAMBAHKAN BAGIAN INI ---
  else if (level == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level2Page()),
      );
  } 
  else if (level == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level3Page()),
      );
  } 
  else if (level == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level4Page()),
      );
  } 
  else if (level == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level5Page()),
      );
  } 
  else if (level == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level6Page()),
      );
  } 
  else if (level == 7) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level7Page()),
      );
  } 
  else if (level == 8) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level8Page()),
      );
  } 
  else if (level == 9) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level9Page()),
      );
  } 
  else if (level == 10) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level10Page()),
      );
  } 
  else if (level == 11) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level11Page()),
      );
  } 
  else if (level == 12) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level12Page()),
      );
  } 
  else if (level == 13) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Level13Page()),
      );
  } 
  // ----------------------------
  else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Level $level belum dibuat!")),
    );
  }
},
      child: Column(
        children: [
          // Efek 'Bounce' atau panah kecil di atas tombol biar user tahu harus klik ini
          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30, shadows: [
            Shadow(blurRadius: 5, color: Colors.black, offset: Offset(0, 2))
          ],),
          
          Container(
            width: 70, 
            height: 70, 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1CC600), // Hijau Terang
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
                // Efek Glow
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Center(
              child: Text(
                "$level",
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 28
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
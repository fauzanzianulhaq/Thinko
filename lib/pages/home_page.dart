import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';
import 'region_1/level_1_page.dart';
import 'region_1/level_2_page.dart';
import 'region_1/level_3_page.dart';
import 'region_1/level_4_page.dart';
import 'region_1/level_5_page.dart';
import 'region_1/level_6_page.dart';
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
  User? currentUser = FirebaseAuth.instance.currentUser;

  // --- DAFTAR KOORDINAT LEVEL (ESTIMASI DARI FOTO AKANG) ---
  // Kalau masih kurang pas, JANGAN MENEBAK.
  // Caranya: Klik layar di HP -> Lihat "Debug Console" di bawah -> Copy angkanya ke sini.
  final List<Offset> levelLocations = [
    const Offset(260, 160), // Level 1 (Kanan Atas)
    const Offset(160, 240), // Level 2 (Tengah)
    const Offset(70, 360),  // Level 3 (Kiri)
    const Offset(240, 520), // Level 4 (Kanan)
    const Offset(120, 680), // Level 5 (Kiri Tengah)
    const Offset(180, 850), // Level 6 (Bawah Tengah)
    
    // -- REGION 2 (Gurun) --
    // Sesuaikan nanti pas gambar gurun muncul di bawah
    const Offset(280, 1000), 
    const Offset(100, 1150),
    const Offset(200, 1300),
    const Offset(100, 1450),
    const Offset(250, 1600),
    const Offset(150, 1750),
    const Offset(180, 1900),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          
          // 1. AMBIL DATA DARI FIREBASE
          int userMaxLevel = userData['level'] ?? 1;
          String username = userData['username'] ?? "Player";
          
          // 2. LOGIKA PILIH KARAKTER
          // Cek apakah ada 'avatar_index', kalau tidak ada default ke 0
          int avatarIndex = userData['avatar_index'] ?? 0; 
          
          // TENTUKAN GAMBAR BERDASARKAN INDEX
          String avatarImage;
          if (avatarIndex == 0) {
            avatarImage = 'assets/images/avatar_1.png'; 
          } else {
            avatarImage = 'assets/images/avatar_2.png'; 
          }

          return Stack(
            children: [
              // --- LAPISAN 1: PETA SCROLLABLE (KODE SAMA SEPERTI SEBELUMNYA) ---
              SingleChildScrollView(
                child: SizedBox(
                  height: 2000, 
                  child: Stack(
                    children: [
                      // ... (Kode Gambar Background Peta TETAP SAMA) ...
                      GestureDetector(
                        // ... kode on tap ...
                        child: Image.asset(
                          'assets/images/map_background.png',
                          width: double.infinity,
                          fit: BoxFit.fitWidth, 
                          alignment: Alignment.topCenter,
                        ),
                      ),

                      // ... (Kode Looping Tombol Level TETAP SAMA) ...
                      for (int i = 1; i <= userMaxLevel; i++) ...[
                        if (i - 1 < levelLocations.length)
                          Positioned(
                            left: levelLocations[i - 1].dx,
                            top: levelLocations[i - 1].dy,
                            child: _buildLevelButton(
                              level: i, 
                              isCurrentHighLevel: (i == userMaxLevel) 
                            ),
                          ),
                      ]
                    ],
                  ),
                ),
              ),

              // --- LAPISAN 2: HEADER PROFIL (YANG KITA UBAH) ---
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 3. TAMPILKAN AVATAR YANG BENAR
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(avatarImage), // <--- SUDAH DINAMIS
                            backgroundColor: Colors.grey[200],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                username, 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                              ),
                              Text(
                                "Level $userMaxLevel", 
                                style: const TextStyle(fontSize: 12, color: Colors.green)
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- WIDGET TOMBOL LEVEL (UKURAN DIPERBAIKI) ---
  Widget _buildLevelButton({required int level, required bool isCurrentHighLevel}) {
    // Ukuran tombol saya set 50 biar pas dengan bulatan di gambar peta Akang
    double size = 50; 

    return GestureDetector(
      onTap: () => _navigateToLevel(level),
      child: Column(
        children: [
          // Panah Penunjuk (Hanya di level paling tinggi)
          if (isCurrentHighLevel)
            const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30, shadows: [
              Shadow(blurRadius: 5, color: Colors.black, offset: Offset(0, 2))
            ]),
          
          Container(
            width: size, 
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Level Aktif: Hijau, Level Lewat: Kuning Emas
              color: isCurrentHighLevel ? const Color(0xFF1CC600) : const Color(0xFFFFC107), 
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: isCurrentHighLevel 
                ? Text("$level", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))
                : const Icon(Icons.check, color: Colors.white, size: 28), // Centang kalau sudah lewat
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi Navigasi
  void _navigateToLevel(int level) {
      if (level == 1) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level1Page()));
      else if (level == 2) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level2Page()));
      else if (level == 3) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level3Page()));
      else if (level == 4) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level4Page()));
      else if (level == 5) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level5Page()));
      else if (level == 6) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level6Page()));
      else if (level == 7) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level7Page()));
      else if (level == 8) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level8Page()));
      else if (level == 9) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level9Page()));
      else if (level == 10) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level10Page()));
      else if (level == 11) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level11Page()));
      else if (level == 12) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level12Page()));
      else if (level == 13) Navigator.push(context, MaterialPageRoute(builder: (c) => const Level13Page()));
  }
}
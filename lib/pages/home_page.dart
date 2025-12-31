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
    const Offset(255, 93), // Level 1 (Kanan Atas)
    const Offset(127, 128), // Level 2 (Tengah)
    const Offset(76, 257),  // Level 3 (Kiri)
    const Offset(201, 325), // Level 4 (Kanan)
    const Offset(180, 460), // Level 5 (Kiri Tengah)
    const Offset(87, 544), // Level 6 (Bawah Tengah)
    
    // -- REGION 2 (Gurun) --
    // Sesuaikan nanti pas gambar gurun muncul di bawah
    const Offset(170, 700), // Level 7
    const Offset(120, 822), // Level 8
    const Offset(90, 950), // Level 9
    const Offset(220, 1027), // Level 10
    const Offset(245, 1170), // Level 11
    const Offset(155, 1278), // Level 12
    const Offset(121, 1400), // Level 13
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
                  height: 1500, 
                  child: Stack(
                    children: [
                      // ... (Kode Gambar Background Peta TETAP SAMA) ...
                      GestureDetector(
                        // ... kode on tap ...
                        child: Image.asset(
                          'assets/images/map_background3.png',
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
  // --- WIDGET TOMBOL LEVEL (PERBAIKAN POSISI) ---
  Widget _buildLevelButton({required int level, required bool isCurrentHighLevel}) {
    double size = 50;

    return GestureDetector(
      onTap: () => _navigateToLevel(level),
      // GANTI COLUMN DENGAN STACK
      child: Stack(
        clipBehavior: Clip.none, // PENTING: Agar panah bisa muncul di luar batas kotak
        alignment: Alignment.center,
        children: [
          // 1. LINGKARAN TOMBOL (Ini jadi patokan posisi tetap)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
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
                  : const Icon(Icons.check, color: Colors.white, size: 28),
            ),
          ),

          // 2. PANAH (Melayang di atas lingkaran)
          // Posisi Absolute relative terhadap lingkaran
          if (isCurrentHighLevel)
            const Positioned(
              top: -35, // Geser ke atas (Nilai minus artinya keluar ke atas)
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 35, // Ukuran panah
                shadows: [
                  Shadow(blurRadius: 5, color: Colors.black, offset: Offset(0, 2))
                ],
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
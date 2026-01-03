import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';

// Import Level Pages
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

  // --- KOORDINAT LEVEL (Sesuai catatanmu) ---
  final List<Offset> levelLocations = [
    const Offset(255, 93),   // Level 1
    const Offset(127, 128),  // Level 2
    const Offset(76, 257),   // Level 3
    const Offset(201, 325),  // Level 4
    const Offset(180, 460),  // Level 5
    const Offset(87, 544),   // Level 6
    const Offset(170, 700),  // Level 7
    const Offset(120, 822),  // Level 8
    const Offset(90, 950),   // Level 9
    const Offset(220, 1027), // Level 10
    const Offset(245, 1170), // Level 11
    const Offset(155, 1278), // Level 12
    const Offset(121, 1400), // Level 13
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold Background digelapkan agar area kosong di Tablet terlihat elegan
    return Scaffold(
      backgroundColor: Colors.grey[900], 
      body: Center(
        // --- 1. KUNCI RAHASIA: CONSTRAINED BOX ---
        // Ini memaksa lebar aplikasi Maksimal 480px (Ukuran HP Besar).
        // Kalau di Tablet, sisa layarnya jadi background hitam.
        // Kalau di HP biasa, dia akan fullscreen normal.
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          color: Colors.white, // Warna background area game
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              // Loading State
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Ambil Data
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              int userMaxLevel = userData['level'] ?? 1;
              String username = userData['username'] ?? "Player";
              int avatarIndex = userData['avatar_index'] ?? 0;
              String avatarImage = (avatarIndex == 0) 
                  ? 'assets/images/avatar_1.png' 
                  : 'assets/images/avatar_2.png';

              return Stack(
                children: [
                  // --- LAPISAN 1: PETA SCROLLABLE ---
                  SingleChildScrollView(
                    child: SizedBox(
                      // Tinggi 1500 aman karena lebar sudah dikunci (tidak akan stretch)
                      height: 1500, 
                      child: Stack(
                        children: [
                          // A. Background Map
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/map_background3.png',
                              fit: BoxFit.cover, // Gunakan cover agar area penuh rapi
                              alignment: Alignment.topCenter,
                            ),
                          ),

                          // B. Tombol Level
                          for (int i = 0; i < levelLocations.length; i++)
                            Positioned(
                              left: levelLocations[i].dx,
                              top: levelLocations[i].dy,
                              child: _buildLevelButton(
                                level: i + 1,
                                userMaxLevel: userMaxLevel,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // --- LAPISAN 2: HEADER PROFIL ---
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (c) => const ProfilePage()));
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
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(avatarImage),
                                backgroundColor: Colors.grey[200],
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text("Level $userMaxLevel", style: const TextStyle(fontSize: 12, color: Colors.green)),
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
        ),
      ),
    );
  }

  // --- WIDGET TOMBOL (Tetap sama) ---
  Widget _buildLevelButton({required int level, required int userMaxLevel}) {
    double size = 50;
    bool isLocked = level > userMaxLevel;
    bool isCurrent = level == userMaxLevel;
    bool isPassed = level < userMaxLevel;

    return GestureDetector(
      onTap: () {
        if (isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Selesaikan Level ${level - 1} dulu!"), backgroundColor: Colors.red, duration: const Duration(seconds: 1)),
          );
        } else {
          _navigateToLevel(level);
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked ? Colors.grey : (isCurrent ? const Color(0xFF1CC600) : const Color(0xFFFFC107)),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: const Offset(0, 3))],
            ),
            child: Center(
              child: isLocked
                  ? const Icon(Icons.lock, color: Colors.white70, size: 24)
                  : (isPassed
                      ? const Icon(Icons.check, color: Colors.white, size: 28)
                      : Text("$level", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))),
            ),
          ),
          if (isCurrent)
            const Positioned(
              top: -40,
              child: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 40, shadows: [Shadow(blurRadius: 5, color: Colors.black, offset: Offset(0, 2))]),
            ),
        ],
      ),
    );
  }

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
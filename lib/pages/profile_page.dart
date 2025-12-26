import 'package:flutter/material.dart';
import 'change_username_page.dart';
import 'change_pin_page.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 0 = Toko, 1 = Profil
  // Kita set default ke 1 (Profil) biar langsung kelihatan desain barunya saat dibuka
  int _selectedTab = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // KONTEN UTAMA (Scrollable)
          Column(
            children: [
              // --- 1. HEADER CUSTOM (Bukit & Avatar) ---
              SizedBox(
                height: 280, 
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // A. Background Bukit (Kotak Penuh)
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.lightGreen, 
                        image: DecorationImage(
                          image: AssetImage('assets/images/hutan.png'), // Pastikan nama file background benar
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter
                        ),
                      ),
                    ),

                    // B. Tombol Kembali
                    Positioned(
                      top: 50, 
                      left: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                    ),

                    // C. Avatar & Nama
                    Positioned(
                      bottom: 0, 
                      left: 24,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end, 
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                              ]
                            ),
                            child: const CircleAvatar(
                              radius: 45, 
                              backgroundImage: AssetImage('assets/images/mc.png'), 
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 30), 
                            child: Text(
                              "Asep Knalpot",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- 2. TAB MENU (Toko / Profil) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    // Tab Toko
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.storefront_rounded, 
                                  color: _selectedTab == 0 ? Colors.green : Colors.grey),
                                const SizedBox(width: 8),
                                Text("Toko", 
                                  style: TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTab == 0 ? Colors.green : Colors.grey
                                  )
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 3,
                              color: _selectedTab == 0 ? Colors.green : Colors.grey[200],
                            )
                          ],
                        ),
                      ),
                    ),
                    
                    // Tab Profil
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person, 
                                  color: _selectedTab == 1 ? Colors.green : Colors.grey),
                                const SizedBox(width: 8),
                                Text("Profil", 
                                  style: TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTab == 1 ? Colors.green : Colors.grey
                                  )
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 3,
                              color: _selectedTab == 1 ? Colors.green : Colors.grey[200],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- 3. ISI KONTEN ---
              Expanded(
                child: _selectedTab == 0 ? _buildTokoContent() : _buildProfilContent(),
              ),
            ],
          ),
          
          // TOMBOL BELI (Hanya di Tab Toko)
          if(_selectedTab == 0)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("1x meteor", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1CC600),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stars_rounded, color: Colors.white), 
                          SizedBox(width: 8),
                          Text("139 - Beli", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- WIDGET KONTEN TOKO ---
  Widget _buildTokoContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                child: const Icon(Icons.star, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              const Text("120", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children:List.generate(3, (index) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            }),
          ),
          const SizedBox(height: 100), 
        ],
      ),
    );
  }

  // --- WIDGET KONTEN PROFIL (BARU SESUAI DESAIN) ---
  Widget _buildProfilContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. BAGIAN USERNAME
          const Text("username", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          
          // Kotak Username Abu-abu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Warna abu muda
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Asep Knalpot", 
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Tombol Ganti Username
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                // 2. NAVIGASI KE HALAMAN GANTI USERNAME
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangeUsernamePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1CC600), // Hijau
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text("Ganti username", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 30),

          // 2. BAGIAN PIN
          const Text("PIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          
          // 4 Kotak PIN
          Row(
            children: List.generate(4, (index) {
              return Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 12), // Jarak antar kotak
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.circle, size: 24, color: Colors.black), // Titik Hitam
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Tombol Ganti PIN
          Align(
  alignment: Alignment.centerRight,
  child: ElevatedButton(
    onPressed: () {
      // --- NAVIGASI KE HALAMAN GANTI PIN ---
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangePinPage()),
      );
    },
    style: ElevatedButton.styleFrom(
       // ... (style biarkan saja) ...
    ),
    child: const Text("Ganti PIN", style: TextStyle(fontWeight: FontWeight.bold)),
  ),
),
          
          // Space di bawah agar tidak mentok
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
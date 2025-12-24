import 'package:flutter/material.dart';
import 'pin_creation_page.dart';

class AvatarSelectionPage extends StatefulWidget {
  const AvatarSelectionPage({super.key});

  @override
  State<AvatarSelectionPage> createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {
  // Variabel untuk menyimpan pilihan user (0 = kiri, 1 = kanan)
  int _selectedIndex = 0;

  // Data karakter (Nama & File Gambar)
  final List<Map<String, String>> _characters = [
    {
      'name': 'Lumi si Penyihir Pintar',
      'image': 'assets/images/avatar_1.png', // Ganti dengan nama file kamu
    },
    {
      'name': 'Kairo si Ninja Gesit',
      'image': 'assets/images/avatar_2.png', // Ganti dengan nama file kamu
    },
  ];

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
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 1. Header: Tombol Kembali & Judul Kecil
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context), // Kembali ke halaman sebelumnya
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Kembali",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Progress Bar (Baris 1 Hijau)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    // Step 1: Hijau (Aktif)
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1CC600), // Hijau
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Step 2: Abu-abu
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
                    // Step 3: Abu-abu
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

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      
                      // Logo Robot Kecil
                      Image.asset(
                        'assets/images/logo_thinko2.png',
                        height: 100,
                      ),
                      
                      const SizedBox(height: 20),

                      const Text(
                        'Sekarang pilih karakter\nyang kamu suka',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 3. Pilihan Avatar (Row)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Avatar 1 (Kiri)
                          _buildAvatarOption(0),
                          
                          const SizedBox(width: 20), // Jarak antar avatar

                          // Avatar 2 (Kanan)
                          _buildAvatarOption(1),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // 4. Nama Karakter (Berubah sesuai pilihan)
                      Text(
                        _characters[_selectedIndex]['name']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey, // Warna teks agak abu sesuai desain
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. Tombol Lanjut
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                  // Langsung pindah ke halaman buat PIN
                Navigator.push(
                  context,
                MaterialPageRoute(builder: (context) => const PinCreationPage()),
                  );
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

  // Widget kecil untuk membuat bunderan avatar
  Widget _buildAvatarOption(int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update state saat diklik
        });
      },
      child: Container(
        padding: const EdgeInsets.all(4), // Jarak antara border dan gambar
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Jika dipilih, border hijau. Jika tidak, transparan.
          border: Border.all(
            color: isSelected ? const Color(0xFF1CC600) : Colors.transparent,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: 50, // Ukuran lingkaran
          backgroundColor: Colors.grey[200], // Warna background kalau gambar transparan
          backgroundImage: AssetImage(_characters[index]['image']!),
        ),
      ),
    );
  }
}
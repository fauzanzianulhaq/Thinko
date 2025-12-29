import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Tambahan
import '../services/firebase_service.dart'; // Tambahan
import 'welcome_page.dart'; // Import halaman welcome

class ChangeUsernamePage extends StatefulWidget {
  const ChangeUsernamePage({super.key});

  @override
  State<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService(); // Panggil Service
  bool _isLoading = false;

  // --- LOGIKA SIMPAN (DIPERBAIKI) ---
  void _handleSave() async {
    String input = _usernameController.text.trim();

    // 1. Validasi Kosong
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username tidak boleh kosong!")),
      );
      return;
    }

    setState(() => _isLoading = true); // Mulai Loading

    // 2. Panggil Firebase Service
    String? error = await _firebaseService.updateUsername(input);

    if (!mounted) return;
    setState(() => _isLoading = false); // Stop Loading

    if (error == null) {
      // BERHASIL -> LOGOUT & KE HALAMAN WELCOME
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      
      // Tampilkan Pesan Sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Berhasil! Silakan LOGIN ULANG dengan username: $input")),
      );

      // Tendang ke halaman Welcome (Hapus riwayat)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (route) => false,
      );

    } else {
      // GAGAL -> Munculkan Popup Robot dengan Pesan Error dari Firebase
      _showErrorDialog(error); 
    }
  }

  // --- POPUP ERROR (DESAIN ROBOT ASLI KAMU) ---
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Stack(
            clipBehavior: Clip.none, // Agar kepala robot bisa nongol keluar
            alignment: Alignment.center,
            children: [
              // 1. KOTAK PUTIH
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 40), // Ruang untuk kepala
                padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Gagal Mengganti",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message, // Pesan Error Dinamis dari Firebase
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // TOMBOL OKE
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Tutup dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1CC600), // Hijau
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Oke",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. KEPALA ROBOT (Thinko)
              Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    // Pastikan file ini ada di assets
                    backgroundImage: AssetImage('assets/images/logo_thinko.png'), 
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ganti Username",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            // 1. GAMBAR ROBOT SECURITY BESAR (ASLI)
            Center(
              child: SizedBox(
                height: 180,
                child: Image.asset(
                  'assets/images/robot2.png', // Robot Security
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            const SizedBox(height: 40),

            // 2. LABEL INPUT
            const Text(
              "username baru",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // 3. TEXT FIELD
            TextField(
              controller: _usernameController, 
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: "Masukkan username baru",
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),

            const SizedBox(height: 30),

            // 4. TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSave, // Kunci tombol saat loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1CC600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                    "Simpan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
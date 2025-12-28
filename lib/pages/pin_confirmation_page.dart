import 'package:flutter/material.dart';
import '../services/firebase_service.dart'; // Import Service
import 'registration_success_page.dart';

class PinConfirmationPage extends StatefulWidget {
  final String username;
  final int avatarIndex;
  final String sourcePin;

  const PinConfirmationPage({
    super.key, 
    required this.username, 
    required this.avatarIndex, 
    required this.sourcePin
  });

  @override
  State<PinConfirmationPage> createState() => _PinConfirmationPageState();
}

class _PinConfirmationPageState extends State<PinConfirmationPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  
  bool _isPinVisible = false; // Default tersembunyi
  bool _isLoading = false;    // Status Loading

  @override
  void dispose() {
    for (var controller in _controllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    super.dispose();
  }

  // --- LOGIKA SIMPAN DATA KE FIREBASE ---
  // --- LOGIKA SIMPAN DATA KE FIREBASE ---
  void _handleFinalRegister() async {
    String confirmPin = _controllers.map((c) => c.text).join();

    // 1. Cek apakah PIN cocok
    if (confirmPin != widget.sourcePin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ups, PIN tidak sama. Coba lagi ya.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true); // Mulai Loading

    // 2. KIRIM KE FIREBASE
    // Pastikan _firebaseService.registerUser mengembalikan NULL jika sukses
    // dan mengembalikan STRING (pesan error) jika gagal.
    String? error = await _firebaseService.registerUser(
      username: widget.username,
      pin: confirmPin,
      avatarIndex: widget.avatarIndex,
    );

    // DEBUGGING: Cek hasil di "Run" tab atau Console
    print("Hasil Register: $error"); 

    if (!mounted) return; // Cek apakah halaman masih aktif

    setState(() => _isLoading = false); // Stop Loading

    if (error == null) {
      // --- BERHASIL ---
      // Gunakan pushAndRemoveUntil agar user tidak bisa tombol "Back" ke halaman PIN lagi
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RegistrationSuccessPage()),
        (route) => false, // Menghapus semua halaman sebelumnya dari stack
      );
    } else {
      // --- GAGAL ---
      // Tampilkan error yang sebenarnya terjadi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal Daftar: $error"), // Tampilkan pesan error spesifik
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // Biar lebih cantik (melayang)
          margin: const EdgeInsets.all(20),
        ),
      );
    }
  }

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
            colors: [Color(0xFFD0F8CE), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 1. Header: Tombol Kembali
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
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

              // 2. Progress Bar (Sesuai desain kamu)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(color: const Color(0xFF1CC600), borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(color: const Color(0xFF1CC600), borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(10)),
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
                      const SizedBox(height: 40),
                      
                      Image.asset(
                        'assets/images/logo_thinko2.png',
                        height: 120,
                      ),
                      
                      const SizedBox(height: 20),

                      const Text(
                        'Sekarang tulis ulang PIN\nmu tadi',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),

                      const SizedBox(height: 40),

                      // 3. Input PIN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 70,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              obscureText: !_isPinVisible,
                              obscuringCharacter: '●',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(border: InputBorder.none, counterText: ""),
                              maxLength: 1,
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  _focusNodes[index + 1].requestFocus();
                                }
                                if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Toggle Mata (Lihat PIN)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPinVisible = !_isPinVisible;
                          });
                        },
                        child: Icon(
                          _isPinVisible ? Icons.visibility_off : Icons.visibility,
                          size: 30,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Tombol Selesai (Dengan Loading & Firebase)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleFinalRegister, // Panggil Fungsi Backend
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1CC600),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading
                      ? const SizedBox(
                          height: 24, 
                          width: 24, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                        )
                      : const Text(
                          'Selesai',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
import 'package:flutter/material.dart';
import '../services/firebase_service.dart'; // Import Service
import 'home_page.dart'; // Import Home Page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _usernameController = TextEditingController();
  
  // Controller & FocusNode untuk 4 Kotak PIN
  final List<TextEditingController> _pinControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  bool _isLoading = false;

  void _handleLogin() async {
    // Gabungkan 4 angka jadi satu string PIN
    String pin = _pinControllers.map((c) => c.text).join();
    String username = _usernameController.text.trim();

    if (username.isEmpty || pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Isi username dan 4 digit PIN ya!")));
      return;
    }

    setState(() => _isLoading = true); // Mulai Loading

    // Panggil Firebase
    String? error = await _firebaseService.loginUser(username: username, pin: pin);

    setState(() => _isLoading = false); // Stop Loading

    if (error == null) {
      // BERHASIL LOGIN
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } else {
      // GAGAL
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Username atau PIN salah!")));
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo_thinko2.png', height: 150),
                      const SizedBox(height: 20),
                      const Text(
                        'Hai, Senang bisa\nketemu lagi',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // INPUT USERNAME
                const Text('Username', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),

                // INPUT PIN (4 KOTAK HIDUP)
                const Text('PIN', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _pinControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 1,
                        onChanged: (value) {
                          // Logic Pindah Kotak Otomatis
                          if (value.isNotEmpty && index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                        decoration: const InputDecoration(counterText: "", border: InputBorder.none),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 50),

                // TOMBOL MASUK
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin, // Disable kalau lagi loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1CC600),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('Masuk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
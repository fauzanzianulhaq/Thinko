import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import 'welcome_page.dart'; // Import halaman welcome

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  // Controller masing-masing baris
  final List<TextEditingController> _oldPinControllers = List.generate(4, (index) => TextEditingController());
  final List<TextEditingController> _newPinControllers = List.generate(4, (index) => TextEditingController());
  final List<TextEditingController> _confirmPinControllers = List.generate(4, (index) => TextEditingController());
  
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;
  
  // --- LOGIKA SIMPAN (METODE RE-AUTHENTICATION) ---
  void _handleSave() async {
    // Gabungkan text menjadi string
    String oldPin = _oldPinControllers.map((c) => c.text).join();
    String newPin = _newPinControllers.map((c) => c.text).join();
    String confirmPin = _confirmPinControllers.map((c) => c.text).join();

    // 1. Validasi Input
    if (oldPin.length != 4 || newPin.length != 4 || confirmPin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua PIN harus 4 angka!")));
      return;
    }
    if (newPin != confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PIN Baru tidak sama dengan Konfirmasi!")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        
        // 2. CEK PIN LAMA DENGAN CARA LOGIN ULANG (RE-AUTH)
        // Ini cara paling ampuh. Kita coba login pake PIN lama + "00".
        // Kalau berhasil, berarti PIN lama valid DAN sesi jadi segar kembali.
        String oldPasswordAuth = oldPin + "00";
        
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, 
          password: oldPasswordAuth
        );

        await user.reauthenticateWithCredential(credential);

        // 3. JIKA LOLOS RE-AUTH, BARU UPDATE PIN BARU
        // Panggil service untuk update Auth & Database
        String? error = await _firebaseService.updatePin(newPin);
        
        if (!mounted) return;
        setState(() => _isLoading = false);

        if (error == null) {
          // SUKSES -> LOGOUT & LOGIN ULANG
          await FirebaseAuth.instance.signOut();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Berhasil! Silakan Login ulang dengan PIN baru.")),
          );
          
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomePage()),
              (route) => false,
          );
        } else {
          _showErrorDialog("Gagal Update: $error");
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      // Kode Error jika password lama salah
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PIN Lama salah!"), backgroundColor: Colors.red)
        );
      } else {
        _showErrorDialog(e.message ?? "Terjadi kesalahan");
      }
    } catch (e) {
        setState(() => _isLoading = false);
        _showErrorDialog("Error: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ups!"),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Oke"))],
      ),
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
          "Ganti PIN",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 1. GAMBAR ROBOT (ASLI)
            Center(
              child: SizedBox(
                height: 150,
                child: Image.asset(
                  'assets/images/logo_thinko.png', 
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // 2. FORM INPUT PIN
            
            // A. PIN LAMA
            const Text("PIN Lama", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            _buildPinInputRow(_oldPinControllers),

            const SizedBox(height: 20),

            // B. PIN BARU
            const Text("PIN Baru", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            _buildPinInputRow(_newPinControllers),

            const SizedBox(height: 20),

            // C. KONFIRMASI PIN
            const Text("Tulis Ulang PIN Baru", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            _buildPinInputRow(_confirmPinControllers),

            const SizedBox(height: 40),

            // 3. TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1CC600), // Hijau
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

  // --- WIDGET KOTAK PIN (UI TETAP SAMA) ---
  Widget _buildPinInputRow(List<TextEditingController> controllers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return Container(
          width: 70, // Lebar kotak
          height: 70, // Tinggi kotak
          decoration: BoxDecoration(
            color: Colors.grey[200], // Warna abu muda
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            obscureText: true, // Titik-titik rahasia
            maxLength: 1,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
            ),
            // Pindah fokus otomatis saat diketik
            onChanged: (value) {
              if (value.isNotEmpty) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
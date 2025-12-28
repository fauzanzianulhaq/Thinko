import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- REGISTER (DAFTAR BARU) ---
  Future<String?> registerUser({
    required String username,
    required String pin,
    required int avatarIndex, // <--- TAMBAHAN: Biar avatar yang dipilih tersimpan
  }) async {
    try {
      // 1. Buat Email Palsu dari Username
      String email = "$username@mathadventure.com".replaceAll(" ", ""); // Hapus spasi

      // 2. Buat Akun di Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pin + "00", // Logika passwordmu (PIN + 00)
      );

      // 3. Simpan Data Lengkap ke Firestore Database
      // Kita pakai UID dari Auth agar aman (sesuai Rules Opsi 2)
      await _db.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'pin': pin,
        'avatar_index': avatarIndex, // <--- Disimpan di sini
        'level': 1,       // Level awal
        'coins': 0,       // Koin awal
        'health': 100,    // Darah awal
        'created_at': FieldValue.serverTimestamp(), // Pakai waktu server biar akurat
      });

      return null; // Berhasil (return null)
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Username ini sudah dipakai orang lain!";
      } else if (e.code == 'weak-password') {
        return "PIN terlalu lemah.";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // --- LOGIN ---
  Future<String?> loginUser({
    required String username,
    required String pin,
  }) async {
    try {
      String email = "$username@mathadventure.com".replaceAll(" ", "");
      
      // Login ke Firebase Auth
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: pin + "00", 
      );
      
      return null; // Berhasil
    } on FirebaseAuthException catch (e) {
      // Error handling yang lebih rapi untuk user
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return "Username atau PIN salah!";
      }
      return "Gagal login: ${e.message}";
    } catch (e) {
      return "Terjadi kesalahan jaringan.";
    }
  }

  // --- AMBIL DATA USER (Untuk Profil/Home) ---
  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
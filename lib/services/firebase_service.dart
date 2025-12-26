import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- REGISTER (DAFTAR BARU) ---
  Future<String?> registerUser({
    required String username,
    required String pin,
  }) async {
    try {
      // 1. Buat Email Palsu dari Username (karena Firebase butuh email)
      String email = "$username@mathadventure.com".replaceAll(" ", ""); // Hapus spasi

      // 2. Buat Akun di Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pin + "00", // Tambah '00' karena password minimal 6 karakter (PIN cuma 4)
      );

      // 3. Simpan Data Level & Koin ke Firestore Database
      await _db.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'pin': pin,
        'level': 1,       // Level awal
        'coins': 0,       // Koin awal
        'health': 100,
        'created_at': DateTime.now(),
      });

      return null; // Berhasil (tidak ada error)
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Username sudah dipakai!";
      } else if (e.code == 'weak-password') {
        return "PIN terlalu lemah";
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
    } catch (e) {
      return "Username atau PIN salah!";
    }
  }

  // --- AMBIL DATA USER (Untuk Profil) ---
  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
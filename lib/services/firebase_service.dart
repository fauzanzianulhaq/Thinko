import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- REGISTER ---
  Future<String?> registerUser({
    required String username,
    required String pin,
    required int avatarIndex,
  }) async {
    try {
      String email = "$username@mathadventure.com".replaceAll(" ", "");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pin + "00", 
      );

      await _db.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'pin': pin,
        'avatar_index': avatarIndex,
        'level': 1,
        'coins': 0,
        'health': 100,
        'created_at': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') return "Username sudah dipakai!";
      if (e.code == 'weak-password') return "PIN terlalu lemah.";
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // --- LOGIN ---
  Future<String?> loginUser({required String username, required String pin}) async {
    try {
      String email = "$username@mathadventure.com".replaceAll(" ", "");
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: pin + "00", 
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return "Username atau PIN salah!";
    } catch (e) {
      return "Terjadi kesalahan jaringan.";
    }
  }

  // --- UPDATE USERNAME (PERBAIKAN UTAMA) ---
  Future<String?> updateUsername(String newUsername) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return "User tidak ditemukan";

      // 1. Update "KTP" (Auth Email)
      String newEmail = "$newUsername@mathadventure.com".replaceAll(" ", "");
      // await user.verifyBeforeUpdateEmail(newEmail); // Versi baru pakai verifyBeforeUpdateEmail atau updateEmail tergantung versi
      // Note: Jika error, coba pakai: await user.updateEmail(newEmail);
      await user.updateEmail(newEmail);

      // 2. Update "Profil" (Database)
      await _db.collection('users').doc(user.uid).update({
        'username': newUsername,
      });

      return null; // Sukses
    } on FirebaseAuthException catch (e) {
      // Error paling sering: User harus login ulang dulu baru boleh ganti email
      if (e.code == 'requires-recent-login') {
        return "Demi keamanan, tolong Logout dan Login lagi sebelum ganti username.";
      }
      if (e.code == 'email-already-in-use') return "Username ini sudah dipakai!";
      return e.message;
    } catch (e) {
      return "Gagal update: $e";
    }
  }

  // --- UPDATE PIN (PERBAIKAN UTAMA) ---
  Future<String?> updatePin(String newPin) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return "User tidak ditemukan";

      // 1. Update "Kunci Pintu" (Auth Password)
      await user.updatePassword(newPin + "00");

      // 2. Update "Catatan" (Database)
      await _db.collection('users').doc(user.uid).update({
        'pin': newPin,
      });

      return null; // Sukses
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return "Demi keamanan, tolong Logout dan Login lagi sebelum ganti PIN.";
      }
      return e.message;
    } catch (e) {
      return "Gagal update: $e";
    }
  }
}
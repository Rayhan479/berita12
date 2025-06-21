import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthService {
  // Gunakan FlutterSecureStorage untuk penyimpanan yang lebih aman
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _tokenKey = 'jwt_token'; // Sesuaikan kunci token jika perlu
  final String _userKey = 'user_profile'; // Kunci untuk menyimpan data user

  // --- Token Management ---
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // --- User Profile Management ---
  /// Menyimpan data profil pengguna ke FlutterSecureStorage.
  Future<void> saveUserProfile(Map<String, dynamic> userData) async {
    // Konversi map ke string JSON untuk disimpan
    await _storage.write(key: _userKey, value: json.encode(userData));
  }

  /// Mengambil data profil pengguna dari FlutterSecureStorage.
  Future<Map<String, dynamic>?> getUserProfile() async {
    final userString = await _storage.read(key: _userKey);
    if (userString != null) {
      // Konversi string JSON kembali ke map
      return json.decode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  /// Menghapus data profil pengguna dari FlutterSecureStorage.
  Future<void> deleteUserProfile() async {
    await _storage.delete(key: _userKey);
  }

  // --- Logout (DIPERBARUI) ---
  Future<void> logout() async {
    // Hapus token dan juga data profil saat logout
    await deleteToken();
    await deleteUserProfile();
  }
}

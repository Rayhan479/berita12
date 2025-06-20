import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../model/article_model.dart';
import 'package:berita12/auth_service.dart';

class ApiService {
  final String baseUrl = "https://rest-api-berita.vercel.app/api/v1";
  final _storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();

  // Helper untuk memproses semua respons dari API secara konsisten
  dynamic _processResponse(http.Response response) {
    final body = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body['data'] == null) {
        throw Exception("Data dari server kosong.");
      }
      return body['data'];
    } else {
      final message = body['message'] ?? 'Terjadi kesalahan tidak diketahui';
      throw Exception(message);
    }
  }

  // Menyimpan token ke secure storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Menyimpan nama dan email user ke secure storage
  Future<void> saveUserInfo({
    required String name,
    required String email,
  }) async {
    await _storage.write(key: 'user_name', value: name);
    await _storage.write(key: 'user_email', value: email);
  }

  // Mengambil info user dari secure storage
  Future<Map<String, String?>> getUserInfo() async {
    final name = await _storage.read(key: 'user_name');
    final email = await _storage.read(key: 'user_email');
    return {'name': name, 'email': email};
  }

  // Autentikasi Untuk Profile Pengguna Yages;
  Future<void> updateUserName(String newName) async {
    await _authenticatedRequest(
      (token) => http.put(
        Uri.parse('$baseUrl/auth/'),
        headers: {'Authorization': 'Bearer $token'},
        body: jsonEncode({'name': newName}),
      ),
    );
  }

  // Helper untuk request yang memerlukan otentikasi (token)
  Future<http.Response> _authenticatedRequest(
    Future<http.Response> Function(String token) request,
  ) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Pengguna belum login. Silakan login terlebih dahulu.');
    }
    return await request(token);
  }

  /// Melakukan login pengguna.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _processResponse(response);
  }

  /// Mendaftarkan pengguna baru.
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'title': 'Crypto Enthusiast',
        'avatar': 'https://api.dicebear.com/8.x/pixel-art/png?seed=$name',
      }),
    );
    return _processResponse(response);
  }

  /// Memeriksa status bookmark sebuah artikel.
  Future<bool> checkBookmarkStatus(String articleId) async {
    final response = await _authenticatedRequest((token) {
      return http.get(
        Uri.parse('$baseUrl/news/$articleId/bookmark'),
        headers: {'Authorization': 'Bearer $token'},
      );
    });
    final data = _processResponse(response);
    return data['isSaved'] ?? false;
  }

  /// Menambahkan artikel ke bookmark.
  Future<void> addBookmark(String articleId) async {
    await _authenticatedRequest(
      (token) => http.post(
        Uri.parse('$baseUrl/news/$articleId/bookmark'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  /// Menghapus artikel dari bookmark.
  Future<void> removeBookmark(String articleId) async {
    await _authenticatedRequest(
      (token) => http.delete(
        Uri.parse('$baseUrl/news/$articleId/bookmark'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  /// Membuat artikel baru.
  Future<bool> CreateNewsPage(Article article) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) throw Exception('Token tidak ditemukan');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(article.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Artikel berhasil dibuat!');
        return true;
      } else {
        print('Gagal membuat artikel: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error saat membuat artikel: $e');
      return false;
    }
  }

  /// Mengupdate artikel.
  Future<void> updateArticle(
    String articleId,
    Map<String, dynamic> articleData,
  ) async {
    await _authenticatedRequest(
      (token) => http.put(
        Uri.parse('$baseUrl/news/$articleId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(articleData),
      ),
    );
  }

  /// Menghapus artikel.
  Future<void> deleteArticle(String articleId) async {
    await _authenticatedRequest(
      (token) => http.delete(
        Uri.parse('$baseUrl/news/$articleId'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }
}

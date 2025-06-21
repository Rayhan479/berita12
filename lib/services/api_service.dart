import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../model/article_model.dart';
import 'package:berita12/auth_service.dart';

class ApiService {
  final String baseUrl = "https://rest-api-berita.vercel.app/api/v1";
  final _storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();

  dynamic _processResponse(http.Response response) {
    final body = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body['data'] == null) {
        // Terkadang API mengembalikan success:true tapi data:null (misal untuk delete)
        // Jadi tidak selalu throw exception jika data null, tergantung API
        return body; // Return body lengkap untuk kasus ini
      }
      return body['data']; // Mengembalikan hanya bagian 'data'
    } else {
      final message = body['message'] ?? 'Terjadi kesalahan tidak diketahui';
      throw Exception(message);
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<void> saveUserInfo({
    required String name,
    required String email,
  }) async {
    await _storage.write(key: 'user_name', value: name);
    await _storage.write(key: 'user_email', value: email);
  }

  Future<Map<String, String?>> getUserInfo() async {
    final name = await _storage.read(key: 'user_name');
    final email = await _storage.read(key: 'user_email');
    return {'name': name, 'email': email};
  }

  Future<void> updateUserName(String newName) async {
    await _authenticatedRequest(
      (token) => http.put(
        Uri.parse('$baseUrl/auth/'),
        headers: {'Authorization': 'Bearer $token'},
        body: jsonEncode({'name': newName}),
      ),
    );
  }

  Future<http.Response> _authenticatedRequest(
    Future<http.Response> Function(String token) request,
  ) async {
    final token = await _authService.getToken(); // Mengambil token dari AuthService
    if (token == null) {
      throw Exception('Pengguna belum login. Silakan login terlebih dahulu.');
    }
    return await request(token);
  }

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

  Future<void> addBookmark(String articleId) async {
    await _authenticatedRequest(
      (token) => http.post(
        Uri.parse('$baseUrl/news/$articleId/bookmark'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<void> removeBookmark(String articleId) async {
    await _authenticatedRequest(
      (token) => http.delete(
        Uri.parse('$baseUrl/news/$articleId/bookmark'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  /// Mengambil artikel yang dibuat oleh pengguna yang terautentikasi.
  Future<List<Article>> getMyArticles() async {
    final response = await _authenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/news/user/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      // Pastikan decodedData adalah Map sebelum mengakses kuncinya
      final dynamic processedData = _processResponse(response);
      if (processedData is Map<String, dynamic> && processedData['articles'] is List) { // Dihapus decodedData != null
        final List<dynamic> articlesData = processedData['articles'];
        return articlesData.map((item) => Article.fromJson(item)).toList();
      } else {
        throw Exception('Format data artikel pengguna tidak valid');
      }
    } else {
      throw Exception('Gagal memuat artikel: ${response.statusCode}');
    }
  }

  /// Mengambil daftar artikel yang di-bookmark oleh pengguna.
  Future<List<Article>> getSavedArticles() async {
    final response = await _authenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/news/bookmarks/list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final dynamic responseData = _processResponse(response); // Ini akan menjadi isi dari 'data'
      
      List<dynamic> articlesData;

      if (responseData is List) {
        // Case 1: 'data' langsung berupa list artikel
        articlesData = responseData;
      } else if (responseData is Map) {
        // Case 2: 'data' berupa map dan list artikel ada di bawah kunci 'bookmarks' atau 'articles'
        if (responseData['bookmarks'] is List) {
          articlesData = responseData['bookmarks'];
        } else if (responseData['articles'] is List) {
          articlesData = responseData['articles'];
        } else {
          throw Exception('Kunci artikel tidak ditemukan dalam data bookmark');
        }
      } else {
        throw Exception('Respons data bookmark tidak dalam format yang diharapkan (bukan List atau Map)');
      }

      return articlesData.map((item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat artikel yang di-bookmark: ${response.statusCode}');
    }
  }


  /// Menghapus artikel.
  Future<void> deleteArticle(String articleId) async {
    await _authenticatedRequest(
      (token) => http.delete(
        Uri.parse('$baseUrl/news/$articleId'), // Menggunakan ID artikel
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }


  /// Membuat artikel baru.
  Future<bool> createNewsPage(Article article) async {
    try {
      final token = await _authService.getToken(); // Menggunakan token dari AuthService
      if (token == null) throw Exception('Token tidak ditemukan');

      final response = await http.post(
        Uri.parse('$baseUrl/news'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": article.title,
          "category": article.category,
          "readTime": article.readTime,
          "imageUrl": article.imageUrl,
          "isTrending": false,
          "tags": article.tags,
          "content": article.content,
        }),
      );
      if (kDebugMode) {
        print('TOKEN: $token');
        print('REQUEST BODY: ${jsonEncode(article.toJson())}');
        print('RESPONSE STATUS: ${response.statusCode}');
        print('RESPONSE BODY: ${response.body}');

        print('🔎 Status Code: ${response.statusCode}');
        print('🔎 Response Body: ${response.body}');
        print("🔐 Token digunakan: $token");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('✅ Artikel berhasil dibuat!');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('❌ Gagal membuat artikel: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saat membuat artikel: $e');
      }
      return false;
    }
  }

  Future<void> updateArticle(String articleId, Map<String, dynamic> articleData) async {
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

  // Future<void> deleteArticle(String articleId) async {
  //   await _authenticatedRequest(
  //     (token) => http.delete(
  //       Uri.parse('$baseUrl/news/$articleId'),
  //       headers: {'Authorization': 'Bearer $token'},
  //     ),
  //   );
  // }

  /// ✅ Fungsi baru: Ambil semua artikel milik user
  Future<List<Article>> fetchUserArticles() async {
    final response = await _authenticatedRequest(
      (token) => http.get(
        Uri.parse('$baseUrl/news/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    final data = _processResponse(response);

    if (data is List) {
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception("Format data tidak sesuai (harus List).");
    }
  }
}

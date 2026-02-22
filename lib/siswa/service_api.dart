import 'package:http/http.dart' as http;
import 'dart:convert';
import '../siswa/user_mode.dart';

class ApiService {
  final String serverUrl = "https://unfoxed-kaycee-subcircular.ngrok-free.dev";

  // Kita buat helper headers agar tidak menulis ulang berkali-kali
  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "69420", // Melewati halaman warning ngrok
      };

  Future<List<User>> fetchUsers() async {
    try {
      final res = await http.get(
        Uri.parse("$serverUrl/dataset/users"),
        headers: _headers, // Tambahkan headers di sini
      );
      
      final data = json.decode(res.body);
      
      final List usersJson = data['data']['users'];
      return usersJson.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<void> updateUser(
      String authUserId, Map<String, dynamic> updateData) async {
    try {
      final res = await http.put(
        Uri.parse("$serverUrl/dataset/users/$authUserId"),
        headers: _headers, // Gunakan helper headers
        body: json.encode(updateData),
      );

      final data = json.decode(res.body);

      if (data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Update gagal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteUser(String authUserId) async {
    try {
      final res = await http.delete(
        Uri.parse("$serverUrl/dataset/users/$authUserId"),
        headers: _headers, // Tambahkan headers agar tidak kena intercept ngrok
      );

      final data = json.decode(res.body);

      if (data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Hapus gagal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> toggleUserStatus(String authUserId, bool newStatus) async {
    try {
      final res = await http.put(
        Uri.parse("$serverUrl/dataset/users/$authUserId"),
        headers: _headers, // Gunakan helper headers
        body: json.encode({"is_active": newStatus}),
      );

      final data = json.decode(res.body);

      if (data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Update status gagal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

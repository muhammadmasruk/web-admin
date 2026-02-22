import 'package:flutter/material.dart';
import '../siswa/user_mode.dart';

class DetailDialog extends StatelessWidget {
  final User user;

  const DetailDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              _buildBody(),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.white),
          const SizedBox(width: 12),
          const Text(
            "Detail Data Siswa",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfilePhoto(),
          const SizedBox(height: 24),
          _buildStatusBadge(),
          const SizedBox(height: 16),
          _detailRow("NIS", user.nis ?? '-', Icons.badge),
          _detailRow("Nama Lengkap", user.displayName ?? '-', Icons.person),
          _detailRow("Email", user.email ?? '-', Icons.email),
          _detailRow("Password", _maskPassword(user.password), Icons.lock),
          _detailRow("Jurusan", user.jurusan ?? '-', Icons.school),
          _detailRow(
              "Lokasi Magang", user.lokasiMagang ?? '-', Icons.business),
          _detailRow(
            "Latitude",
            user.latitude?.toString() ?? '-',
            Icons.location_on,
          ),
          _detailRow(
            "Longitude",
            user.longitude?.toString() ?? '-',
            Icons.location_on,
          ),
          if (user.latitude != null && user.longitude != null)
            _buildLocationCard(),
        ],
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: user.isActive ? Colors.green[700]! : Colors.grey[400]!,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: user.fotoUrl != null && user.fotoUrl != ''
              ? Image.network(
                  user.fotoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                )
              : Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.grey[600],
                ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: user.isActive ? Colors.green[50] : Colors.red[50],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: user.isActive ? Colors.green[300]! : Colors.red[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              user.isActive ? Icons.check_circle : Icons.cancel,
              size: 22,
              color: user.isActive ? Colors.green[700] : Colors.red[700],
            ),
            const SizedBox(width: 8),
            Text(
              user.isActive ? "Akun Aktif" : "Akun Nonaktif",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: user.isActive ? Colors.green[700] : Colors.red[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.map, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Koordinat Lokasi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                Text(
                  "${user.latitude}, ${user.longitude}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Tutup", style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  String _maskPassword(dynamic password) {
    if (password == null || password.toString().isEmpty) return '-';
    return '•' * password.toString().length;
  }
}
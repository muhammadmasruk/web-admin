import 'package:flutter/material.dart';
import '../siswa/user_mode.dart';
import 'siswa/data_table.dart';
import 'siswa/detail_dialog.dart';
import 'siswa/service_api.dart';
import 'siswa/detail.dart';

class DataSiswaPage extends StatefulWidget {
  const DataSiswaPage({super.key});

  @override
  State<DataSiswaPage> createState() => _DataSiswaPageState();
}

class _DataSiswaPageState extends State<DataSiswaPage> {
  final ApiService _apiService = ApiService();
  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = true;

  // Pagination
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPages = 1;

  // Search
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchDataSiswa();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();
      _filterUsers();
      currentPage = 1;
    });
  }

  void _filterUsers() {
    if (searchQuery.isEmpty) {
      filteredUsers = users;
    } else {
      filteredUsers = users.where((user) {
        final name = (user.displayName ?? '').toLowerCase();
        final lokasi = (user.lokasiMagang ?? '').toLowerCase();
        final nis = (user.nis ?? '').toLowerCase();
        return name.contains(searchQuery) ||
            lokasi.contains(searchQuery) ||
            nis.contains(searchQuery);
      }).toList();
    }
    _updatePagination();
  }

  void _updatePagination() {
    totalPages = (filteredUsers.length / itemsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;
    if (currentPage > totalPages) currentPage = totalPages;
  }

  List<User> get paginatedUsers {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    if (startIndex >= filteredUsers.length) return [];
    return filteredUsers.sublist(
      startIndex,
      endIndex > filteredUsers.length ? filteredUsers.length : endIndex,
    );
  }

  Future<void> fetchDataSiswa() async {
    setState(() => isLoading = true);
    try {
      final fetchedUsers = await _apiService.fetchUsers();
      setState(() {
        users = fetchedUsers;
        filteredUsers = users;
        _updatePagination();
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _toggleUserStatus(User user, bool newStatus) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await _apiService.toggleUserStatus(user.authUserId!, newStatus);

      // Close loading
      Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Status siswa ${user.displayName} berhasil ${newStatus ? 'diaktifkan' : 'dinonaktifkan'}',
            ),
            backgroundColor: newStatus ? Colors.green[700] : Colors.orange[700],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Refresh data
      fetchDataSiswa();
    } catch (e) {
      // Close loading
      Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah status: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildSearchField(),
              ),
              const SizedBox(width: 16),
              _buildItemsPerPageDropdown(),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildContent()),
          if (!isLoading && filteredUsers.isNotEmpty)
            _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.people, color: Colors.green[700], size: 28),
        const SizedBox(width: 12),
        const Text(
          "Data Siswa",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Cari nama siswa, NIS, atau lokasi magang...",
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildItemsPerPageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Show:",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: itemsPerPage,
            underline: const SizedBox(),
            items: [5, 10, 50].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                itemsPerPage = newValue!;
                currentPage = 1;
                _updatePagination();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              searchQuery.isEmpty
                  ? "Data siswa kosong"
                  : "Tidak ada hasil untuk '$searchQuery'",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return DataTableWidget(
      users: paginatedUsers,
      currentPage: currentPage,
      itemsPerPage: itemsPerPage,
      onDetail: _showDetailModal,
      onEdit: _showEditModal,
      onDelete: _confirmDelete,
      onToggleStatus: _toggleUserStatus,
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Menampilkan ${((currentPage - 1) * itemsPerPage) + 1} - ${((currentPage - 1) * itemsPerPage) + paginatedUsers.length} dari ${filteredUsers.length} data",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: currentPage > 1
                    ? () => setState(() => currentPage--)
                    : null,
                icon: const Icon(Icons.chevron_left, size: 18),
                label: const Text("Previous"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green[700],
                  elevation: 0,
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$currentPage / $totalPages",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: currentPage < totalPages
                    ? () => setState(() => currentPage++)
                    : null,
                icon: const Icon(Icons.chevron_right, size: 18),
                label: const Text("Next"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green[700],
                  elevation: 0,
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailModal(User user) {
    showDialog(
      context: context,
      builder: (context) => DetailDialog(user: user),
    );
  }

  void _showEditModal(User user) {
    showDialog(
      context: context,
      builder: (context) => EditDialog(
        user: user,
        onSave: (updateData) async {
          try {
            await _apiService.updateUser(user.authUserId!, updateData);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Data ${updateData['nama']} berhasil diupdate',
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }

            fetchDataSiswa();
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal update: $e'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            rethrow;
          }
        },
      ),
    );
  }

  void _confirmDelete(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[700]),
            const SizedBox(width: 12),
            const Text("Konfirmasi Hapus"),
          ],
        ),
        content: Text(
          "Apakah Anda yakin ingin menghapus data siswa '${user.displayName}'?\n\nTindakan ini akan menghapus:\n• Data dari database\n• Folder dataset lokal\n• Semua foto training\n\nTindakan ini tidak dapat dibatalkan.",
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                await _apiService.deleteUser(user.authUserId!);

                Navigator.pop(context);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Data ${user.displayName} berhasil dihapus"),
                      backgroundColor: Colors.green[700],
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                fetchDataSiswa();
              } catch (e) {
                Navigator.pop(context);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Gagal menghapus: $e"),
                      backgroundColor: Colors.red[700],
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.delete),
            label: const Text("Hapus"),
          ),
        ],
      ),
    );
  }
}

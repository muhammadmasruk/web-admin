import 'package:flutter/material.dart';
import '../siswa/user_mode.dart';


class DataTableWidget extends StatelessWidget {
  final List<User> users;
  final int currentPage;
  final int itemsPerPage;
  final Function(User) onDetail;
  final Function(User) onEdit;
  final Function(User) onDelete;
  final Function(User, bool) onToggleStatus;

  const DataTableWidget({
    super.key,
    required this.users,
    required this.currentPage,
    required this.itemsPerPage,
    required this.onDetail,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: users.isEmpty
                ? const Center(child: Text("Tidak ada data"))
                : SingleChildScrollView(
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(60),
                        1: FixedColumnWidth(80),
                        2: FixedColumnWidth(120),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(1.5),
                        5: FlexColumnWidth(2),
                        6: FlexColumnWidth(1.5),
                        7: FixedColumnWidth(140),
                        8: FixedColumnWidth(180),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      children: List.generate(
                        users.length,
                        (i) => _buildTableRow(i),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[600]!],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(60),
          1: FixedColumnWidth(80),
          2: FixedColumnWidth(120),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(1.5),
          5: FlexColumnWidth(2),
          6: FlexColumnWidth(1.5),
          7: FixedColumnWidth(140),
          8: FixedColumnWidth(180),
        },
        children: [
          TableRow(
            children: [
              _buildHeaderCell("No", isWhite: true),
              _buildHeaderCell("Foto", isWhite: true),
              _buildHeaderCell("NIS", isWhite: true),
              _buildHeaderCell("Nama Siswa", isWhite: true),
              _buildHeaderCell("Jurusan", isWhite: true),
              _buildHeaderCell("Lokasi Magang", isWhite: true),
              _buildHeaderCell("Email", isWhite: true),
              _buildHeaderCell("Status", isWhite: true),
              _buildHeaderCell("Aksi", isWhite: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {bool isWhite = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: isWhite ? Colors.white : Colors.black87,
        ),
        textAlign: text == "No" || text == "Aksi" || text == "Foto" || text == "Status"
            ? TextAlign.center
            : TextAlign.left,
      ),
    );
  }

  TableRow _buildTableRow(int index) {
    final user = users[index];
    final actualIndex = (currentPage - 1) * itemsPerPage + index;
    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : Colors.grey[50],
      ),
      children: [
        _buildTableCell("${actualIndex + 1}", isCenter: true),
        _buildPhotoCell(user),
        _buildTableCell(user.nis ?? '-', isCenter: true),
        _buildTableCell(user.displayName ?? '-'),
        _buildTableCell(user.jurusan ?? '-'),
        _buildTableCell(user.lokasiMagang ?? '-'),
        _buildTableCell(user.email ?? '-'),
        _buildStatusCell(user),
        _buildActionCell(user),
      ],
    );
  }

  Widget _buildPhotoCell(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green[700]!,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: user.fotoUrl != null && user.fotoUrl != ''
                ? Image.network(
                    user.fotoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person, size: 25, color: Colors.grey[600]),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green[700]!,
                          ),
                        ),
                      );
                    },
                  )
                : Icon(Icons.person, size: 25, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isCenter = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        textAlign: isCenter ? TextAlign.center : TextAlign.left,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatusCell(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Center(
        child: Builder(
          builder: (BuildContext cellContext) {
            return InkWell(
              onTap: () => _showToggleConfirmation(cellContext, user),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: user.isActive ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: user.isActive ? Colors.green[300]! : Colors.red[300]!,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      user.isActive ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: user.isActive ? Colors.green[700] : Colors.red[700],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user.isActive ? "Aktif" : "Nonaktif",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: user.isActive ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showToggleConfirmation(BuildContext context, User user) {
    final newStatus = !user.isActive;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              newStatus ? Icons.check_circle : Icons.cancel,
              color: newStatus ? Colors.green[700] : Colors.red[700],
            ),
            const SizedBox(width: 12),
            Text(newStatus ? "Aktifkan Siswa" : "Nonaktifkan Siswa"),
          ],
        ),
        content: Text(
          "Apakah Anda yakin ingin ${newStatus ? 'mengaktifkan' : 'menonaktifkan'} akun siswa '${user.displayName}'?\n\n${newStatus ? 'Siswa akan dapat login ke aplikasi.' : 'Siswa tidak akan dapat login ke aplikasi.'}",
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal"),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus ? Colors.green[700] : Colors.red[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              onToggleStatus(user, newStatus);
            },
            icon: Icon(newStatus ? Icons.check : Icons.block),
            label: Text(newStatus ? "Aktifkan" : "Nonaktifkan"),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCell(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: IconButton(
              icon: const Icon(Icons.visibility, size: 18),
              color: Colors.green[700],
              onPressed: () => onDetail(user),
              tooltip: "Detail",
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, size: 18),
              color: Colors.blue[700],
              onPressed: () => onEdit(user),
              tooltip: "Edit",
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: IconButton(
              icon: const Icon(Icons.delete, size: 18),
              color: Colors.red[700],
              onPressed: () => onDelete(user),
              tooltip: "Hapus",
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
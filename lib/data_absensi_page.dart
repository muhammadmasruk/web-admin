import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class DataAbsensiPage extends StatefulWidget {
  const DataAbsensiPage({super.key});

  @override
  State<DataAbsensiPage> createState() => _DataAbsensiPageState();
}

class _DataAbsensiPageState extends State<DataAbsensiPage> {
  final String serverUrl = "https://unfoxed-kaycee-subcircular.ngrok-free.dev";
  List absensiList = [];
  List filteredAbsensi = [];
  bool isLoading = true;

  // Pagination
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPages = 1;

  // Search & Filter
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  String selectedKategori = "Semua";
  String selectedStatus = "Semua";
  DateTime? selectedDate;

  final List<String> kategoriOptions = ["Semua", "MASUK", "PULANG"];
  final List<String> statusOptions = [
    "Semua",
    "Hadir",
    "Terlambat",
    "Izin",
    "Sakit",
    "Alpha"
  ];

  @override
  void initState() {
    super.initState();
    fetchDataAbsensi();
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
      _filterAbsensi();
      currentPage = 1;
    });
  }

  void _filterAbsensi() {
    setState(() {
      filteredAbsensi = absensiList.where((absensi) {
        final name = (absensi['display_name'] ?? '').toString().toLowerCase();
        final matchSearch = searchQuery.isEmpty || name.contains(searchQuery);

        final status =
            (absensi['status_absensi'] ?? '').toString().toUpperCase();
        final selectedStatusUpper = selectedStatus.toUpperCase();
        final matchStatus =
            selectedStatus == "Semua" || status == selectedStatusUpper;

        // Filter Kategori (Masuk/Pulang)
        final kategori =
            (absensi['kategori'] ?? 'MASUK').toString().toUpperCase();
        final matchKategori =
            selectedKategori == "Semua" || kategori == selectedKategori;

        bool matchDate = true;
        if (selectedDate != null) {
          String formattedSelected =
              DateFormat('dd MMM yyyy').format(selectedDate!);
          matchDate = absensi['tanggal'] == formattedSelected;
        }

        return matchSearch && matchStatus && matchDate && matchKategori;
      }).toList();

      _updatePagination();
    });
  }

  void _updatePagination() {
    totalPages = (filteredAbsensi.length / itemsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;
    if (currentPage > totalPages) currentPage = totalPages;
  }

  List get paginatedAbsensi {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    if (startIndex >= filteredAbsensi.length) return [];
    return filteredAbsensi.sublist(
      startIndex,
      endIndex > filteredAbsensi.length ? filteredAbsensi.length : endIndex,
    );
  }

  Future<void> fetchDataAbsensi() async {
    setState(() => isLoading = true);
    try {
      // Header ngrok-skip-browser-warning ditambahkan agar tidak muncul halaman warning ngrok
      final res = await http.get(
        Uri.parse("$serverUrl/absensi/history"),
        headers: {
          "ngrok-skip-browser-warning": "true",
        },
      );
      final data = json.decode(res.body);

      setState(() {
        absensiList = data['data']['absensi'];
        filteredAbsensi = absensiList;
        _updatePagination();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching absensi: $e");
      setState(() => isLoading = false);
    }
  }

  String formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String formatDate(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String formatTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'Hadir':
        return Colors.green;
      case 'Terlambat':
        return Colors.orange;
      case 'Izin':
        return Colors.blue;
      case 'Sakit':
        return Colors.purple;
      case 'Alpha':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String? status) {
    switch (status) {
      case 'Hadir':
        return Icons.check_circle;
      case 'Terlambat':
        return Icons.access_time;
      case 'Izin':
        return Icons.info;
      case 'Sakit':
        return Icons.local_hospital;
      case 'Alpha':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(isMobile),
              const SizedBox(height: 20),
              _filterSection(isMobile),
              const SizedBox(height: 20),
              Expanded(child: _content(isMobile)),
              if (!isLoading && filteredAbsensi.isNotEmpty)
                _paginationControls(isMobile),
            ],
          ),
        );
      },
    );
  }

  Widget _header(bool isMobile) {
    return Row(
      children: [
        Icon(
          Icons.event_note,
          color: Colors.green[700],
          size: isMobile ? 24 : 28,
        ),
        const SizedBox(width: 12),
        Text(
          "Data Absensi",
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (!isMobile)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: fetchDataAbsensi,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              "Refresh Data",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
      ],
    );
  }

  Widget _filterSection(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _searchField(),
          const SizedBox(height: 12),
          _kategoriSelector(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _statusFilter()),
              const SizedBox(width: 8),
              Expanded(child: _dateFilter()),
            ],
          ),
          const SizedBox(height: 12),
          _itemsPerPageDropdown(),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 3, child: _searchField()),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: _statusFilter()),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: _dateFilter()),
            const SizedBox(width: 12),
            _itemsPerPageDropdown(),
          ],
        ),
        const SizedBox(height: 12),
        _kategoriSelector(),
      ],
    );
  }

  Widget _kategoriSelector() {
    return Row(
      children: kategoriOptions.map((kat) {
        bool isSelected = selectedKategori == kat;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(kat),
            selected: isSelected,
            selectedColor:
                kat == "PULANG" ? Colors.orange[700] : Colors.green[700],
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  selectedKategori = kat;
                  currentPage = 1;
                  _filterAbsensi();
                });
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _searchField() {
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
          hintText: "Cari nama siswa...",
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

  Widget _statusFilter() {
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
      child: DropdownButton<String>(
        value: selectedStatus,
        isExpanded: true,
        underline: const SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
        items: statusOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(
                  value == "Semua" ? Icons.filter_list : getStatusIcon(value),
                  size: 18,
                  color: value == "Semua"
                      ? Colors.grey[700]
                      : getStatusColor(value),
                ),
                const SizedBox(width: 8),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedStatus = newValue!;
            currentPage = 1;
            _filterAbsensi();
          });
        },
      ),
    );
  }

  Widget _dateFilter() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.green[700]!,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
            currentPage = 1;
            _filterAbsensi();
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          children: [
            Icon(Icons.calendar_today, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedDate == null
                    ? "Pilih Tanggal"
                    : DateFormat('dd/MM/yyyy').format(selectedDate!),
                style: TextStyle(
                  fontSize: 14,
                  color:
                      selectedDate == null ? Colors.grey[500] : Colors.black87,
                ),
              ),
            ),
            if (selectedDate != null)
              IconButton(
                icon: Icon(Icons.clear, size: 18, color: Colors.grey[600]),
                onPressed: () {
                  setState(() {
                    selectedDate = null;
                    currentPage = 1;
                    _filterAbsensi();
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _itemsPerPageDropdown() {
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

  Widget _content(bool isMobile) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (filteredAbsensi.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              searchQuery.isEmpty &&
                      selectedStatus == "Semua" &&
                      selectedDate == null &&
                      selectedKategori == "Semua"
                  ? "Data absensi kosong"
                  : "Tidak ada hasil yang ditemukan",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            if (searchQuery.isNotEmpty ||
                selectedStatus != "Semua" ||
                selectedDate != null ||
                selectedKategori != "Semua")
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      selectedStatus = "Semua";
                      selectedKategori = "Semua";
                      selectedDate = null;
                      _filterAbsensi();
                    });
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text("Reset Filter"),
                ),
              ),
          ],
        ),
      );
    }

    if (isMobile) {
      return _buildMobileView();
    }

    return _buildTableView();
  }

  Widget _buildMobileView() {
    return ListView.builder(
      itemCount: paginatedAbsensi.length,
      itemBuilder: (_, i) {
        final absensi = paginatedAbsensi[i];
        final status = absensi['status_absensi'] ?? '-';
        final kategori =
            (absensi['kategori'] ?? 'MASUK').toString().toUpperCase();
        final actualIndex = (currentPage - 1) * itemsPerPage + i;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showDetailModal(absensi),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: kategori == "PULANG"
                            ? Colors.orange[700]
                            : Colors.green[700],
                        child: Text(
                          "${actualIndex + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  absensi['nama_siswa'] ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kategori == "PULANG"
                                        ? Colors.orange[100]
                                        : Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    kategori,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: kategori == "PULANG"
                                          ? Colors.orange[900]
                                          : Colors.green[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatDateTime(absensi['waktu_absensi'] ?? ''),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              getStatusIcon(status),
                              size: 16,
                              color: getStatusColor(status),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status,
                              style: TextStyle(
                                color: getStatusColor(status),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.check_circle,
                        "Wajah: ${absensi['wajah_valid'] == true ? 'Valid' : 'Tidak Valid'}",
                        absensi['wajah_valid'] == true
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.location_on,
                        "Lokasi: ${absensi['lokasi_valid'] == true ? 'Valid' : 'Tidak Valid'}",
                        absensi['lokasi_valid'] == true
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 10, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTableView() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
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
                1: FlexColumnWidth(2),
                2: FixedColumnWidth(100),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.2),
                5: FlexColumnWidth(1),
                6: FlexColumnWidth(1),
                7: FixedColumnWidth(100),
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell("No", isWhite: true),
                    _buildHeaderCell("Nama Siswa", isWhite: true),
                    _buildHeaderCell("Kategori", isWhite: true),
                    _buildHeaderCell("Waktu", isWhite: true),
                    _buildHeaderCell("Status", isWhite: true),
                    _buildHeaderCell("Wajah", isWhite: true),
                    _buildHeaderCell("Lokasi", isWhite: true),
                    _buildHeaderCell("Detail", isWhite: true),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: paginatedAbsensi.isEmpty
                ? const Center(child: Text("Tidak ada data"))
                : SingleChildScrollView(
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(60),
                        1: FlexColumnWidth(2),
                        2: FixedColumnWidth(100),
                        3: FlexColumnWidth(1.5),
                        4: FlexColumnWidth(1.2),
                        5: FlexColumnWidth(1),
                        6: FlexColumnWidth(1),
                        7: FixedColumnWidth(100),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      children: List.generate(
                        paginatedAbsensi.length,
                        (i) => _buildTableRow(i),
                      ),
                    ),
                  ),
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
        textAlign: text == "No" || text == "Detail" || text == "Kategori"
            ? TextAlign.center
            : TextAlign.left,
      ),
    );
  }

  TableRow _buildTableRow(int index) {
    final absensi = paginatedAbsensi[index];
    final actualIndex = (currentPage - 1) * itemsPerPage + index;
    final status = absensi['status_absensi'] ?? '-';
    final kategori = (absensi['kategori'] ?? 'MASUK').toString().toUpperCase();

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : Colors.grey[50],
      ),
      children: [
        _buildTableCell("${actualIndex + 1}", isCenter: true),
        _buildTableCell(absensi['display_name'] ?? '-'),
        _buildTableCellWidget(
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kategori == "PULANG"
                    ? Colors.orange[100]
                    : Colors.green[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                kategori,
                style: TextStyle(
                  color: kategori == "PULANG"
                      ? Colors.orange[900]
                      : Colors.green[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        _buildTableCellWidget(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatDate(absensi['tanggal'] ?? ''),
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Text(
                formatTime(absensi['jam'] ?? ''),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        _buildTableCellWidget(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  getStatusIcon(status),
                  size: 14,
                  color: getStatusColor(status),
                ),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: getStatusColor(status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildTableCellWidget(
          Icon(
            absensi['wajah_valid'] == true ? Icons.check_circle : Icons.cancel,
            color: absensi['wajah_valid'] == true ? Colors.green : Colors.red,
            size: 20,
          ),
          isCenter: true,
        ),
        _buildTableCellWidget(
          Icon(
            absensi['lokasi_valid'] == true ? Icons.check_circle : Icons.cancel,
            color: absensi['lokasi_valid'] == true ? Colors.green : Colors.red,
            size: 20,
          ),
          isCenter: true,
        ),
        _buildTableCellWidget(
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                icon: const Icon(Icons.visibility, size: 18),
                color: Colors.blue[700],
                onPressed: () => _showDetailModal(absensi),
                tooltip: "Lihat Detail",
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isCenter = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        textAlign: isCenter ? TextAlign.center : TextAlign.left,
      ),
    );
  }

  Widget _buildTableCellWidget(Widget child, {bool isCenter = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: isCenter ? Center(child: child) : child,
    );
  }

  Widget _paginationControls(bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: isMobile ? _buildMobilePagination() : _buildDesktopPagination(),
    );
  }

  Widget _buildMobilePagination() {
    return Column(
      children: [
        Text(
          "Halaman $currentPage dari $totalPages",
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed:
                  currentPage > 1 ? () => setState(() => currentPage--) : null,
              icon: const Icon(Icons.chevron_left),
              color: Colors.green[700],
            ),
            const SizedBox(width: 16),
            Text(
              "$currentPage",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: currentPage < totalPages
                  ? () => setState(() => currentPage++)
                  : null,
              icon: const Icon(Icons.chevron_right),
              color: Colors.green[700],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Menampilkan ${paginatedAbsensi.length} dari ${filteredAbsensi.length} data",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDesktopPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Menampilkan ${((currentPage - 1) * itemsPerPage) + 1} - ${((currentPage - 1) * itemsPerPage) + paginatedAbsensi.length} dari ${filteredAbsensi.length} data",
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed:
                  currentPage > 1 ? () => setState(() => currentPage--) : null,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }

  void _showDetailModal(Map absensi) {
    final kategori = (absensi['kategori'] ?? 'MASUK').toString().toUpperCase();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kategori == "PULANG"
                      ? Colors.orange[700]
                      : Colors.green[700],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      "Detail Absensi - $kategori",
                      style: const TextStyle(
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
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (absensi['foto_url'] != null &&
                        absensi['foto_url'] != '')
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              absensi['foto_url'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 80),
                            ),
                          ),
                        ),
                      ),
                    _detailRow("Nama Siswa", absensi['nama_siswa'] ?? '-',
                        Icons.person),
                    _detailRow("Kategori", kategori, Icons.label,
                        color: kategori == "PULANG"
                            ? Colors.orange[700]
                            : Colors.green[700]),
                    _detailRow(
                        "Waktu Absensi",
                        formatDateTime(absensi['waktu_absensi'] ?? ''),
                        Icons.access_time),
                    _detailRow(
                        "Status", absensi['status_absensi'] ?? '-', Icons.info,
                        color: getStatusColor(absensi['status_absensi'])),
                    _detailRow(
                        "Validasi Wajah",
                        absensi['wajah_valid'] == true
                            ? 'Valid'
                            : 'Tidak Valid',
                        Icons.face,
                        color: absensi['wajah_valid'] == true
                            ? Colors.green
                            : Colors.red),
                    _detailRow(
                        "Validasi Lokasi",
                        absensi['lokasi_valid'] == true
                            ? 'Valid'
                            : 'Tidak Valid',
                        Icons.location_on,
                        color: absensi['lokasi_valid'] == true
                            ? Colors.green
                            : Colors.red),
                    _detailRow(
                        "Dibuat",
                        formatDateTime(absensi['created_at'] ?? ''),
                        Icons.calendar_today),
                  ],
                ),
              ),
              Container(
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
                        backgroundColor: kategori == "PULANG"
                            ? Colors.orange[700]
                            : Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          const Text("Tutup", style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey[600]),
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: color ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

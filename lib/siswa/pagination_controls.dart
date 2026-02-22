import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int itemsShowing;
  final int totalItems;
  final bool isMobile;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.itemsShowing,
    required this.totalItems,
    required this.isMobile,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: onPrevious,
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
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
              color: Colors.green[700],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Menampilkan $itemsShowing dari $totalItems data",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDesktopPagination() {
    final startIndex = ((currentPage - 1) * (totalItems ~/ totalPages)) + 1;
    final endIndex = startIndex + itemsShowing - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Menampilkan $startIndex - $endIndex dari $totalItems data",
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onPrevious,
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
              onPressed: onNext,
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
}
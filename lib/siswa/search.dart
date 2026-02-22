import 'package:flutter/material.dart';

class SearchAndFilterWidget extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final int itemsPerPage;
  final bool isMobile;
  final Function(int) onItemsPerPageChanged;

  const SearchAndFilterWidget({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.itemsPerPage,
    required this.isMobile,
    required this.onItemsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 12),
          _buildItemsPerPageDropdown(),
        ],
      );
    }

    return Row(
      children: [
        Expanded(flex: 2, child: _buildSearchField()),
        const SizedBox(width: 16),
        _buildItemsPerPageDropdown(),
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
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Cari nama siswa atau lokasi magang...",
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () {
                    searchController.clear();
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
              if (newValue != null) {
                onItemsPerPageChanged(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
}
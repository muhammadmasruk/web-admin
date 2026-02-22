import 'package:flutter/material.dart';
import 'data_siswa_page.dart';
import 'data_absensi_page.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void changePage(int index) {
    setState(() => selectedIndex = index);
    _animationController.reset();
    _animationController.forward();

    // Tutup drawer di mobile setelah memilih menu
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Deteksi apakah mobile atau desktop
        bool isMobile = constraints.maxWidth < 800;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey[50],

          // AppBar untuk mobile
          appBar: isMobile
              ? AppBar(
                  title: Text(_getPageTitle()),
                  backgroundColor: Colors.green[700],
                  elevation: 2,
                  leading: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                )
              : null,

          // Drawer untuk mobile
          drawer: isMobile ? _buildDrawer() : null,

          // Bottom Navigation untuk mobile
          bottomNavigationBar: isMobile ? _buildBottomNav() : null,

          body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        );
      },
    );
  }

  String _getPageTitle() {
    switch (selectedIndex) {
      case 0:
        return "Data Siswa";
      case 1:
        return "Data Absensi";
      default:
        return "Admin Panel";
    }
  }

  // Layout Desktop (dengan sidebar)
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildSidebar(),
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _getCurrentPage(),
          ),
        ),
      ],
    );
  }

  // Layout Mobile (tanpa sidebar)
  Widget _buildMobileLayout() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: _getCurrentPage(),
    );
  }

  Widget _getCurrentPage() {
    return selectedIndex == 0 ? const DataSiswaPage() : const DataAbsensiPage();
  }

  // ================= SIDEBAR (Desktop) =================
  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green[800]!, Colors.green[600]!],
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            "assets/logo.png",
            height: 150, // Tentukan tinggi agar tidak terlalu besar
            width: 150, // Tentukan lebar
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported,
                  color: Colors.white, size: 50);
            },
          ),
          const SizedBox(height: 30),
          _menuItem(Icons.people, "Data Siswa", 0),
          _menuItem(Icons.fact_check, "Data Absensi", 1),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("LOGOUT",
                style: TextStyle(color: Colors.white70, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  // ================= DRAWER (Mobile) =================
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[800]!, Colors.green[600]!],
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.admin_panel_settings,
                      color: Colors.white, size: 60),
                  SizedBox(height: 10),
                  Text(
                    "Admin Panel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _menuItem(Icons.people, "Data Siswa", 0),
            _menuItem(Icons.fact_check, "Data Absensi", 1),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= BOTTOM NAVIGATION (Mobile) =================
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: changePage,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: "Data Siswa",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fact_check),
          label: "Data Absensi",
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title, int index) {
    final isActive = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.green[800] : Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.green[800] : Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isActive ? Colors.white : const Color.fromARGB(0, 11, 5, 5),
      onTap: () => changePage(index),
    );
  }
}

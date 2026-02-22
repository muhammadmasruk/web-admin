import 'package:flutter/material.dart';
import '../siswa/user_mode.dart';

class EditDialog extends StatefulWidget {
  final User user;
  final Function(Map<String, dynamic>) onSave;

  const EditDialog({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController nisController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController jurusanController;
  late TextEditingController lokasiController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  final formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    nisController = TextEditingController(text: widget.user.nis);
    nameController = TextEditingController(text: widget.user.displayName);
    emailController = TextEditingController(text: widget.user.email);
    passwordController = TextEditingController(text: widget.user.password);
    jurusanController = TextEditingController(text: widget.user.jurusan);
    lokasiController = TextEditingController(text: widget.user.lokasiMagang);
    latitudeController =
        TextEditingController(text: widget.user.latitude?.toString() ?? '');
    longitudeController =
        TextEditingController(text: widget.user.longitude?.toString() ?? '');
  }

  @override
  void dispose() {
    nisController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    jurusanController.dispose();
    lokasiController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

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
          const Icon(Icons.edit, color: Colors.white),
          const SizedBox(width: 12),
          const Text(
            "Edit Data Siswa",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: isSubmitting ? null : () => Navigator.pop(context),
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormField(
              "NIS",
              nisController,
              Icons.badge,
              "Masukkan NIS siswa",
            ),
            const SizedBox(height: 16),
            _buildFormField(
              "Nama Siswa",
              nameController,
              Icons.person,
              "Masukkan nama siswa",
            ),
            const SizedBox(height: 16),
            _buildFormField(
              "Email",
              emailController,
              Icons.email,
              "Masukkan email",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildFormField(
              "Password",
              passwordController,
              Icons.lock,
              "Masukkan password",
              isPassword: true,
            ),
            const SizedBox(height: 16),
            _buildFormField(
              "Jurusan",
              jurusanController,
              Icons.school,
              "Masukkan jurusan",
            ),
            const SizedBox(height: 16),
            _buildFormField(
              "Lokasi Magang",
              lokasiController,
              Icons.business,
              "Masukkan lokasi magang",
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    "Latitude",
                    latitudeController,
                    Icons.location_on,
                    "Latitude",
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFormField(
                    "Longitude",
                    longitudeController,
                    Icons.location_on,
                    "Longitude",
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
          ],
        ),
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
          TextButton(
            onPressed: isSubmitting ? null : () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text(
              "Batal",
              style: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: isSubmitting ? null : _handleSubmit,
            icon: isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(
              isSubmitting ? "Menyimpan..." : "Simpan",
              style: const TextStyle(fontSize: 15),
            ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.blue[700]!,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _handleSubmit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });

      try {
        Map<String, dynamic> updateData = {
          "nis": nisController.text,
          "nama": nameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "jurusan": jurusanController.text,
          "lokasi_magang": lokasiController.text,
        };

        if (latitudeController.text.isNotEmpty) {
          updateData["latitude"] = double.tryParse(latitudeController.text);
        }
        if (longitudeController.text.isNotEmpty) {
          updateData["longitude"] = double.tryParse(longitudeController.text);
        }

        await widget.onSave(updateData);

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          isSubmitting = false;
        });
        rethrow;
      }
    }
  }
}
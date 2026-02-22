// import 'package:flutter/material.dart';
// import '../siswa/user_mode.dart';

// class MobileListWidget extends StatelessWidget {
//   final List<User> users;
//   final int currentPage;
//   final int itemsPerPage;
//   final Function(User) onDetail;
//   final Function(User) onEdit;
//   final Function(User) onDelete;
//   final Function(User, bool) onToggleStatus;

//   const MobileListWidget({
//     super.key,
//     required this.users,
//     required this.currentPage,
//     required this.itemsPerPage,
//     required this.onDetail,
//     required this.onEdit,
//     required this.onDelete,
//     required this.onToggleStatus,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: users.length,
//       itemBuilder: (_, i) {
//         final user = users[i];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: InkWell(
//             onTap: () => onDetail(user),
//             borderRadius: BorderRadius.circular(12),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       _buildAvatar(user),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildUserInfo(user),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   _buildStatusBadge(user, context),
//                   const SizedBox(height: 12),
//                   _buildActionButtons(user),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAvatar(User user) {
//     return Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: user.isActive ? Colors.green[700]! : Colors.grey[400]!,
//           width: 2,
//         ),
//       ),
//       child: ClipOval(
//         child: user.fotoUrl != null && user.fotoUrl != ''
//             ? Image.network(
//                 user.fotoUrl!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) =>
//                     Icon(Icons.person, size: 30, color: Colors.grey[600]),
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Center(
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Colors.green[700]!,
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : Icon(Icons.person, size: 30, color: Colors.grey[600]),
//       ),
//     );
//   }

//   Widget _buildUserInfo(User user) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           user.displayName ?? '-',
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Row(
//           children: [
//             Icon(Icons.badge, size: 14, color: Colors.grey[600]),
//             const SizedBox(width: 4),
//             Text(
//               'NIS: ${user.nis ?? '-'}',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 2),
//         Row(
//           children: [
//             Icon(Icons.school, size: 14, color: Colors.grey[600]),
//             const SizedBox(width: 4),
//             Text(
//               user.jurusan ?? '-',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 2),
//         Row(
//           children: [
//             Icon(Icons.business, size: 14, color: Colors.grey[600]),
//             const SizedBox(width: 4),
//             Expanded(
//               child: Text(
//                 user.lokasiMagang ?? '-',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusBadge(User user, BuildContext context) {
//     return InkWell(
//       onTap: () => _showToggleConfirmation(context, user),
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: user.isActive ? Colors.green[50] : Colors.red[50],
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: user.isActive ? Colors.green[300]! : Colors.red[300]!,
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               user.isActive ? Icons.check_circle : Icons.cancel,
//               size: 18,
//               color: user.isActive ? Colors.green[700] : Colors.red[700],
//             ),
//             const SizedBox(width: 8),
//             Text(
//               user.isActive ? "Status: Aktif" : "Status: Nonaktif",
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: user.isActive ? Colors.green[700] : Colors.red[700],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Icon(
//               Icons.touch_app,
//               size: 16,
//               color: user.isActive ? Colors.green[600] : Colors.red[600],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showToggleConfirmation(BuildContext context, User user) {
//     final newStatus = !user.isActive;
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(
//               newStatus ? Icons.check_circle : Icons.cancel,
//               color: newStatus ? Colors.green[700] : Colors.red[700],
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 newStatus ? "Aktifkan Siswa" : "Nonaktifkan Siswa",
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           "Apakah Anda yakin ingin ${newStatus ? 'mengaktifkan' : 'menonaktifkan'} akun siswa '${user.displayName}'?\n\n${newStatus ? 'Siswa akan dapat login ke aplikasi.' : 'Siswa tidak akan dapat login ke aplikasi.'}",
//           style: const TextStyle(fontSize: 14),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Batal"),
//           ),
//           ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: newStatus ? Colors.green[700] : Colors.red[700],
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               onToggleStatus(user, newStatus);
//             },
//             icon: Icon(newStatus ? Icons.check : Icons.block),
//             label: Text(newStatus ? "Aktifkan" : "Nonaktifkan"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(User user) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.visibility, size: 20),
//           color: Colors.green[700],
//           onPressed: () => onDetail(user),
//           tooltip: "Detail",
//         ),
//         IconButton(
//           icon: const Icon(Icons.edit, size: 20),
//           color: Colors.blue[700],
//           onPressed: () => onEdit(user),
//           tooltip: "Edit",
//         ),
//         IconButton(
//           icon: const Icon(Icons.delete, size: 20),
//           color: Colors.red[700],
//           onPressed: () => onDelete(user),
//           tooltip: "Hapus",
//         ),
//       ],
//     );
//   }
// }
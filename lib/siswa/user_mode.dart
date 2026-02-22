class User {
  final String? authUserId;
  final String? displayName;
  final String? email;
  final String? password;
  final String? jurusan;
  final String? lokasiMagang;
  final double? latitude;
  final double? longitude;
  final String? fotoUrl;
  final String? nis;
  final bool isActive;

  User({
    this.authUserId,
    this.displayName,
    this.email,
    this.password,
    this.jurusan,
    this.lokasiMagang,
    this.latitude,
    this.longitude,
    this.fotoUrl,
    this.nis,
    this.isActive = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      authUserId: json['auth_user_id'],
      displayName: json['display_name'],
      email: json['email'],
      password: json['password'],
      jurusan: json['jurusan'],
      lokasiMagang: json['lokasi_magang'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      fotoUrl: json['foto_url'],
      nis: json['nis'],
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auth_user_id': authUserId,
      'display_name': displayName,
      'email': email,
      'password': password,
      'jurusan': jurusan,
      'lokasi_magang': lokasiMagang,
      'latitude': latitude,
      'longitude': longitude,
      'foto_url': fotoUrl,
      'nis': nis,
      'is_active': isActive,
    };
  }

  Map<String, dynamic> toUpdateJson({
    String? nama,
    String? email,
    String? password,
    String? jurusan,
    String? lokasiMagang,
    double? latitude,
    double? longitude,
    String? nis,
    bool? isActive,
  }) {
    final data = <String, dynamic>{};
    
    if (nama != null) data['nama'] = nama;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    if (jurusan != null) data['jurusan'] = jurusan;
    if (lokasiMagang != null) data['lokasi_magang'] = lokasiMagang;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (nis != null) data['nis'] = nis;
    if (isActive != null) data['is_active'] = isActive;
    
    return data;
  }
}
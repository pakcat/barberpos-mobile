class AuthResponseDto {
  AuthResponseDto({
    required this.token,
    required this.refreshToken,
    required this.user,
    this.expiresAt,
  });

  final String token;
  final String refreshToken;
  final UserDto user;
  final DateTime? expiresAt;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      token: json['token']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      expiresAt: json['expiresAt'] != null ? DateTime.tryParse(json['expiresAt'].toString()) : null,
    );
  }
}

class UserDto {
  UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone = '',
    this.address = '',
    this.region = '',
    this.isGoogle = false,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String address;
  final String region;
  final bool isGoogle;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'manager',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      isGoogle: json['isGoogle'] == true,
    );
  }
}

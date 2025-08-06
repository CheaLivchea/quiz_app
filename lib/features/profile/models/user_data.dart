class UserData {
  final int id;
  final String? username;
  final String countryCode;
  final String phone;
  final String firstName;
  final String lastName;
  final String? status;
  final String? lastSeenAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    this.username,
    required this.countryCode,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.status,
    this.lastSeenAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      username: json['username'],
      countryCode: json['countryCode'] ?? '',
      phone: json['phone'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      status: json['status'],
      lastSeenAt: json['lastSeenAt'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Helper method to get display name
  String get displayName {
    if (username != null && username!.isNotEmpty) {
      return username!;
    }
    return '$firstName $lastName'.trim();
  }

  // Helper method to get full name
  String get fullName {
    return '$firstName $lastName'.trim();
  }

  // Helper method to get phone with country code
  String get fullPhone {
    return '+$countryCode $phone';
  }

  // Helper method to get phone with country name
  String get formattedPhone {
    String countryName = _getCountryName(countryCode);
    return '+$countryCode $phone ($countryName)';
  }

  // Helper method to get country name from code
  String _getCountryName(String code) {
    switch (code) {
      case '855':
        return 'Cambodia';
      case '1':
        return 'USA';
      case '86':
        return 'China';
      case '81':
        return 'Japan';
      case '82':
        return 'South Korea';
      case '66':
        return 'Thailand';
      case '84':
        return 'Vietnam';
      default:
        return 'Unknown';
    }
  }
}

import 'dart:convert';

class AuthSession {
  const AuthSession({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    required this.onboardingComplete,
    this.startupName,
    this.startupIndustry,
    this.startupStage,
    this.startupTagline,
    this.startupCountry,
    this.startupCity,
    this.username,
    this.dateOfBirth,
    this.gender,
    this.country,
    this.city,
    this.profilePhotoLabel,
    this.profilePhotoPath,
  });

  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String role;
  final bool onboardingComplete;
  final String? startupName;
  final String? startupIndustry;
  final String? startupStage;
  final String? startupTagline;
  final String? startupCountry;
  final String? startupCity;
  final String? username;
  final String? dateOfBirth;
  final String? gender;
  final String? country;
  final String? city;
  final String? profilePhotoLabel;
  final String? profilePhotoPath;

  bool get isStartupRole => role == 'Founder' || role == 'Company';

  AuthSession copyWith({
    String? fullName,
    String? email,
    String? password,
    String? phone,
    String? role,
    bool? onboardingComplete,
    String? startupName,
    String? startupIndustry,
    String? startupStage,
    String? startupTagline,
    String? startupCountry,
    String? startupCity,
    String? username,
    String? dateOfBirth,
    String? gender,
    String? country,
    String? city,
    String? profilePhotoLabel,
    String? profilePhotoPath,
  }) {
    return AuthSession(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      startupName: startupName ?? this.startupName,
      startupIndustry: startupIndustry ?? this.startupIndustry,
      startupStage: startupStage ?? this.startupStage,
      startupTagline: startupTagline ?? this.startupTagline,
      startupCountry: startupCountry ?? this.startupCountry,
      startupCity: startupCity ?? this.startupCity,
      username: username ?? this.username,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      city: city ?? this.city,
      profilePhotoLabel: profilePhotoLabel ?? this.profilePhotoLabel,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'onboardingComplete': onboardingComplete,
      'startupName': startupName,
      'startupIndustry': startupIndustry,
      'startupStage': startupStage,
      'startupTagline': startupTagline,
      'startupCountry': startupCountry,
      'startupCity': startupCity,
      'username': username,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'country': country,
      'city': city,
      'profilePhotoLabel': profilePhotoLabel,
      'profilePhotoPath': profilePhotoPath,
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? 'Professional',
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      startupName: json['startupName'] as String?,
      startupIndustry: json['startupIndustry'] as String?,
      startupStage: json['startupStage'] as String?,
      startupTagline: json['startupTagline'] as String?,
      startupCountry: json['startupCountry'] as String?,
      startupCity: json['startupCity'] as String?,
      username: json['username'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      profilePhotoLabel: json['profilePhotoLabel'] as String?,
      profilePhotoPath: json['profilePhotoPath'] as String?,
    );
  }

  String toEncodedJson() => jsonEncode(toJson());

  factory AuthSession.fromEncodedJson(String encoded) {
    return AuthSession.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
  }
}

import 'package:flutter/foundation.dart';
import '../../../shared/enums/app_enums.dart';

class SignUpState {
  const SignUpState({
    this.currentStep = 0,
    this.selectedRole = UserRole.founder,
    this.selectedGender = 'Male',
    this.dateOfBirth,
    this.profilePhotoPath,
    this.profilePhotoBytes,
    this.photoUploaded = false,
    this.photoLabel = 'Upload Photo',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  });

  final int currentStep;
  final UserRole selectedRole;
  final String selectedGender;
  final DateTime? dateOfBirth;
  final String? profilePhotoPath;
  final Uint8List? profilePhotoBytes;
  final bool photoUploaded;
  final String photoLabel;
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  String get passwordStatusText {
    if (profilePhotoBytes != null) return '$photoLabel • Tap to change';
    if (photoUploaded) return 'Photo ready • Tap to change';
    return 'Optional • JPG or PNG • Max 5 MB';
  }

  String get roleButtonText =>
      selectedRole.isStartupRole ? 'Create Startup' : 'Complete Registration';

  SignUpState copyWith({
    int? currentStep,
    UserRole? selectedRole,
    String? selectedGender,
    DateTime? dateOfBirth,
    String? profilePhotoPath,
    Uint8List? profilePhotoBytes,
    bool? photoUploaded,
    String? photoLabel,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
  }) {
    return SignUpState(
      currentStep: currentStep ?? this.currentStep,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedGender: selectedGender ?? this.selectedGender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      profilePhotoBytes: profilePhotoBytes ?? this.profilePhotoBytes,
      photoUploaded: photoUploaded ?? this.photoUploaded,
      photoLabel: photoLabel ?? this.photoLabel,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }
}

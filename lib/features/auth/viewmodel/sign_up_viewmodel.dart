import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../shared/enums/app_enums.dart';
import 'sign_up_state.dart';

class SignUpViewModel extends StateNotifier<SignUpState> {
  SignUpViewModel() : super(const SignUpState());

  void setCurrentStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  bool goToNextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
      return true;
    }
    return false;
  }

  bool goToPreviousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
      return true;
    }
    return false;
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

  void selectRole(UserRole role) {
    state = state.copyWith(selectedRole: role);
  }

  void selectGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }

  void setDateOfBirth(DateTime picked) {
    state = state.copyWith(dateOfBirth: picked);
  }

  void selectCountry(String country) {
    // Country selection handled by UI
  }

  Future<void> pickPhoto(ImageSource source, {void Function()? onCameraUnsupported}) async {
    if (kIsWeb && source == ImageSource.camera) {
      onCameraUnsupported?.call();
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (pickedFile == null) return;

    final bytes = await pickedFile.readAsBytes();

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final persistentFile = File('${dir.path}/$fileName');
    await persistentFile.writeAsBytes(bytes);

    state = state.copyWith(
      profilePhotoPath: persistentFile.path,
      profilePhotoBytes: bytes,
      photoUploaded: true,
      photoLabel: source == ImageSource.camera ? 'Photo captured' : 'Photo selected',
    );
  }

  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

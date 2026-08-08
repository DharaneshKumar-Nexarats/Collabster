import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../shared/enums/app_enums.dart';

class SignUpViewModel extends ChangeNotifier {
  int _currentStep = 0;
  int get currentStep => _currentStep;

  UserRole _selectedRole = UserRole.founder;
  UserRole get selectedRole => _selectedRole;

  String _selectedGender = 'Male';
  String get selectedGender => _selectedGender;

  DateTime? _dateOfBirth;
  DateTime? get dateOfBirth => _dateOfBirth;

  String? _profilePhotoPath;
  String? get profilePhotoPath => _profilePhotoPath;

  Uint8List? _profilePhotoBytes;
  Uint8List? get profilePhotoBytes => _profilePhotoBytes;

  bool _photoUploaded = false;
  bool get photoUploaded => _photoUploaded;

  String _photoLabel = 'Upload Photo';
  String get photoLabel => _photoLabel;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  String get passwordStatusText {
    if (_profilePhotoBytes != null) return '$_photoLabel • Tap to change';
    if (_photoUploaded) return 'Photo ready • Tap to change';
    return 'Optional • JPG or PNG • Max 5 MB';
  }

  String get roleButtonText =>
      _selectedRole.isStartupRole ? 'Create Startup' : 'Complete Registration';

  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  bool goToNextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool goToPreviousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
      return true;
    }
    return false;
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void selectGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void setDateOfBirth(DateTime picked) {
    _dateOfBirth = picked;
    notifyListeners();
  }

  void selectCountry(String country) {
    notifyListeners();
  }

  Future<void> pickPhoto(ImageSource source, {VoidCallback? onCameraUnsupported}) async {
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

    // Save bytes to a persistent file in app documents directory
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final persistentFile = File('${dir.path}/$fileName');
    await persistentFile.writeAsBytes(bytes);

    _profilePhotoPath = persistentFile.path;
    _profilePhotoBytes = bytes;
    _photoUploaded = true;
    _photoLabel = source == ImageSource.camera ? 'Photo captured' : 'Photo selected';
    notifyListeners();
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

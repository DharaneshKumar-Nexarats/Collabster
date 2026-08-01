import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/view/home_screen.dart';
import '../../startup/startup.dart';
import '../model/auth_session.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(
    text: 'United States',
  );
  final TextEditingController _cityController = TextEditingController();
  int _currentStep = 0;
  String _selectedRole = 'Founder';
  String _selectedGender = 'Male';
  DateTime? _dateOfBirth;
  String? _profilePhotoPath;
  Uint8List? _profilePhotoBytes;
  bool _photoUploaded = false;
  String _photoLabel = 'Upload Photo';

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeRegistration();
    }
  }

  Future<void> _completeRegistration() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Complete the basic details before finishing registration.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    await ref.read(authViewModelProvider.notifier).signUp(
      AuthSession(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        role: _selectedRole,
        onboardingComplete: true,
        username: _usernameController.text.trim().isEmpty
            ? null
            : _usernameController.text.trim(),
        dateOfBirth: _dateOfBirth?.toIso8601String(),
        gender: _selectedGender,
        country: _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
        city: _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
        profilePhotoLabel: _photoUploaded ? _photoLabel : null,
        profilePhotoPath: _profilePhotoPath,
      ),
    );

    if (!mounted) {
      return;
    }

    final isStartupRole =
        _selectedRole == 'Founder' || _selectedRole == 'Company';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (isStartupRole) {
            return StartupLandingScreen(selectedRole: _selectedRole);
          }

          return const HomeScreen();
        },
      ),
    );
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  _buildBasicDetailsStep(),
                  _buildPersonalDetailsStep(),
                  _buildRoleSelectionStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? AppColors.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Your Account',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Let's begin with your basic details.",
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _buildTextFieldLabel('Full Name'),
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              hintText: 'John Doe',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Email Address'),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'name@company.com',
              prefixIcon: Icon(Icons.mail_outline),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Phone Number'),
          Row(
            children: [
              Container(
                width: 90,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 56,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🇮🇳 +91'), // Placeholder for country code picker
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(hintText: '(555) 000-0000'),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Password'),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Confirm Password'),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              hintText: 'Re-enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _nextStep,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Continue'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tell us a bit more about yourself.",
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          Center(
            child: GestureDetector(
              onTap: _showPhotoOptions,
              child: Column(
                children: [
                  Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: _photoUploaded
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF5B21B6),
                                    Color(0xFF8B5CF6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: _photoUploaded ? null : AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: _profilePhotoBytes != null
                              ? ClipOval(
                                  child: Image.memory(
                                    _profilePhotoBytes!,
                                    width: 84,
                                    height: 84,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : _photoUploaded
                              ? Text(
                                  _fullNameController.text.trim().isEmpty
                                      ? 'U'
                                      : _fullNameController.text
                                            .trim()[0]
                                            .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _photoLabel,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _profilePhotoBytes != null
                        ? '$_photoLabel • Tap to change'
                        : _photoUploaded
                        ? 'Photo ready • Tap to change'
                        : 'Optional • JPG or PNG • Max 5 MB',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildTextFieldLabel('Username'),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: '@alex_designer',
              suffixIcon: Icon(Icons.check_circle, color: AppColors.success),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Only letters, numbers and underscores',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFieldLabel('Date of Birth'),
                    TextFormField(
                      controller: _dobController,
                      decoration: const InputDecoration(
                        hintText: 'Select date',
                        suffixIcon: Icon(Icons.calendar_today, size: 20),
                      ),
                      readOnly: true,
                      onTap: _pickDateOfBirth,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFieldLabel('Age'),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(hintText: '0'),
                      enabled: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Gender'),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _buildGenderOption(
                      Icons.male,
                      'Male',
                      _selectedGender == 'Male',
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _buildGenderOption(
                      Icons.female,
                      'Female',
                      _selectedGender == 'Female',
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _buildGenderOption(
                      Icons.transgender,
                      'Non-Binary',
                      _selectedGender == 'Non-Binary',
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _buildGenderOption(
                      Icons.visibility_off,
                      'Prefer Not\nTo Say',
                      _selectedGender == 'Prefer Not To Say',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Country'),
          TextFormField(
            controller: _countryController,
            decoration: const InputDecoration(
              hintText: 'Select your country',
              suffixIcon: Icon(Icons.keyboard_arrow_down),
            ),
            readOnly: true,
            onTap: _selectCountry,
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('City'),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(hintText: 'Enter your city'),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelectionStep() {
    final roles = [
      {
        'title': 'Student',
        'desc': 'Learning and building skills',
        'icon': Icons.school,
      },
      {
        'title': 'Professional',
        'desc': 'Working professional or employee',
        'icon': Icons.work,
      },
      {
        'title': 'Founder',
        'desc': 'Building my own startup',
        'icon': Icons.rocket_launch,
      },
      {
        'title': 'Company',
        'desc': 'Managing a company',
        'icon': Icons.business,
      },
      {
        'title': 'Investor',
        'desc': 'Investing in opportunities',
        'icon': Icons.attach_money,
      },
      {
        'title': 'Creator',
        'desc': 'Investing content and value',
        'icon': Icons.palette,
      },
      {
        'title': 'Mentor',
        'desc': 'Guiding and mentoring others',
        'icon': Icons.psychology,
      },
      {
        'title': 'Influencer',
        'desc': 'Inspiring and influencing people',
        'icon': Icons.star,
      },
      {
        'title': 'Service Provider',
        'desc': 'Offering professional services',
        'icon': Icons.handyman,
      },
      {'title': 'Other', 'desc': 'Something else', 'icon': Icons.more_horiz},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Choose Your Primary Role',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Select the role that best represents you.",
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: roles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final role = roles[index];
              final title = role['title'] as String;
              final isSelected = _selectedRole == title;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRole = title;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        role['icon'] as IconData,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role['desc'] as String,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _nextStep,
            child: Text(
              _selectedRole == 'Founder' || _selectedRole == 'Company'
                  ? 'Create Startup'
                  : 'Complete Registration',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildGenderOption(IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = label.replaceAll('\n', ' ');
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.background,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final initialDate =
        _dateOfBirth ?? DateTime(now.year - 25, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 80),
      lastDate: DateTime(now.year - 10),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _dateOfBirth = picked;
      _dobController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      _ageController.text = _calculateAge(picked).toString();
    });
  }

  Future<void> _selectCountry() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final countries = [
          'United States',
          'India',
          'United Kingdom',
          'Canada',
          'Australia',
        ];

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Country',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...countries.map(
                (country) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(country),
                  trailing: _countryController.text == country
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () => Navigator.pop(sheetContext, country),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _countryController.text = selected;
    });
  }

  Future<void> _showPhotoOptions() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Profile Photo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pick a photo from your gallery or camera.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _photoChoiceTile(
                label: 'Choose from gallery',
                subtitle: 'Select an existing photo from your device',
                icon: Icons.photo_library_outlined,
                onTap: () => Navigator.pop(sheetContext, 'gallery'),
              ),
              const SizedBox(height: 12),
              _photoChoiceTile(
                label: 'Take a photo',
                subtitle: 'Open the camera and capture a new image',
                icon: Icons.photo_camera_outlined,
                onTap: () => Navigator.pop(sheetContext, 'camera'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(sheetContext),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }

    if (selected == 'gallery') {
      await _pickPhoto(ImageSource.gallery);
      return;
    }

    if (selected == 'camera') {
      await _pickPhoto(ImageSource.camera);
    }
  }

  Widget _photoChoiceTile({
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      if (kIsWeb && source == ImageSource.camera) {
        _showMessage(
          'Camera capture is not supported on web. Please choose from gallery.',
        );
        return;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (pickedFile == null) {
        return;
      }

      final bytes = await pickedFile.readAsBytes();

      setState(() {
        _profilePhotoPath = pickedFile.path;
        _profilePhotoBytes = bytes;
        _photoUploaded = true;
        _photoLabel = source == ImageSource.camera
            ? 'Photo captured'
            : 'Photo selected';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage(
        'Could not open ${source == ImageSource.camera ? 'camera' : 'gallery'}.',
      );
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

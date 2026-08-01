import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/views/home_screen.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
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
                color: index <= _currentStep ? AppColors.primary : Colors.grey.shade300,
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
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            "Let's begin with your basic details.",
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _buildTextFieldLabel('Full Name'),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'John Doe',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Email Address'),
          TextFormField(
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
                  decoration: const InputDecoration(
                    hintText: '(555) 000-0000',
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Password'),
          TextFormField(
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Confirm Password'),
          TextFormField(
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              hintText: 'Re-enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
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
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tell us a bit more about yourself.",
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.secondary,
                      child: const Icon(Icons.person, size: 40, color: AppColors.primary),
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
                        child: const Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upload Photo',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Optional • JPG or PNG • Max 5 MB',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildTextFieldLabel('Username'),
          TextFormField(
            decoration: const InputDecoration(
              hintText: '@alex_designer',
              suffixIcon: Icon(Icons.check_circle, color: AppColors.success),
            ),
          ),
          const SizedBox(height: 4),
          Text('Only letters, numbers and underscores', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
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
                      decoration: const InputDecoration(
                        hintText: 'Select date',
                        suffixIcon: Icon(Icons.calendar_today, size: 20),
                      ),
                      readOnly: true,
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
                      decoration: const InputDecoration(
                        hintText: '0',
                      ),
                      enabled: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Gender'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGenderOption(Icons.male, 'Male', true),
              _buildGenderOption(Icons.female, 'Female', false),
              _buildGenderOption(Icons.transgender, 'Non-\nBinary', false),
              _buildGenderOption(Icons.visibility_off, 'Prefer Not\nTo Say', false),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('Country'),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Select your country',
              suffixIcon: Icon(Icons.keyboard_arrow_down),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16),
          _buildTextFieldLabel('City'),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your city',
            ),
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
      {'title': 'Student', 'desc': 'Learning and building skills', 'icon': Icons.school},
      {'title': 'Professional', 'desc': 'Working professional or employee', 'icon': Icons.work},
      {'title': 'Founder', 'desc': 'Building my own startup', 'icon': Icons.rocket_launch},
      {'title': 'Company', 'desc': 'Managing a company', 'icon': Icons.business},
      {'title': 'Investor', 'desc': 'Investing in opportunities', 'icon': Icons.attach_money},
      {'title': 'Creator', 'desc': 'Investing content and value', 'icon': Icons.palette},
      {'title': 'Mentor', 'desc': 'Guiding and mentoring others', 'icon': Icons.psychology},
      {'title': 'Influencer', 'desc': 'Inspiring and influencing people', 'icon': Icons.star},
      {'title': 'Service Provider', 'desc': 'Offering professional services', 'icon': Icons.handyman},
      {'title': 'Other', 'desc': 'Something else', 'icon': Icons.more_horiz},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Choose Your Primary Role',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
              return Container(
                decoration: BoxDecoration(
                  color: index == 0 ? AppColors.secondary : AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: index == 0 ? AppColors.primary : AppColors.border,
                    width: index == 0 ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(roles[index]['icon'] as IconData, color: AppColors.primary, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      roles[index]['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      roles[index]['desc'] as String,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _nextStep,
            child: const Text('Complete Registration'),
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : AppColors.background,
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
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
    );
  }
}

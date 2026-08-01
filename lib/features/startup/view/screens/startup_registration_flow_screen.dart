import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/startup_models.dart';
import '../../../auth/viewmodel/auth_viewmodel.dart';
import 'startup_success_screen.dart';

class StartupRegistrationFlowScreen extends ConsumerStatefulWidget {
  const StartupRegistrationFlowScreen({
    super.key,
    this.selectedRole = 'Founder',
  });

  final String selectedRole;

  @override
  ConsumerState<StartupRegistrationFlowScreen> createState() =>
      _StartupRegistrationFlowScreenState();
}

class _StartupRegistrationFlowScreenState
    extends ConsumerState<StartupRegistrationFlowScreen> {
  static const int _totalSteps = 8;

  final PageController _pageController = PageController();
  final TextEditingController _startupNameController = TextEditingController();
  final TextEditingController _taglineController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(
    text: 'United States',
  );
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _founderNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController(
    text: 'https://yourstartup.com',
  );
  final TextEditingController _incorporationController =
      TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _solutionController = TextEditingController();
  final TextEditingController _missionController = TextEditingController();
  final TextEditingController _visionController = TextEditingController();
  final TextEditingController _socialWebsiteController = TextEditingController(
    text: 'https://acme.ai',
  );
  final TextEditingController _socialLinkedInController = TextEditingController(
    text: 'linkedin.com/acme',
  );
  final TextEditingController _socialProductHuntController =
      TextEditingController(text: 'producthunt.com/acme');
  final TextEditingController _inviteEmailController = TextEditingController();
  final TextEditingController _useOfFundsController = TextEditingController();

  int _currentStep = 0;
  String _selectedStage = 'Seed';
  String _selectedTeamSize = '1-5';
  String _selectedFundingStage = 'Seed';
  String _selectedInviteRole = 'Founder';
  String _selectedVisibility = 'Public';
  bool _currentlyRaising = true;
  double _yearsOfExperience = 5;

  final List<String> _skillTags = const [
    'Leadership',
    'AI',
    'Marketing',
    'Sales',
    'Engineering',
    'Finance',
    'Design',
    'Operations',
    'Product',
  ];

  final Set<String> _selectedSkills = {'Leadership', 'AI', 'Product'};

  final List<StartupMember> _members = [
    StartupMember(
      name: 'Sarah Jenkins',
      role: 'CEO & Co-founder',
      status: 'Active',
      initials: 'SJ',
    ),
    StartupMember(
      name: 'Marcus Zhao',
      role: 'Lead Developer',
      status: 'Invite Sent',
      initials: 'MZ',
    ),
  ];

  final List<String> _fundingStages = const [
    'Bootstrapped',
    'Angel',
    'Pre-Seed',
    'Seed',
    'Series A',
    'Series B',
  ];

  final List<String> _visibilityOptions = const [
    'Public',
    'Private',
    'Invite Only',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _startupNameController.dispose();
    _taglineController.dispose();
    _industryController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _founderNameController.dispose();
    _designationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _linkedinController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _incorporationController.dispose();
    _shortDescriptionController.dispose();
    _problemController.dispose();
    _solutionController.dispose();
    _missionController.dispose();
    _visionController.dispose();
    _socialWebsiteController.dispose();
    _socialLinkedInController.dispose();
    _socialProductHuntController.dispose();
    _inviteEmailController.dispose();
    _useOfFundsController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
      return;
    }

    _publishStartup();
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
      return;
    }

    Navigator.pop(context);
  }

  void _showCountryPicker() {
    final countries = [
      'United States',
      'United Kingdom',
      'Canada',
      'Australia',
      'India',
      'Germany',
      'France',
      'Singapore',
      'Japan',
      'Brazil',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Country',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      title: Text(
                        country,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        setState(() {
                          _countryController.text = country;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _publishStartup() async {
    final startupName = _startupNameController.text.trim();
    if (startupName.isEmpty) {
      _showComingSoon('Enter your startup name before publishing');
      return;
    }

    // Save the profile before showing the confirmation screen so it survives
    // an app restart or an interrupted completion screen.
    await ref.read(authViewModelProvider.notifier).updateStartupData(
      startupName: startupName,
      industry: _industryController.text.trim(),
      stage: _selectedStage,
      tagline: _taglineController.text.trim(),
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StartupSuccessScreen(
          startupName: startupName,
          selectedRole: widget.selectedRole,
          completion: 65,
          industry: _industryController.text.trim(),
          stage: _selectedStage,
          tagline: _taglineController.text.trim(),
          country: _countryController.text.trim(),
          city: _cityController.text.trim(),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature is coming soon.')));
  }

  void _inviteTeamMember() {
    final email = _inviteEmailController.text.trim();
    if (email.isEmpty) {
      _showComingSoon('Enter an email address first');
      return;
    }

    setState(() {
      _members.insert(
        0,
        StartupMember(
          name: email.split('@').first,
          role: _selectedInviteRole,
          status: 'Invite Sent',
          initials: email.isNotEmpty ? email[0].toUpperCase() : 'U',
        ),
      );
      _inviteEmailController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Invitation sent to $email')));
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentStep + 1) / _totalSteps;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5B21B6)),
          onPressed: _goToPreviousStep,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step ${_currentStep + 1} of $_totalSteps',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5B6272),
                    ),
                  ),
                  Text(
                    '${((progress * 100).round())}% Complete',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5B21B6),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE9DCF9),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF5B21B6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
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
                  _buildBasicInformationStep(),
                  _buildFounderInformationStep(),
                  _buildStartupDetailsStep(),
                  _buildBrandingStep(),
                  _buildSocialLinksStep(),
                  _buildTeamMembersStep(),
                  _buildFundingStep(),
                  _buildReviewStep(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFD9D5E9))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _goToPreviousStep,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    foregroundColor: const Color(0xFF3B3B4F),
                    side: const BorderSide(color: Color(0xFFB7B5C9)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(_currentStep == 0 ? 'Back' : 'Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _goToNextStep,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    elevation: 0,
                    backgroundColor: const Color(0xFF5B21B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _currentStep == _totalSteps - 1 ? 'Publish' : 'Next Step',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepScaffold({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD8D4E9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _field({
    required String label,
    required String hint,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3E4351),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
        ),
      ],
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFFE4DAFF),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: selected ? const Color(0xFF5B21B6) : const Color(0xFF3C4251),
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: selected ? const Color(0xFF5B21B6) : const Color(0xFFD4D6E2),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }

  Widget _teamSizeChip(String label) {
    final selected = _selectedTeamSize == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTeamSize = label;
        });
      },
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE4DAFF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF5B21B6) : const Color(0xFFD4D6E2),
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: selected ? const Color(0xFF5B21B6) : const Color(0xFF30384A),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInformationStep() {
    return _buildStepScaffold(
      title: 'Create Your Startup',
      subtitle: 'Let\'s begin with your startup\'s basic identity.',
      child: _sectionCard(
        child: Column(
          children: [
            _field(
              label: 'Startup Name',
              hint: 'e.g. Phoenix Analytics',
              controller: _startupNameController,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Tagline',
              hint: 'A short, catchy description of what you do',
              controller: _taglineController,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Industry',
              hint: 'e.g. FinTech, AI, Health',
              controller: _industryController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _field(
                    label: 'Country',
                    hint: 'United States',
                    controller: _countryController,
                    readOnly: true,
                    onTap: _showCountryPicker,
                    suffixIcon: const Icon(
                      Icons.public,
                      color: Color(0xFF5B21B6),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    label: 'City',
                    hint: 'e.g. San Francisco',
                    controller: _cityController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedStage,
              items: const [
                DropdownMenuItem(value: 'Idea', child: Text('Idea')),
                DropdownMenuItem(value: 'Prototype', child: Text('Prototype')),
                DropdownMenuItem(value: 'Seed', child: Text('Seed')),
                DropdownMenuItem(value: 'Growth', child: Text('Growth')),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedStage = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Startup Stage',
                hintText: 'Select stage',
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Team Size',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3E4351),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.3,
              children: [
                _teamSizeChip('1-5'),
                _teamSizeChip('5-10'),
                _teamSizeChip('10-25'),
                _teamSizeChip('25-50'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFounderInformationStep() {
    return _buildStepScaffold(
      title: 'Founder Information',
      subtitle: 'Tell investors who you are and your professional background.',
      child: _sectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: const Color(0xFFE8DBFF),
                        child: const Icon(
                          Icons.person_outline,
                          size: 38,
                          color: Color(0xFF5B21B6),
                        ),
                      ),
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: const Color(0xFF5B21B6),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 12,
                          splashRadius: 14,
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () => _showComingSoon('Photo upload'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _showComingSoon('Upload photo'),
                    child: const Text('Upload Photo'),
                  ),
                ],
              ),
            ),
            _field(
              label: 'Founder Name *',
              hint: 'Enter full name',
              controller: _founderNameController,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Designation *',
              hint: 'e.g. CEO & Co-founder',
              controller: _designationController,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Professional Email *',
              hint: 'name@company.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Phone Number',
              hint: '+1 (555) 000-0000',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'LinkedIn URL',
              hint: 'linkedin.com/in/username',
              controller: _linkedinController,
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Years of Experience',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3E4351),
                  ),
                ),
                Text(
                  '${_yearsOfExperience.toInt()} years',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5B21B6),
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(
                context,
              ).copyWith(activeTrackColor: const Color(0xFF5B21B6)),
              child: Slider(
                value: _yearsOfExperience,
                min: 0,
                max: 30,
                divisions: 30,
                onChanged: (value) {
                  setState(() {
                    _yearsOfExperience = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 4),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Key Skills',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3E4351),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skillTags
                  .map(
                    (skill) =>
                        _chip(skill, _selectedSkills.contains(skill), () {
                          setState(() {
                            if (_selectedSkills.contains(skill)) {
                              _selectedSkills.remove(skill);
                            } else {
                              _selectedSkills.add(skill);
                            }
                          });
                        }),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Short Bio',
              hint: 'Briefly describe your background...',
              controller: _bioController,
              maxLines: 5,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tell investors who you are and your professional background.',
              style: TextStyle(fontSize: 12, color: Color(0xFF707784)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartupDetailsStep() {
    return _buildStepScaffold(
      title: 'Tell us about your startup',
      subtitle:
          'Help us understand your mission and the problems you are solving.',
      child: _sectionCard(
        child: Column(
          children: [
            _field(
              label: 'Website',
              hint: 'https://yourstartup.com',
              controller: _websiteController,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Incorporation Date',
              hint: 'MM / YYYY',
              controller: _incorporationController,
              suffixIcon: const Icon(Icons.calendar_month_outlined),
            ),
            const SizedBox(height: 18),
            _field(
              label: 'Short Description',
              hint: 'One sentence describing what you do...',
              controller: _shortDescriptionController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Problem Statement',
              hint: 'What specific pain point are you addressing?',
              controller: _problemController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Solution',
              hint: 'How does your product solve the problem?',
              controller: _solutionController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Mission',
              hint: 'Our mission is to...',
              controller: _missionController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Vision',
              hint: 'We envision a world where...',
              controller: _visionController,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingStep() {
    return _buildStepScaffold(
      title: 'Build Your Brand',
      subtitle: 'Upload your visual identity to stand out.',
      child: Column(
        children: [
          _sectionCard(
            child: _uploadPanel(
              title: 'Startup Logo',
              subtitle: 'Drag and drop your logo here, or browse',
              hint: 'PNG, SVG up to 5MB',
              icon: Icons.cloud_upload_outlined,
              onTap: () => _showComingSoon('Logo upload'),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: _uploadPanel(
              title: 'Cover Image',
              subtitle: 'Upload a brand banner',
              hint: '1920x1080 recommended',
              icon: Icons.image_outlined,
              onTap: () => _showComingSoon('Cover image upload'),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: _uploadPanel(
              title: 'Pitch Deck',
              subtitle: 'Select PDF or PPTX',
              hint: 'Maximum file size 25MB',
              icon: Icons.picture_as_pdf_outlined,
              trailing: const Icon(
                Icons.circle,
                color: Color(0xFF1284E4),
                size: 16,
              ),
              onTap: () => _showComingSoon('Pitch deck upload'),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: _uploadPanel(
              title: 'Supporting Documents',
              subtitle: 'Upload Guidelines or Docs',
              hint: 'Multiple files allowed',
              icon: Icons.description_outlined,
              onTap: () => _showComingSoon('Supporting documents upload'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadPanel({
    required String title,
    required String subtitle,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F5FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFD5CEE9),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE9E1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF5B21B6)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5B6272),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hint,
                    style: const TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      color: Color(0xFF8A90A0),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinksStep() {
    return _buildStepScaffold(
      title: 'Connect Your Startup',
      subtitle:
          'Link your online presence so investors, job seekers, and collaborators can discover your startup.',
      child: _sectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.language, color: Color(0xFF5B21B6)),
                SizedBox(width: 8),
                Text(
                  'Online Presence',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _linkRow('Website', _socialWebsiteController, Icons.language),
            const SizedBox(height: 12),
            _linkRow('LinkedIn', _socialLinkedInController, Icons.link),
            const SizedBox(height: 12),
            _linkRow(
              'Product Hunt',
              _socialProductHuntController,
              Icons.campaign_outlined,
            ),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                '"You can always add more links later."',
                style: TextStyle(fontSize: 13, color: Color(0xFF5D6472)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linkRow(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD7D5E5)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE2EAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF374151)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showComingSoon('Edit $label'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMembersStep() {
    return _buildStepScaffold(
      title: 'Invite Your Team',
      subtitle:
          'Collaborate by inviting founders, developers, designers, advisors, and marketers.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field(
                  label: 'Email Address',
                  hint: 'name@company.com',
                  controller: _inviteEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedInviteRole,
                  items: const [
                    DropdownMenuItem(value: 'Founder', child: Text('Founder')),
                    DropdownMenuItem(
                      value: 'Co-founder',
                      child: Text('Co-founder'),
                    ),
                    DropdownMenuItem(
                      value: 'Designer',
                      child: Text('Designer'),
                    ),
                    DropdownMenuItem(
                      value: 'Developer',
                      child: Text('Developer'),
                    ),
                    DropdownMenuItem(value: 'Advisor', child: Text('Advisor')),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedInviteRole = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _inviteTeamMember,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    elevation: 0,
                    backgroundColor: const Color(0xFF5B21B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Send Invitation'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Existing Members',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w800,
              color: Color(0xFF5B6272),
            ),
          ),
          const SizedBox(height: 12),
          ..._members.map(_buildMemberTile),
        ],
      ),
    );
  }

  Widget _buildMemberTile(StartupMember member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD7D5E5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: const Color(0xFFE4DAFF),
            child: Text(
              member.initials,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF5B21B6),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  member.role,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5D6472),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: member.status == 'Active'
                  ? const Color(0xFFE7F8EA)
                  : const Color(0xFFF1EFFA),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              member.status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: member.status == 'Active'
                    ? const Color(0xFF1C8B46)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundingStep() {
    return _buildStepScaffold(
      title: 'Funding & Investment',
      subtitle:
          'Define your current capital structure and investment roadmap to tailor your dashboard insights.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Funding Stage',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.1,
                  children: _fundingStages
                      .map(
                        (stage) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFundingStage = stage;
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: _selectedFundingStage == stage
                                  ? const Color(0xFFE4DAFF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedFundingStage == stage
                                    ? const Color(0xFF5B21B6)
                                    : const Color(0xFFD4D6E2),
                                width: _selectedFundingStage == stage ? 1.8 : 1,
                              ),
                            ),
                            child: Text(
                              stage,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _selectedFundingStage == stage
                                    ? const Color(0xFF5B21B6)
                                    : const Color(0xFF30384A),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: _currentlyRaising,
                  title: const Text(
                    'Currently Raising?',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text('Activate to input round details'),
                  activeThumbColor: const Color(0xFF5B21B6),
                  onChanged: (value) {
                    setState(() {
                      _currentlyRaising = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _field(
                  label: 'Use of Funds',
                  hint:
                      'Describe how the investment capital will accelerate your business growth...',
                  controller: _useOfFundsController,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return _buildStepScaffold(
      title: 'Review & Publish',
      subtitle:
          'Check your application one last time before going live on the platform.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _reviewCard('Startup Information', 'Name, Mission, Industry', 0),
          _reviewCard(
            'Founder Information',
            'Bio, Experience, ID Verification',
            1,
          ),
          _reviewCard('Brand Assets', 'Logo, Color Palette, Typography', 3),
          _reviewCard(
            'Team Members',
            '${_members.length} active members invited',
            5,
          ),
          _reviewCard('Funding', 'Seed stage, capital raised', 6),
          _reviewCard('Social Links', 'LinkedIn, Twitter, Website', 4),
          const SizedBox(height: 8),
          const Text(
            'Listing Visibility',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: _visibilityOptions
                  .map(
                    (option) => Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedVisibility = option;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedVisibility == option
                                ? const Color(0xFF5B21B6)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            option,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _selectedVisibility == option
                                  ? Colors.white
                                  : const Color(0xFF44495A),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your startup will be visible to all verified investors and users.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewCard(String title, String subtitle, int stepIndex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD7D5E5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5D6472),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _pageController.animateToPage(
                stepIndex,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
              );
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

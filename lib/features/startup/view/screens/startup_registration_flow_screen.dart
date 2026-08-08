import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/startup_models.dart';
import '../../viewmodel/registration_viewmodel.dart';
import '../../../../core/di/providers.dart';
import '../../../../shared/utils/app_snackbar.dart';
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
  final PageController _pageController = PageController();
  final RegistrationViewModel _viewModel = RegistrationViewModel();
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

  File? _founderPhoto;
  File? _logoFile;
  File? _coverFile;
  File? _pitchDeckFile;
  final List<File> _supportingDocs = [];
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickFounderPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999))),
            const SizedBox(height: 20),
            const Text('Choose Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            _sourceOption(Icons.photo_library_outlined, 'Gallery', ImageSource.gallery),
            _sourceOption(Icons.camera_alt_outlined, 'Camera', ImageSource.camera),
          ],
        ),
      ),
    );
    if (source == null) return;

    if (!kIsWeb) {
      final status = await _requestPermission(source);
      if (!status) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission required to access photos. Please enable it in Settings.'), behavior: SnackBarBehavior.floating),
        );
        return;
      }
    }

    final picked = await _imagePicker.pickImage(source: source, imageQuality: 85, maxWidth: 1200);
    if (picked != null) setState(() => _founderPhoto = File(picked.path));
  }

  Widget _sourceOption(IconData icon, String label, ImageSource source) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, source),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF5B21B6).withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5B21B6), size: 22),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFile({required String type}) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999))),
            const SizedBox(height: 20),
            Text('Upload $type', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            _sourceOption(Icons.photo_library_outlined, 'Gallery', ImageSource.gallery),
            _sourceOption(Icons.camera_alt_outlined, 'Camera', ImageSource.camera),
          ],
        ),
      ),
    );
    if (source == null) return;

    if (!kIsWeb) {
      final status = await _requestPermission(source);
      if (!status) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission required to access photos. Please enable it in Settings.'), behavior: SnackBarBehavior.floating),
        );
        return;
      }
    }

    final picked = await _imagePicker.pickImage(source: source, imageQuality: 85, maxWidth: 1920);
    if (picked == null || !mounted) return;
    final file = File(picked.path);
    setState(() {
      switch (type) {
        case 'Logo':
          _logoFile = file;
        case 'Cover Image':
          _coverFile = file;
      }
    });
    if (mounted) {
      AppSnackBar.showSuccess(context, '$type uploaded');
    }
  }

  Future<void> _pickDocument({required String type}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: type == 'Pitch Deck' ? ['pdf', 'pptx', 'ppt'] : ['pdf', 'doc', 'docx', 'txt', 'png', 'jpg'],
      allowMultiple: type == 'Supporting Documents',
    );
    if (result == null || result.files.isEmpty) return;
    if (!mounted) return;
    final files = result.files.map((f) => File(f.path!)).toList();
    setState(() {
      switch (type) {
        case 'Pitch Deck':
          _pitchDeckFile = files.first;
        case 'Supporting Documents':
          _supportingDocs.addAll(files);
      }
    });
    if (mounted) {
      AppSnackBar.showSuccess(context, '${files.length} file(s) uploaded');
    }
  }

  Future<bool> _requestPermission(ImageSource source) async {
    PermissionStatus status;
    if (source == ImageSource.camera) {
      status = await Permission.camera.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.camera.request();
      }
    } else {
      status = await Permission.photos.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.photos.request();
      }
      if (status.isPermanentlyDenied || status.isDenied) {
        status = await Permission.storage.status;
        if (status.isDenied || status.isPermanentlyDenied) {
          status = await Permission.storage.request();
        }
      }
    }
    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      openAppSettings();
      return false;
    }
    return status.isGranted || status.isLimited;
  }

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
    if (_viewModel.currentStep < RegistrationViewModel.totalSteps - 1) {
      _viewModel.goToNextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
      return;
    }

    _publishStartup();
  }

  void _goToPreviousStep() {
    if (_viewModel.currentStep > 0) {
      _viewModel.goToPreviousStep();
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
      stage: _viewModel.selectedStage,
      tagline: _taglineController.text.trim(),
      logoPath: _logoFile?.path,
      coverPath: _coverFile?.path,
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
      description: _shortDescriptionController.text.trim(),
      problem: _problemController.text.trim(),
      solution: _solutionController.text.trim(),
      mission: _missionController.text.trim(),
      vision: _visionController.text.trim(),
      website: _websiteController.text.trim(),
      incorporationDate: _incorporationController.text.trim(),
      founderName: _founderNameController.text.trim(),
      founderDesignation: _designationController.text.trim(),
      founderEmail: _emailController.text.trim(),
      founderPhone: _phoneController.text.trim(),
      founderLinkedin: _linkedinController.text.trim(),
      founderBio: _bioController.text.trim(),
      socialWebsite: _socialWebsiteController.text.trim(),
      socialLinkedin: _socialLinkedInController.text.trim(),
      socialProductHunt: _socialProductHuntController.text.trim(),
      useOfFunds: _useOfFundsController.text.trim(),
      teamSize: _viewModel.selectedTeamSize,
      fundingStage: _viewModel.selectedFundingStage,
      currentlyRaising: _viewModel.currentlyRaising,
      visibility: _viewModel.selectedVisibility,
      // Do NOT set originalStartupName/Data here — those are only written
      // by the join-another-startup flow, never at registration time.
    );

    // --- Frontend registry: publish so Join Startup screen can find it ---
    final industry = _industryController.text.trim();
    final teamSizeStr = _viewModel.selectedTeamSize; // e.g. '1-5'
    final teamCount = int.tryParse(teamSizeStr.split('-').first) ?? 1;
    ref.read(startupRegistryProvider.notifier).addStartup(
      SuggestedStartup(
        name: startupName,
        industry: industry.isNotEmpty ? industry : 'Other',
        location: [
          _cityController.text.trim(),
          _countryController.text.trim(),
        ].where((s) => s.isNotEmpty).join(', '),
        teamMembers: teamCount,
        stage: _viewModel.selectedStage,
        tags: industry.isNotEmpty ? [industry] : [],
        tagline: _taglineController.text.trim(),
        description: _shortDescriptionController.text.trim(),
        problem: _problemController.text.trim(),
        solution: _solutionController.text.trim(),
        mission: _missionController.text.trim(),
        vision: _visionController.text.trim(),
        website: _websiteController.text.trim(),
        founderName: _founderNameController.text.trim(),
        incorporationDate: _incorporationController.text.trim(),
      ),
    );
    // -----------------------------------------------------------------------

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StartupSuccessScreen(
          startupName: startupName,
          selectedRole: widget.selectedRole,
          completion: 65,
          industry: _industryController.text.trim(),
          stage: _viewModel.selectedStage,
          tagline: _taglineController.text.trim(),
          country: _countryController.text.trim(),
          city: _cityController.text.trim(),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    AppSnackBar.showInfo(context, '$feature is coming soon.');
  }

  void _inviteTeamMember() {
    final email = _inviteEmailController.text.trim();
    if (email.isEmpty) {
      _showComingSoon('Enter an email address first');
      return;
    }

    _viewModel.inviteTeamMember(email);
    _inviteEmailController.clear();

    AppSnackBar.showSuccess(context, 'Invitation sent to $email');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final progress = _viewModel.progress;

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
                        'Step ${_viewModel.currentStep + 1} of ${RegistrationViewModel.totalSteps}',
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
                      _viewModel.setCurrentStep(index);
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
                  child: Text(_viewModel.currentStep == 0 ? 'Back' : 'Back'),
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
                    _viewModel.currentStep == RegistrationViewModel.totalSteps - 1 ? 'Publish' : 'Next Step',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      );
      },
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
    final selected = _viewModel.selectedTeamSize == label;
    return GestureDetector(
      onTap: () {
        _viewModel.selectTeamSize(label);
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
              initialValue: _viewModel.selectedStage,
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
                _viewModel.selectStage(value);
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
                        backgroundImage: _founderPhoto != null ? FileImage(_founderPhoto!) : null,
                        child: _founderPhoto != null
                            ? null
                            : const Icon(
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
                          onPressed: () => _pickFounderPhoto(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _pickFounderPhoto(),
                    child: Text(_founderPhoto != null ? 'Change Photo' : 'Upload Photo'),
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
                  '${_viewModel.yearsOfExperience.toInt()} years',
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
                value: _viewModel.yearsOfExperience,
                min: 0,
                max: 30,
                divisions: 30,
                onChanged: (value) {
                  _viewModel.setYearsOfExperience(value);
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
              children: _viewModel.skillTags
                  .map(
                    (skill) =>
                        _chip(skill, _viewModel.selectedSkills.contains(skill), () {
                          _viewModel.toggleSkill(skill);
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
              statusLabel: _logoFile != null ? 'Uploaded' : null,
              onTap: () => _pickImageFile(type: 'Logo'),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: _uploadPanel(
              title: 'Cover Image',
              subtitle: 'Upload a brand banner',
              hint: '1920x1080 recommended',
              icon: Icons.image_outlined,
              statusLabel: _coverFile != null ? 'Uploaded' : null,
              onTap: () => _pickImageFile(type: 'Cover Image'),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: _uploadPanel(
              title: 'Pitch Deck',
              subtitle: 'Select PDF or PPTX',
              hint: 'Maximum file size 25MB',
              icon: Icons.picture_as_pdf_outlined,
              statusLabel: _pitchDeckFile != null ? 'Uploaded' : null,
              trailing: const Icon(
                Icons.circle,
                color: Color(0xFF1284E4),
                size: 16,
              ),
              onTap: () => _pickDocument(type: 'Pitch Deck'),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: _uploadPanel(
              title: 'Supporting Documents',
              subtitle: 'Upload Guidelines or Docs',
              hint: 'Multiple files allowed',
              icon: Icons.description_outlined,
              statusLabel: _supportingDocs.isNotEmpty ? '${_supportingDocs.length} file(s)' : null,
              onTap: () => _pickDocument(type: 'Supporting Documents'),
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
    String? statusLabel,
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
            if (statusLabel != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7ED),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2F9B54),
                  ),
                ),
              ),
            ],
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
                  initialValue: _viewModel.selectedInviteRole,
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
                    _viewModel.selectInviteRole(value);
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
          ..._viewModel.members.map(_buildMemberTile),
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
                  children: _viewModel.fundingStages
                      .map(
                        (stage) => GestureDetector(
                          onTap: () {
                            _viewModel.selectFundingStage(stage);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: _viewModel.selectedFundingStage == stage
                                  ? const Color(0xFFE4DAFF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _viewModel.selectedFundingStage == stage
                                    ? const Color(0xFF5B21B6)
                                    : const Color(0xFFD4D6E2),
                                width: _viewModel.selectedFundingStage == stage ? 1.8 : 1,
                              ),
                            ),
                            child: Text(
                              stage,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _viewModel.selectedFundingStage == stage
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
                  value: _viewModel.currentlyRaising,
                  title: const Text(
                    'Currently Raising?',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text('Activate to input round details'),
                  activeThumbColor: const Color(0xFF5B21B6),
                  onChanged: (value) {
                    _viewModel.toggleRaising(value);
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
            '${_viewModel.members.length} active members invited',
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
              children: _viewModel.visibilityOptions
                  .map(
                    (option) => Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _viewModel.selectVisibility(option);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _viewModel.selectedVisibility == option
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
                              color: _viewModel.selectedVisibility == option
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

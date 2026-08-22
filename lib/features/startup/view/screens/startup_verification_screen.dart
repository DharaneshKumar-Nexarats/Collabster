import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/di/providers.dart';

class StartupVerificationScreen extends ConsumerStatefulWidget {
  const StartupVerificationScreen({super.key});

  @override
  ConsumerState<StartupVerificationScreen> createState() =>
      _StartupVerificationScreenState();
}

class _StartupVerificationScreenState
    extends ConsumerState<StartupVerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _entityNameController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _gstinController = TextEditingController();
  final _websiteController = TextEditingController();
  final _repNameController = TextEditingController();

  String _country = 'India';
  String _docType = 'Certificate of Incorporation';
  String _repDesignation = 'Founder & CEO';
  String _idType = 'National ID / Aadhaar';
  bool _agreedToTerms = false;
  bool _isSubmitting = false;

  final Map<String, File?> _uploadedFiles = {};

  static const List<String> _countries = [
    'India',
    'United States',
    'Singapore',
    'United Kingdom',
    'United Arab Emirates',
    'Germany',
    'Canada',
    'Other',
  ];

  static const List<String> _docTypes = [
    'Certificate of Incorporation',
    'GST / Tax Registration',
    'Trade License / Business Permit',
    'Pitch Deck / Proof of Business',
  ];

  static const List<String> _designations = [
    'Founder & CEO',
    'Co-Founder',
    'Managing Director',
    'Chief Technology Officer (CTO)',
    'Authorized Representative',
  ];

  static const List<String> _idTypes = [
    'National ID / Aadhaar',
    'Passport',
    'Driver\'s License',
    'Tax Identification Card (PAN)',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final session = ref.read(authViewModelProvider).session;
        if (session != null) {
          if (_entityNameController.text.isEmpty && session.startupName != null) {
            _entityNameController.text = session.startupName!;
          }
          if (_repNameController.text.isEmpty) {
            _repNameController.text = session.fullName;
          }
        }
      } catch (e) {
        debugPrint('Error loading session in StartupVerificationScreen: $e');
      }
    });
  }

  @override
  void dispose() {
    _entityNameController.dispose();
    _regNumberController.dispose();
    _gstinController.dispose();
    _websiteController.dispose();
    _repNameController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(String key) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );
      if (result == null || result.files.isEmpty || result.files.first.path == null) {
        return;
      }

      setState(() {
        _uploadedFiles[key] = File(result.files.first.path!);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attached ${_getFileName(key)}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  String _getFileName(String key) {
    final file = _uploadedFiles[key];
    if (file == null) return '';
    return file.path.split('/').last;
  }

  void _removeFile(String key) {
    setState(() {
      _uploadedFiles.remove(key);
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_uploadedFiles['incorporation'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please attach your Business Incorporation Document.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm the legal declaration.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 700));

    ref.read(startupDashboardViewModelProvider.notifier).submitVerification();

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    _showSuccessModal();
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFF16A34A),
                  size: 42,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Verification Submitted!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your startup documents have been submitted to our compliance team. Once verified, you will unlock job postings and candidate hiring tools.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B21B6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Back to Dashboard',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final startupState = ref.watch(startupDashboardViewModelProvider);
    final isRejected = startupState.isVerificationRejected;
    final rejectionReason = startupState.verificationRejectionReason;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(topPadding, isRejected),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isRejected && rejectionReason != null)
                      _buildRejectionNotice(rejectionReason),

                    _buildSectionCard(
                      title: '1. Business Entity Details',
                      subtitle: 'Official company registration info',
                      icon: Icons.business_rounded,
                      children: [
                        _buildLabel('Legal Company Name *'),
                        TextFormField(
                          controller: _entityNameController,
                          decoration: _inputDecoration(
                            hint: 'e.g. Nexarats Technologies Pvt Ltd',
                            prefixIcon: Icons.apartment_rounded,
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Entity name is required' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('CIN / Reg Number *'),
                                  TextFormField(
                                    controller: _regNumberController,
                                    decoration: _inputDecoration(
                                      hint: 'U72900KA2024PTC...',
                                      prefixIcon: Icons.badge_outlined,
                                    ),
                                    validator: (v) =>
                                        v == null || v.trim().isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('GSTIN / Tax ID'),
                                  TextFormField(
                                    controller: _gstinController,
                                    decoration: _inputDecoration(
                                      hint: '29ABCDE1234F1Z5',
                                      prefixIcon: Icons.receipt_long_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Incorporation Country *'),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _country,
                          dropdownColor: Colors.white,
                          decoration: _inputDecoration(prefixIcon: Icons.public_rounded),
                          items: _countries
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c, overflow: TextOverflow.ellipsis),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _country = val);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Official Website / Pitch Deck URL'),
                        TextFormField(
                          controller: _websiteController,
                          keyboardType: TextInputType.url,
                          decoration: _inputDecoration(
                            hint: 'https://yourstartup.io',
                            prefixIcon: Icons.language_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSectionCard(
                      title: '2. Business Registration Document',
                      subtitle: 'Upload official certificate or proof of entity',
                      icon: Icons.folder_zip_rounded,
                      children: [
                        _buildLabel('Document Type *'),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _docType,
                          dropdownColor: Colors.white,
                          decoration: _inputDecoration(prefixIcon: Icons.description_outlined),
                          items: _docTypes
                              .map((d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d, overflow: TextOverflow.ellipsis),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _docType = val);
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildUploadTile(
                          fileKey: 'incorporation',
                          label: 'Upload Business Document (PDF / PNG / JPG)',
                          sublabel: 'Max file size: 10 MB',
                          isRequired: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSectionCard(
                      title: '3. Authorized Representative ID',
                      subtitle: 'Verify founder or authorized executive',
                      icon: Icons.person_pin_rounded,
                      children: [
                        _buildLabel('Representative Name *'),
                        TextFormField(
                          controller: _repNameController,
                          decoration: _inputDecoration(
                            hint: 'Full legal name',
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Representative name required' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Designation *'),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _repDesignation,
                          dropdownColor: Colors.white,
                          decoration: _inputDecoration(prefixIcon: Icons.work_outline_rounded),
                          items: _designations
                              .map((d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d, overflow: TextOverflow.ellipsis),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _repDesignation = val);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Government ID Type *'),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _idType,
                          dropdownColor: Colors.white,
                          decoration: _inputDecoration(prefixIcon: Icons.verified_user_outlined),
                          items: _idTypes
                              .map((id) => DropdownMenuItem(
                                    value: id,
                                    child: Text(id, overflow: TextOverflow.ellipsis),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _idType = val);
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildUploadTile(
                          fileKey: 'rep_id',
                          label: 'Upload Government ID Proof (Optional)',
                          sublabel: 'Aadhaar / Passport / Driver\'s License',
                          isRequired: false,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedToTerms,
                              activeColor: const Color(0xFF5B21B6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              onChanged: (val) {
                                setState(() => _agreedToTerms = val ?? false);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                              child: const Text(
                                'I hereby declare that all uploaded business details and documents are authentic, valid, and registered under our company.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF334155),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B21B6),
                          elevation: 2,
                          shadowColor: const Color(0xFF5B21B6).withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.lock_open_rounded, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Submit for Verification',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double topPadding, bool isRejected) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12, topPadding + 8, 18, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A0E8F), Color(0xFF6D28D9), Color(0xFF4F46E5)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  isRejected ? 'Resubmit Verification' : 'Startup Verification',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isRejected
                      ? const Color(0xFFEF4444).withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isRejected ? Colors.redAccent : Colors.white24,
                  ),
                ),
                child: Text(
                  isRejected ? 'REJECTED' : 'UNVERIFIED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              'Verify your startup entity to unlock job postings, candidate hiring pipelines, and trusted ecosystem status.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionNotice(String reason) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Previous Verification Rejected',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF991B1B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF7F1D1D),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B21B6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF5B21B6), size: 19),
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
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildUploadTile({
    required String fileKey,
    required String label,
    required String sublabel,
    required bool isRequired,
  }) {
    final file = _uploadedFiles[fileKey];
    final hasFile = file != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hasFile ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasFile ? const Color(0xFF86EFAC) : const Color(0xFFCBD5E1),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: hasFile
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFF5B21B6).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              hasFile ? Icons.insert_drive_file_rounded : Icons.cloud_upload_outlined,
              color: hasFile ? const Color(0xFF16A34A) : const Color(0xFF5B21B6),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasFile ? _getFileName(fileKey) : label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: hasFile ? const Color(0xFF14532D) : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasFile ? 'Attached & ready for submission' : sublabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: hasFile ? const Color(0xFF15803D) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (hasFile)
            IconButton(
              icon: const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626), size: 20),
              onPressed: () => _removeFile(fileKey),
            )
          else
            ElevatedButton(
              onPressed: () => _pickFile(fileKey),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B21B6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Browse', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required IconData prefixIcon, String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF64748B), size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF5B21B6), width: 1.8),
      ),
    );
  }
}

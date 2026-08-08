import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/providers.dart';

class StartupInfoScreen extends ConsumerWidget {
  const StartupInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authViewModelProvider).session;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final startupName = session?.startupName ?? 'My Startup';
    final tagline = session?.startupTagline ?? '';
    final industry = session?.startupIndustry ?? '';
    final stage = session?.startupStage ?? '';
    final city = session?.startupCity ?? '';
    final country = session?.startupCountry ?? '';
    final description = session?.startupDescription ?? '';
    final problem = session?.startupProblem ?? '';
    final solution = session?.startupSolution ?? '';
    final mission = session?.startupMission ?? '';
    final vision = session?.startupVision ?? '';
    final website = session?.startupWebsite ?? '';
    final incorporationDate = session?.startupIncorporationDate ?? '';
    final founderName = session?.startupFounderName ?? '';
    final founderDesignation = session?.startupFounderDesignation ?? '';
    final founderEmail = session?.startupFounderEmail ?? '';
    final founderPhone = session?.startupFounderPhone ?? '';
    final founderLinkedin = session?.startupFounderLinkedin ?? '';
    final founderBio = session?.startupFounderBio ?? '';
    final socialWebsite = session?.startupSocialWebsite ?? '';
    final socialLinkedin = session?.startupSocialLinkedin ?? '';
    final socialProductHunt = session?.startupSocialProductHunt ?? '';
    final useOfFunds = session?.startupUseOfFunds ?? '';
    final teamSize = session?.startupTeamSize ?? '';
    final fundingStage = session?.startupFundingStage ?? '';
    final currentlyRaising = session?.startupCurrentlyRaising ?? false;
    final visibility = session?.startupVisibility ?? '';

    final logoPath = session?.startupLogoPath ?? '';
    final hasLogo = logoPath.isNotEmpty && File(logoPath).existsSync();

    final initials = startupName.isNotEmpty
        ? startupName.substring(0, 1).toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A0E8F), Color(0xFF6D28D9), Color(0xFF5B21B6)],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // App bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              'Startup Info',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Startup icon / logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                      ),
                      child: hasLogo
                          ? ClipOval(
                              child: Image.file(
                                File(logoPath),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    // Name
                    Text(
                      startupName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    if (tagline.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          tagline,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                    // Badges row
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        if (industry.isNotEmpty) _badge(industry),
                        if (stage.isNotEmpty) _badge(stage),
                        if (city.isNotEmpty || country.isNotEmpty)
                          _badge([city, country].where((e) => e.isNotEmpty).join(', ')),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // ── About Section ──
          if (description.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'ABOUT',
                isDark: isDark,
                children: [
                  _buildTextBlock(description, isDark),
                ],
              ),
            ),

          // ── Problem & Solution ──
          if (problem.isNotEmpty || solution.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'PROBLEM & SOLUTION',
                isDark: isDark,
                children: [
                  if (problem.isNotEmpty) ...[
                    _buildLabelRow('Problem', problem, isDark),
                    if (solution.isNotEmpty) _divider(isDark),
                  ],
                  if (solution.isNotEmpty)
                    _buildLabelRow('Solution', solution, isDark),
                ],
              ),
            ),

          // ── Mission & Vision ──
          if (mission.isNotEmpty || vision.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'MISSION & VISION',
                isDark: isDark,
                children: [
                  if (mission.isNotEmpty) ...[
                    _buildLabelRow('Mission', mission, isDark),
                    if (vision.isNotEmpty) _divider(isDark),
                  ],
                  if (vision.isNotEmpty)
                    _buildLabelRow('Vision', vision, isDark),
                ],
              ),
            ),

          // ── Company Details ──
          SliverToBoxAdapter(
            child: _buildSection(
              title: 'COMPANY DETAILS',
              isDark: isDark,
              children: [
                if (incorporationDate.isNotEmpty) ...[
                  _buildInfoRow(Icons.calendar_today_rounded, 'Incorporated', incorporationDate, isDark),
                  _divider(isDark),
                ],
                if (website.isNotEmpty) ...[
                  _buildInfoRow(Icons.language_rounded, 'Website', website, isDark),
                  _divider(isDark),
                ],
                _buildInfoRow(Icons.visibility_rounded, 'Visibility', visibility.isNotEmpty ? visibility : 'Public', isDark),
              ],
            ),
          ),

          // ── Founder ──
          if (founderName.isNotEmpty || founderEmail.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'FOUNDER',
                isDark: isDark,
                children: [
                  if (founderName.isNotEmpty) ...[
                    _buildInfoRow(Icons.person_outline_rounded, 'Name', founderName, isDark),
                    _divider(isDark),
                  ],
                  if (founderDesignation.isNotEmpty) ...[
                    _buildInfoRow(Icons.badge_outlined, 'Designation', founderDesignation, isDark),
                    _divider(isDark),
                  ],
                  if (founderEmail.isNotEmpty) ...[
                    _buildInfoRow(Icons.email_outlined, 'Email', founderEmail, isDark),
                    _divider(isDark),
                  ],
                  if (founderPhone.isNotEmpty) ...[
                    _buildInfoRow(Icons.phone_outlined, 'Phone', founderPhone, isDark),
                    _divider(isDark),
                  ],
                  if (founderLinkedin.isNotEmpty) ...[
                    _buildInfoRow(Icons.link_rounded, 'LinkedIn', founderLinkedin, isDark),
                    _divider(isDark),
                  ],
                  if (founderBio.isNotEmpty)
                    _buildLabelRow('Bio', founderBio, isDark),
                ],
              ),
            ),

          // ── Social Links ──
          if (socialWebsite.isNotEmpty || socialLinkedin.isNotEmpty || socialProductHunt.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'SOCIAL LINKS',
                isDark: isDark,
                children: [
                  if (socialWebsite.isNotEmpty) ...[
                    _buildInfoRow(Icons.language_rounded, 'Website', socialWebsite, isDark),
                    _divider(isDark),
                  ],
                  if (socialLinkedin.isNotEmpty) ...[
                    _buildInfoRow(Icons.work_outline_rounded, 'LinkedIn', socialLinkedin, isDark),
                    _divider(isDark),
                  ],
                  if (socialProductHunt.isNotEmpty)
                    _buildInfoRow(Icons.rocket_launch_rounded, 'Product Hunt', socialProductHunt, isDark),
                ],
              ),
            ),

          // ── Funding ──
          if (fundingStage.isNotEmpty || useOfFunds.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'FUNDING',
                isDark: isDark,
                children: [
                  _buildInfoRow(Icons.account_balance_wallet_rounded, 'Funding Stage', fundingStage, isDark),
                  if (teamSize.isNotEmpty) ...[
                    _divider(isDark),
                    _buildInfoRow(Icons.group_rounded, 'Team Size', teamSize, isDark),
                  ],
                  _divider(isDark),
                  _buildInfoRow(
                    currentlyRaising ? Icons.trending_up_rounded : Icons.pause_circle_outline_rounded,
                    'Currently Raising',
                    currentlyRaising ? 'Yes' : 'No',
                    isDark,
                  ),
                  if (useOfFunds.isNotEmpty) ...[
                    _divider(isDark),
                    _buildLabelRow('Use of Funds', useOfFunds, isDark),
                  ],
                ],
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border, width: 0.5),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(height: 1, indent: 52, color: isDark ? AppColors.darkBorder : AppColors.border);
  }

  Widget _buildTextBlock(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

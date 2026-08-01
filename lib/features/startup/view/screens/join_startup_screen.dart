import 'package:flutter/material.dart';

import 'join_startup_verification_screen.dart';

class JoinStartupScreen extends StatefulWidget {
  const JoinStartupScreen({super.key});

  @override
  State<JoinStartupScreen> createState() => _JoinStartupScreenState();
}

class _JoinStartupScreenState extends State<JoinStartupScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedMode = 'Startup Name';
  final String _selectedStartup = 'NexusAI';

  final List<_SuggestedStartup> _suggestedStartups = const [
    _SuggestedStartup(
      name: 'NexusAI',
      industry: 'Artificial Intelligence',
      location: 'San Francisco',
      teamMembers: 48,
    ),
    _SuggestedStartup(
      name: 'FlowPay',
      industry: 'Fintech',
      location: 'London',
      teamMembers: 124,
    ),
    _SuggestedStartup(
      name: 'VitaLife',
      industry: 'HealthTech',
      location: 'Berlin',
      teamMembers: 32,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openVerification([String? startupName]) {
    final selected = startupName ?? _selectedStartup;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinStartupVerificationScreen(startupName: selected),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final filteredStartups = _filteredStartups;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5B21B6)),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Join Existing Startup',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: Color(0xFF12233D),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Search for the startup you want to join. You can search using the startup name, startup ID, invitation code, or website.',
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.5,
                  color: Color(0xFF5D6472),
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Startup',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 18),
              const Text(
                'Quick Join Options',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF8C8FA0),
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                children: [
                  _quickOption('Startup Name', Icons.domain_add_outlined, () {
                    setState(() {
                      _selectedMode = 'Startup Name';
                    });
                    _showSnack('Search by startup name selected');
                  }),
                  _quickOption('Invitation Code', Icons.key_outlined, () {
                    setState(() {
                      _selectedMode = 'Invitation Code';
                    });
                    _showSnack('Invitation code selected');
                  }),
                  _quickOption('Scan QR Code', Icons.qr_code_scanner_outlined, () {
                    _showSnack('QR scanner coming soon');
                  }),
                  _quickOption('Org Email', Icons.alternate_email, () {
                    setState(() {
                      _selectedMode = 'Org Email';
                    });
                    _showSnack('Organizational email selected');
                  }),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Suggested Startups',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF8C8FA0),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showSnack('View all coming soon'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              ...filteredStartups.map((startup) => _startupCard(startup)),
              const SizedBox(height: 8),
              Text(
                'Selected mode: $_selectedMode',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5B21B6),
                ),
              ),
            ],
          ),
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
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    foregroundColor: const Color(0xFF3B3B4F),
                    side: const BorderSide(color: Color(0xFFB7B5C9)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Back', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _openVerification(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    elevation: 0,
                    backgroundColor: const Color(0xFF5B21B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Next Step', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_SuggestedStartup> get _filteredStartups {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _suggestedStartups;
    }

    return _suggestedStartups.where((startup) {
      return startup.name.toLowerCase().contains(query) ||
          startup.industry.toLowerCase().contains(query) ||
          startup.location.toLowerCase().contains(query);
    }).toList();
  }

  Widget _quickOption(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD7D5E5)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8DBFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF5B21B6), size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF12233D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _startupCard(_SuggestedStartup startup) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD7D5E5)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE9EFFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.business_outlined, color: Color(0xFF5B21B6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      startup.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF12233D),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.verified, size: 16, color: Color(0xFF5B21B6)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${startup.industry} · ${startup.location}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF5D6472)),
                ),
                const SizedBox(height: 6),
                Text(
                  '${startup.teamMembers} Team Members',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF8C8FA0)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () => _openVerification(startup.name),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 46),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                elevation: 0,
                backgroundColor: const Color(0xFF5B21B6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestedStartup {
  const _SuggestedStartup({
    required this.name,
    required this.industry,
    required this.location,
    required this.teamMembers,
  });

  final String name;
  final String industry;
  final String location;
  final int teamMembers;
}

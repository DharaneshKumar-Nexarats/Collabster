import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class TeamViewModel extends ChangeNotifier {
  final List<TeamMember> _members = [
    TeamMember(name: 'Rahul Verma', role: 'Founder & CEO', department: 'Executive / Strategy', badge: 'FOUNDER', badgeColor: Color(0xFF5B21B6), initials: 'RV'),
    TeamMember(name: 'Sneha Iyer', role: 'Co-Founder & CTO', department: 'Engineering / Tech', badge: 'CO-FOUNDER', badgeColor: Color(0xFF0D9488), initials: 'SI'),
    TeamMember(name: 'Vikram Singh', role: 'Marketing Lead', department: 'Growth / Comms', badge: 'CORE TEAM', badgeColor: Color(0xFF2563EB), initials: 'VS'),
    TeamMember(name: 'Anika Patel', role: 'Product Designer', department: 'Design / UX', badge: 'CORE TEAM', badgeColor: Color(0xFF2563EB), initials: 'AP'),
  ];
  List<TeamMember> get members => _members;
}

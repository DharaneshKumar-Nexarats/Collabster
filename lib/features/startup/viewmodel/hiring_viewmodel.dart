import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class HiringViewModel extends ChangeNotifier {
  final List<OpenRole> _roles = const [
    OpenRole(title: 'Senior AI Engineer', department: 'Core Engine / Engineering', applicants: 48, shortlisted: 6, status: 'HIRING', statusColor: Color(0xFF059669)),
    OpenRole(title: 'ML Research Lead', department: 'R&D / Research', applicants: 12, shortlisted: 2, status: 'HIRING', statusColor: Color(0xFF059669)),
    OpenRole(title: 'Product Designer', department: 'Design / UI-UX', applicants: 24, shortlisted: 4, status: 'PAUSED', statusColor: Color(0xFFF59E0B)),
  ];
  List<OpenRole> get roles => _roles;
}

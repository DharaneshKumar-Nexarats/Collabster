import 'package:flutter/material.dart';

class ConnectionRequest {
  final String name;
  final String role;
  final String initials;
  const ConnectionRequest({required this.name, required this.role, required this.initials});
}

class ActivityItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const ActivityItem({required this.icon, required this.title, required this.subtitle, required this.color});
}

class FundraisingInvestor {
  final String name;
  final String fund;
  final String amount;
  final String meetingIn;
  final String initials;
  final Color color;
  const FundraisingInvestor({required this.name, required this.fund, required this.amount, required this.meetingIn, required this.initials, required this.color});
}

class OpenRole {
  final String title;
  final String department;
  final int applicants;
  final int shortlisted;
  final String status;
  final Color statusColor;
  const OpenRole({required this.title, required this.department, required this.applicants, required this.shortlisted, required this.status, required this.statusColor});
}

class InvestorEntry {
  final String name;
  final String fund;
  final String amount;
  final String status;
  final Color statusColor;
  final String initials;
  final Color color;
  final int contacted;
  final int replied;
  const InvestorEntry({required this.name, required this.fund, required this.amount, required this.status, required this.statusColor, required this.initials, required this.color, required this.contacted, required this.replied});
}

class SuggestedStartup {
  final String name;
  final String industry;
  final String location;
  final int teamMembers;
  final String stage;
  final List<String> tags;
  const SuggestedStartup({required this.name, required this.industry, required this.location, required this.teamMembers, required this.stage, required this.tags});
}

class TeamMember {
  final String name;
  final String role;
  final String department;
  final String badge;
  final Color badgeColor;
  final String initials;
  const TeamMember({required this.name, required this.role, required this.department, required this.badge, required this.badgeColor, required this.initials});
}

class StartupProduct {
  final String name;
  final String description;
  final String status;
  final Color statusColor;
  final String version;
  final double rating;
  final int saves;
  final int downloads;
  final Color tagColor;
  const StartupProduct({required this.name, required this.description, required this.status, required this.statusColor, required this.version, required this.rating, required this.saves, required this.downloads, required this.tagColor});
}

class DocumentItem {
  final String name;
  final String type;
  final String size;
  final String category;
  final Color color;
  const DocumentItem({required this.name, required this.type, required this.size, required this.category, required this.color});
}

class DocumentCollection {
  final String name;
  final int count;
  final Color color;
  const DocumentCollection({required this.name, required this.count, required this.color});
}

class Milestone {
  final String title;
  final String date;
  final bool completed;
  final bool active;
  const Milestone({required this.title, required this.date, required this.completed, required this.active});
}

class StartupMember {
  final String name;
  final String role;
  final String status;
  final String initials;
  const StartupMember({required this.name, required this.role, required this.status, required this.initials});
}

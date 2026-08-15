import 'package:flutter/material.dart';

class CommunityCategory {
  final String id;
  final String label;
  final IconData icon;

  const CommunityCategory({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class WhatsHappeningItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String status;

  const WhatsHappeningItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.status = 'Active today',
  });
}

class MyCommunityItem {
  final String id;
  final String title;
  final String memberCount;
  final String activeTodayCount;
  final List<String> avatarUrls;
  final int overflowCount;
  final List<Color> gradientColors;
  final IconData logoIcon;
  final String categoryId;
  final String? imageUrl;
  bool isJoined;

  MyCommunityItem({
    required this.id,
    required this.title,
    required this.memberCount,
    required this.activeTodayCount,
    required this.avatarUrls,
    required this.overflowCount,
    required this.gradientColors,
    required this.logoIcon,
    required this.categoryId,
    this.isJoined = true,
    this.imageUrl,
  });
}

class CommunityRoom {
  final String id;
  final String communityId;
  final String communityTitle;
  final String name;
  final String memberCount;
  bool isJoined;

  CommunityRoom({
    required this.id,
    required this.communityId,
    required this.communityTitle,
    required this.name,
    required this.memberCount,
    this.isJoined = false,
  });
}

class RecommendedCommunityItem {
  final String id;
  final String title;
  final String memberCount;
  final String tag;
  final String categoryId;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  bool isJoined;

  RecommendedCommunityItem({
    required this.id,
    required this.title,
    required this.memberCount,
    required this.tag,
    required this.categoryId,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    this.isJoined = false,
  });
}

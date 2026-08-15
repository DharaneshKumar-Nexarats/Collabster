import '../model/community_model.dart';

class CommunityState {
  const CommunityState({
    this.categories = const [],
    this.whatsHappening = const [],
    this.myCommunities = const [],
    this.recommendedCommunities = const [],
    this.rooms = const [],
    this.selectedCategoryId = 'all',
    this.searchQuery = '',
    this.unreadCount = 2,
  });

  final List<CommunityCategory> categories;
  final List<WhatsHappeningItem> whatsHappening;
  final List<MyCommunityItem> myCommunities;
  final List<RecommendedCommunityItem> recommendedCommunities;
  final List<CommunityRoom> rooms;
  final String selectedCategoryId;
  final String searchQuery;
  final int unreadCount;

  List<MyCommunityItem> get filteredMyCommunities {
    if (selectedCategoryId == 'all') return myCommunities;
    return myCommunities
        .where((c) => c.categoryId == selectedCategoryId)
        .toList();
  }

  List<RecommendedCommunityItem> get filteredRecommended {
    if (selectedCategoryId == 'all') return recommendedCommunities;
    return recommendedCommunities
        .where((c) => c.categoryId == selectedCategoryId)
        .toList();
  }

  CommunityState copyWith({
    List<CommunityCategory>? categories,
    List<WhatsHappeningItem>? whatsHappening,
    List<MyCommunityItem>? myCommunities,
    List<RecommendedCommunityItem>? recommendedCommunities,
    List<CommunityRoom>? rooms,
    String? selectedCategoryId,
    String? searchQuery,
    int? unreadCount,
  }) {
    return CommunityState(
      categories: categories ?? this.categories,
      whatsHappening: whatsHappening ?? this.whatsHappening,
      myCommunities: myCommunities ?? this.myCommunities,
      recommendedCommunities:
          recommendedCommunities ?? this.recommendedCommunities,
      rooms: rooms ?? this.rooms,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

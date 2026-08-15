/// Startup pitch deck model for investor review.
class PitchDeck {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final int slideCount;
  final bool isPublic;
  final String company;
  final String sector;
  final String stage;
  final String colorKey;
  final bool isBookmarked;

  const PitchDeck({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.slideCount = 0,
    this.isPublic = false,
    this.company = '',
    this.sector = '',
    this.stage = '',
    this.colorKey = 'gold',
    this.isBookmarked = false,
  });

  PitchDeck copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    int? slideCount,
    bool? isPublic,
    String? company,
    String? sector,
    String? stage,
    String? colorKey,
    bool? isBookmarked,
  }) {
    return PitchDeck(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      slideCount: slideCount ?? this.slideCount,
      isPublic: isPublic ?? this.isPublic,
      company: company ?? this.company,
      sector: sector ?? this.sector,
      stage: stage ?? this.stage,
      colorKey: colorKey ?? this.colorKey,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

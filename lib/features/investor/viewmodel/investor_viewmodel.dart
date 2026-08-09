import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/investor_model.dart';
import 'investor_state.dart';

class InvestorViewModel extends StateNotifier<InvestorState> {
  InvestorViewModel() : super(const InvestorState());

  void loadInvestors() {
    state = state.copyWith(
      investors: const [
        Investor(
          id: '1',
          name: 'Vertex Capital',
          firm: 'Vertex Capital',
          focus: 'Series A',
          location: 'San Francisco',
          investmentRange: 500000,
          portfolioSize: 45,
          initials: 'VC',
          colorKey: 'indigo',
        ),
        Investor(
          id: '2',
          name: 'NorthStar Ventures',
          firm: 'NorthStar Ventures',
          focus: 'Pre-Seed',
          location: 'London',
          investmentRange: 400000,
          portfolioSize: 32,
          initials: 'NV',
          colorKey: 'teal',
        ),
      ],
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleFollow(String investorId) {
    final updated = state.investors.map((i) {
      if (i.id == investorId) {
        return Investor(
          id: i.id,
          name: i.name,
          firm: i.firm,
          focus: i.focus,
          location: i.location,
          investmentRange: i.investmentRange,
          portfolioSize: i.portfolioSize,
          initials: i.initials,
          colorKey: i.colorKey,
          isFollowing: !i.isFollowing,
        );
      }
      return i;
    }).toList();
    state = state.copyWith(investors: updated);
  }
}

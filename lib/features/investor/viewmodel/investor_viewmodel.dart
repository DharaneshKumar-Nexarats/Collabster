import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/investment_model.dart';
import '../model/funding_round_model.dart';
import '../model/investor_model.dart';
import 'investor_state.dart';

class InvestorViewModel extends StateNotifier<InvestorState> {
  InvestorViewModel() : super(const InvestorState());

  void loadInvestorData() {
    _loadAll();
  }

  /// Backwards-compatible alias used by the Connection Bridge.
  void loadInvestors() => loadInvestorData();

  void _loadAll() {
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
          colorKey: 'gold',
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
        Investor(
          id: '3',
          name: 'GoldenLeaf Capital',
          firm: 'GoldenLeaf Capital',
          focus: 'Seed',
          location: 'Bengaluru',
          investmentRange: 300000,
          portfolioSize: 28,
          initials: 'GC',
          colorKey: 'green',
        ),
        Investor(
          id: '4',
          name: 'Meridian Angels',
          firm: 'Meridian Angels',
          focus: 'Angel',
          location: 'Dubai',
          investmentRange: 250000,
          portfolioSize: 19,
          initials: 'MA',
          colorKey: 'purple',
        ),
      ],
      investments: const [
        Investment(
          id: 'inv1',
          company: 'Nova Robotics',
          sector: 'Robotics',
          stage: 'Series A',
          invested: 250000,
          currentValue: 415000,
          equity: 4.2,
          round: 'Series A',
          colorKey: 'gold',
        ),
        Investment(
          id: 'inv2',
          company: 'FinEdge',
          sector: 'Fintech',
          stage: 'Seed',
          invested: 120000,
          currentValue: 178000,
          equity: 2.8,
          round: 'Seed',
          colorKey: 'green',
        ),
        Investment(
          id: 'inv3',
          company: 'Cloudly AI',
          sector: 'AI / SaaS',
          stage: 'Pre-Seed',
          invested: 90000,
          currentValue: 61000,
          equity: 5.5,
          round: 'Pre-Seed',
          colorKey: 'blue',
        ),
        Investment(
          id: 'inv4',
          company: 'EcoKart',
          sector: 'E-commerce',
          stage: 'Series B',
          invested: 180000,
          currentValue: 242000,
          equity: 1.9,
          round: 'Series B',
          colorKey: 'purple',
        ),
        Investment(
          id: 'inv5',
          company: 'MediSense',
          sector: 'HealthTech',
          stage: 'Seed',
          invested: 95000,
          currentValue: 128500,
          equity: 3.1,
          round: 'Seed',
          colorKey: 'orange',
        ),
      ],
      fundingRounds: const [
        FundingRound(
          id: 'fr1',
          startup: 'Nova Robotics',
          sector: 'Robotics',
          stage: 'Series A',
          targetAmount: 1200000,
          raisedAmount: 890000,
          location: 'San Francisco, US',
          colorKey: 'gold',
          investors: 14,
          closeDate: 'Aug 28',
        ),
        FundingRound(
          id: 'fr2',
          startup: 'FinEdge',
          sector: 'Fintech',
          stage: 'Seed',
          targetAmount: 600000,
          raisedAmount: 540000,
          location: 'London, UK',
          colorKey: 'green',
          investors: 9,
          closeDate: 'Sep 04',
        ),
        FundingRound(
          id: 'fr3',
          startup: 'Cloudly AI',
          sector: 'AI / SaaS',
          stage: 'Pre-Seed',
          targetAmount: 350000,
          raisedAmount: 212000,
          location: 'Bengaluru, IN',
          colorKey: 'blue',
          investors: 6,
          closeDate: 'Sep 12',
        ),
        FundingRound(
          id: 'fr4',
          startup: 'MediSense',
          sector: 'HealthTech',
          stage: 'Seed',
          targetAmount: 500000,
          raisedAmount: 175000,
          location: 'Berlin, DE',
          colorKey: 'orange',
          investors: 4,
          closeDate: 'Sep 19',
        ),
        FundingRound(
          id: 'fr5',
          startup: 'EcoKart',
          sector: 'E-commerce',
          stage: 'Series B',
          targetAmount: 2000000,
          raisedAmount: 1410000,
          location: 'Singapore, SG',
          colorKey: 'purple',
          investors: 18,
          closeDate: 'Sep 25',
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

  /// Commits capital to a live funding round and records it as a holding.
  void investInRound(FundingRound round, double amount) {
    final updatedRounds = state.fundingRounds.map((r) {
      if (r.id != round.id) return r;
      return FundingRound(
        id: r.id,
        startup: r.startup,
        sector: r.sector,
        stage: r.stage,
        targetAmount: r.targetAmount,
        raisedAmount: r.raisedAmount + amount,
        location: r.location,
        colorKey: r.colorKey,
        investors: r.investors + 1,
        closeDate: r.closeDate,
      );
    }).toList();

    final holding = Investment(
      id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
      company: round.startup,
      sector: round.sector,
      stage: round.stage,
      invested: amount,
      currentValue: amount,
      equity: 1.0,
      round: round.stage,
      colorKey: round.colorKey,
    );

    state = state.copyWith(
      fundingRounds: updatedRounds,
      investments: [...state.investments, holding],
    );
  }

  /// Adds a new deal / funding round to the live deal flow.
  void addFundingRound(FundingRound round) {
    state = state.copyWith(
      fundingRounds: [round, ...state.fundingRounds],
    );
  }
}

/// Monthly portfolio growth series used by the animated line chart.
const List<double> portfolioGrowthSeries = [
  310000, 322000, 318000, 346000, 362000, 358000,
  391000, 402000, 434000, 452000, 481000, 510000,
];

const List<String> portfolioGrowthLabels = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
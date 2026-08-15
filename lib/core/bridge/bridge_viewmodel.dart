import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../features/career/viewmodel/career_viewmodel.dart';
import '../../features/community/viewmodel/post_viewmodel.dart';
import '../../features/event/viewmodel/event_viewmodel.dart';
import '../../features/investor/viewmodel/investor_viewmodel.dart';
import '../../features/startup/viewmodel/hiring_viewmodel.dart';
import '../../features/startup/viewmodel/investor_pipeline_viewmodel.dart';
import 'bridge_models.dart';
import 'bridge_state.dart';

/// Aggregates data from every mode (Startup, Career, Community, Event,
/// Investor) into unified cross-mode lists consumed by the Connect hub
/// and by bridged sections inside each mode's home.
class BridgeViewModel extends StateNotifier<BridgeState> {
  final EventViewModel _eventViewModel;
  final CareerViewModel _careerViewModel;
  final HiringViewModel _hiringViewModel;
  final PostViewModel _postViewModel;
  final InvestorPipelineViewModel _investorPipelineViewModel;
  final InvestorViewModel _investorViewModel;
  final AuthViewModel _authViewModel;

  BridgeViewModel({
    required EventViewModel eventViewModel,
    required CareerViewModel careerViewModel,
    required HiringViewModel hiringViewModel,
    required PostViewModel postViewModel,
    required InvestorPipelineViewModel investorPipelineViewModel,
    required InvestorViewModel investorViewModel,
    required AuthViewModel authViewModel,
  })  : _eventViewModel = eventViewModel,
        _careerViewModel = careerViewModel,
        _hiringViewModel = hiringViewModel,
        _postViewModel = postViewModel,
        _investorPipelineViewModel = investorPipelineViewModel,
        _investorViewModel = investorViewModel,
        _authViewModel = authViewModel,
        super(const BridgeState());

  /// Loads (and re-aggregates) data from every connected mode.
  void loadAll() {
    _eventViewModel.loadEvents();
    _careerViewModel.loadInitialData();
    _hiringViewModel.loadInitialData();
    _postViewModel.loadPosts();
    _investorPipelineViewModel.loadInitialData();
    _investorViewModel.loadInvestors();

    final session = _authViewModel.state.session;
    final startupName = (session?.startupName?.isNotEmpty == true)
        ? session!.startupName!
        : session?.joinedStartupName;

    final opportunities = [
      ...startupHiringOpportunities(
        _hiringViewModel.state.roles
            .where((r) => r.roleType == 'job')
            .toList(),
        startupName: startupName ?? 'Startup',
      ),
      ...startupHiringOpportunities(
        _hiringViewModel.state.roles
            .where((r) => r.roleType == 'internship')
            .toList(),
        startupName: startupName ?? 'Startup',
      ),
      ...careerJobOpportunities(_careerViewModel.state.jobs),
    ];

    final posts = [
      ...(session?.posts ?? const [])
          .map((p) => startupPostToBridge(p, startupName: startupName ?? 'Startup')),
      ..._postViewModel.state.posts.map(careerPostToBridge),
    ];

    final events = [
      ..._eventViewModel.state.events.map(eventToBridge),
    ];

    final investors = [
      ...startupPipelineToBridge(
        _investorPipelineViewModel.state.discoverInvestors,
        sourceLabel: startupName ?? 'Startup Pipeline',
      ),
      ...investorModeToBridge(_investorViewModel.state.investors),
    ];

    state = BridgeState(
      opportunities: opportunities,
      posts: posts,
      events: events,
      investors: investors,
      isLoaded: true,
    );
  }
}
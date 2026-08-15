import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'team_viewmodel.dart';
import 'team_state.dart';
import 'requests_viewmodel.dart';
import 'requests_state.dart';

final teamViewModelProvider = StateNotifierProvider<TeamViewModel, TeamState>((ref) {
  return TeamViewModel();
});

final requestsViewModelProvider = StateNotifierProvider<RequestsViewModel, RequestsState>((ref) {
  return RequestsViewModel();
});

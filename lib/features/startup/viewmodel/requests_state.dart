import '../model/startup_models.dart';

class RequestsState {
  const RequestsState({
    this.pending = const [],
    this.accepted = const [],
    this.connected = 24,
    this.ignored = 8,
  });

  final List<ConnectionRequest> pending;
  final List<ConnectionRequest> accepted;
  final int connected;
  final int ignored;

  int get pendingCount => pending.length;

  RequestsState copyWith({
    List<ConnectionRequest>? pending,
    List<ConnectionRequest>? accepted,
    int? connected,
    int? ignored,
  }) {
    return RequestsState(
      pending: pending ?? this.pending,
      accepted: accepted ?? this.accepted,
      connected: connected ?? this.connected,
      ignored: ignored ?? this.ignored,
    );
  }
}

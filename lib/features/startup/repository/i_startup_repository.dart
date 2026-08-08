import '../model/startup_models.dart';

abstract class IStartupRepository {
  Future<List<SuggestedStartup>> searchStartups(String query);
  Future<void> createStartup(Map<String, dynamic> data);
  Future<void> inviteTeamMember(String email, String role);
}

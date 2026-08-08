import '../model/startup_models.dart';
import 'i_startup_repository.dart';

class StartupRepositoryImpl implements IStartupRepository {
  @override
  Future<List<SuggestedStartup>> searchStartups(String query) async {
    return [];
  }

  @override
  Future<void> createStartup(Map<String, dynamic> data) async {
    // TODO: Implement
  }

  @override
  Future<void> inviteTeamMember(String email, String role) async {
    // TODO: Implement
  }
}

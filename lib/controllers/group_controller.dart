import 'package:rxdart/rxdart.dart';

import '../models/group.dart';
import '../services/api_service.dart';

class GroupController {
  GroupController._();
  static GroupController? _instance;
  static GroupController get instance => _instance ??= GroupController._();

  ApiService api = ApiService.instance;
  BehaviorSubject<List<Group>?> groupsSubject = BehaviorSubject.seeded(null);

  Future<void> fetchGroups() async {
    final groups = (await api.getUserGroups()) ?? [];
    groupsSubject.add(groups);
  }

  Future<void> createGroup({required String name}) async {
    await api.addGroup(name);
  }
}

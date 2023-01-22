import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
    await fetchGroups();
  }

  Future<String> scanQR() async => await FlutterBarcodeScanner.scanBarcode("#0000ee", "Cancel", true, ScanMode.QR);

  Future<void> joinGroup() async {
    await api.joinGroup(await scanQR());
    await fetchGroups();
  }
}

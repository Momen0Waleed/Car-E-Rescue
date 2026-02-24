import 'package:flutter/material.dart';
import '../model/mechanic_history_model.dart';
import '../model/mechainc_history_repo.dart';

class MechaincHistoryViewModel extends ChangeNotifier {
  final MechaincHistoryRepo _repo = MechaincHistoryRepo();

  List<MechanicHistoryModel> historyRequests = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> getHistory() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      historyRequests = await _repo.fetchHistory();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
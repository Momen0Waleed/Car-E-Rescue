import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/user_request_model.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/request_history/model/request_history_repo.dart';
import 'package:flutter/material.dart';

class RequestHistoryViewModel extends ChangeNotifier {
  final RequestHistoryRepo _repo = RequestHistoryRepo();
  List<UserRequestModel> historyRequests = [];
  bool isLoading = true;

  RequestHistoryViewModel() {
    loadRequestHistory();
  }

  Future<void> loadRequestHistory() async {
    isLoading = true;
    notifyListeners();
    try {
      historyRequests = await _repo.fetchRequestHistory();
    } catch (e) {
      debugPrint("History Fetch Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


      ///For Testing UI
//   Future<void> loadRequestHistory() async {
//     isLoading = true;
//     notifyListeners();
//
//     // Wait a moment to simulate network delay
//     await Future.delayed(const Duration(seconds: 1));
//
//     // MOCK DATA: Create a list with 20 different requests to test scrolling
//     historyRequests = List.generate(20, (index) => UserRequestModel(
//       requestId: 100 + index,
//       mechanicId: "uuid-$index",
//       mechanicName: "Mechanic $index",
//       status: index % 2 == 0 ? "Completed" : "Canceled",
//       type: index == 0 ? "engine" : "tiers and wheels",
//       createdAt: "2024-02-1${index}T10:00:00",
//       completedAt: "2024-02-1${index}T11:00:00",
//     ));
//
//     isLoading = false;
//     notifyListeners();
//   }
}
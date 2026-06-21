import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/user_request_model.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/request_history/model/request_history_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/rating/model/rating_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/rating/model/rating_model.dart';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:flutter/material.dart';

class RequestHistoryViewModel extends ChangeNotifier {
  final RequestHistoryRepo _repo = RequestHistoryRepo();
  List<UserRequestModel> historyRequests = [];
  Map<int, RatingModel> userRatings = {};
  bool isLoading = true;

  RequestHistoryViewModel() {
    loadRequestHistory();
  }

  Future<void> loadRequestHistory() async {
    isLoading = true;
    notifyListeners();
    try {
      historyRequests = await _repo.fetchRequestHistory();
      await fetchRatings();
    } catch (e) {
      debugPrint("History Fetch Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRatings() async {
    try {
      final ratingRepo = RatingRepo();
      final ratingsList = await ratingRepo.fetchUserRatings();
      userRatings = {for (var r in ratingsList) r.requestId: r};
    } catch (e) {
      debugPrint("Ratings Fetch Error: $e");
    }
  }

  Future<bool> deleteRating(int ratingId, int requestId) async {
    try {
      final ratingRepo = RatingRepo();
      await ratingRepo.deleteRating(ratingId);
      userRatings.remove(requestId);
      notifyListeners();
      SnackbarService.showSuccessNotification("Rating deleted");
      return true;
    } catch (e) {
      SnackbarService.showErrorNotification("Error: $e");
      return false;
    }
  }


      ///For Testing UI
  // Future<void> loadRequestHistory() async {
  //   isLoading = true;
  //   notifyListeners();
  //
  //   // Wait a moment to simulate network delay
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   // MOCK DATA: Create a list with 20 different requests to test scrolling
  //   historyRequests = List.generate(20, (index) => UserRequestModel(
  //     requestId: 100 + index,
  //     mechanicId: "uuid-$index",
  //     mechanicName: "Mechanic $index",
  //     status: index % 2 == 0 ? "Completed" : "Canceled",
  //     type: index == 0 ? "engine" : "tiers and wheels",
  //     createdAt: "2024-02-1${index}T10:00:00",
  //     completedAt: "2024-02-1${index}T11:00:00",
  //   ));
  //
  //   isLoading = false;
  //   notifyListeners();
  // }
}
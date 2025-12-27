import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Stats
  final totalStaff = 150.obs;
  final newStaff = 2.obs;
  final guestsToday = 24.obs;
  final inBuilding = 45.obs;
  final pendingRequests = 3.obs;

  // Chart data (mock)
  final trafficGrowth = 12.obs;
  final totalTraffic = 345.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch data here
  }
}




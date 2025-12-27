import 'package:get/get.dart';
import 'package:quanly/app/database/app_database.dart';

class StaffPresentItem {
  final String id;
  final String name;
  final String department;
  final DateTime? checkInTime;
  final bool isPresent;

  StaffPresentItem({
    required this.id,
    required this.name,
    required this.department,
    this.checkInTime,
    required this.isPresent,
  });
}

class DashboardController extends GetxController {
  final _db = AppDatabase.instance;
  // Stats
  final totalStaff = 150.obs;
  final newStaff = 2.obs;
  final guestsToday = 24.obs;
  final inBuilding = 45.obs;
  final pendingRequests = 3.obs;

  // Chart data
  final trafficGrowth = 0.obs;
  final totalTraffic = 0.obs;
  final trafficData = <Map<String, dynamic>>[].obs;

  RxList<TimeManagementTableData> recentEntrys = RxList<TimeManagementTableData>([]);
  RxList<StaffPresentItem> todayStaffPresent = RxList<StaffPresentItem>([]);
  
  // Store recent entries with resolved names
  final recentEntriesWithNames = <Map<String, dynamic>>[].obs;

  @override 
  void onInit() {
    super.onInit();
    // Fetch data here
    refreshAllData();
  }
  
  Future<void> refreshAllData() async {
    await Future.wait([
      getTotalStaff(),
      getTodayTotalEntry(),
      getTodayTotalNotEntry(),
      getRecentEntrys(),
      getTodayStaffPresent(),
      getTrafficData(),
    ]);
  }
  
  Future<void> getTrafficData() async {
    try {
      // Get traffic for last 7 days
      final last7Days = await _db.getTrafficLast7Days();
      trafficData.value = last7Days;
      
      // Calculate total traffic (sum of all entries in last 7 days)
      totalTraffic.value = last7Days.fold<int>(
        0,
        (sum, day) => sum + (day['count'] as int),
      );
      
      // Get traffic for previous 7 days for comparison
      final previous7Days = await _db.getTrafficPrevious7Days();
      final previousTotal = previous7Days.fold<int>(
        0,
        (sum, day) => sum + (day['count'] as int),
      );
      
      // Calculate growth percentage
      if (previousTotal > 0) {
        final growth = ((totalTraffic.value - previousTotal) / previousTotal * 100).round();
        trafficGrowth.value = growth;
      } else if (totalTraffic.value > 0) {
        trafficGrowth.value = 100; // 100% growth if no previous data
      } else {
        trafficGrowth.value = 0;
      }
    } catch (e) {
      print('Error getting traffic data: $e');
      trafficData.value = [];
      totalTraffic.value = 0;
      trafficGrowth.value = 0;
    }
  }

  Future<void> getTodayTotalNotEntry() async {
    inBuilding.value = await _db.getTodayTotalNotEntry();
  }

  Future<void> getTotalStaff() async {
    totalStaff.value = await _db.getTotalStaff();
  }

  Future<void> getTodayTotalEntry() async {
    guestsToday.value = await _db.getTodayEntryCount();
  }

  Future<void> getRecentEntrys() async {
    recentEntrys.clear();
    recentEntrys.addAll(await _db.getTimeManagement(1, 10, sortByDateTime: true));
    
    // Resolve member names for recent entries
    recentEntriesWithNames.clear();
    for (var entry in recentEntrys) {
      String name = 'Unknown';
      if (entry.role == 'member') {
        final member = await _db.getMemberById(entry.memberId);
        name = member?.name ?? 'Unknown';
      } else if (entry.role == 'anonymus') {
        final guest = await _db.getGuestById(entry.memberId);
        name = guest?.name ?? 'Unknown';
      }
      recentEntriesWithNames.add({
        'entry': entry,
        'name': name,
      });
    }
  }

  Future<void> getTodayStaffPresent() async {
    try {
      final data = await _db.getTodayStaffPresent();
      todayStaffPresent.clear();
      
      for (var item in data) {
        final member = item['member'] as MemberTableData;
        final departmentName = item['departmentName'] as String;
        final checkInTime = item['checkInTime'] as DateTime?;
        final hasCheckedIn = item['hasCheckedIn'] as bool;

        todayStaffPresent.add(StaffPresentItem(
          id: member.id,
          name: member.name,
          department: departmentName,
          checkInTime: checkInTime,
          isPresent: hasCheckedIn,
        ));
      }
    } catch (e) {
      // Handle error silently or log it
      todayStaffPresent.clear();
    }
  }
}




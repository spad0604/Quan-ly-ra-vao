import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:quanly/app/database/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

class HistoryItem {
  final String id;
  final String name;
  final String memberCode; // Identity number or Staff ID
  final String department;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String status;
  final Color statusColor;
  final String role; // 'member' or 'anonymus'

  HistoryItem({
    required this.id,
    required this.name,
    required this.memberCode,
    required this.department,
    required this.checkInTime,
    this.checkOutTime,
    required this.status,
    required this.statusColor,
    required this.role,
  });
}

class HistoryController extends GetxController {
  // Filters
  final selectedFilter = 0.obs; // 0: Staff, 1: Guest
  final searchController = TextEditingController();
  final selectedDate = '15/10/2023'.obs; // Mock date for now, should be real date picker
  
  // Data
  final historyList = <HistoryItem>[].obs;
  final isLoading = false.obs;

  final _db = AppDatabase.instance;

  @override
  void onInit() {
    super.onInit();
    // Default to today
    selectedDate.value = DateFormat('dd/MM/yyyy').format(DateTime.now());
    fetchHistory();
    
    // Debounce search
    searchController.addListener(() {
      // Simple debounce logic could be added here
      if (searchController.text.isEmpty) {
        fetchHistory();
      }
    });
  }

  void changeFilter(int index) {
    selectedFilter.value = index;
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    historyList.clear();

    try {
      final isStaff = selectedFilter.value == 0;
      
      // Query TimeManagementTable based on role
      // Note: role is stored as string in DB based on our previous insert logic
      final roleFilter = isStaff ? 'member' : 'anonymus';
      
      // Simple join query logic
      // Since drift's join syntax can be verbose, we'll do manual fetch & merge for simplicity 
      // or use simple joins if possible.
      // Let's query TimeManagement first.
      
      final timeLogs = await (_db.select(_db.timeManagementTable)
        ..where((tbl) => tbl.role.equals(roleFilter))
        ..orderBy([(t) => drift.OrderingTerm(expression: t.checkInTime, mode: drift.OrderingMode.desc)]))
        .get();

      for (var log in timeLogs) {
        String name = 'Unknown';
        String code = '---';
        String dept = '---';
        
        if (isStaff) {
          final member = await (_db.select(_db.memberTable)..where((tbl) => tbl.id.equals(log.memberId))).getSingleOrNull();
          if (member != null) {
            name = member.name;
            code = member.identityNumber; // Or use ID
            // Get Dept
            if (member.departmentId.isNotEmpty) {
               final department = await _db.getDepartmentById(member.departmentId);
               dept = department?.name ?? '---';
            }
          }
        } else {
          final guest = await (_db.select(_db.anonymusTable)..where((tbl) => tbl.id.equals(log.memberId))).getSingleOrNull();
          if (guest != null) {
            name = guest.name;
            code = guest.identityNumber;
            // Use reason from guest table or note from time log
            dept = guest.reason.isNotEmpty ? guest.reason : (log.note ?? 'Khách vãng lai');
          }
        }

        // Apply search filter in memory (for simplicity)
        if (searchController.text.isNotEmpty) {
          final query = searchController.text.toLowerCase();
          if (!name.toLowerCase().contains(query) && !code.toLowerCase().contains(query)) {
            continue;
          }
        }

        // Determine Status & Color
        String statusText = 'Đang ở trong';
        Color statusColor = Colors.green;
        
        if (log.checkOutTime != null) {
          statusText = 'Đã ra về';
          statusColor = Colors.grey;
        }

        historyList.add(HistoryItem(
          id: log.id,
          name: name,
          memberCode: code,
          department: dept,
          checkInTime: log.checkInTime,
          checkOutTime: log.checkOutTime,
          status: statusText,
          statusColor: statusColor,
          role: roleFilter,
        ));
      }

    } catch (e) {
      print('Error fetching history: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

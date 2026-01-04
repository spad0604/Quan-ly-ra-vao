import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/core/services/excel_export_service.dart';
import 'package:quanly/core/authentication/authentication_service.dart';
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
  final startDate = DateTime.now().obs;
  final endDate = DateTime.now().obs;
  final selectedStatus = 0.obs; // 0: All, 1: In building, 2: Left
  
  // Data
  final historyList = <HistoryItem>[].obs;
  final isLoading = false.obs;
  
  Timer? _debounceTimer;

  final _db = AppDatabase.instance;
  final _excelExportService = ExcelExportService();
  final _authenticationService = AuthenticationService();

  @override
  void onInit() {
    super.onInit();
    // Default to today
    final now = DateTime.now();
    startDate.value = now;
    endDate.value = now;
    fetchHistory();
    
    // Debounce search
    searchController.addListener(() {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        fetchHistory();
      });
    });
  }
  
  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }
  
  String get formattedStartDate => DateFormat('dd/MM/yyyy').format(startDate.value);
  String get formattedEndDate => DateFormat('dd/MM/yyyy').format(endDate.value);
  
  void selectStartDate(DateTime date) {
    startDate.value = date;
    // Ensure endDate is not before startDate
    if (endDate.value.isBefore(date)) {
      endDate.value = date;
    }
    fetchHistory();
  }
  
  void selectEndDate(DateTime date) {
    endDate.value = date;
    // Ensure startDate is not after endDate
    if (startDate.value.isAfter(date)) {
      startDate.value = date;
    }
    fetchHistory();
  }
  
  void selectStatus(int status) {
    selectedStatus.value = status;
    fetchHistory();
  }
  
  String get statusText {
    switch (selectedStatus.value) {
      case 1:
        return 'history_in_building'.tr;
      case 2:
        return 'history_left'.tr;
      default:
        return 'history_all_status'.tr;
    }
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
      
      // Build date range filter - filter by date range (ignore time)
      final start = DateTime(startDate.value.year, startDate.value.month, startDate.value.day);
      final end = DateTime(endDate.value.year, endDate.value.month, endDate.value.day, 23, 59, 59);
      
      // Get all logs for the role first, then filter by date range in memory
      // This is simpler than trying to do complex date range queries in Drift
      var query = _db.select(_db.timeManagementTable)
        ..where((tbl) => tbl.role.equals(roleFilter))
        ..orderBy([(t) => drift.OrderingTerm(expression: t.checkInTime, mode: drift.OrderingMode.desc)]);
      
      final allTimeLogs = await query.get();
      
      // Filter by date range
      final filteredTimeLogs = allTimeLogs.where((log) {
        final logDate = log.checkInTime;
        return !logDate.isBefore(start) && !logDate.isAfter(end);
      }).toList();
      
      for (var log in filteredTimeLogs) {
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

        // Determine Status & Color
        String statusText = 'history_in_building'.tr;
        Color statusColor = Colors.green;
        bool hasLeft = false;
        
        if (log.checkOutTime != null) {
          statusText = 'history_left'.tr;
          statusColor = Colors.grey;
          hasLeft = true;
        }
        
        // Apply status filter
        if (selectedStatus.value == 1 && hasLeft) {
          continue; // Skip if filtering for "In building" but has left
        }
        if (selectedStatus.value == 2 && !hasLeft) {
          continue; // Skip if filtering for "Left" but still in building
        }
        
        // Apply search filter in memory (for simplicity)
        if (searchController.text.isNotEmpty) {
          final query = searchController.text.toLowerCase();
          if (!name.toLowerCase().contains(query) && !code.toLowerCase().contains(query)) {
            continue;
          }
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

  Future<void> exportHistoryToExcel() async {
    try {
      isLoading.value = true;
      
      // Prepare data for export
      final exportData = <Map<String, dynamic>>[];
      final isStaff = selectedFilter.value == 0;
      
      for (var item in historyList) {
        // Decode identity number
        String identityNumber = item.memberCode;
        try {
          identityNumber = _authenticationService.decodeIndentityNumber(item.memberCode);
        } catch (e) {
          // Already decoded or not encrypted
        }

        final data = {
          'name': item.name,
          'identity_number': identityNumber,
          'check_in_time': item.checkInTime.millisecondsSinceEpoch ~/ 1000,
          'check_out_time': item.checkOutTime != null ? item.checkOutTime!.millisecondsSinceEpoch ~/ 1000 : null,
          'reason': isStaff ? null : item.department,
        };
        exportData.add(data);
      }

      final filePath = await _excelExportService.exportHistory(exportData, isStaff: isStaff);
      isLoading.value = false;

      if (filePath != null) {
        Get.snackbar(
          'Thành công',
          'Xuất Excel thành công!\nFile: $filePath',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Lỗi',
          'Lỗi khi xuất Excel',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Lỗi',
        'Lỗi khi xuất Excel: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

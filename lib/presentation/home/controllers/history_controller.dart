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

  // Pagination
  final currentPage = 1.obs;
  final pageSize = 10;
  final totalCount = 0.obs;

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
        currentPage.value = 1;
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

  String get formattedStartDate =>
      DateFormat('dd/MM/yyyy').format(startDate.value);
  String get formattedEndDate => DateFormat('dd/MM/yyyy').format(endDate.value);

  int get totalPages {
    final total = totalCount.value;
    if (total <= 0) return 0;
    return (total / pageSize).ceil();
  }

  void selectStartDate(DateTime date) {
    startDate.value = date;
    // Ensure endDate is not before startDate
    if (endDate.value.isBefore(date)) {
      endDate.value = date;
    }
    currentPage.value = 1;
    fetchHistory();
  }

  void selectEndDate(DateTime date) {
    endDate.value = date;
    // Ensure startDate is not after endDate
    if (startDate.value.isAfter(date)) {
      startDate.value = date;
    }
    currentPage.value = 1;
    fetchHistory();
  }

  void selectStatus(int status) {
    selectedStatus.value = status;
    currentPage.value = 1;
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
    currentPage.value = 1;
    fetchHistory();
  }

  void previousPage() {
    if (currentPage.value <= 1) return;
    currentPage.value -= 1;
    fetchHistory();
  }

  void nextPage() {
    final tp = totalPages;
    if (tp <= 0) return;
    if (currentPage.value >= tp) return;
    currentPage.value += 1;
    fetchHistory();
  }

  void goToPage(int page) {
    final tp = totalPages;
    if (tp <= 0) return;
    final clamped = page.clamp(1, tp);
    if (clamped == currentPage.value) return;
    currentPage.value = clamped;
    fetchHistory();
  }

  Future<List<String>?> _resolveMemberIdsForSearch({
    required bool isStaff,
    required String searchText,
  }) async {
    final q = searchText.trim();
    if (q.isEmpty) return null;

    if (isStaff) {
      final rows = await (_db.select(
        _db.memberTable,
      )..where((t) => t.name.like('%$q%') | t.id.like('%$q%'))).get();
      return rows.map((e) => e.id).toList();
    }

    final rows =
        await (_db.select(_db.anonymusTable)..where(
              (t) =>
                  t.name.like('%$q%') |
                  t.identityNumber.like('%$q%') |
                  t.id.like('%$q%'),
            ))
            .get();
    return rows.map((e) => e.id).toList();
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
      final start = DateTime(
        startDate.value.year,
        startDate.value.month,
        startDate.value.day,
      );
      final end = DateTime(
        endDate.value.year,
        endDate.value.month,
        endDate.value.day,
        23,
        59,
        59,
      );

      bool? isInBuilding;
      if (selectedStatus.value == 1) {
        isInBuilding = true;
      } else if (selectedStatus.value == 2) {
        isInBuilding = false;
      }

      final memberIds = await _resolveMemberIdsForSearch(
        isStaff: isStaff,
        searchText: searchController.text,
      );

      totalCount.value = await _db.getTotalTimeManagementCount(
        role: roleFilter,
        start: start,
        end: end,
        isInBuilding: isInBuilding,
        memberIds: memberIds,
      );

      final logs = await _db.searchTimeManagement(
        page: currentPage.value,
        pageSize: pageSize,
        role: roleFilter,
        start: start,
        end: end,
        isInBuilding: isInBuilding,
        memberIds: memberIds,
      );

      if (logs.isEmpty) {
        return;
      }

      final idsOnPage = logs.map((e) => e.memberId).toSet().toList();

      final Map<String, dynamic> peopleById = {};
      if (isStaff) {
        final members = await (_db.select(
          _db.memberTable,
        )..where((t) => t.id.isIn(idsOnPage))).get();
        for (final m in members) {
          peopleById[m.id] = m;
        }
      } else {
        final guests = await (_db.select(
          _db.anonymusTable,
        )..where((t) => t.id.isIn(idsOnPage))).get();
        for (final g in guests) {
          peopleById[g.id] = g;
        }
      }

      final Map<String, String> deptNameById = {};

      for (final log in logs) {
        String name = 'Unknown';
        String code = '---';
        String dept = '---';

        if (isStaff) {
          final member = peopleById[log.memberId];
          if (member != null) {
            // MemberTableData
            name = member.name;
            code = member.identityNumber;

            final deptId = member.departmentId;
            if (deptId != null && deptId.isNotEmpty) {
              deptNameById[deptId] ??=
                  (await _db.getDepartmentById(deptId))?.name ?? '---';
              dept = deptNameById[deptId] ?? '---';
            }
          }
        } else {
          final guest = peopleById[log.memberId];
          if (guest != null) {
            // AnonymusTableData
            name = guest.name;
            code = guest.identityNumber;
            dept = guest.reason.isNotEmpty
                ? guest.reason
                : (log.note ?? 'Khách vãng lai');
          }
        }

        // Determine Status & Color
        String statusText = 'history_in_building'.tr;
        Color statusColor = Colors.green;
        if (log.checkOutTime != null) {
          statusText = 'history_left'.tr;
          statusColor = Colors.grey;
        }

        historyList.add(
          HistoryItem(
            id: log.id,
            name: name,
            memberCode: code,
            department: dept,
            checkInTime: log.checkInTime,
            checkOutTime: log.checkOutTime,
            status: statusText,
            statusColor: statusColor,
            role: roleFilter,
          ),
        );
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

      final isStaff = selectedFilter.value == 0;
      final roleFilter = isStaff ? 'member' : 'anonymus';
      final start = DateTime(
        startDate.value.year,
        startDate.value.month,
        startDate.value.day,
      );
      final end = DateTime(
        endDate.value.year,
        endDate.value.month,
        endDate.value.day,
        23,
        59,
        59,
      );

      bool? isInBuilding;
      if (selectedStatus.value == 1) {
        isInBuilding = true;
      } else if (selectedStatus.value == 2) {
        isInBuilding = false;
      }

      final memberIds = await _resolveMemberIdsForSearch(
        isStaff: isStaff,
        searchText: searchController.text,
      );

      final exportTotal = await _db.getTotalTimeManagementCount(
        role: roleFilter,
        start: start,
        end: end,
        isInBuilding: isInBuilding,
        memberIds: memberIds,
      );

      final logs = exportTotal > 0
          ? await _db.searchTimeManagement(
              page: 1,
              pageSize: exportTotal,
              role: roleFilter,
              start: start,
              end: end,
              isInBuilding: isInBuilding,
              memberIds: memberIds,
            )
          : <TimeManagementTableData>[];

      final exportData = <Map<String, dynamic>>[];
      for (final log in logs) {
        String name = 'Unknown';
        String identityNumber = '---';
        String reason;

        if (isStaff) {
          final member = await (_db.select(
            _db.memberTable,
          )..where((t) => t.id.equals(log.memberId))).getSingleOrNull();
          if (member != null) {
            name = member.name;
            identityNumber = member.identityNumber;
          }
          reason = '';
        } else {
          final guest = await (_db.select(
            _db.anonymusTable,
          )..where((t) => t.id.equals(log.memberId))).getSingleOrNull();
          if (guest != null) {
            name = guest.name;
            identityNumber = guest.identityNumber;
          }
          reason = guest?.reason ?? '';
        }

        // Decode identity number
        try {
          identityNumber = _authenticationService.decodeIndentityNumber(
            identityNumber,
          );
        } catch (e) {
          // Already decoded or not encrypted
        }

        exportData.add({
          'name': name,
          'identity_number': identityNumber,
          'check_in_time': log.checkInTime.millisecondsSinceEpoch ~/ 1000,
          'check_out_time': log.checkOutTime != null
              ? log.checkOutTime!.millisecondsSinceEpoch ~/ 1000
              : null,
          'reason': isStaff ? null : reason,
        });
      }

      final filePath = await _excelExportService.exportHistory(
        exportData,
        isStaff: isStaff,
      );
      isLoading.value = false;

      if (filePath != null) {
        final fileName = filePath.split(RegExp(r'[\\\\/]')).last;
        Get.showSnackbar(
          GetSnackBar(
            titleText: const Text('Thành công', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            messageText: Text('Đã xuất: $fileName', style: const TextStyle(color: Colors.white)),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            margin: EdgeInsets.only(
              right: 16,
              bottom: 16,
              left: Get.width * 0.55,
            ),
            borderRadius: 10,
            duration: const Duration(seconds: 6),
            mainButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async {
                    final ok = await _excelExportService.openFile(filePath);
                    if (!ok) {
                      await _excelExportService.revealInFolder(filePath);
                    }
                  },
                  child: const Text(
                    'Mở file',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    await _excelExportService.revealInFolder(filePath);
                  },
                  child: const Text(
                    'Mở thư mục',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        Get.showSnackbar(
          GetSnackBar(
            titleText: const Text('Lỗi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            messageText: const Text('Lỗi khi xuất Excel', style: TextStyle(color: Colors.white)),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            margin: EdgeInsets.only(
              right: 16,
              bottom: 16,
              left: Get.width * 0.55,
            ),
            borderRadius: 10,
            duration: const Duration(seconds: 4),
          ),
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

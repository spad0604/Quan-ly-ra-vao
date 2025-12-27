import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quanly/app/database/admin_table.dart';
import 'package:quanly/app/database/member_table.dart';
import 'package:quanly/app/database/time_management_table.dart';
import 'package:quanly/core/authentication/authentication_service.dart';
import 'package:quanly/app/database/department_table.dart';
import 'package:quanly/app/database/anonymus_table.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    TimeManagementTable,
    MemberTable,
    AdminTable,
    DepartmentTable,
    AnonymusTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  static AppDatabase get instance => _instance;

  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Add position and sex columns
        await m.addColumn(memberTable, memberTable.position);
        await m.addColumn(memberTable, memberTable.sex);
      }
      if (from < 4) {
        // Create AnonymusTable if it doesn't exist
        try {
          await m.database.customStatement('''
            CREATE TABLE IF NOT EXISTS anonymus_table (
              id TEXT NOT NULL PRIMARY KEY,
              name TEXT NOT NULL,
              identity_number TEXT NOT NULL,
              address TEXT NOT NULL,
              date_of_birth TEXT NOT NULL,
              reason TEXT NOT NULL
            )
          ''');
        } catch (e) {
          print('Error creating anonymus_table: $e');
        }
        // Try to add reason column if table exists but column doesn't
        try {
          await m.addColumn(anonymusTable, anonymusTable.reason);
        } catch (e) {
          // Column might already exist, ignore
          print('AnonymusTable reason column migration: $e');
        }
      }
      // Note: SQLite TEXT columns don't have max length constraints in the database,
      // so no migration is needed. The maxLength is only enforced by Drift at the application level.
      // Schema version 6 was added to update the schema definition.
    },
  );

  Future<void> createMemeber(MemberTableCompanion member) async {
    await into(memberTable).insert(member);
  }

  Future<void> deleteMember(String memberId) async {
    await (delete(memberTable)..where((tbl) => tbl.id.equals(memberId))).go();
  }

  Future<void> updateMember(
    String memberId,
    MemberTableCompanion member,
  ) async {
    await (update(
      memberTable,
    )..where((tbl) => tbl.id.equals(memberId))).write(member);
  }

  Future<MemberTableData?> getMemberById(String memberId) async {
    try {
      final member = await (select(
        memberTable,
      )..where((tbl) => tbl.id.equals(memberId))).getSingleOrNull();
      return member;
    } catch (e) {
      return null;
    }
  }

  Future<MemberTableData?> getMemberByIdentityNumber(
    String identityNumber,
  ) async {
    try {
      // Because encryption uses random IV, we cannot directly compare encoded values.
      // We need to fetch all members, decode their identityNumbers, and compare.
      final allMembers = await select(memberTable).get();
      for (final member in allMembers) {
        try {
          final decodedId = _authenticationService.decodeIndentityNumber(
            member.identityNumber,
          );
          if (decodedId == identityNumber) {
            return member;
          }
        } catch (e) {
          // Skip members with invalid encoded identityNumber
          continue;
        }
      }
      return null;
    } catch (e) {
      print('Error getting member by identity number: $e');
      return null;
    }
  }

  Future<int> getTodayEntryCount() async {
    try {
      final today = DateTime.now();
      final list =
          await (select(timeManagementTable)..where(
                (tbl) =>
                    tbl.checkInTime.year.equals(today.year) &
                    tbl.checkInTime.month.equals(today.month) &
                    tbl.checkInTime.day.equals(today.day),
              ))
              .get();
      return list.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getTodayTotalNotEntry() async {
    try {
      final today = DateTime.now();
      final list =
          await (select(timeManagementTable)..where(
                (tbl) =>
                    tbl.checkInTime.year.equals(today.year) &
                    tbl.checkInTime.month.equals(today.month) &
                    tbl.checkInTime.day.equals(today.day) &
                    tbl.status.equals(Status.entry.value),
              ))
              .get();
      return list.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getTotalStaff() async {
    try {
      final list = await select(memberTable).get();
      return list.length;
    } catch (e) {
      return 0;
    }
  }

  Future<List<TimeManagementTableData>> getTimeManagement(
    int page,
    int pageSize, {
    bool sortByDateTime = true,
  }) async {
    try {
      final query = select(timeManagementTable)
        ..orderBy([
          (tbl) => OrderingTerm(
            expression: tbl.checkInTime,
            mode: sortByDateTime ? OrderingMode.desc : OrderingMode.asc,
          ),
        ])
        ..limit(pageSize, offset: (page - 1) * pageSize);
      final list = await query.get();
      return list;
    } catch (e) {
      return [];
    }
  }

  /// Get traffic data for last 7 days (count entries per day)
  /// Returns a list of maps: [{date: DateTime, count: int}, ...]
  Future<List<Map<String, dynamic>>> getTrafficLast7Days() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final sevenDaysAgo = today.subtract(const Duration(days: 6));
      
      // Get all entries
      final allEntries = await select(timeManagementTable).get();
      
      // Filter and group by date (day only, ignore time)
      final Map<DateTime, int> dayCounts = {};
      for (var entry in allEntries) {
        final entryDay = DateTime(
          entry.checkInTime.year,
          entry.checkInTime.month,
          entry.checkInTime.day,
        );
        
        // Check if within last 7 days (including today)
        if (!entryDay.isBefore(sevenDaysAgo) && !entryDay.isAfter(today)) {
          dayCounts[entryDay] = (dayCounts[entryDay] ?? 0) + 1;
        }
      }
      
      // Create list for last 7 days, including days with 0 entries
      final result = <Map<String, dynamic>>[];
      for (int i = 0; i < 7; i++) {
        final date = sevenDaysAgo.add(Duration(days: i));
        result.add({
          'date': date,
          'count': dayCounts[date] ?? 0,
        });
      }
      
      return result;
    } catch (e) {
      print('Error getting traffic last 7 days: $e');
      return [];
    }
  }

  /// Get traffic data for previous 7 days (for comparison)
  /// Returns total count for the 7 days before the last 7 days
  Future<List<Map<String, dynamic>>> getTrafficPrevious7Days() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final sevenDaysAgo = today.subtract(const Duration(days: 6));
      final fourteenDaysAgo = sevenDaysAgo.subtract(const Duration(days: 7));
      final eightDaysAgo = sevenDaysAgo.subtract(const Duration(days: 1));
      
      // Get all entries
      final allEntries = await select(timeManagementTable).get();
      
      // Filter and group by date
      final Map<DateTime, int> dayCounts = {};
      for (var entry in allEntries) {
        final entryDay = DateTime(
          entry.checkInTime.year,
          entry.checkInTime.month,
          entry.checkInTime.day,
        );
        
        // Check if within previous 7 days (8-14 days ago)
        if (!entryDay.isBefore(fourteenDaysAgo) && entryDay.isBefore(eightDaysAgo)) {
          dayCounts[entryDay] = (dayCounts[entryDay] ?? 0) + 1;
        }
      }
      
      // Create list for previous 7 days
      final result = <Map<String, dynamic>>[];
      for (int i = 0; i < 7; i++) {
        final date = fourteenDaysAgo.add(Duration(days: i));
        result.add({
          'date': date,
          'count': dayCounts[date] ?? 0,
        });
      }
      
      return result;
    } catch (e) {
      print('Error getting traffic previous 7 days: $e');
      return [];
    }
  }

  Future<List<TimeManagementTableData>> getAllEntrys(
    int page,
    int pageSize,
  ) async {
    try {
      final list = await (select(
        timeManagementTable,
      )..limit(pageSize, offset: (page - 1) * pageSize)).get();
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List<TimeManagementTableData>> getAllTimeManagements(
    int page,
    int pageSize,
  ) async {
    try {
      final list = await (select(
        timeManagementTable,
      )..limit(pageSize, offset: (page - 1) * pageSize)).get();
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List<MemberTableData>> getAllMember(int page, int pageSize) async {
    try {
      final list = await (select(
        memberTable,
      )..limit(pageSize, offset: (page - 1) * pageSize)).get();
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List<MemberTableData>> searchMembers({
    int page = 1,
    int pageSize = 10,
    String? searchQuery,
    String? departmentId,
  }) async {
    try {
      var query = select(memberTable);

      // Apply search filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query
          ..where(
            (tbl) =>
                tbl.name.like('%$searchQuery%') | tbl.id.like('%$searchQuery%'),
          );
      }

      // Apply department filter (will be combined with search filter using AND)
      if (departmentId != null && departmentId.isNotEmpty) {
        query = query..where((tbl) => tbl.departmentId.equals(departmentId));
      }

      final list =
          await (query
                ..limit(pageSize, offset: (page - 1) * pageSize)
                ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
              .get();
      return list;
    } catch (e) {
      print('Error in searchMembers: $e');
      return [];
    }
  }

  Future<int> getTotalMembersCount({
    String? searchQuery,
    String? departmentId,
  }) async {
    try {
      var query = select(memberTable);

      // Apply search filter (same logic as searchMembers)
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query
          ..where(
            (tbl) =>
                tbl.name.like('%$searchQuery%') | tbl.id.like('%$searchQuery%'),
          );
      }

      // Apply department filter (will be combined with search filter using AND)
      if (departmentId != null && departmentId.isNotEmpty) {
        query = query..where((tbl) => tbl.departmentId.equals(departmentId));
      }

      final list = await query.get();
      return list.length;
    } catch (e) {
      print('Error in getTotalMembersCount: $e');
      return 0;
    }
  }

  Future<AdminTableData?> loginAdmin(String username, String password) async {
    final query = select(adminTable)
      ..where(
        (tbl) =>
            tbl.indentityNumber.equals(
              _authenticationService.encodeIndentityNumber(username),
            ) &
            tbl.password.equals(
              _authenticationService.encodePassword(password),
            ),
      );
    final admin = await query.getSingleOrNull();
    return admin;
  }

  Future<void> createDepartment(String name) async {
    // Generate ID from name (you can customize this logic)
    final id = Uuid().v4();
    final department = DepartmentTableCompanion(
      id: Value(id),
      name: Value(name),
    );
    await into(departmentTable).insert(department);
  }

  Future<List<DepartmentTableData>> getAllDepartments() async {
    try {
      final list = await select(departmentTable).get();
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<DepartmentTableData?> getDepartmentById(String departmentId) async {
    try {
      final department = await (select(
        departmentTable,
      )..where((tbl) => tbl.id.equals(departmentId))).getSingleOrNull();
      return department;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getTodayStaffPresent() async {
    try {
      final today = DateTime.now();

      // Get all staff members
      final allStaff = await select(memberTable).get();

      // Get today's time logs for staff (role = 'member')
      final todayLogs =
          await (select(timeManagementTable)
                ..where(
                  (tbl) =>
                      tbl.role.equals('member') &
                      tbl.checkInTime.year.equals(today.year) &
                      tbl.checkInTime.month.equals(today.month) &
                      tbl.checkInTime.day.equals(today.day) &
                      tbl.status.equals(Status.entry.value),
                )
                ..orderBy([
                  (tbl) => OrderingTerm(
                    expression: tbl.checkInTime,
                    mode: OrderingMode.asc,
                  ),
                ]))
              .get();

      // Create a map of memberId -> latest check-in time
      final staffCheckIns = <String, DateTime>{};
      for (var log in todayLogs) {
        if (!staffCheckIns.containsKey(log.memberId) ||
            staffCheckIns[log.memberId]!.isBefore(log.checkInTime)) {
          staffCheckIns[log.memberId] = log.checkInTime;
        }
      }

      // Build result list
      final result = <Map<String, dynamic>>[];
      for (var staff in allStaff) {
        final hasCheckedIn = staffCheckIns.containsKey(staff.id);
        final checkInTime = staffCheckIns[staff.id];

        // Get department name
        String departmentName = '';
        if (staff.departmentId.isNotEmpty) {
          final dept = await getDepartmentById(staff.departmentId);
          departmentName = dept?.name ?? '';
        }

        result.add({
          'member': staff,
          'departmentName': departmentName,
          'checkInTime': checkInTime,
          'hasCheckedIn': hasCheckedIn,
        });
      }

      // Sort: checked in first (by time), then absent
      result.sort((a, b) {
        if (a['hasCheckedIn'] && !b['hasCheckedIn']) return -1;
        if (!a['hasCheckedIn'] && b['hasCheckedIn']) return 1;
        if (a['hasCheckedIn'] && b['hasCheckedIn']) {
          final timeA = a['checkInTime'] as DateTime;
          final timeB = b['checkInTime'] as DateTime;
          return timeA.compareTo(timeB);
        }
        return 0;
      });

      return result;
    } catch (e) {
      return [];
    }
  }

  Future<AnonymusTableData?> getGuestById(String guestId) async {
    try {
      return await (select(
        anonymusTable,
      )..where((t) => t.id.equals(guestId))).getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  Future<AnonymusTableData?> getGuestByIdentityNumber(
    String identityNumber,
  ) async {
    try {
      // Because encryption uses random IV, we cannot directly compare encoded values.
      // We need to fetch all guests, decode their identityNumbers, and compare.
      final allGuests = await select(anonymusTable).get();
      for (final guest in allGuests) {
        try {
          final decodedId = _authenticationService.decodeIndentityNumber(
            guest.identityNumber,
          );
          if (decodedId == identityNumber) {
            return guest;
          }
        } catch (e) {
          // Skip guests with invalid encoded identityNumber
          continue;
        }
      }
      return null;
    } catch (e) {
      print('Error getting guest by identity number: $e');
      return null;
    }
  }

  Future<TimeManagementTableData?> getLatestTimeLog({
    required String memberId,
    required String role,
  }) async {
    try {
      return await (select(timeManagementTable)
            ..where((t) => t.memberId.equals(memberId) & t.role.equals(role))
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.checkInTime,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(1))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Toggle entry/exit using QR id.
  /// - If the latest log is ENTRY (and no checkout), set EXIT + checkout time.
  /// - Otherwise insert a new ENTRY record.
  /// Returns the new status: `Status.entry.value` or `Status.exit.value`.
  Future<String> toggleEntryExit({
    required String memberId,
    required String role,
    String? note,
  }) async {
    final now = DateTime.now();
    final latest = await getLatestTimeLog(memberId: memberId, role: role);

    if (latest != null &&
        latest.status == Status.entry.value &&
        latest.checkOutTime == null) {
      await (update(
        timeManagementTable,
      )..where((t) => t.id.equals(latest.id))).write(
        TimeManagementTableCompanion(
          checkOutTime: Value(now),
          status: Value(Status.exit.value),
        ),
      );
      return Status.exit.value;
    }

    await into(timeManagementTable).insert(
      TimeManagementTableCompanion(
        id: Value(const Uuid().v4()),
        memberId: Value(memberId),
        checkInTime: Value(now),
        checkOutTime: const Value.absent(),
        note: note != null ? Value(note) : const Value.absent(),
        status: Value(Status.entry.value),
        role: Value(role),
      ),
    );
    return Status.entry.value;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

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
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _ensureDefaultAdmin(m.database);
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

      if (from < 7) {
        // AdminTable: add status + createdAt columns (and constraints updated in Drift schema)
        try {
          await m.addColumn(adminTable, adminTable.status);
        } catch (_) {}
        try {
          await m.addColumn(adminTable, adminTable.createdAt);
        } catch (_) {}
      }
      if (from < 8) {
        // Ensure default admin exists
        try {
          final hash = _authenticationService.hashPassword('admin');
          final now = DateTime.now();
          await m.database.customStatement(
            '''
            INSERT OR IGNORE INTO admin_table
            (id, name, phone_number, password, indentity_number, image_url, status, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ''',
            [
              'admin-default',
              'Administrator',
              '',
              hash,
              'admin',
              '',
              'ACTIVE',
              now.millisecondsSinceEpoch ~/ 1000, // Unix timestamp in seconds
            ],
          );
        } catch (_) {}
      }
      if (from < 9) {
        // Add officerNumber and rank columns to MemberTable
        try {
          await m.addColumn(memberTable, memberTable.officerNumber);
        } catch (_) {}
        try {
          await m.addColumn(memberTable, memberTable.rank);
        } catch (_) {}
      }
    },
  );

  /// Ensures the default admin account exists (username: admin, password: admin)
  Future<void> _ensureDefaultAdmin(GeneratedDatabase db) async {
    try {
      // Check if admin with username 'admin' exists (plaintext check first)
      // Using string interpolation is safe here since 'admin' is a constant
      final result = await db.customSelect(
        "SELECT id, password FROM admin_table WHERE indentity_number = 'admin'",
        readsFrom: {adminTable},
      ).getSingleOrNull();
      
      final hash = _authenticationService.hashPassword('ducthang123@');
      print('Default admin password hash: $hash');
      print('Default admin password hash length: ${hash.length}');
      
      if (result == null) {
        // Admin with username 'admin' doesn't exist, create default admin
        print('Creating default admin...');
        final now = DateTime.now();
        await db.customStatement(
          '''
          INSERT OR IGNORE INTO admin_table
          (id, name, phone_number, password, indentity_number, image_url, status, created_at)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
          ''',
          [
            'admin-default',
            'Administrator',
            '',
            hash,
            'admin',
            '',
            'ACTIVE',
            now.millisecondsSinceEpoch ~/ 1000, // Unix timestamp in seconds
          ],
        );
        print('Default admin created');
      } else {
        // Admin exists, check if password needs updating
        final existingPassword = result.read<String>('password');
        print('Existing password hash: $existingPassword');
        print('Existing password hash length: ${existingPassword.length}');
        print('Hash match: ${existingPassword == hash}');
        
        if (existingPassword != hash) {
          // Password hash doesn't match, update it
          print('Updating default admin password...');
          final adminId = result.read<String>('id');
          await db.customStatement(
            'UPDATE admin_table SET password = ? WHERE id = ?',
            [hash, adminId],
          );
          print('Default admin password updated');
        } else {
          print('Default admin password is correct');
        }
      }
    } catch (e) {
      // Ignore errors (admin might already exist or table structure might differ)
      print('Error ensuring default admin: $e');
    }
  }

  /// Public method to ensure default admin exists (called from login or other places)
  Future<void> ensureDefaultAdmin() async {
    await _ensureDefaultAdmin(attachedDatabase);
  }

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

  Future<int> getTodayEntryCount({String? role}) async {
    try {
      final today = DateTime.now();
      final query = select(timeManagementTable)
        ..where(
          (tbl) =>
              tbl.checkInTime.year.equals(today.year) &
              tbl.checkInTime.month.equals(today.month) &
              tbl.checkInTime.day.equals(today.day),
        );

      if (role != null && role.isNotEmpty) {
        query.where((tbl) => tbl.role.equals(role));
      }

      final list = await query.get();
      return list.length;
    } catch (e) {
      return 0;
    }
  }

  /// Counts today's guest *check-ins* (role = anonymus, status = ENTRY).
  /// Used by dashboard card "Khách vãng lai hôm nay".
  Future<int> getTodayGuestEntryCount() async {
    try {
      final today = DateTime.now();
      final list = await (select(timeManagementTable)
            ..where(
              (tbl) =>
                  tbl.role.equals(Role.anonymus.value) &
                  tbl.status.equals(Status.entry.value) &
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

  Future<List<TimeManagementTableData>> searchTimeManagement({
    required int page,
    required int pageSize,
    required String role,
    DateTime? start,
    DateTime? end,
    bool? isInBuilding,
    List<String>? memberIds,
    bool sortDescByCheckInTime = true,
  }) async {
    try {
      if (memberIds != null && memberIds.isEmpty) {
        return [];
      }

      final query = select(timeManagementTable)
        ..where((t) => t.role.equals(role));

      if (start != null && end != null) {
        query.where((t) => t.checkInTime.isBetweenValues(start, end));
      }

      if (isInBuilding != null) {
        if (isInBuilding) {
          query.where((t) => t.checkOutTime.isNull());
        } else {
          query.where((t) => t.checkOutTime.isNotNull());
        }
      }

      if (memberIds != null) {
        query.where((t) => t.memberId.isIn(memberIds));
      }

      query
        ..orderBy([
          (t) => OrderingTerm(
                expression: t.checkInTime,
                mode: sortDescByCheckInTime ? OrderingMode.desc : OrderingMode.asc,
              ),
        ])
        ..limit(pageSize, offset: (page - 1) * pageSize);

      return await query.get();
    } catch (e) {
      print('Error in searchTimeManagement: $e');
      return [];
    }
  }

  Future<int> getTotalTimeManagementCount({
    required String role,
    DateTime? start,
    DateTime? end,
    bool? isInBuilding,
    List<String>? memberIds,
  }) async {
    try {
      if (memberIds != null && memberIds.isEmpty) {
        return 0;
      }

      final countExp = timeManagementTable.id.count();
      final query = selectOnly(timeManagementTable)..addColumns([countExp]);

      query.where(timeManagementTable.role.equals(role));

      if (start != null && end != null) {
        query.where(timeManagementTable.checkInTime.isBetweenValues(start, end));
      }

      if (isInBuilding != null) {
        if (isInBuilding) {
          query.where(timeManagementTable.checkOutTime.isNull());
        } else {
          query.where(timeManagementTable.checkOutTime.isNotNull());
        }
      }

      if (memberIds != null) {
        query.where(timeManagementTable.memberId.isIn(memberIds));
      }

      final row = await query.getSingle();
      return row.read(countExp) ?? 0;
    } catch (e) {
      print('Error in getTotalTimeManagementCount: $e');
      return 0;
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

  /// Get traffic data for last 30 days (count entries per day)
  /// Returns a list of maps: [{date: DateTime, count: int}, ...]
  Future<List<Map<String, dynamic>>> getTrafficLast30Days() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final thirtyDaysAgo = today.subtract(const Duration(days: 29));

      final allEntries = await select(timeManagementTable).get();

      final Map<DateTime, int> dayCounts = {};
      for (var entry in allEntries) {
        final entryDay = DateTime(
          entry.checkInTime.year,
          entry.checkInTime.month,
          entry.checkInTime.day,
        );
        if (!entryDay.isBefore(thirtyDaysAgo) && !entryDay.isAfter(today)) {
          dayCounts[entryDay] = (dayCounts[entryDay] ?? 0) + 1;
        }
      }

      final result = <Map<String, dynamic>>[];
      for (int i = 0; i < 30; i++) {
        final date = thirtyDaysAgo.add(Duration(days: i));
        result.add({
          'date': date,
          'count': dayCounts[date] ?? 0,
        });
      }

      return result;
    } catch (e) {
      print('Error getting traffic last 30 days: $e');
      return [];
    }
  }

  /// Get traffic data for previous 30 days (for comparison)
  Future<List<Map<String, dynamic>>> getTrafficPrevious30Days() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final thirtyDaysAgo = today.subtract(const Duration(days: 29));
      final sixtyDaysAgo = thirtyDaysAgo.subtract(const Duration(days: 30));

      final allEntries = await select(timeManagementTable).get();

      final Map<DateTime, int> dayCounts = {};
      for (var entry in allEntries) {
        final entryDay = DateTime(
          entry.checkInTime.year,
          entry.checkInTime.month,
          entry.checkInTime.day,
        );
        if (!entryDay.isBefore(sixtyDaysAgo) && entryDay.isBefore(thirtyDaysAgo)) {
          dayCounts[entryDay] = (dayCounts[entryDay] ?? 0) + 1;
        }
      }

      final result = <Map<String, dynamic>>[];
      for (int i = 0; i < 30; i++) {
        final date = sixtyDaysAgo.add(Duration(days: i));
        result.add({
          'date': date,
          'count': dayCounts[date] ?? 0,
        });
      }

      return result;
    } catch (e) {
      print('Error getting traffic previous 30 days: $e');
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
    try {
      final passwordHash = _authenticationService.hashPassword(password);
      print('Login attempt - Username: $username');
      print('Login attempt - Password hash: $passwordHash');
      print('Login attempt - Password hash length: ${passwordHash.length}');
      
      // Use raw query to avoid DateTime parsing issues
      final adminRows = await customSelect(
        'SELECT id, name, phone_number, password, indentity_number, image_url, status, created_at FROM admin_table',
        readsFrom: {adminTable},
      ).get();
      
      print('Total admins in database: ${adminRows.length}');
      
      for (final row in adminRows) {
        try {
          final adminId = row.read<String>('id');
          final indentityNumber = row.read<String>('indentity_number');
          final storedPassword = row.read<String>('password');
          final status = row.read<String>('status');
          
          print('Checking admin: id=$adminId, indentityNumber=$indentityNumber');
          
          // Username may be stored as plaintext OR encrypted legacy value.
          var usernameMatch = indentityNumber == username;
          print('Direct username match: $usernameMatch');
          
          if (!usernameMatch) {
            try {
              print('Attempting to decode identity number...');
              final decodedUser = _authenticationService
                  .decodeIndentityNumber(indentityNumber);
              print('Decoded username: $decodedUser');
              usernameMatch = decodedUser == username;
              print('Decoded username match: $usernameMatch');
            } catch (e) {
              print('Failed to decode identity number: $e');
              // Not encrypted, continue
            }
          }
          
          if (usernameMatch) {
            print('Found admin with matching username: $adminId');
            print('Stored password hash: $storedPassword');
            print('Stored password hash length: ${storedPassword.length}');
            print('Password hash match: ${storedPassword == passwordHash}');
          }
          
          if (!usernameMatch) {
            print('Username does not match, skipping...');
            continue;
          }

          // Password is stored as SHA256 hash (new) OR encrypted legacy value.
          if (storedPassword == passwordHash) {
            print('Password hash matches!');
            try {
              final statusUpper = status.toUpperCase();
              print('Admin status: $statusUpper');
              if (statusUpper == 'LOCKED') {
                print('Admin is LOCKED');
                return null;
              }
              print('Fetching full admin data...');
              // Get full admin data using Drift query
              final admin = await (select(adminTable)..where((t) => t.id.equals(adminId))).getSingleOrNull();
              if (admin != null) {
                print('Returning admin successfully');
                return admin;
              }
            } catch (e) {
              print('Error fetching admin data: $e');
              // Try to create AdminTableData manually if needed
              try {
                final name = row.read<String>('name');
                final phoneNumber = row.read<String>('phone_number');
                final imageUrl = row.read<String>('image_url');
                final createdAtStr = row.read<String>('created_at');
                DateTime createdAt;
                try {
                  // Try to parse as Unix timestamp (seconds)
                  final timestamp = int.parse(createdAtStr);
                  createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                } catch (_) {
                  // Fallback to current time
                  createdAt = DateTime.now();
                }
                return AdminTableData(
                  id: adminId,
                  name: name,
                  phoneNumber: phoneNumber,
                  password: storedPassword,
                  indentityNumber: indentityNumber,
                  imageUrl: imageUrl,
                  status: status,
                  createdAt: createdAt,
                );
              } catch (e2) {
                print('Error creating AdminTableData: $e2');
              }
            }
          }
          
          // Legacy fallback: decrypt then compare, and migrate to hash on success.
          try {
            print('Trying legacy password decode...');
            final decodedPass =
                _authenticationService.decodePassword(storedPassword);
            print('Decoded password: $decodedPass');
            if (decodedPass != password) {
              print('Decoded password does not match');
              continue;
            }
            print('Legacy password matches, migrating to hash...');
            await (update(adminTable)..where((t) => t.id.equals(adminId))).write(
              AdminTableCompanion(password: Value(passwordHash)),
            );
            final statusUpper = status.toUpperCase();
            if (statusUpper == 'LOCKED') return null;
            final admin = await (select(adminTable)..where((t) => t.id.equals(adminId))).getSingleOrNull();
            return admin;
          } catch (e) {
            print('Legacy password decode failed: $e');
            continue;
          }
        } catch (e, stackTrace) {
          print('Error processing admin row: $e');
          print('Stack trace: $stackTrace');
          continue;
        }
      }
      print('No matching admin found');
      return null;
    } catch (e, stackTrace) {
      print('Error in loginAdmin: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> createAdmin(AdminTableCompanion admin) async {
    await into(adminTable).insert(admin);
  }

  Future<void> deleteAdmin(String adminId) async {
    await (delete(adminTable)..where((t) => t.id.equals(adminId))).go();
  }

  Future<void> updateAdminStatus(String adminId, String status) async {
    await (update(adminTable)..where((t) => t.id.equals(adminId))).write(
      AdminTableCompanion(
        status: Value(status),
      ),
    );
  }

  /// Returns a list of admins for UI usage, with decrypted username for display/search.
  Future<List<Map<String, dynamic>>> searchAdmins({
    String? searchQuery,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final list = await (select(adminTable)
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.createdAt,
                    mode: OrderingMode.desc,
                  ),
            ]))
          .get();

      final q = (searchQuery ?? '').trim().toLowerCase();
      final filtered = <Map<String, dynamic>>[];
      for (final admin in list) {
        // Username may be plaintext or encrypted legacy.
        var usernameDecoded = admin.indentityNumber;
        try {
          usernameDecoded =
              _authenticationService.decodeIndentityNumber(admin.indentityNumber);
        } catch (_) {}

        final matches = q.isEmpty ||
            admin.name.toLowerCase().contains(q) ||
            usernameDecoded.toLowerCase().contains(q);
        if (!matches) continue;

        filtered.add({
          'admin': admin,
          'username': usernameDecoded,
        });
      }

      final start = (page - 1) * pageSize;
      if (start >= filtered.length) return [];
      final end = (start + pageSize) > filtered.length
          ? filtered.length
          : (start + pageSize);
      return filtered.sublist(start, end);
    } catch (e) {
      return [];
    }
  }

  Future<int> getTotalAdminsCount({String? searchQuery}) async {
    try {
      final list = await select(adminTable).get();
      final q = (searchQuery ?? '').trim().toLowerCase();
      if (q.isEmpty) return list.length;

      var count = 0;
      for (final admin in list) {
        var usernameDecoded = admin.indentityNumber;
        try {
          usernameDecoded =
              _authenticationService.decodeIndentityNumber(admin.indentityNumber);
        } catch (_) {}

        final matches = admin.name.toLowerCase().contains(q) ||
            usernameDecoded.toLowerCase().contains(q);
        if (matches) count++;
      }
      return count;
    } catch (e) {
      return 0;
    }
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

  Future<void> deleteDepartment(String departmentId) async {
    try {
      await (delete(departmentTable)..where((tbl) => tbl.id.equals(departmentId))).go();
    } catch (e) {
      throw Exception('Lỗi khi xóa phòng ban: $e');
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
    // Create app-specific folder: AppData/Roaming/quanly/data/
    final appDataDir = Directory(p.join(dbFolder.path, 'quanly', 'data'));
    if (!await appDataDir.exists()) {
      await appDataDir.create(recursive: true);
    }
    final file = File(p.join(appDataDir.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

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
  int get schemaVersion => 4;

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
        // Add reason column to AnonymusTable (if table exists)
        try {
          await m.addColumn(anonymusTable, anonymusTable.reason);
        } catch (e) {
          // Table doesn't exist yet, it will be created with all columns in onCreate
          // This is fine, just continue
          print('AnonymusTable not found during migration, will be created on next app start: $e');
        }
      }
    },
  );

  Future<void> createMemeber(MemberTableCompanion member) async {
    await into(memberTable).insert(member);
  }

  Future<void> deleteMember(String memberId) async {
    await (delete(memberTable)..where((tbl) => tbl.id.equals(memberId))).go();
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

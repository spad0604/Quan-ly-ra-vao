import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quanly/app/database/admin_table.dart';
import 'package:quanly/app/database/member_table.dart';
import 'package:quanly/app/database/time_management_table.dart';
import 'package:quanly/core/authentication/authentication_service.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TimeManagementTable, MemberTable, AdminTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  static AppDatabase get instance => _instance;

  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  );

  Future<void> createMemeber(MemberTableCompanion member) async {
    await into(memberTable).insert(member);
  }

  Future<void> deleteMember(String memberId) async {
    await (delete(memberTable)..where((tbl) => tbl.id.equals(memberId))).go();
  }

  

  Future<List<TimeManagementTableData>> getAllEntrys(int page, int pageSize) async {
    try {
      final list = await (select(
        timeManagementTable,
      )..limit(pageSize, offset: (page - 1) * pageSize)).get();
      return list;
    } catch (e) {
      return [];
    }
  }
  Future<List<TimeManagementTableData>> getAllTimeManagements(int page, int pageSize) async {
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

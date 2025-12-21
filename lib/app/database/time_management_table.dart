import 'package:drift/drift.dart';

class TimeManagementTable extends Table{
  TextColumn get id => text().withLength(min: 1, max: 50)();

  TextColumn get memberId => text().withLength(min: 1, max: 50)();

  DateTimeColumn get checkInTime => dateTime()();

  DateTimeColumn get checkOutTime => dateTime().nullable()();

  TextColumn get note => text().nullable()();

  TextColumn get status => text().withLength(min: 1, max: 20)();

  TextColumn get role => text().withLength(min: 1, max: 20)();

  @override
  Set<Column> get primaryKey => {id};
}

enum Role {
  member,
  admin, 
  anonymus;

  String get value {
    switch (this) {
      case Role.member:
        return 'member';
      case Role.admin:
        return 'admin';
      case Role.anonymus:
        return 'anonymus';
    }
  }

  static Role fromString(String role) {
    switch (role) {
      case 'member':
        return Role.member;
      case 'admin':
        return Role.admin;  
      case 'anonymus':
        return Role.anonymus;
      default:
        return Role.anonymus;
    }
  }
}
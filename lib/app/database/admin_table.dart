import 'package:drift/drift.dart';


class AdminTable extends Table{
  TextColumn get id => text().withLength(min: 1, max: 50)();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  // Optional (not required on admin create UI)
  TextColumn get phoneNumber =>
      text().withLength(min: 0, max: 15).withDefault(const Constant(''))();

  TextColumn get password => text().withLength(min: 6, max: 100)();

  // Stored as encrypted value (base64), needs higher max length.
  TextColumn get indentityNumber => text().withLength(min: 5, max: 255)();

  TextColumn get imageUrl =>
      text().withLength(min: 0, max: 255).withDefault(const Constant(''))();

  // Admin status: ACTIVE / LOCKED
  TextColumn get status =>
      text().withLength(min: 1, max: 20).withDefault(const Constant('ACTIVE'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
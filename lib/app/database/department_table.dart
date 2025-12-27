import 'package:drift/drift.dart';

class DepartmentTable extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  @override
  Set<Column> get primaryKey => {id};
}
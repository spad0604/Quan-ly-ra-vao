import 'package:drift/drift.dart';

class MemberTable extends Table{
  TextColumn get id => text().withLength(min: 1, max: 50)();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get phoneNumber => text().withLength(min: 10, max: 15)();

  TextColumn get identityNumber => text().withLength(min: 5, max: 255)();

  TextColumn get imageUrl => text().withLength(min: 0, max: 255)();

  TextColumn get address => text().withLength(min: 0, max: 255)();
  
  TextColumn get dateOfBirth => text().withLength(min: 0, max: 20)();

  TextColumn get departmentId => text().withLength(min: 1, max: 50)();

  TextColumn get position => text().withLength(min: 0, max: 100)();

  TextColumn get sex => text().withLength(min: 0, max: 10)();

  // Số hiệu sĩ quan
  TextColumn get officerNumber => text().withLength(min: 0, max: 50).withDefault(const Constant(''))();

  // Cấp bậc
  TextColumn get rank => text().withLength(min: 0, max: 50).withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}
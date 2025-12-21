import 'package:drift/drift.dart';

class MemberTable extends Table{
  TextColumn get id => text().withLength(min: 1, max: 50)();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get phoneNumber => text().withLength(min: 10, max: 15)();

  TextColumn get identityNumber => text().withLength(min: 5, max: 20)();

  TextColumn get imageUrl => text().withLength(min: 0, max: 255)();

  TextColumn get address => text().withLength(min: 0, max: 255)();
  
  TextColumn get dateOfBirth => text().withLength(min: 0, max: 20)();
  @override
  Set<Column> get primaryKey => {id};
}
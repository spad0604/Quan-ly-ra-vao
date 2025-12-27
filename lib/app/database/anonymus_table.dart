import 'package:drift/drift.dart';

class AnonymusTable extends Table{
  TextColumn get id => text().withLength(min: 1, max: 50)();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get identityNumber => text().withLength(min: 5, max: 20)();

  TextColumn get address => text().withLength(min: 0, max: 255)();
  
  TextColumn get dateOfBirth => text().withLength(min: 0, max: 20)();

  TextColumn get reason => text().withLength(min: 0, max: 255)();
  
  @override
  Set<Column> get primaryKey => {id};
}
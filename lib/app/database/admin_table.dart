import 'package:drift/drift.dart';


class AdminTable extends Table{
  TextColumn get id => text().primaryKey()();
}
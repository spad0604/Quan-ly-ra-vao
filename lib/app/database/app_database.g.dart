// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TimeManagementTableTable extends TimeManagementTable
    with TableInfo<$TimeManagementTableTable, TimeManagementTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeManagementTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkInTimeMeta = const VerificationMeta(
    'checkInTime',
  );
  @override
  late final GeneratedColumn<DateTime> checkInTime = GeneratedColumn<DateTime>(
    'check_in_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkOutTimeMeta = const VerificationMeta(
    'checkOutTime',
  );
  @override
  late final GeneratedColumn<DateTime> checkOutTime = GeneratedColumn<DateTime>(
    'check_out_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    memberId,
    checkInTime,
    checkOutTime,
    note,
    status,
    role,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_management_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeManagementTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('check_in_time')) {
      context.handle(
        _checkInTimeMeta,
        checkInTime.isAcceptableOrUnknown(
          data['check_in_time']!,
          _checkInTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkInTimeMeta);
    }
    if (data.containsKey('check_out_time')) {
      context.handle(
        _checkOutTimeMeta,
        checkOutTime.isAcceptableOrUnknown(
          data['check_out_time']!,
          _checkOutTimeMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeManagementTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeManagementTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      checkInTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_in_time'],
      )!,
      checkOutTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_out_time'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
    );
  }

  @override
  $TimeManagementTableTable createAlias(String alias) {
    return $TimeManagementTableTable(attachedDatabase, alias);
  }
}

class TimeManagementTableData extends DataClass
    implements Insertable<TimeManagementTableData> {
  final String id;
  final String memberId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String? note;
  final String status;
  final String role;
  const TimeManagementTableData({
    required this.id,
    required this.memberId,
    required this.checkInTime,
    this.checkOutTime,
    this.note,
    required this.status,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['check_in_time'] = Variable<DateTime>(checkInTime);
    if (!nullToAbsent || checkOutTime != null) {
      map['check_out_time'] = Variable<DateTime>(checkOutTime);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    map['role'] = Variable<String>(role);
    return map;
  }

  TimeManagementTableCompanion toCompanion(bool nullToAbsent) {
    return TimeManagementTableCompanion(
      id: Value(id),
      memberId: Value(memberId),
      checkInTime: Value(checkInTime),
      checkOutTime: checkOutTime == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOutTime),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      role: Value(role),
    );
  }

  factory TimeManagementTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeManagementTableData(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      checkInTime: serializer.fromJson<DateTime>(json['checkInTime']),
      checkOutTime: serializer.fromJson<DateTime?>(json['checkOutTime']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'checkInTime': serializer.toJson<DateTime>(checkInTime),
      'checkOutTime': serializer.toJson<DateTime?>(checkOutTime),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
      'role': serializer.toJson<String>(role),
    };
  }

  TimeManagementTableData copyWith({
    String? id,
    String? memberId,
    DateTime? checkInTime,
    Value<DateTime?> checkOutTime = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? status,
    String? role,
  }) => TimeManagementTableData(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    checkInTime: checkInTime ?? this.checkInTime,
    checkOutTime: checkOutTime.present ? checkOutTime.value : this.checkOutTime,
    note: note.present ? note.value : this.note,
    status: status ?? this.status,
    role: role ?? this.role,
  );
  TimeManagementTableData copyWithCompanion(TimeManagementTableCompanion data) {
    return TimeManagementTableData(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      checkInTime: data.checkInTime.present
          ? data.checkInTime.value
          : this.checkInTime,
      checkOutTime: data.checkOutTime.present
          ? data.checkOutTime.value
          : this.checkOutTime,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeManagementTableData(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('checkOutTime: $checkOutTime, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, memberId, checkInTime, checkOutTime, note, status, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeManagementTableData &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.checkInTime == this.checkInTime &&
          other.checkOutTime == this.checkOutTime &&
          other.note == this.note &&
          other.status == this.status &&
          other.role == this.role);
}

class TimeManagementTableCompanion
    extends UpdateCompanion<TimeManagementTableData> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<DateTime> checkInTime;
  final Value<DateTime?> checkOutTime;
  final Value<String?> note;
  final Value<String> status;
  final Value<String> role;
  final Value<int> rowid;
  const TimeManagementTableCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.checkInTime = const Value.absent(),
    this.checkOutTime = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeManagementTableCompanion.insert({
    required String id,
    required String memberId,
    required DateTime checkInTime,
    this.checkOutTime = const Value.absent(),
    this.note = const Value.absent(),
    required String status,
    required String role,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memberId = Value(memberId),
       checkInTime = Value(checkInTime),
       status = Value(status),
       role = Value(role);
  static Insertable<TimeManagementTableData> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<DateTime>? checkInTime,
    Expression<DateTime>? checkOutTime,
    Expression<String>? note,
    Expression<String>? status,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (checkInTime != null) 'check_in_time': checkInTime,
      if (checkOutTime != null) 'check_out_time': checkOutTime,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeManagementTableCompanion copyWith({
    Value<String>? id,
    Value<String>? memberId,
    Value<DateTime>? checkInTime,
    Value<DateTime?>? checkOutTime,
    Value<String?>? note,
    Value<String>? status,
    Value<String>? role,
    Value<int>? rowid,
  }) {
    return TimeManagementTableCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      note: note ?? this.note,
      status: status ?? this.status,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (checkInTime.present) {
      map['check_in_time'] = Variable<DateTime>(checkInTime.value);
    }
    if (checkOutTime.present) {
      map['check_out_time'] = Variable<DateTime>(checkOutTime.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeManagementTableCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('checkOutTime: $checkOutTime, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberTableTable extends MemberTable
    with TableInfo<$MemberTableTable, MemberTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 10,
      maxTextLength: 15,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _identityNumberMeta = const VerificationMeta(
    'identityNumber',
  );
  @override
  late final GeneratedColumn<String> identityNumber = GeneratedColumn<String>(
    'identity_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 5,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
    'date_of_birth',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phoneNumber,
    identityNumber,
    imageUrl,
    address,
    dateOfBirth,
    departmentId,
    position,
    sex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('identity_number')) {
      context.handle(
        _identityNumberMeta,
        identityNumber.isAcceptableOrUnknown(
          data['identity_number']!,
          _identityNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identityNumberMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      identityNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identity_number'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_of_birth'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
    );
  }

  @override
  $MemberTableTable createAlias(String alias) {
    return $MemberTableTable(attachedDatabase, alias);
  }
}

class MemberTableData extends DataClass implements Insertable<MemberTableData> {
  final String id;
  final String name;
  final String phoneNumber;
  final String identityNumber;
  final String imageUrl;
  final String address;
  final String dateOfBirth;
  final String departmentId;
  final String position;
  final String sex;
  const MemberTableData({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.identityNumber,
    required this.imageUrl,
    required this.address,
    required this.dateOfBirth,
    required this.departmentId,
    required this.position,
    required this.sex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['identity_number'] = Variable<String>(identityNumber);
    map['image_url'] = Variable<String>(imageUrl);
    map['address'] = Variable<String>(address);
    map['date_of_birth'] = Variable<String>(dateOfBirth);
    map['department_id'] = Variable<String>(departmentId);
    map['position'] = Variable<String>(position);
    map['sex'] = Variable<String>(sex);
    return map;
  }

  MemberTableCompanion toCompanion(bool nullToAbsent) {
    return MemberTableCompanion(
      id: Value(id),
      name: Value(name),
      phoneNumber: Value(phoneNumber),
      identityNumber: Value(identityNumber),
      imageUrl: Value(imageUrl),
      address: Value(address),
      dateOfBirth: Value(dateOfBirth),
      departmentId: Value(departmentId),
      position: Value(position),
      sex: Value(sex),
    );
  }

  factory MemberTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      identityNumber: serializer.fromJson<String>(json['identityNumber']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      address: serializer.fromJson<String>(json['address']),
      dateOfBirth: serializer.fromJson<String>(json['dateOfBirth']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      position: serializer.fromJson<String>(json['position']),
      sex: serializer.fromJson<String>(json['sex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'identityNumber': serializer.toJson<String>(identityNumber),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'address': serializer.toJson<String>(address),
      'dateOfBirth': serializer.toJson<String>(dateOfBirth),
      'departmentId': serializer.toJson<String>(departmentId),
      'position': serializer.toJson<String>(position),
      'sex': serializer.toJson<String>(sex),
    };
  }

  MemberTableData copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? identityNumber,
    String? imageUrl,
    String? address,
    String? dateOfBirth,
    String? departmentId,
    String? position,
    String? sex,
  }) => MemberTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    identityNumber: identityNumber ?? this.identityNumber,
    imageUrl: imageUrl ?? this.imageUrl,
    address: address ?? this.address,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    departmentId: departmentId ?? this.departmentId,
    position: position ?? this.position,
    sex: sex ?? this.sex,
  );
  MemberTableData copyWithCompanion(MemberTableCompanion data) {
    return MemberTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      identityNumber: data.identityNumber.present
          ? data.identityNumber.value
          : this.identityNumber,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      address: data.address.present ? data.address.value : this.address,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      position: data.position.present ? data.position.value : this.position,
      sex: data.sex.present ? data.sex.value : this.sex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('identityNumber: $identityNumber, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('address: $address, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('departmentId: $departmentId, ')
          ..write('position: $position, ')
          ..write('sex: $sex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phoneNumber,
    identityNumber,
    imageUrl,
    address,
    dateOfBirth,
    departmentId,
    position,
    sex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.identityNumber == this.identityNumber &&
          other.imageUrl == this.imageUrl &&
          other.address == this.address &&
          other.dateOfBirth == this.dateOfBirth &&
          other.departmentId == this.departmentId &&
          other.position == this.position &&
          other.sex == this.sex);
}

class MemberTableCompanion extends UpdateCompanion<MemberTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phoneNumber;
  final Value<String> identityNumber;
  final Value<String> imageUrl;
  final Value<String> address;
  final Value<String> dateOfBirth;
  final Value<String> departmentId;
  final Value<String> position;
  final Value<String> sex;
  final Value<int> rowid;
  const MemberTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.identityNumber = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.address = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.position = const Value.absent(),
    this.sex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberTableCompanion.insert({
    required String id,
    required String name,
    required String phoneNumber,
    required String identityNumber,
    required String imageUrl,
    required String address,
    required String dateOfBirth,
    required String departmentId,
    required String position,
    required String sex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       phoneNumber = Value(phoneNumber),
       identityNumber = Value(identityNumber),
       imageUrl = Value(imageUrl),
       address = Value(address),
       dateOfBirth = Value(dateOfBirth),
       departmentId = Value(departmentId),
       position = Value(position),
       sex = Value(sex);
  static Insertable<MemberTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phoneNumber,
    Expression<String>? identityNumber,
    Expression<String>? imageUrl,
    Expression<String>? address,
    Expression<String>? dateOfBirth,
    Expression<String>? departmentId,
    Expression<String>? position,
    Expression<String>? sex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (identityNumber != null) 'identity_number': identityNumber,
      if (imageUrl != null) 'image_url': imageUrl,
      if (address != null) 'address': address,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (departmentId != null) 'department_id': departmentId,
      if (position != null) 'position': position,
      if (sex != null) 'sex': sex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? phoneNumber,
    Value<String>? identityNumber,
    Value<String>? imageUrl,
    Value<String>? address,
    Value<String>? dateOfBirth,
    Value<String>? departmentId,
    Value<String>? position,
    Value<String>? sex,
    Value<int>? rowid,
  }) {
    return MemberTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      identityNumber: identityNumber ?? this.identityNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      departmentId: departmentId ?? this.departmentId,
      position: position ?? this.position,
      sex: sex ?? this.sex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (identityNumber.present) {
      map['identity_number'] = Variable<String>(identityNumber.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('identityNumber: $identityNumber, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('address: $address, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('departmentId: $departmentId, ')
          ..write('position: $position, ')
          ..write('sex: $sex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AdminTableTable extends AdminTable
    with TableInfo<$AdminTableTable, AdminTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdminTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 10,
      maxTextLength: 15,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indentityNumberMeta = const VerificationMeta(
    'indentityNumber',
  );
  @override
  late final GeneratedColumn<String> indentityNumber = GeneratedColumn<String>(
    'indentity_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 5,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phoneNumber,
    password,
    indentityNumber,
    imageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'admin_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdminTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('indentity_number')) {
      context.handle(
        _indentityNumberMeta,
        indentityNumber.isAcceptableOrUnknown(
          data['indentity_number']!,
          _indentityNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_indentityNumberMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdminTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdminTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      indentityNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}indentity_number'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
    );
  }

  @override
  $AdminTableTable createAlias(String alias) {
    return $AdminTableTable(attachedDatabase, alias);
  }
}

class AdminTableData extends DataClass implements Insertable<AdminTableData> {
  final String id;
  final String name;
  final String phoneNumber;
  final String password;
  final String indentityNumber;
  final String imageUrl;
  const AdminTableData({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.password,
    required this.indentityNumber,
    required this.imageUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['password'] = Variable<String>(password);
    map['indentity_number'] = Variable<String>(indentityNumber);
    map['image_url'] = Variable<String>(imageUrl);
    return map;
  }

  AdminTableCompanion toCompanion(bool nullToAbsent) {
    return AdminTableCompanion(
      id: Value(id),
      name: Value(name),
      phoneNumber: Value(phoneNumber),
      password: Value(password),
      indentityNumber: Value(indentityNumber),
      imageUrl: Value(imageUrl),
    );
  }

  factory AdminTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdminTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      password: serializer.fromJson<String>(json['password']),
      indentityNumber: serializer.fromJson<String>(json['indentityNumber']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'password': serializer.toJson<String>(password),
      'indentityNumber': serializer.toJson<String>(indentityNumber),
      'imageUrl': serializer.toJson<String>(imageUrl),
    };
  }

  AdminTableData copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? password,
    String? indentityNumber,
    String? imageUrl,
  }) => AdminTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    password: password ?? this.password,
    indentityNumber: indentityNumber ?? this.indentityNumber,
    imageUrl: imageUrl ?? this.imageUrl,
  );
  AdminTableData copyWithCompanion(AdminTableCompanion data) {
    return AdminTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      password: data.password.present ? data.password.value : this.password,
      indentityNumber: data.indentityNumber.present
          ? data.indentityNumber.value
          : this.indentityNumber,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdminTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('password: $password, ')
          ..write('indentityNumber: $indentityNumber, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phoneNumber, password, indentityNumber, imageUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdminTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.password == this.password &&
          other.indentityNumber == this.indentityNumber &&
          other.imageUrl == this.imageUrl);
}

class AdminTableCompanion extends UpdateCompanion<AdminTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phoneNumber;
  final Value<String> password;
  final Value<String> indentityNumber;
  final Value<String> imageUrl;
  final Value<int> rowid;
  const AdminTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.password = const Value.absent(),
    this.indentityNumber = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AdminTableCompanion.insert({
    required String id,
    required String name,
    required String phoneNumber,
    required String password,
    required String indentityNumber,
    required String imageUrl,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       phoneNumber = Value(phoneNumber),
       password = Value(password),
       indentityNumber = Value(indentityNumber),
       imageUrl = Value(imageUrl);
  static Insertable<AdminTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phoneNumber,
    Expression<String>? password,
    Expression<String>? indentityNumber,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (password != null) 'password': password,
      if (indentityNumber != null) 'indentity_number': indentityNumber,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AdminTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? phoneNumber,
    Value<String>? password,
    Value<String>? indentityNumber,
    Value<String>? imageUrl,
    Value<int>? rowid,
  }) {
    return AdminTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      indentityNumber: indentityNumber ?? this.indentityNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (indentityNumber.present) {
      map['indentity_number'] = Variable<String>(indentityNumber.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdminTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('password: $password, ')
          ..write('indentityNumber: $indentityNumber, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepartmentTableTable extends DepartmentTable
    with TableInfo<$DepartmentTableTable, DepartmentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartmentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'department_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DepartmentTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DepartmentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DepartmentTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $DepartmentTableTable createAlias(String alias) {
    return $DepartmentTableTable(attachedDatabase, alias);
  }
}

class DepartmentTableData extends DataClass
    implements Insertable<DepartmentTableData> {
  final String id;
  final String name;
  const DepartmentTableData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  DepartmentTableCompanion toCompanion(bool nullToAbsent) {
    return DepartmentTableCompanion(id: Value(id), name: Value(name));
  }

  factory DepartmentTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DepartmentTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  DepartmentTableData copyWith({String? id, String? name}) =>
      DepartmentTableData(id: id ?? this.id, name: name ?? this.name);
  DepartmentTableData copyWithCompanion(DepartmentTableCompanion data) {
    return DepartmentTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentTableData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DepartmentTableData &&
          other.id == this.id &&
          other.name == this.name);
}

class DepartmentTableCompanion extends UpdateCompanion<DepartmentTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const DepartmentTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepartmentTableCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<DepartmentTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepartmentTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return DepartmentTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnonymusTableTable extends AnonymusTable
    with TableInfo<$AnonymusTableTable, AnonymusTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnonymusTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _identityNumberMeta = const VerificationMeta(
    'identityNumber',
  );
  @override
  late final GeneratedColumn<String> identityNumber = GeneratedColumn<String>(
    'identity_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 5,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
    'date_of_birth',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    identityNumber,
    address,
    dateOfBirth,
    reason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'anonymus_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnonymusTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('identity_number')) {
      context.handle(
        _identityNumberMeta,
        identityNumber.isAcceptableOrUnknown(
          data['identity_number']!,
          _identityNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identityNumberMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnonymusTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnonymusTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      identityNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identity_number'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_of_birth'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
    );
  }

  @override
  $AnonymusTableTable createAlias(String alias) {
    return $AnonymusTableTable(attachedDatabase, alias);
  }
}

class AnonymusTableData extends DataClass
    implements Insertable<AnonymusTableData> {
  final String id;
  final String name;
  final String identityNumber;
  final String address;
  final String dateOfBirth;
  final String reason;
  const AnonymusTableData({
    required this.id,
    required this.name,
    required this.identityNumber,
    required this.address,
    required this.dateOfBirth,
    required this.reason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['identity_number'] = Variable<String>(identityNumber);
    map['address'] = Variable<String>(address);
    map['date_of_birth'] = Variable<String>(dateOfBirth);
    map['reason'] = Variable<String>(reason);
    return map;
  }

  AnonymusTableCompanion toCompanion(bool nullToAbsent) {
    return AnonymusTableCompanion(
      id: Value(id),
      name: Value(name),
      identityNumber: Value(identityNumber),
      address: Value(address),
      dateOfBirth: Value(dateOfBirth),
      reason: Value(reason),
    );
  }

  factory AnonymusTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnonymusTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      identityNumber: serializer.fromJson<String>(json['identityNumber']),
      address: serializer.fromJson<String>(json['address']),
      dateOfBirth: serializer.fromJson<String>(json['dateOfBirth']),
      reason: serializer.fromJson<String>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'identityNumber': serializer.toJson<String>(identityNumber),
      'address': serializer.toJson<String>(address),
      'dateOfBirth': serializer.toJson<String>(dateOfBirth),
      'reason': serializer.toJson<String>(reason),
    };
  }

  AnonymusTableData copyWith({
    String? id,
    String? name,
    String? identityNumber,
    String? address,
    String? dateOfBirth,
    String? reason,
  }) => AnonymusTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    identityNumber: identityNumber ?? this.identityNumber,
    address: address ?? this.address,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    reason: reason ?? this.reason,
  );
  AnonymusTableData copyWithCompanion(AnonymusTableCompanion data) {
    return AnonymusTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      identityNumber: data.identityNumber.present
          ? data.identityNumber.value
          : this.identityNumber,
      address: data.address.present ? data.address.value : this.address,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnonymusTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('identityNumber: $identityNumber, ')
          ..write('address: $address, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, identityNumber, address, dateOfBirth, reason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnonymusTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.identityNumber == this.identityNumber &&
          other.address == this.address &&
          other.dateOfBirth == this.dateOfBirth &&
          other.reason == this.reason);
}

class AnonymusTableCompanion extends UpdateCompanion<AnonymusTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> identityNumber;
  final Value<String> address;
  final Value<String> dateOfBirth;
  final Value<String> reason;
  final Value<int> rowid;
  const AnonymusTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.identityNumber = const Value.absent(),
    this.address = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.reason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnonymusTableCompanion.insert({
    required String id,
    required String name,
    required String identityNumber,
    required String address,
    required String dateOfBirth,
    required String reason,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       identityNumber = Value(identityNumber),
       address = Value(address),
       dateOfBirth = Value(dateOfBirth),
       reason = Value(reason);
  static Insertable<AnonymusTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? identityNumber,
    Expression<String>? address,
    Expression<String>? dateOfBirth,
    Expression<String>? reason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (identityNumber != null) 'identity_number': identityNumber,
      if (address != null) 'address': address,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (reason != null) 'reason': reason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnonymusTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? identityNumber,
    Value<String>? address,
    Value<String>? dateOfBirth,
    Value<String>? reason,
    Value<int>? rowid,
  }) {
    return AnonymusTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      identityNumber: identityNumber ?? this.identityNumber,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      reason: reason ?? this.reason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (identityNumber.present) {
      map['identity_number'] = Variable<String>(identityNumber.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnonymusTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('identityNumber: $identityNumber, ')
          ..write('address: $address, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('reason: $reason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TimeManagementTableTable timeManagementTable =
      $TimeManagementTableTable(this);
  late final $MemberTableTable memberTable = $MemberTableTable(this);
  late final $AdminTableTable adminTable = $AdminTableTable(this);
  late final $DepartmentTableTable departmentTable = $DepartmentTableTable(
    this,
  );
  late final $AnonymusTableTable anonymusTable = $AnonymusTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    timeManagementTable,
    memberTable,
    adminTable,
    departmentTable,
    anonymusTable,
  ];
}

typedef $$TimeManagementTableTableCreateCompanionBuilder =
    TimeManagementTableCompanion Function({
      required String id,
      required String memberId,
      required DateTime checkInTime,
      Value<DateTime?> checkOutTime,
      Value<String?> note,
      required String status,
      required String role,
      Value<int> rowid,
    });
typedef $$TimeManagementTableTableUpdateCompanionBuilder =
    TimeManagementTableCompanion Function({
      Value<String> id,
      Value<String> memberId,
      Value<DateTime> checkInTime,
      Value<DateTime?> checkOutTime,
      Value<String?> note,
      Value<String> status,
      Value<String> role,
      Value<int> rowid,
    });

class $$TimeManagementTableTableFilterComposer
    extends Composer<_$AppDatabase, $TimeManagementTableTable> {
  $$TimeManagementTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkOutTime => $composableBuilder(
    column: $table.checkOutTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TimeManagementTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeManagementTableTable> {
  $$TimeManagementTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkOutTime => $composableBuilder(
    column: $table.checkOutTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TimeManagementTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeManagementTableTable> {
  $$TimeManagementTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get checkOutTime => $composableBuilder(
    column: $table.checkOutTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$TimeManagementTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeManagementTableTable,
          TimeManagementTableData,
          $$TimeManagementTableTableFilterComposer,
          $$TimeManagementTableTableOrderingComposer,
          $$TimeManagementTableTableAnnotationComposer,
          $$TimeManagementTableTableCreateCompanionBuilder,
          $$TimeManagementTableTableUpdateCompanionBuilder,
          (
            TimeManagementTableData,
            BaseReferences<
              _$AppDatabase,
              $TimeManagementTableTable,
              TimeManagementTableData
            >,
          ),
          TimeManagementTableData,
          PrefetchHooks Function()
        > {
  $$TimeManagementTableTableTableManager(
    _$AppDatabase db,
    $TimeManagementTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeManagementTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeManagementTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TimeManagementTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<DateTime> checkInTime = const Value.absent(),
                Value<DateTime?> checkOutTime = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeManagementTableCompanion(
                id: id,
                memberId: memberId,
                checkInTime: checkInTime,
                checkOutTime: checkOutTime,
                note: note,
                status: status,
                role: role,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String memberId,
                required DateTime checkInTime,
                Value<DateTime?> checkOutTime = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required String status,
                required String role,
                Value<int> rowid = const Value.absent(),
              }) => TimeManagementTableCompanion.insert(
                id: id,
                memberId: memberId,
                checkInTime: checkInTime,
                checkOutTime: checkOutTime,
                note: note,
                status: status,
                role: role,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TimeManagementTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeManagementTableTable,
      TimeManagementTableData,
      $$TimeManagementTableTableFilterComposer,
      $$TimeManagementTableTableOrderingComposer,
      $$TimeManagementTableTableAnnotationComposer,
      $$TimeManagementTableTableCreateCompanionBuilder,
      $$TimeManagementTableTableUpdateCompanionBuilder,
      (
        TimeManagementTableData,
        BaseReferences<
          _$AppDatabase,
          $TimeManagementTableTable,
          TimeManagementTableData
        >,
      ),
      TimeManagementTableData,
      PrefetchHooks Function()
    >;
typedef $$MemberTableTableCreateCompanionBuilder =
    MemberTableCompanion Function({
      required String id,
      required String name,
      required String phoneNumber,
      required String identityNumber,
      required String imageUrl,
      required String address,
      required String dateOfBirth,
      required String departmentId,
      required String position,
      required String sex,
      Value<int> rowid,
    });
typedef $$MemberTableTableUpdateCompanionBuilder =
    MemberTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> phoneNumber,
      Value<String> identityNumber,
      Value<String> imageUrl,
      Value<String> address,
      Value<String> dateOfBirth,
      Value<String> departmentId,
      Value<String> position,
      Value<String> sex,
      Value<int> rowid,
    });

class $$MemberTableTableFilterComposer
    extends Composer<_$AppDatabase, $MemberTableTable> {
  $$MemberTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identityNumber => $composableBuilder(
    column: $table.identityNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemberTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberTableTable> {
  $$MemberTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identityNumber => $composableBuilder(
    column: $table.identityNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemberTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberTableTable> {
  $$MemberTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identityNumber => $composableBuilder(
    column: $table.identityNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);
}

class $$MemberTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberTableTable,
          MemberTableData,
          $$MemberTableTableFilterComposer,
          $$MemberTableTableOrderingComposer,
          $$MemberTableTableAnnotationComposer,
          $$MemberTableTableCreateCompanionBuilder,
          $$MemberTableTableUpdateCompanionBuilder,
          (
            MemberTableData,
            BaseReferences<_$AppDatabase, $MemberTableTable, MemberTableData>,
          ),
          MemberTableData,
          PrefetchHooks Function()
        > {
  $$MemberTableTableTableManager(_$AppDatabase db, $MemberTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemberTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> identityNumber = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> dateOfBirth = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<String> position = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberTableCompanion(
                id: id,
                name: name,
                phoneNumber: phoneNumber,
                identityNumber: identityNumber,
                imageUrl: imageUrl,
                address: address,
                dateOfBirth: dateOfBirth,
                departmentId: departmentId,
                position: position,
                sex: sex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String phoneNumber,
                required String identityNumber,
                required String imageUrl,
                required String address,
                required String dateOfBirth,
                required String departmentId,
                required String position,
                required String sex,
                Value<int> rowid = const Value.absent(),
              }) => MemberTableCompanion.insert(
                id: id,
                name: name,
                phoneNumber: phoneNumber,
                identityNumber: identityNumber,
                imageUrl: imageUrl,
                address: address,
                dateOfBirth: dateOfBirth,
                departmentId: departmentId,
                position: position,
                sex: sex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemberTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberTableTable,
      MemberTableData,
      $$MemberTableTableFilterComposer,
      $$MemberTableTableOrderingComposer,
      $$MemberTableTableAnnotationComposer,
      $$MemberTableTableCreateCompanionBuilder,
      $$MemberTableTableUpdateCompanionBuilder,
      (
        MemberTableData,
        BaseReferences<_$AppDatabase, $MemberTableTable, MemberTableData>,
      ),
      MemberTableData,
      PrefetchHooks Function()
    >;
typedef $$AdminTableTableCreateCompanionBuilder =
    AdminTableCompanion Function({
      required String id,
      required String name,
      required String phoneNumber,
      required String password,
      required String indentityNumber,
      required String imageUrl,
      Value<int> rowid,
    });
typedef $$AdminTableTableUpdateCompanionBuilder =
    AdminTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> phoneNumber,
      Value<String> password,
      Value<String> indentityNumber,
      Value<String> imageUrl,
      Value<int> rowid,
    });

class $$AdminTableTableFilterComposer
    extends Composer<_$AppDatabase, $AdminTableTable> {
  $$AdminTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get indentityNumber => $composableBuilder(
    column: $table.indentityNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AdminTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AdminTableTable> {
  $$AdminTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get indentityNumber => $composableBuilder(
    column: $table.indentityNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AdminTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdminTableTable> {
  $$AdminTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get indentityNumber => $composableBuilder(
    column: $table.indentityNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$AdminTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AdminTableTable,
          AdminTableData,
          $$AdminTableTableFilterComposer,
          $$AdminTableTableOrderingComposer,
          $$AdminTableTableAnnotationComposer,
          $$AdminTableTableCreateCompanionBuilder,
          $$AdminTableTableUpdateCompanionBuilder,
          (
            AdminTableData,
            BaseReferences<_$AppDatabase, $AdminTableTable, AdminTableData>,
          ),
          AdminTableData,
          PrefetchHooks Function()
        > {
  $$AdminTableTableTableManager(_$AppDatabase db, $AdminTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdminTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdminTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdminTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> indentityNumber = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AdminTableCompanion(
                id: id,
                name: name,
                phoneNumber: phoneNumber,
                password: password,
                indentityNumber: indentityNumber,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String phoneNumber,
                required String password,
                required String indentityNumber,
                required String imageUrl,
                Value<int> rowid = const Value.absent(),
              }) => AdminTableCompanion.insert(
                id: id,
                name: name,
                phoneNumber: phoneNumber,
                password: password,
                indentityNumber: indentityNumber,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AdminTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AdminTableTable,
      AdminTableData,
      $$AdminTableTableFilterComposer,
      $$AdminTableTableOrderingComposer,
      $$AdminTableTableAnnotationComposer,
      $$AdminTableTableCreateCompanionBuilder,
      $$AdminTableTableUpdateCompanionBuilder,
      (
        AdminTableData,
        BaseReferences<_$AppDatabase, $AdminTableTable, AdminTableData>,
      ),
      AdminTableData,
      PrefetchHooks Function()
    >;
typedef $$DepartmentTableTableCreateCompanionBuilder =
    DepartmentTableCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$DepartmentTableTableUpdateCompanionBuilder =
    DepartmentTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$DepartmentTableTableFilterComposer
    extends Composer<_$AppDatabase, $DepartmentTableTable> {
  $$DepartmentTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DepartmentTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartmentTableTable> {
  $$DepartmentTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DepartmentTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartmentTableTable> {
  $$DepartmentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$DepartmentTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepartmentTableTable,
          DepartmentTableData,
          $$DepartmentTableTableFilterComposer,
          $$DepartmentTableTableOrderingComposer,
          $$DepartmentTableTableAnnotationComposer,
          $$DepartmentTableTableCreateCompanionBuilder,
          $$DepartmentTableTableUpdateCompanionBuilder,
          (
            DepartmentTableData,
            BaseReferences<
              _$AppDatabase,
              $DepartmentTableTable,
              DepartmentTableData
            >,
          ),
          DepartmentTableData,
          PrefetchHooks Function()
        > {
  $$DepartmentTableTableTableManager(
    _$AppDatabase db,
    $DepartmentTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartmentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartmentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartmentTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartmentTableCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => DepartmentTableCompanion.insert(
                id: id,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DepartmentTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepartmentTableTable,
      DepartmentTableData,
      $$DepartmentTableTableFilterComposer,
      $$DepartmentTableTableOrderingComposer,
      $$DepartmentTableTableAnnotationComposer,
      $$DepartmentTableTableCreateCompanionBuilder,
      $$DepartmentTableTableUpdateCompanionBuilder,
      (
        DepartmentTableData,
        BaseReferences<
          _$AppDatabase,
          $DepartmentTableTable,
          DepartmentTableData
        >,
      ),
      DepartmentTableData,
      PrefetchHooks Function()
    >;
typedef $$AnonymusTableTableCreateCompanionBuilder =
    AnonymusTableCompanion Function({
      required String id,
      required String name,
      required String identityNumber,
      required String address,
      required String dateOfBirth,
      required String reason,
      Value<int> rowid,
    });
typedef $$AnonymusTableTableUpdateCompanionBuilder =
    AnonymusTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> identityNumber,
      Value<String> address,
      Value<String> dateOfBirth,
      Value<String> reason,
      Value<int> rowid,
    });

class $$AnonymusTableTableFilterComposer
    extends Composer<_$AppDatabase, $AnonymusTableTable> {
  $$AnonymusTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identityNumber => $composableBuilder(
    column: $table.identityNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnonymusTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AnonymusTableTable> {
  $$AnonymusTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identityNumber => $composableBuilder(
    column: $table.identityNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnonymusTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnonymusTableTable> {
  $$AnonymusTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get identityNumber => $composableBuilder(
    column: $table.identityNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);
}

class $$AnonymusTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnonymusTableTable,
          AnonymusTableData,
          $$AnonymusTableTableFilterComposer,
          $$AnonymusTableTableOrderingComposer,
          $$AnonymusTableTableAnnotationComposer,
          $$AnonymusTableTableCreateCompanionBuilder,
          $$AnonymusTableTableUpdateCompanionBuilder,
          (
            AnonymusTableData,
            BaseReferences<
              _$AppDatabase,
              $AnonymusTableTable,
              AnonymusTableData
            >,
          ),
          AnonymusTableData,
          PrefetchHooks Function()
        > {
  $$AnonymusTableTableTableManager(_$AppDatabase db, $AnonymusTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnonymusTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnonymusTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnonymusTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> identityNumber = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> dateOfBirth = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnonymusTableCompanion(
                id: id,
                name: name,
                identityNumber: identityNumber,
                address: address,
                dateOfBirth: dateOfBirth,
                reason: reason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String identityNumber,
                required String address,
                required String dateOfBirth,
                required String reason,
                Value<int> rowid = const Value.absent(),
              }) => AnonymusTableCompanion.insert(
                id: id,
                name: name,
                identityNumber: identityNumber,
                address: address,
                dateOfBirth: dateOfBirth,
                reason: reason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnonymusTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnonymusTableTable,
      AnonymusTableData,
      $$AnonymusTableTableFilterComposer,
      $$AnonymusTableTableOrderingComposer,
      $$AnonymusTableTableAnnotationComposer,
      $$AnonymusTableTableCreateCompanionBuilder,
      $$AnonymusTableTableUpdateCompanionBuilder,
      (
        AnonymusTableData,
        BaseReferences<_$AppDatabase, $AnonymusTableTable, AnonymusTableData>,
      ),
      AnonymusTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TimeManagementTableTableTableManager get timeManagementTable =>
      $$TimeManagementTableTableTableManager(_db, _db.timeManagementTable);
  $$MemberTableTableTableManager get memberTable =>
      $$MemberTableTableTableManager(_db, _db.memberTable);
  $$AdminTableTableTableManager get adminTable =>
      $$AdminTableTableTableManager(_db, _db.adminTable);
  $$DepartmentTableTableTableManager get departmentTable =>
      $$DepartmentTableTableTableManager(_db, _db.departmentTable);
  $$AnonymusTableTableTableManager get anonymusTable =>
      $$AnonymusTableTableTableManager(_db, _db.anonymusTable);
}

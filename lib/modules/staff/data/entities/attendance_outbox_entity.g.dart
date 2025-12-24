// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_outbox_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAttendanceOutboxEntityCollection on Isar {
  IsarCollection<AttendanceOutboxEntity> get attendanceOutboxEntitys =>
      this.collection();
}

const AttendanceOutboxEntitySchema = CollectionSchema(
  name: r'AttendanceOutboxEntity',
  id: -4650292016076839050,
  properties: {
    r'action': PropertySchema(
      id: 0,
      name: r'action',
      type: IsarType.byte,
      enumMap: _AttendanceOutboxEntityactionEnumValueMap,
    ),
    r'attempts': PropertySchema(id: 1, name: r'attempts', type: IsarType.long),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(id: 3, name: r'date', type: IsarType.dateTime),
    r'employeeId': PropertySchema(
      id: 4,
      name: r'employeeId',
      type: IsarType.long,
    ),
    r'employeeName': PropertySchema(
      id: 5,
      name: r'employeeName',
      type: IsarType.string,
    ),
    r'lastAttemptAt': PropertySchema(
      id: 6,
      name: r'lastAttemptAt',
      type: IsarType.dateTime,
    ),
    r'lastError': PropertySchema(
      id: 7,
      name: r'lastError',
      type: IsarType.string,
    ),
    r'nextAttemptAt': PropertySchema(
      id: 8,
      name: r'nextAttemptAt',
      type: IsarType.dateTime,
    ),
    r'source': PropertySchema(id: 9, name: r'source', type: IsarType.string),
    r'synced': PropertySchema(id: 10, name: r'synced', type: IsarType.bool),
    r'syncedAt': PropertySchema(
      id: 11,
      name: r'syncedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _attendanceOutboxEntityEstimateSize,
  serialize: _attendanceOutboxEntitySerialize,
  deserialize: _attendanceOutboxEntityDeserialize,
  deserializeProp: _attendanceOutboxEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _attendanceOutboxEntityGetId,
  getLinks: _attendanceOutboxEntityGetLinks,
  attach: _attendanceOutboxEntityAttach,
  version: '3.3.0',
);

int _attendanceOutboxEntityEstimateSize(
  AttendanceOutboxEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.employeeName.length * 3;
  {
    final value = object.lastError;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.source.length * 3;
  return bytesCount;
}

void _attendanceOutboxEntitySerialize(
  AttendanceOutboxEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.action.index);
  writer.writeLong(offsets[1], object.attempts);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeLong(offsets[4], object.employeeId);
  writer.writeString(offsets[5], object.employeeName);
  writer.writeDateTime(offsets[6], object.lastAttemptAt);
  writer.writeString(offsets[7], object.lastError);
  writer.writeDateTime(offsets[8], object.nextAttemptAt);
  writer.writeString(offsets[9], object.source);
  writer.writeBool(offsets[10], object.synced);
  writer.writeDateTime(offsets[11], object.syncedAt);
}

AttendanceOutboxEntity _attendanceOutboxEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AttendanceOutboxEntity();
  object.action =
      _AttendanceOutboxEntityactionValueEnumMap[reader.readByteOrNull(
        offsets[0],
      )] ??
      AttendanceOutboxActionEntity.checkIn;
  object.attempts = reader.readLong(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.date = reader.readDateTime(offsets[3]);
  object.employeeId = reader.readLongOrNull(offsets[4]);
  object.employeeName = reader.readString(offsets[5]);
  object.id = id;
  object.lastAttemptAt = reader.readDateTimeOrNull(offsets[6]);
  object.lastError = reader.readStringOrNull(offsets[7]);
  object.nextAttemptAt = reader.readDateTimeOrNull(offsets[8]);
  object.source = reader.readString(offsets[9]);
  object.synced = reader.readBool(offsets[10]);
  object.syncedAt = reader.readDateTimeOrNull(offsets[11]);
  return object;
}

P _attendanceOutboxEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_AttendanceOutboxEntityactionValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              AttendanceOutboxActionEntity.checkIn)
          as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AttendanceOutboxEntityactionEnumValueMap = {'checkIn': 0, 'checkOut': 1};
const _AttendanceOutboxEntityactionValueEnumMap = {
  0: AttendanceOutboxActionEntity.checkIn,
  1: AttendanceOutboxActionEntity.checkOut,
};

Id _attendanceOutboxEntityGetId(AttendanceOutboxEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _attendanceOutboxEntityGetLinks(
  AttendanceOutboxEntity object,
) {
  return [];
}

void _attendanceOutboxEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  AttendanceOutboxEntity object,
) {
  object.id = id;
}

extension AttendanceOutboxEntityQueryWhereSort
    on QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QWhere> {
  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AttendanceOutboxEntityQueryWhere
    on
        QueryBuilder<
          AttendanceOutboxEntity,
          AttendanceOutboxEntity,
          QWhereClause
        > {
  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterWhereClause
  >
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterWhereClause
  >
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AttendanceOutboxEntityQueryFilter
    on
        QueryBuilder<
          AttendanceOutboxEntity,
          AttendanceOutboxEntity,
          QFilterCondition
        > {
  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  actionEqualTo(AttendanceOutboxActionEntity value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'action', value: value),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  actionGreaterThan(
    AttendanceOutboxActionEntity value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'action',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  actionLessThan(AttendanceOutboxActionEntity value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'action',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  actionBetween(
    AttendanceOutboxActionEntity lower,
    AttendanceOutboxActionEntity upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'action',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  attemptsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'attempts', value: value),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  attemptsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'attempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  attemptsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'attempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  attemptsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'attempts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  dateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  dateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'employeeId'),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'employeeId'),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'employeeId', value: value),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'employeeId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'employeeId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'employeeId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'employeeName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'employeeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'employeeName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'employeeName', value: ''),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  employeeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'employeeName', value: ''),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastAttemptAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastAttemptAt'),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastAttemptAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastAttemptAt'),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastAttemptAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastAttemptAt', value: value),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastAttemptAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastAttemptAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastAttemptAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastAttemptAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastAttemptAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastAttemptAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastError'),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastError'),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastError',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastError',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastError',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastError',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastError',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastError',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastError',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastError',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastError', value: ''),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  lastErrorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastError', value: ''),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  nextAttemptAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'nextAttemptAt'),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  nextAttemptAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'nextAttemptAt'),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  nextAttemptAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nextAttemptAt', value: value),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  nextAttemptAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nextAttemptAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  nextAttemptAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nextAttemptAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  nextAttemptAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nextAttemptAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  sourceEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'source',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  sourceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  sourceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'source',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'source', value: ''),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'source', value: ''),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  syncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'synced', value: value),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  syncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'syncedAt'),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  syncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'syncedAt'),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  syncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncedAt', value: value),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  syncedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  syncedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'syncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxEntity,
    QAfterFilterCondition
  >
  syncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AttendanceOutboxEntityQueryObject
    on
        QueryBuilder<
          AttendanceOutboxEntity,
          AttendanceOutboxEntity,
          QFilterCondition
        > {}

extension AttendanceOutboxEntityQueryLinks
    on
        QueryBuilder<
          AttendanceOutboxEntity,
          AttendanceOutboxEntity,
          QFilterCondition
        > {}

extension AttendanceOutboxEntityQuerySortBy
    on QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QSortBy> {
  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByEmployeeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByEmployeeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByEmployeeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByLastAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByNextAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortByNextAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }
}

extension AttendanceOutboxEntityQuerySortThenBy
    on
        QueryBuilder<
          AttendanceOutboxEntity,
          AttendanceOutboxEntity,
          QSortThenBy
        > {
  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByEmployeeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByEmployeeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByEmployeeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByLastAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByNextAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenByNextAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QAfterSortBy>
  thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }
}

extension AttendanceOutboxEntityQueryWhereDistinct
    on QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct> {
  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'action');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attempts');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employeeId');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctByEmployeeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employeeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAttemptAt');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctByLastError({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastError', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctByNextAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextAttemptAt');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctBySource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'synced');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, AttendanceOutboxEntity, QDistinct>
  distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }
}

extension AttendanceOutboxEntityQueryProperty
    on
        QueryBuilder<
          AttendanceOutboxEntity,
          AttendanceOutboxEntity,
          QQueryProperty
        > {
  QueryBuilder<AttendanceOutboxEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<
    AttendanceOutboxEntity,
    AttendanceOutboxActionEntity,
    QQueryOperations
  >
  actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'action');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, int, QQueryOperations>
  attemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attempts');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, DateTime, QQueryOperations>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, int?, QQueryOperations>
  employeeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employeeId');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, String, QQueryOperations>
  employeeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employeeName');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, DateTime?, QQueryOperations>
  lastAttemptAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAttemptAt');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, String?, QQueryOperations>
  lastErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastError');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, DateTime?, QQueryOperations>
  nextAttemptAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextAttemptAt');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, String, QQueryOperations>
  sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, bool, QQueryOperations>
  syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'synced');
    });
  }

  QueryBuilder<AttendanceOutboxEntity, DateTime?, QQueryOperations>
  syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }
}

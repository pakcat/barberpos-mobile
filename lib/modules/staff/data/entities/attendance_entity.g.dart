// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAttendanceEntityCollection on Isar {
  IsarCollection<AttendanceEntity> get attendanceEntitys => this.collection();
}

const AttendanceEntitySchema = CollectionSchema(
  name: r'AttendanceEntity',
  id: 5479936569571385882,
  properties: {
    r'checkIn': PropertySchema(
      id: 0,
      name: r'checkIn',
      type: IsarType.dateTime,
    ),
    r'checkOut': PropertySchema(
      id: 1,
      name: r'checkOut',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(id: 2, name: r'date', type: IsarType.dateTime),
    r'employeeId': PropertySchema(
      id: 3,
      name: r'employeeId',
      type: IsarType.long,
    ),
    r'employeeName': PropertySchema(
      id: 4,
      name: r'employeeName',
      type: IsarType.string,
    ),
    r'source': PropertySchema(id: 5, name: r'source', type: IsarType.string),
    r'status': PropertySchema(
      id: 6,
      name: r'status',
      type: IsarType.byte,
      enumMap: _AttendanceEntitystatusEnumValueMap,
    ),
  },

  estimateSize: _attendanceEntityEstimateSize,
  serialize: _attendanceEntitySerialize,
  deserialize: _attendanceEntityDeserialize,
  deserializeProp: _attendanceEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _attendanceEntityGetId,
  getLinks: _attendanceEntityGetLinks,
  attach: _attendanceEntityAttach,
  version: '3.3.0',
);

int _attendanceEntityEstimateSize(
  AttendanceEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.employeeName.length * 3;
  bytesCount += 3 + object.source.length * 3;
  return bytesCount;
}

void _attendanceEntitySerialize(
  AttendanceEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.checkIn);
  writer.writeDateTime(offsets[1], object.checkOut);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLong(offsets[3], object.employeeId);
  writer.writeString(offsets[4], object.employeeName);
  writer.writeString(offsets[5], object.source);
  writer.writeByte(offsets[6], object.status.index);
}

AttendanceEntity _attendanceEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AttendanceEntity();
  object.checkIn = reader.readDateTimeOrNull(offsets[0]);
  object.checkOut = reader.readDateTimeOrNull(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.employeeId = reader.readLongOrNull(offsets[3]);
  object.employeeName = reader.readString(offsets[4]);
  object.id = id;
  object.source = reader.readString(offsets[5]);
  object.status =
      _AttendanceEntitystatusValueEnumMap[reader.readByteOrNull(offsets[6])] ??
      AttendanceStatus.present;
  return object;
}

P _attendanceEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (_AttendanceEntitystatusValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              AttendanceStatus.present)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AttendanceEntitystatusEnumValueMap = {
  'present': 0,
  'leave': 1,
  'sick': 2,
  'off': 3,
};
const _AttendanceEntitystatusValueEnumMap = {
  0: AttendanceStatus.present,
  1: AttendanceStatus.leave,
  2: AttendanceStatus.sick,
  3: AttendanceStatus.off,
};

Id _attendanceEntityGetId(AttendanceEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _attendanceEntityGetLinks(AttendanceEntity object) {
  return [];
}

void _attendanceEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  AttendanceEntity object,
) {
  object.id = id;
}

extension AttendanceEntityQueryWhereSort
    on QueryBuilder<AttendanceEntity, AttendanceEntity, QWhere> {
  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AttendanceEntityQueryWhere
    on QueryBuilder<AttendanceEntity, AttendanceEntity, QWhereClause> {
  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterWhereClause>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterWhereClause> idBetween(
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

extension AttendanceEntityQueryFilter
    on QueryBuilder<AttendanceEntity, AttendanceEntity, QFilterCondition> {
  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkInIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkIn'),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkInIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkIn'),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkInEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'checkIn', value: value),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkInGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'checkIn',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkInLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'checkIn',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkInBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'checkIn',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkOutIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkOut'),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkOutIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkOut'),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkOutEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'checkOut', value: value),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkOutGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'checkOut',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkOutLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'checkOut',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  checkOutBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'checkOut',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  employeeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'employeeId'),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  employeeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'employeeId'),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  employeeIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'employeeId', value: value),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  employeeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'employeeName', value: ''),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  employeeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'employeeName', value: ''),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
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

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'source', value: ''),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'source', value: ''),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  statusEqualTo(AttendanceStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  statusGreaterThan(AttendanceStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  statusLessThan(AttendanceStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterFilterCondition>
  statusBetween(
    AttendanceStatus lower,
    AttendanceStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AttendanceEntityQueryObject
    on QueryBuilder<AttendanceEntity, AttendanceEntity, QFilterCondition> {}

extension AttendanceEntityQueryLinks
    on QueryBuilder<AttendanceEntity, AttendanceEntity, QFilterCondition> {}

extension AttendanceEntityQuerySortBy
    on QueryBuilder<AttendanceEntity, AttendanceEntity, QSortBy> {
  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByCheckIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIn', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByCheckInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIn', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByCheckOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOut', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByCheckOutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOut', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByEmployeeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByEmployeeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByEmployeeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension AttendanceEntityQuerySortThenBy
    on QueryBuilder<AttendanceEntity, AttendanceEntity, QSortThenBy> {
  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByCheckIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIn', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByCheckInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIn', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByCheckOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOut', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByCheckOutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOut', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByEmployeeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByEmployeeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByEmployeeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension AttendanceEntityQueryWhereDistinct
    on QueryBuilder<AttendanceEntity, AttendanceEntity, QDistinct> {
  QueryBuilder<AttendanceEntity, AttendanceEntity, QDistinct>
  distinctByCheckIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkIn');
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QDistinct>
  distinctByCheckOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkOut');
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QDistinct>
  distinctByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employeeId');
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QDistinct>
  distinctByEmployeeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employeeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QDistinct> distinctBySource({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceEntity, QDistinct>
  distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension AttendanceEntityQueryProperty
    on QueryBuilder<AttendanceEntity, AttendanceEntity, QQueryProperty> {
  QueryBuilder<AttendanceEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AttendanceEntity, DateTime?, QQueryOperations>
  checkInProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkIn');
    });
  }

  QueryBuilder<AttendanceEntity, DateTime?, QQueryOperations>
  checkOutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkOut');
    });
  }

  QueryBuilder<AttendanceEntity, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<AttendanceEntity, int?, QQueryOperations> employeeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employeeId');
    });
  }

  QueryBuilder<AttendanceEntity, String, QQueryOperations>
  employeeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employeeName');
    });
  }

  QueryBuilder<AttendanceEntity, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<AttendanceEntity, AttendanceStatus, QQueryOperations>
  statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}

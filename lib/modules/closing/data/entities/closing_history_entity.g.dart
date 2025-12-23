// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'closing_history_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetClosingHistoryEntityCollection on Isar {
  IsarCollection<ClosingHistoryEntity> get closingHistoryEntitys =>
      this.collection();
}

const ClosingHistoryEntitySchema = CollectionSchema(
  name: r'ClosingHistoryEntity',
  id: -9184159592482299849,
  properties: {
    r'catatan': PropertySchema(id: 0, name: r'catatan', type: IsarType.string),
    r'fisik': PropertySchema(id: 1, name: r'fisik', type: IsarType.string),
    r'karyawan': PropertySchema(
      id: 2,
      name: r'karyawan',
      type: IsarType.string,
    ),
    r'operatorName': PropertySchema(
      id: 3,
      name: r'operatorName',
      type: IsarType.string,
    ),
    r'shift': PropertySchema(id: 4, name: r'shift', type: IsarType.string),
    r'shiftId': PropertySchema(id: 5, name: r'shiftId', type: IsarType.string),
    r'status': PropertySchema(id: 6, name: r'status', type: IsarType.string),
    r'tanggal': PropertySchema(
      id: 7,
      name: r'tanggal',
      type: IsarType.dateTime,
    ),
    r'total': PropertySchema(id: 8, name: r'total', type: IsarType.long),
  },

  estimateSize: _closingHistoryEntityEstimateSize,
  serialize: _closingHistoryEntitySerialize,
  deserialize: _closingHistoryEntityDeserialize,
  deserializeProp: _closingHistoryEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _closingHistoryEntityGetId,
  getLinks: _closingHistoryEntityGetLinks,
  attach: _closingHistoryEntityAttach,
  version: '3.3.0',
);

int _closingHistoryEntityEstimateSize(
  ClosingHistoryEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.catatan.length * 3;
  bytesCount += 3 + object.fisik.length * 3;
  bytesCount += 3 + object.karyawan.length * 3;
  bytesCount += 3 + object.operatorName.length * 3;
  bytesCount += 3 + object.shift.length * 3;
  {
    final value = object.shiftId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _closingHistoryEntitySerialize(
  ClosingHistoryEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.catatan);
  writer.writeString(offsets[1], object.fisik);
  writer.writeString(offsets[2], object.karyawan);
  writer.writeString(offsets[3], object.operatorName);
  writer.writeString(offsets[4], object.shift);
  writer.writeString(offsets[5], object.shiftId);
  writer.writeString(offsets[6], object.status);
  writer.writeDateTime(offsets[7], object.tanggal);
  writer.writeLong(offsets[8], object.total);
}

ClosingHistoryEntity _closingHistoryEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ClosingHistoryEntity();
  object.catatan = reader.readString(offsets[0]);
  object.fisik = reader.readString(offsets[1]);
  object.id = id;
  object.karyawan = reader.readString(offsets[2]);
  object.operatorName = reader.readString(offsets[3]);
  object.shift = reader.readString(offsets[4]);
  object.shiftId = reader.readStringOrNull(offsets[5]);
  object.status = reader.readString(offsets[6]);
  object.tanggal = reader.readDateTime(offsets[7]);
  object.total = reader.readLong(offsets[8]);
  return object;
}

P _closingHistoryEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _closingHistoryEntityGetId(ClosingHistoryEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _closingHistoryEntityGetLinks(
  ClosingHistoryEntity object,
) {
  return [];
}

void _closingHistoryEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  ClosingHistoryEntity object,
) {
  object.id = id;
}

extension ClosingHistoryEntityQueryWhereSort
    on QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QWhere> {
  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ClosingHistoryEntityQueryWhere
    on QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QWhereClause> {
  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterWhereClause>
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

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterWhereClause>
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

extension ClosingHistoryEntityQueryFilter
    on
        QueryBuilder<
          ClosingHistoryEntity,
          ClosingHistoryEntity,
          QFilterCondition
        > {
  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  catatanEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'catatan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  catatanGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'catatan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  catatanLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'catatan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  catatanBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'catatan',
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  catatanStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'catatan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  catatanEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'catatan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  catatanContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'catatan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  catatanMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'catatan',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  catatanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'catatan', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  catatanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'catatan', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  fisikEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fisik',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  fisikGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fisik',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  fisikLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fisik',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  fisikBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fisik',
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  fisikStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fisik',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  fisikEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fisik',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  fisikContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fisik',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  fisikMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fisik',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  fisikIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fisik', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  fisikIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fisik', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  karyawanEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'karyawan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  karyawanGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'karyawan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  karyawanLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'karyawan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  karyawanBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'karyawan',
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  karyawanStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'karyawan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  karyawanEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'karyawan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  karyawanContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'karyawan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  karyawanMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'karyawan',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  karyawanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'karyawan', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  karyawanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'karyawan', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  operatorNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'operatorName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  operatorNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'operatorName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  operatorNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'operatorName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  operatorNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'operatorName',
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  operatorNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'operatorName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  operatorNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'operatorName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  operatorNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'operatorName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  operatorNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'operatorName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  operatorNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'operatorName', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  operatorNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'operatorName', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shift',
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'shift',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shift', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'shift', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'shiftId'),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'shiftId'),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'shiftId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shiftId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shiftId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shiftId',
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'shiftId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'shiftId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'shiftId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'shiftId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shiftId', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  shiftIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'shiftId', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  statusEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
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
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  statusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  tanggalEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tanggal', value: value),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  tanggalGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tanggal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  tanggalLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tanggal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  tanggalBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tanggal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  totalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'total', value: value),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  totalGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'total',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  totalLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'total',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ClosingHistoryEntity,
    ClosingHistoryEntity,
    QAfterFilterCondition
  >
  totalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'total',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ClosingHistoryEntityQueryObject
    on
        QueryBuilder<
          ClosingHistoryEntity,
          ClosingHistoryEntity,
          QFilterCondition
        > {}

extension ClosingHistoryEntityQueryLinks
    on
        QueryBuilder<
          ClosingHistoryEntity,
          ClosingHistoryEntity,
          QFilterCondition
        > {}

extension ClosingHistoryEntityQuerySortBy
    on QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QSortBy> {
  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByCatatan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catatan', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByCatatanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catatan', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByFisik() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fisik', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByFisikDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fisik', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByKaryawan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'karyawan', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByKaryawanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'karyawan', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByOperatorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByOperatorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByShiftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByShiftId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftId', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByShiftIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftId', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByTanggalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }
}

extension ClosingHistoryEntityQuerySortThenBy
    on QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QSortThenBy> {
  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByCatatan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catatan', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByCatatanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catatan', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByFisik() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fisik', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByFisikDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fisik', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByKaryawan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'karyawan', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByKaryawanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'karyawan', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByOperatorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByOperatorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByShiftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByShiftId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftId', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByShiftIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftId', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByTanggalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.desc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QAfterSortBy>
  thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }
}

extension ClosingHistoryEntityQueryWhereDistinct
    on QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QDistinct> {
  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QDistinct>
  distinctByCatatan({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catatan', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QDistinct>
  distinctByFisik({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fisik', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QDistinct>
  distinctByKaryawan({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'karyawan', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QDistinct>
  distinctByOperatorName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operatorName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QDistinct>
  distinctByShift({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shift', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QDistinct>
  distinctByShiftId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shiftId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QDistinct>
  distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QDistinct>
  distinctByTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tanggal');
    });
  }

  QueryBuilder<ClosingHistoryEntity, ClosingHistoryEntity, QDistinct>
  distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total');
    });
  }
}

extension ClosingHistoryEntityQueryProperty
    on
        QueryBuilder<
          ClosingHistoryEntity,
          ClosingHistoryEntity,
          QQueryProperty
        > {
  QueryBuilder<ClosingHistoryEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ClosingHistoryEntity, String, QQueryOperations>
  catatanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catatan');
    });
  }

  QueryBuilder<ClosingHistoryEntity, String, QQueryOperations> fisikProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fisik');
    });
  }

  QueryBuilder<ClosingHistoryEntity, String, QQueryOperations>
  karyawanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'karyawan');
    });
  }

  QueryBuilder<ClosingHistoryEntity, String, QQueryOperations>
  operatorNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operatorName');
    });
  }

  QueryBuilder<ClosingHistoryEntity, String, QQueryOperations> shiftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shift');
    });
  }

  QueryBuilder<ClosingHistoryEntity, String?, QQueryOperations>
  shiftIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shiftId');
    });
  }

  QueryBuilder<ClosingHistoryEntity, String, QQueryOperations>
  statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<ClosingHistoryEntity, DateTime, QQueryOperations>
  tanggalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tanggal');
    });
  }

  QueryBuilder<ClosingHistoryEntity, int, QQueryOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total');
    });
  }
}

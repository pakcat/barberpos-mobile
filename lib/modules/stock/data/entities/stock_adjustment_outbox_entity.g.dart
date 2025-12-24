// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_adjustment_outbox_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStockAdjustmentOutboxEntityCollection on Isar {
  IsarCollection<StockAdjustmentOutboxEntity>
  get stockAdjustmentOutboxEntitys => this.collection();
}

const StockAdjustmentOutboxEntitySchema = CollectionSchema(
  name: r'StockAdjustmentOutboxEntity',
  id: 8597487966296944590,
  properties: {
    r'attempts': PropertySchema(id: 0, name: r'attempts', type: IsarType.long),
    r'change': PropertySchema(id: 1, name: r'change', type: IsarType.long),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'lastAttemptAt': PropertySchema(
      id: 3,
      name: r'lastAttemptAt',
      type: IsarType.dateTime,
    ),
    r'lastError': PropertySchema(
      id: 4,
      name: r'lastError',
      type: IsarType.string,
    ),
    r'nextAttemptAt': PropertySchema(
      id: 5,
      name: r'nextAttemptAt',
      type: IsarType.dateTime,
    ),
    r'note': PropertySchema(id: 6, name: r'note', type: IsarType.string),
    r'productId': PropertySchema(
      id: 7,
      name: r'productId',
      type: IsarType.long,
    ),
    r'stockId': PropertySchema(id: 8, name: r'stockId', type: IsarType.long),
    r'synced': PropertySchema(id: 9, name: r'synced', type: IsarType.bool),
    r'type': PropertySchema(id: 10, name: r'type', type: IsarType.string),
  },

  estimateSize: _stockAdjustmentOutboxEntityEstimateSize,
  serialize: _stockAdjustmentOutboxEntitySerialize,
  deserialize: _stockAdjustmentOutboxEntityDeserialize,
  deserializeProp: _stockAdjustmentOutboxEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _stockAdjustmentOutboxEntityGetId,
  getLinks: _stockAdjustmentOutboxEntityGetLinks,
  attach: _stockAdjustmentOutboxEntityAttach,
  version: '3.3.0',
);

int _stockAdjustmentOutboxEntityEstimateSize(
  StockAdjustmentOutboxEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lastError;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.note.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _stockAdjustmentOutboxEntitySerialize(
  StockAdjustmentOutboxEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attempts);
  writer.writeLong(offsets[1], object.change);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDateTime(offsets[3], object.lastAttemptAt);
  writer.writeString(offsets[4], object.lastError);
  writer.writeDateTime(offsets[5], object.nextAttemptAt);
  writer.writeString(offsets[6], object.note);
  writer.writeLong(offsets[7], object.productId);
  writer.writeLong(offsets[8], object.stockId);
  writer.writeBool(offsets[9], object.synced);
  writer.writeString(offsets[10], object.type);
}

StockAdjustmentOutboxEntity _stockAdjustmentOutboxEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StockAdjustmentOutboxEntity();
  object.attempts = reader.readLong(offsets[0]);
  object.change = reader.readLong(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.lastAttemptAt = reader.readDateTimeOrNull(offsets[3]);
  object.lastError = reader.readStringOrNull(offsets[4]);
  object.nextAttemptAt = reader.readDateTimeOrNull(offsets[5]);
  object.note = reader.readString(offsets[6]);
  object.productId = reader.readLongOrNull(offsets[7]);
  object.stockId = reader.readLong(offsets[8]);
  object.synced = reader.readBool(offsets[9]);
  object.type = reader.readString(offsets[10]);
  return object;
}

P _stockAdjustmentOutboxEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stockAdjustmentOutboxEntityGetId(StockAdjustmentOutboxEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stockAdjustmentOutboxEntityGetLinks(
  StockAdjustmentOutboxEntity object,
) {
  return [];
}

void _stockAdjustmentOutboxEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  StockAdjustmentOutboxEntity object,
) {
  object.id = id;
}

extension StockAdjustmentOutboxEntityQueryWhereSort
    on
        QueryBuilder<
          StockAdjustmentOutboxEntity,
          StockAdjustmentOutboxEntity,
          QWhere
        > {
  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StockAdjustmentOutboxEntityQueryWhere
    on
        QueryBuilder<
          StockAdjustmentOutboxEntity,
          StockAdjustmentOutboxEntity,
          QWhereClause
        > {
  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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

extension StockAdjustmentOutboxEntityQueryFilter
    on
        QueryBuilder<
          StockAdjustmentOutboxEntity,
          StockAdjustmentOutboxEntity,
          QFilterCondition
        > {
  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  changeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'change', value: value),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  changeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'change',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  changeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'change',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  changeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'change',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  noteEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  noteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  noteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  noteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'note',
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  noteStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  noteEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'note',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  productIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'productId'),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  productIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'productId'),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  productIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'productId', value: value),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  productIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'productId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  productIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'productId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  productIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'productId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  stockIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stockId', value: value),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  stockIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stockId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  stockIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stockId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  stockIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stockId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  typeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
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
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  typeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  typeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'type',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterFilterCondition
  >
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }
}

extension StockAdjustmentOutboxEntityQueryObject
    on
        QueryBuilder<
          StockAdjustmentOutboxEntity,
          StockAdjustmentOutboxEntity,
          QFilterCondition
        > {}

extension StockAdjustmentOutboxEntityQueryLinks
    on
        QueryBuilder<
          StockAdjustmentOutboxEntity,
          StockAdjustmentOutboxEntity,
          QFilterCondition
        > {}

extension StockAdjustmentOutboxEntityQuerySortBy
    on
        QueryBuilder<
          StockAdjustmentOutboxEntity,
          StockAdjustmentOutboxEntity,
          QSortBy
        > {
  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'change', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'change', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByLastAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByNextAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByNextAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByStockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockId', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByStockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockId', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension StockAdjustmentOutboxEntityQuerySortThenBy
    on
        QueryBuilder<
          StockAdjustmentOutboxEntity,
          StockAdjustmentOutboxEntity,
          QSortThenBy
        > {
  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'change', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'change', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByLastAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByNextAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByNextAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByStockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockId', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByStockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockId', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QAfterSortBy
  >
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension StockAdjustmentOutboxEntityQueryWhereDistinct
    on
        QueryBuilder<
          StockAdjustmentOutboxEntity,
          StockAdjustmentOutboxEntity,
          QDistinct
        > {
  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attempts');
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctByChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'change');
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAttemptAt');
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctByLastError({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastError', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctByNextAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextAttemptAt');
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctByStockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stockId');
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'synced');
    });
  }

  QueryBuilder<
    StockAdjustmentOutboxEntity,
    StockAdjustmentOutboxEntity,
    QDistinct
  >
  distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension StockAdjustmentOutboxEntityQueryProperty
    on
        QueryBuilder<
          StockAdjustmentOutboxEntity,
          StockAdjustmentOutboxEntity,
          QQueryProperty
        > {
  QueryBuilder<StockAdjustmentOutboxEntity, int, QQueryOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, int, QQueryOperations>
  attemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attempts');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, int, QQueryOperations>
  changeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'change');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, DateTime?, QQueryOperations>
  lastAttemptAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAttemptAt');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, String?, QQueryOperations>
  lastErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastError');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, DateTime?, QQueryOperations>
  nextAttemptAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextAttemptAt');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, String, QQueryOperations>
  noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, int?, QQueryOperations>
  productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, int, QQueryOperations>
  stockIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stockId');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, bool, QQueryOperations>
  syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'synced');
    });
  }

  QueryBuilder<StockAdjustmentOutboxEntity, String, QQueryOperations>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

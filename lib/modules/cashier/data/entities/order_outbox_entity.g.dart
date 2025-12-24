// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_outbox_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderOutboxEntityCollection on Isar {
  IsarCollection<OrderOutboxEntity> get orderOutboxEntitys => this.collection();
}

const OrderOutboxEntitySchema = CollectionSchema(
  name: r'OrderOutboxEntity',
  id: 1025171232726645168,
  properties: {
    r'clientRef': PropertySchema(
      id: 0,
      name: r'clientRef',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'lastError': PropertySchema(
      id: 2,
      name: r'lastError',
      type: IsarType.string,
    ),
    r'payloadJson': PropertySchema(
      id: 3,
      name: r'payloadJson',
      type: IsarType.string,
    ),
    r'pendingCode': PropertySchema(
      id: 4,
      name: r'pendingCode',
      type: IsarType.string,
    ),
    r'serverCode': PropertySchema(
      id: 5,
      name: r'serverCode',
      type: IsarType.string,
    ),
    r'synced': PropertySchema(id: 6, name: r'synced', type: IsarType.bool),
    r'syncedAt': PropertySchema(
      id: 7,
      name: r'syncedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _orderOutboxEntityEstimateSize,
  serialize: _orderOutboxEntitySerialize,
  deserialize: _orderOutboxEntityDeserialize,
  deserializeProp: _orderOutboxEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _orderOutboxEntityGetId,
  getLinks: _orderOutboxEntityGetLinks,
  attach: _orderOutboxEntityAttach,
  version: '3.3.0',
);

int _orderOutboxEntityEstimateSize(
  OrderOutboxEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.clientRef.length * 3;
  {
    final value = object.lastError;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.payloadJson.length * 3;
  bytesCount += 3 + object.pendingCode.length * 3;
  {
    final value = object.serverCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _orderOutboxEntitySerialize(
  OrderOutboxEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.clientRef);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.lastError);
  writer.writeString(offsets[3], object.payloadJson);
  writer.writeString(offsets[4], object.pendingCode);
  writer.writeString(offsets[5], object.serverCode);
  writer.writeBool(offsets[6], object.synced);
  writer.writeDateTime(offsets[7], object.syncedAt);
}

OrderOutboxEntity _orderOutboxEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderOutboxEntity();
  object.clientRef = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.lastError = reader.readStringOrNull(offsets[2]);
  object.payloadJson = reader.readString(offsets[3]);
  object.pendingCode = reader.readString(offsets[4]);
  object.serverCode = reader.readStringOrNull(offsets[5]);
  object.synced = reader.readBool(offsets[6]);
  object.syncedAt = reader.readDateTimeOrNull(offsets[7]);
  return object;
}

P _orderOutboxEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _orderOutboxEntityGetId(OrderOutboxEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderOutboxEntityGetLinks(
  OrderOutboxEntity object,
) {
  return [];
}

void _orderOutboxEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  OrderOutboxEntity object,
) {
  object.id = id;
}

extension OrderOutboxEntityQueryWhereSort
    on QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QWhere> {
  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OrderOutboxEntityQueryWhere
    on QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QWhereClause> {
  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterWhereClause>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterWhereClause>
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

extension OrderOutboxEntityQueryFilter
    on QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QFilterCondition> {
  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  clientRefEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'clientRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  clientRefGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'clientRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  clientRefLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'clientRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  clientRefBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'clientRef',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  clientRefStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'clientRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  clientRefEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'clientRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  clientRefContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'clientRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  clientRefMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'clientRef',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  clientRefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clientRef', value: ''),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  clientRefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'clientRef', value: ''),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  lastErrorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastError'),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  lastErrorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastError'),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  lastErrorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastError', value: ''),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  lastErrorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastError', value: ''),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  payloadJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  payloadJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  payloadJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  payloadJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'payloadJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  payloadJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  payloadJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  payloadJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  payloadJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'payloadJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  payloadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'payloadJson', value: ''),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  payloadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'payloadJson', value: ''),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  pendingCodeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pendingCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  pendingCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pendingCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  pendingCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pendingCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  pendingCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pendingCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  pendingCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pendingCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  pendingCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pendingCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  pendingCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pendingCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  pendingCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pendingCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  pendingCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pendingCode', value: ''),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  pendingCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'pendingCode', value: ''),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'serverCode'),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'serverCode'),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'serverCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'serverCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'serverCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'serverCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'serverCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'serverCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'serverCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'serverCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'serverCode', value: ''),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  serverCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'serverCode', value: ''),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  syncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'synced', value: value),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  syncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'syncedAt'),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  syncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'syncedAt'),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
  syncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncedAt', value: value),
      );
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterFilterCondition>
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

extension OrderOutboxEntityQueryObject
    on QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QFilterCondition> {}

extension OrderOutboxEntityQueryLinks
    on QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QFilterCondition> {}

extension OrderOutboxEntityQuerySortBy
    on QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QSortBy> {
  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByClientRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientRef', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByClientRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientRef', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByPendingCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingCode', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByPendingCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingCode', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByServerCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverCode', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortByServerCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverCode', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }
}

extension OrderOutboxEntityQuerySortThenBy
    on QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QSortThenBy> {
  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByClientRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientRef', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByClientRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientRef', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByPendingCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingCode', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByPendingCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingCode', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByServerCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverCode', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenByServerCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverCode', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QAfterSortBy>
  thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }
}

extension OrderOutboxEntityQueryWhereDistinct
    on QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QDistinct> {
  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QDistinct>
  distinctByClientRef({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientRef', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QDistinct>
  distinctByLastError({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastError', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QDistinct>
  distinctByPayloadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QDistinct>
  distinctByPendingCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QDistinct>
  distinctByServerCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QDistinct>
  distinctBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'synced');
    });
  }

  QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QDistinct>
  distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }
}

extension OrderOutboxEntityQueryProperty
    on QueryBuilder<OrderOutboxEntity, OrderOutboxEntity, QQueryProperty> {
  QueryBuilder<OrderOutboxEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderOutboxEntity, String, QQueryOperations>
  clientRefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientRef');
    });
  }

  QueryBuilder<OrderOutboxEntity, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OrderOutboxEntity, String?, QQueryOperations>
  lastErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastError');
    });
  }

  QueryBuilder<OrderOutboxEntity, String, QQueryOperations>
  payloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadJson');
    });
  }

  QueryBuilder<OrderOutboxEntity, String, QQueryOperations>
  pendingCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingCode');
    });
  }

  QueryBuilder<OrderOutboxEntity, String?, QQueryOperations>
  serverCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverCode');
    });
  }

  QueryBuilder<OrderOutboxEntity, bool, QQueryOperations> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'synced');
    });
  }

  QueryBuilder<OrderOutboxEntity, DateTime?, QQueryOperations>
  syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }
}

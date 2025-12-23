// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransactionEntityCollection on Isar {
  IsarCollection<TransactionEntity> get transactionEntitys => this.collection();
}

const TransactionEntitySchema = CollectionSchema(
  name: r'TransactionEntity',
  id: 7517214299117749517,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.long),
    r'code': PropertySchema(id: 1, name: r'code', type: IsarType.string),
    r'customer': PropertySchema(
      id: 2,
      name: r'customer',
      type: IsarType.object,

      target: r'TransactionCustomerEntity',
    ),
    r'date': PropertySchema(id: 3, name: r'date', type: IsarType.dateTime),
    r'items': PropertySchema(
      id: 4,
      name: r'items',
      type: IsarType.objectList,

      target: r'TransactionLineEntity',
    ),
    r'operatorName': PropertySchema(
      id: 5,
      name: r'operatorName',
      type: IsarType.string,
    ),
    r'paymentIntentId': PropertySchema(
      id: 6,
      name: r'paymentIntentId',
      type: IsarType.string,
    ),
    r'paymentMethod': PropertySchema(
      id: 7,
      name: r'paymentMethod',
      type: IsarType.string,
    ),
    r'paymentReference': PropertySchema(
      id: 8,
      name: r'paymentReference',
      type: IsarType.string,
    ),
    r'shiftId': PropertySchema(id: 9, name: r'shiftId', type: IsarType.string),
    r'status': PropertySchema(
      id: 10,
      name: r'status',
      type: IsarType.byte,
      enumMap: _TransactionEntitystatusEnumValueMap,
    ),
    r'stylist': PropertySchema(id: 11, name: r'stylist', type: IsarType.string),
    r'time': PropertySchema(id: 12, name: r'time', type: IsarType.string),
  },

  estimateSize: _transactionEntityEstimateSize,
  serialize: _transactionEntitySerialize,
  deserialize: _transactionEntityDeserialize,
  deserializeProp: _transactionEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'TransactionLineEntity': TransactionLineEntitySchema,
    r'TransactionCustomerEntity': TransactionCustomerEntitySchema,
  },

  getId: _transactionEntityGetId,
  getLinks: _transactionEntityGetLinks,
  attach: _transactionEntityAttach,
  version: '3.3.0',
);

int _transactionEntityEstimateSize(
  TransactionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.code.length * 3;
  {
    final value = object.customer;
    if (value != null) {
      bytesCount +=
          3 +
          TransactionCustomerEntitySchema.estimateSize(
            value,
            allOffsets[TransactionCustomerEntity]!,
            allOffsets,
          );
    }
  }
  bytesCount += 3 + object.items.length * 3;
  {
    final offsets = allOffsets[TransactionLineEntity]!;
    for (var i = 0; i < object.items.length; i++) {
      final value = object.items[i];
      bytesCount += TransactionLineEntitySchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  bytesCount += 3 + object.operatorName.length * 3;
  {
    final value = object.paymentIntentId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.paymentMethod.length * 3;
  {
    final value = object.paymentReference;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.shiftId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.stylist.length * 3;
  bytesCount += 3 + object.time.length * 3;
  return bytesCount;
}

void _transactionEntitySerialize(
  TransactionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeString(offsets[1], object.code);
  writer.writeObject<TransactionCustomerEntity>(
    offsets[2],
    allOffsets,
    TransactionCustomerEntitySchema.serialize,
    object.customer,
  );
  writer.writeDateTime(offsets[3], object.date);
  writer.writeObjectList<TransactionLineEntity>(
    offsets[4],
    allOffsets,
    TransactionLineEntitySchema.serialize,
    object.items,
  );
  writer.writeString(offsets[5], object.operatorName);
  writer.writeString(offsets[6], object.paymentIntentId);
  writer.writeString(offsets[7], object.paymentMethod);
  writer.writeString(offsets[8], object.paymentReference);
  writer.writeString(offsets[9], object.shiftId);
  writer.writeByte(offsets[10], object.status.index);
  writer.writeString(offsets[11], object.stylist);
  writer.writeString(offsets[12], object.time);
}

TransactionEntity _transactionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransactionEntity();
  object.amount = reader.readLong(offsets[0]);
  object.code = reader.readString(offsets[1]);
  object.customer = reader.readObjectOrNull<TransactionCustomerEntity>(
    offsets[2],
    TransactionCustomerEntitySchema.deserialize,
    allOffsets,
  );
  object.date = reader.readDateTime(offsets[3]);
  object.id = id;
  object.items =
      reader.readObjectList<TransactionLineEntity>(
        offsets[4],
        TransactionLineEntitySchema.deserialize,
        allOffsets,
        TransactionLineEntity(),
      ) ??
      [];
  object.operatorName = reader.readString(offsets[5]);
  object.paymentIntentId = reader.readStringOrNull(offsets[6]);
  object.paymentMethod = reader.readString(offsets[7]);
  object.paymentReference = reader.readStringOrNull(offsets[8]);
  object.shiftId = reader.readStringOrNull(offsets[9]);
  object.status =
      _TransactionEntitystatusValueEnumMap[reader.readByteOrNull(
        offsets[10],
      )] ??
      TransactionStatusEntity.paid;
  object.stylist = reader.readString(offsets[11]);
  object.time = reader.readString(offsets[12]);
  return object;
}

P _transactionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readObjectOrNull<TransactionCustomerEntity>(
            offset,
            TransactionCustomerEntitySchema.deserialize,
            allOffsets,
          ))
          as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readObjectList<TransactionLineEntity>(
                offset,
                TransactionLineEntitySchema.deserialize,
                allOffsets,
                TransactionLineEntity(),
              ) ??
              [])
          as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (_TransactionEntitystatusValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              TransactionStatusEntity.paid)
          as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TransactionEntitystatusEnumValueMap = {'paid': 0, 'refund': 1};
const _TransactionEntitystatusValueEnumMap = {
  0: TransactionStatusEntity.paid,
  1: TransactionStatusEntity.refund,
};

Id _transactionEntityGetId(TransactionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transactionEntityGetLinks(
  TransactionEntity object,
) {
  return [];
}

void _transactionEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  TransactionEntity object,
) {
  object.id = id;
}

extension TransactionEntityQueryWhereSort
    on QueryBuilder<TransactionEntity, TransactionEntity, QWhere> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TransactionEntityQueryWhere
    on QueryBuilder<TransactionEntity, TransactionEntity, QWhereClause> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause>
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

extension TransactionEntityQueryFilter
    on QueryBuilder<TransactionEntity, TransactionEntity, QFilterCondition> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  amountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'amount', value: value),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  amountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  amountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  amountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  codeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  codeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  codeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  codeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'code',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  codeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  codeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  codeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  codeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'code',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'code', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'code', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  customerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customer'),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  customerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customer'),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  itemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'items', length, true, length, true);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  itemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'items', 0, true, 0, true);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  itemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'items', 0, false, 999999, true);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  itemsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'items', 0, true, length, include);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  itemsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'items', length, include, 999999, true);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  itemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  operatorNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'operatorName', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  operatorNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'operatorName', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'paymentIntentId'),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'paymentIntentId'),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paymentIntentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paymentIntentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paymentIntentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paymentIntentId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paymentIntentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paymentIntentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paymentIntentId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paymentIntentId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentIntentId', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentIntentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paymentIntentId', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentMethodEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paymentMethod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentMethodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentMethodEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paymentMethod',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentMethod', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paymentMethod', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'paymentReference'),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'paymentReference'),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paymentReference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paymentReference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paymentReference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paymentReference',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paymentReference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paymentReference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paymentReference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paymentReference',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentReference', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  paymentReferenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paymentReference', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  shiftIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'shiftId'),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  shiftIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'shiftId'),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  shiftIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shiftId', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  shiftIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'shiftId', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  statusEqualTo(TransactionStatusEntity value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  statusGreaterThan(TransactionStatusEntity value, {bool include = false}) {
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  statusLessThan(TransactionStatusEntity value, {bool include = false}) {
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  statusBetween(
    TransactionStatusEntity lower,
    TransactionStatusEntity upper, {
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  stylistEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'stylist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  stylistGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stylist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  stylistLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stylist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  stylistBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stylist',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  stylistStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'stylist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  stylistEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'stylist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  stylistContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'stylist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  stylistMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'stylist',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  stylistIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stylist', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  stylistIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'stylist', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  timeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'time',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  timeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'time',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  timeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'time',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  timeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'time',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  timeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'time',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  timeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'time',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  timeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'time',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  timeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'time',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  timeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'time', value: ''),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  timeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'time', value: ''),
      );
    });
  }
}

extension TransactionEntityQueryObject
    on QueryBuilder<TransactionEntity, TransactionEntity, QFilterCondition> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  customer(FilterQuery<TransactionCustomerEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'customer');
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
  itemsElement(FilterQuery<TransactionLineEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'items');
    });
  }
}

extension TransactionEntityQueryLinks
    on QueryBuilder<TransactionEntity, TransactionEntity, QFilterCondition> {}

extension TransactionEntityQuerySortBy
    on QueryBuilder<TransactionEntity, TransactionEntity, QSortBy> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByOperatorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByOperatorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByPaymentIntentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentIntentId', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByPaymentIntentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentIntentId', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByPaymentReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentReference', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByPaymentReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentReference', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByShiftId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftId', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByShiftIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftId', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByStylist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stylist', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByStylistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stylist', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  sortByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension TransactionEntityQuerySortThenBy
    on QueryBuilder<TransactionEntity, TransactionEntity, QSortThenBy> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByOperatorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByOperatorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByPaymentIntentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentIntentId', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByPaymentIntentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentIntentId', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByPaymentReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentReference', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByPaymentReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentReference', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByShiftId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftId', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByShiftIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftId', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByStylist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stylist', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByStylistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stylist', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
  thenByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension TransactionEntityQueryWhereDistinct
    on QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> {
  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
  distinctByOperatorName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operatorName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
  distinctByPaymentIntentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'paymentIntentId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
  distinctByPaymentMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'paymentMethod',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
  distinctByPaymentReference({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'paymentReference',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
  distinctByShiftId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shiftId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
  distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
  distinctByStylist({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stylist', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByTime({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'time', caseSensitive: caseSensitive);
    });
  }
}

extension TransactionEntityQueryProperty
    on QueryBuilder<TransactionEntity, TransactionEntity, QQueryProperty> {
  QueryBuilder<TransactionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TransactionEntity, int, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<TransactionEntity, String, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<TransactionEntity, TransactionCustomerEntity?, QQueryOperations>
  customerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customer');
    });
  }

  QueryBuilder<TransactionEntity, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<TransactionEntity, List<TransactionLineEntity>, QQueryOperations>
  itemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'items');
    });
  }

  QueryBuilder<TransactionEntity, String, QQueryOperations>
  operatorNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operatorName');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations>
  paymentIntentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentIntentId');
    });
  }

  QueryBuilder<TransactionEntity, String, QQueryOperations>
  paymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMethod');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations>
  paymentReferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentReference');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations> shiftIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shiftId');
    });
  }

  QueryBuilder<TransactionEntity, TransactionStatusEntity, QQueryOperations>
  statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<TransactionEntity, String, QQueryOperations> stylistProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stylist');
    });
  }

  QueryBuilder<TransactionEntity, String, QQueryOperations> timeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'time');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TransactionLineEntitySchema = Schema(
  name: r'TransactionLineEntity',
  id: -638210563830007458,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 1, name: r'name', type: IsarType.string),
    r'price': PropertySchema(id: 2, name: r'price', type: IsarType.long),
    r'qty': PropertySchema(id: 3, name: r'qty', type: IsarType.long),
  },

  estimateSize: _transactionLineEntityEstimateSize,
  serialize: _transactionLineEntitySerialize,
  deserialize: _transactionLineEntityDeserialize,
  deserializeProp: _transactionLineEntityDeserializeProp,
);

int _transactionLineEntityEstimateSize(
  TransactionLineEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _transactionLineEntitySerialize(
  TransactionLineEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeString(offsets[1], object.name);
  writer.writeLong(offsets[2], object.price);
  writer.writeLong(offsets[3], object.qty);
}

TransactionLineEntity _transactionLineEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransactionLineEntity();
  object.category = reader.readString(offsets[0]);
  object.name = reader.readString(offsets[1]);
  object.price = reader.readLong(offsets[2]);
  object.qty = reader.readLong(offsets[3]);
  return object;
}

P _transactionLineEntityDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TransactionLineEntityQueryFilter
    on
        QueryBuilder<
          TransactionLineEntity,
          TransactionLineEntity,
          QFilterCondition
        > {
  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  categoryEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'category',
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
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  categoryStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  categoryEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'category',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
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
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  priceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'price', value: value),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  priceGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'price',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  priceLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'price',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  priceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'price',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  qtyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'qty', value: value),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  qtyGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'qty',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  qtyLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'qty',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionLineEntity,
    TransactionLineEntity,
    QAfterFilterCondition
  >
  qtyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'qty',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TransactionLineEntityQueryObject
    on
        QueryBuilder<
          TransactionLineEntity,
          TransactionLineEntity,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TransactionCustomerEntitySchema = Schema(
  name: r'TransactionCustomerEntity',
  id: 2703800207137251624,
  properties: {
    r'address': PropertySchema(id: 0, name: r'address', type: IsarType.string),
    r'email': PropertySchema(id: 1, name: r'email', type: IsarType.string),
    r'lastVisit': PropertySchema(
      id: 2,
      name: r'lastVisit',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
    r'phone': PropertySchema(id: 4, name: r'phone', type: IsarType.string),
    r'visits': PropertySchema(id: 5, name: r'visits', type: IsarType.long),
  },

  estimateSize: _transactionCustomerEntityEstimateSize,
  serialize: _transactionCustomerEntitySerialize,
  deserialize: _transactionCustomerEntityDeserialize,
  deserializeProp: _transactionCustomerEntityDeserializeProp,
);

int _transactionCustomerEntityEstimateSize(
  TransactionCustomerEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.address.length * 3;
  bytesCount += 3 + object.email.length * 3;
  {
    final value = object.lastVisit;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  return bytesCount;
}

void _transactionCustomerEntitySerialize(
  TransactionCustomerEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.email);
  writer.writeString(offsets[2], object.lastVisit);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.phone);
  writer.writeLong(offsets[5], object.visits);
}

TransactionCustomerEntity _transactionCustomerEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransactionCustomerEntity();
  object.address = reader.readString(offsets[0]);
  object.email = reader.readString(offsets[1]);
  object.lastVisit = reader.readStringOrNull(offsets[2]);
  object.name = reader.readString(offsets[3]);
  object.phone = reader.readString(offsets[4]);
  object.visits = reader.readLong(offsets[5]);
  return object;
}

P _transactionCustomerEntityDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TransactionCustomerEntityQueryFilter
    on
        QueryBuilder<
          TransactionCustomerEntity,
          TransactionCustomerEntity,
          QFilterCondition
        > {
  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  addressEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'address',
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
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  addressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  addressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'address',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'address', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'address', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  emailEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'email',
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
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  emailStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  emailEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'email',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastVisit'),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastVisit'),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastVisit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastVisit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastVisit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastVisit',
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
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastVisit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastVisit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastVisit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastVisit',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastVisit', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  lastVisitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastVisit', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
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
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  phoneEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phone',
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
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  phoneStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  phoneEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  phoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  phoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'phone',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'phone', value: ''),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  visitsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'visits', value: value),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  visitsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'visits',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  visitsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'visits',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TransactionCustomerEntity,
    TransactionCustomerEntity,
    QAfterFilterCondition
  >
  visitsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'visits',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TransactionCustomerEntityQueryObject
    on
        QueryBuilder<
          TransactionCustomerEntity,
          TransactionCustomerEntity,
          QFilterCondition
        > {}

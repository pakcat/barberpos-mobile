// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_topup_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMembershipTopupEntityCollection on Isar {
  IsarCollection<MembershipTopupEntity> get membershipTopupEntitys =>
      this.collection();
}

const MembershipTopupEntitySchema = CollectionSchema(
  name: r'MembershipTopupEntity',
  id: -4614831399943894753,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.long),
    r'date': PropertySchema(id: 1, name: r'date', type: IsarType.dateTime),
    r'manager': PropertySchema(id: 2, name: r'manager', type: IsarType.string),
    r'note': PropertySchema(id: 3, name: r'note', type: IsarType.string),
  },

  estimateSize: _membershipTopupEntityEstimateSize,
  serialize: _membershipTopupEntitySerialize,
  deserialize: _membershipTopupEntityDeserialize,
  deserializeProp: _membershipTopupEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _membershipTopupEntityGetId,
  getLinks: _membershipTopupEntityGetLinks,
  attach: _membershipTopupEntityAttach,
  version: '3.3.0',
);

int _membershipTopupEntityEstimateSize(
  MembershipTopupEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.manager.length * 3;
  bytesCount += 3 + object.note.length * 3;
  return bytesCount;
}

void _membershipTopupEntitySerialize(
  MembershipTopupEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.manager);
  writer.writeString(offsets[3], object.note);
}

MembershipTopupEntity _membershipTopupEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MembershipTopupEntity();
  object.amount = reader.readLong(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.id = id;
  object.manager = reader.readString(offsets[2]);
  object.note = reader.readString(offsets[3]);
  return object;
}

P _membershipTopupEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _membershipTopupEntityGetId(MembershipTopupEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _membershipTopupEntityGetLinks(
  MembershipTopupEntity object,
) {
  return [];
}

void _membershipTopupEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  MembershipTopupEntity object,
) {
  object.id = id;
}

extension MembershipTopupEntityQueryWhereSort
    on QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QWhere> {
  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MembershipTopupEntityQueryWhere
    on
        QueryBuilder<
          MembershipTopupEntity,
          MembershipTopupEntity,
          QWhereClause
        > {
  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterWhereClause>
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

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterWhereClause>
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

extension MembershipTopupEntityQueryFilter
    on
        QueryBuilder<
          MembershipTopupEntity,
          MembershipTopupEntity,
          QFilterCondition
        > {
  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  amountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'amount', value: value),
      );
    });
  }

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  managerEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'manager',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  managerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'manager',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  managerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'manager',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  managerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'manager',
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
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  managerStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'manager',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  managerEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'manager',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  managerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'manager',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  managerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'manager',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  managerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'manager', value: ''),
      );
    });
  }

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  managerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'manager', value: ''),
      );
    });
  }

  QueryBuilder<
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
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
    MembershipTopupEntity,
    MembershipTopupEntity,
    QAfterFilterCondition
  >
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }
}

extension MembershipTopupEntityQueryObject
    on
        QueryBuilder<
          MembershipTopupEntity,
          MembershipTopupEntity,
          QFilterCondition
        > {}

extension MembershipTopupEntityQueryLinks
    on
        QueryBuilder<
          MembershipTopupEntity,
          MembershipTopupEntity,
          QFilterCondition
        > {}

extension MembershipTopupEntityQuerySortBy
    on QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QSortBy> {
  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  sortByManager() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manager', Sort.asc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  sortByManagerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manager', Sort.desc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }
}

extension MembershipTopupEntityQuerySortThenBy
    on QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QSortThenBy> {
  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  thenByManager() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manager', Sort.asc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  thenByManagerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manager', Sort.desc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QAfterSortBy>
  thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }
}

extension MembershipTopupEntityQueryWhereDistinct
    on QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QDistinct> {
  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QDistinct>
  distinctByManager({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manager', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MembershipTopupEntity, MembershipTopupEntity, QDistinct>
  distinctByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }
}

extension MembershipTopupEntityQueryProperty
    on
        QueryBuilder<
          MembershipTopupEntity,
          MembershipTopupEntity,
          QQueryProperty
        > {
  QueryBuilder<MembershipTopupEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MembershipTopupEntity, int, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<MembershipTopupEntity, DateTime, QQueryOperations>
  dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<MembershipTopupEntity, String, QQueryOperations>
  managerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manager');
    });
  }

  QueryBuilder<MembershipTopupEntity, String, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_state_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMembershipStateEntityCollection on Isar {
  IsarCollection<MembershipStateEntity> get membershipStateEntitys =>
      this.collection();
}

const MembershipStateEntitySchema = CollectionSchema(
  name: r'MembershipStateEntity',
  id: -7786992913553038813,
  properties: {
    r'usedQuota': PropertySchema(
      id: 0,
      name: r'usedQuota',
      type: IsarType.long,
    ),
  },

  estimateSize: _membershipStateEntityEstimateSize,
  serialize: _membershipStateEntitySerialize,
  deserialize: _membershipStateEntityDeserialize,
  deserializeProp: _membershipStateEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _membershipStateEntityGetId,
  getLinks: _membershipStateEntityGetLinks,
  attach: _membershipStateEntityAttach,
  version: '3.3.0',
);

int _membershipStateEntityEstimateSize(
  MembershipStateEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _membershipStateEntitySerialize(
  MembershipStateEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.usedQuota);
}

MembershipStateEntity _membershipStateEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MembershipStateEntity();
  object.id = id;
  object.usedQuota = reader.readLong(offsets[0]);
  return object;
}

P _membershipStateEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _membershipStateEntityGetId(MembershipStateEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _membershipStateEntityGetLinks(
  MembershipStateEntity object,
) {
  return [];
}

void _membershipStateEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  MembershipStateEntity object,
) {
  object.id = id;
}

extension MembershipStateEntityQueryWhereSort
    on QueryBuilder<MembershipStateEntity, MembershipStateEntity, QWhere> {
  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MembershipStateEntityQueryWhere
    on
        QueryBuilder<
          MembershipStateEntity,
          MembershipStateEntity,
          QWhereClause
        > {
  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterWhereClause>
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

  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterWhereClause>
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

extension MembershipStateEntityQueryFilter
    on
        QueryBuilder<
          MembershipStateEntity,
          MembershipStateEntity,
          QFilterCondition
        > {
  QueryBuilder<
    MembershipStateEntity,
    MembershipStateEntity,
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
    MembershipStateEntity,
    MembershipStateEntity,
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
    MembershipStateEntity,
    MembershipStateEntity,
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
    MembershipStateEntity,
    MembershipStateEntity,
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
    MembershipStateEntity,
    MembershipStateEntity,
    QAfterFilterCondition
  >
  usedQuotaEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'usedQuota', value: value),
      );
    });
  }

  QueryBuilder<
    MembershipStateEntity,
    MembershipStateEntity,
    QAfterFilterCondition
  >
  usedQuotaGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'usedQuota',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MembershipStateEntity,
    MembershipStateEntity,
    QAfterFilterCondition
  >
  usedQuotaLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'usedQuota',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MembershipStateEntity,
    MembershipStateEntity,
    QAfterFilterCondition
  >
  usedQuotaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'usedQuota',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MembershipStateEntityQueryObject
    on
        QueryBuilder<
          MembershipStateEntity,
          MembershipStateEntity,
          QFilterCondition
        > {}

extension MembershipStateEntityQueryLinks
    on
        QueryBuilder<
          MembershipStateEntity,
          MembershipStateEntity,
          QFilterCondition
        > {}

extension MembershipStateEntityQuerySortBy
    on QueryBuilder<MembershipStateEntity, MembershipStateEntity, QSortBy> {
  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterSortBy>
  sortByUsedQuota() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedQuota', Sort.asc);
    });
  }

  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterSortBy>
  sortByUsedQuotaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedQuota', Sort.desc);
    });
  }
}

extension MembershipStateEntityQuerySortThenBy
    on QueryBuilder<MembershipStateEntity, MembershipStateEntity, QSortThenBy> {
  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterSortBy>
  thenByUsedQuota() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedQuota', Sort.asc);
    });
  }

  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QAfterSortBy>
  thenByUsedQuotaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedQuota', Sort.desc);
    });
  }
}

extension MembershipStateEntityQueryWhereDistinct
    on QueryBuilder<MembershipStateEntity, MembershipStateEntity, QDistinct> {
  QueryBuilder<MembershipStateEntity, MembershipStateEntity, QDistinct>
  distinctByUsedQuota() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'usedQuota');
    });
  }
}

extension MembershipStateEntityQueryProperty
    on
        QueryBuilder<
          MembershipStateEntity,
          MembershipStateEntity,
          QQueryProperty
        > {
  QueryBuilder<MembershipStateEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MembershipStateEntity, int, QQueryOperations>
  usedQuotaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'usedQuota');
    });
  }
}

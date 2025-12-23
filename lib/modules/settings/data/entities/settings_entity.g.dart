// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsEntityCollection on Isar {
  IsarCollection<SettingsEntity> get settingsEntitys => this.collection();
}

const SettingsEntitySchema = CollectionSchema(
  name: r'SettingsEntity',
  id: -7271317039764597112,
  properties: {
    r'autoBackup': PropertySchema(
      id: 0,
      name: r'autoBackup',
      type: IsarType.bool,
    ),
    r'autoPrint': PropertySchema(
      id: 1,
      name: r'autoPrint',
      type: IsarType.bool,
    ),
    r'businessAddress': PropertySchema(
      id: 2,
      name: r'businessAddress',
      type: IsarType.string,
    ),
    r'businessName': PropertySchema(
      id: 3,
      name: r'businessName',
      type: IsarType.string,
    ),
    r'businessPhone': PropertySchema(
      id: 4,
      name: r'businessPhone',
      type: IsarType.string,
    ),
    r'cashierPin': PropertySchema(
      id: 5,
      name: r'cashierPin',
      type: IsarType.bool,
    ),
    r'defaultPaymentMethod': PropertySchema(
      id: 6,
      name: r'defaultPaymentMethod',
      type: IsarType.string,
    ),
    r'notifications': PropertySchema(
      id: 7,
      name: r'notifications',
      type: IsarType.bool,
    ),
    r'paperSize': PropertySchema(
      id: 8,
      name: r'paperSize',
      type: IsarType.string,
    ),
    r'printerName': PropertySchema(
      id: 9,
      name: r'printerName',
      type: IsarType.string,
    ),
    r'receiptFooter': PropertySchema(
      id: 10,
      name: r'receiptFooter',
      type: IsarType.string,
    ),
    r'roundingPrice': PropertySchema(
      id: 11,
      name: r'roundingPrice',
      type: IsarType.bool,
    ),
    r'trackStock': PropertySchema(
      id: 12,
      name: r'trackStock',
      type: IsarType.bool,
    ),
  },

  estimateSize: _settingsEntityEstimateSize,
  serialize: _settingsEntitySerialize,
  deserialize: _settingsEntityDeserialize,
  deserializeProp: _settingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _settingsEntityGetId,
  getLinks: _settingsEntityGetLinks,
  attach: _settingsEntityAttach,
  version: '3.3.0',
);

int _settingsEntityEstimateSize(
  SettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.businessAddress.length * 3;
  bytesCount += 3 + object.businessName.length * 3;
  bytesCount += 3 + object.businessPhone.length * 3;
  bytesCount += 3 + object.defaultPaymentMethod.length * 3;
  bytesCount += 3 + object.paperSize.length * 3;
  bytesCount += 3 + object.printerName.length * 3;
  bytesCount += 3 + object.receiptFooter.length * 3;
  return bytesCount;
}

void _settingsEntitySerialize(
  SettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoBackup);
  writer.writeBool(offsets[1], object.autoPrint);
  writer.writeString(offsets[2], object.businessAddress);
  writer.writeString(offsets[3], object.businessName);
  writer.writeString(offsets[4], object.businessPhone);
  writer.writeBool(offsets[5], object.cashierPin);
  writer.writeString(offsets[6], object.defaultPaymentMethod);
  writer.writeBool(offsets[7], object.notifications);
  writer.writeString(offsets[8], object.paperSize);
  writer.writeString(offsets[9], object.printerName);
  writer.writeString(offsets[10], object.receiptFooter);
  writer.writeBool(offsets[11], object.roundingPrice);
  writer.writeBool(offsets[12], object.trackStock);
}

SettingsEntity _settingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettingsEntity();
  object.autoBackup = reader.readBool(offsets[0]);
  object.autoPrint = reader.readBool(offsets[1]);
  object.businessAddress = reader.readString(offsets[2]);
  object.businessName = reader.readString(offsets[3]);
  object.businessPhone = reader.readString(offsets[4]);
  object.cashierPin = reader.readBool(offsets[5]);
  object.defaultPaymentMethod = reader.readString(offsets[6]);
  object.id = id;
  object.notifications = reader.readBool(offsets[7]);
  object.paperSize = reader.readString(offsets[8]);
  object.printerName = reader.readString(offsets[9]);
  object.receiptFooter = reader.readString(offsets[10]);
  object.roundingPrice = reader.readBool(offsets[11]);
  object.trackStock = reader.readBool(offsets[12]);
  return object;
}

P _settingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settingsEntityGetId(SettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingsEntityGetLinks(SettingsEntity object) {
  return [];
}

void _settingsEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  SettingsEntity object,
) {
  object.id = id;
}

extension SettingsEntityQueryWhereSort
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhere> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsEntityQueryWhere
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhereClause> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idBetween(
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

extension SettingsEntityQueryFilter
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  autoBackupEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoBackup', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  autoPrintEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoPrint', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessAddressEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessAddressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessAddressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessAddressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'businessAddress',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessAddressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessAddressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'businessAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'businessAddress',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'businessAddress', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'businessAddress', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'businessName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'businessName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'businessName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'businessName', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'businessName', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessPhoneEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessPhoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessPhoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessPhoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'businessPhone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessPhoneStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessPhoneEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'businessPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'businessPhone',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'businessPhone', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  businessPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'businessPhone', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  cashierPinEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cashierPin', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  defaultPaymentMethodEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  defaultPaymentMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  defaultPaymentMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  defaultPaymentMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultPaymentMethod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  defaultPaymentMethodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  defaultPaymentMethodEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  defaultPaymentMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  defaultPaymentMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'defaultPaymentMethod',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  defaultPaymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'defaultPaymentMethod', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  defaultPaymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'defaultPaymentMethod',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  notificationsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notifications', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  paperSizeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paperSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  paperSizeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paperSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  paperSizeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paperSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  paperSizeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paperSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  paperSizeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paperSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  paperSizeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paperSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  paperSizeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paperSize',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  paperSizeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paperSize',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  paperSizeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paperSize', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  paperSizeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paperSize', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  printerNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  printerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  printerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  printerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'printerName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  printerNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  printerNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  printerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'printerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  printerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'printerName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  printerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'printerName', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  printerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'printerName', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  receiptFooterEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  receiptFooterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  receiptFooterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  receiptFooterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receiptFooter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  receiptFooterStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  receiptFooterEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  receiptFooterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'receiptFooter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  receiptFooterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'receiptFooter',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  receiptFooterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receiptFooter', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  receiptFooterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'receiptFooter', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  roundingPriceEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'roundingPrice', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  trackStockEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'trackStock', value: value),
      );
    });
  }
}

extension SettingsEntityQueryObject
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQueryLinks
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQuerySortBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByAutoBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackup', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByAutoBackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackup', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> sortByAutoPrint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrint', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByAutoPrintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrint', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByBusinessAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByBusinessAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByBusinessName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByBusinessNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByBusinessPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPhone', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByBusinessPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPhone', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByCashierPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierPin', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByCashierPinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierPin', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByDefaultPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPaymentMethod', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByDefaultPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPaymentMethod', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByNotifications() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifications', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByNotificationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifications', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> sortByPaperSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperSize', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByPaperSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperSize', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByPrinterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerName', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByPrinterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerName', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByReceiptFooter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptFooter', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByReceiptFooterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptFooter', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByRoundingPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundingPrice', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByRoundingPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundingPrice', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackStock', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByTrackStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackStock', Sort.desc);
    });
  }
}

extension SettingsEntityQuerySortThenBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortThenBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByAutoBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackup', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByAutoBackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackup', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByAutoPrint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrint', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByAutoPrintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrint', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByBusinessAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByBusinessAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByBusinessName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByBusinessNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByBusinessPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPhone', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByBusinessPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPhone', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByCashierPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierPin', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByCashierPinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierPin', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByDefaultPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPaymentMethod', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByDefaultPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPaymentMethod', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByNotifications() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifications', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByNotificationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifications', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByPaperSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperSize', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByPaperSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperSize', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByPrinterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerName', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByPrinterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerName', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByReceiptFooter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptFooter', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByReceiptFooterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptFooter', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByRoundingPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundingPrice', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByRoundingPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundingPrice', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackStock', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByTrackStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackStock', Sort.desc);
    });
  }
}

extension SettingsEntityQueryWhereDistinct
    on QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> {
  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByAutoBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoBackup');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByAutoPrint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoPrint');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByBusinessAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'businessAddress',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByBusinessName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByBusinessPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'businessPhone',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByCashierPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashierPin');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByDefaultPaymentMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'defaultPaymentMethod',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByNotifications() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notifications');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> distinctByPaperSize({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paperSize', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByPrinterName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'printerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByReceiptFooter({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'receiptFooter',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByRoundingPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roundingPrice');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackStock');
    });
  }
}

extension SettingsEntityQueryProperty
    on QueryBuilder<SettingsEntity, SettingsEntity, QQueryProperty> {
  QueryBuilder<SettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations> autoBackupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoBackup');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations> autoPrintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoPrint');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations>
  businessAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessAddress');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations>
  businessNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessName');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations>
  businessPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessPhone');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations> cashierPinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashierPin');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations>
  defaultPaymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultPaymentMethod');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations> notificationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notifications');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations> paperSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paperSize');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations> printerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'printerName');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations>
  receiptFooterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptFooter');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations> roundingPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roundingPrice');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations> trackStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackStock');
    });
  }
}

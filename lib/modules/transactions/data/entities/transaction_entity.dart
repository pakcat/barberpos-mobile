import 'package:isar_community/isar.dart';

part 'transaction_entity.g.dart';

@embedded
class TransactionLineEntity {
  late String name;
  late String category;
  late int price;
  late int qty;
}

@embedded
class TransactionCustomerEntity {
  late String name;
  late String phone;
  late String email;
  late String address;
  int visits = 0;
  String? lastVisit;
}

@collection
class TransactionEntity {
  Id id = Isar.autoIncrement;
  late String code;
  late DateTime date;
  late String time;
  late int amount;
  late String paymentMethod;
  String? shiftId;
  String operatorName = '';
  String? paymentIntentId;
  String? paymentReference;
  @enumerated
  late TransactionStatusEntity status;
  late List<TransactionLineEntity> items;
  TransactionCustomerEntity? customer;
  String stylist = '';
}

enum TransactionStatusEntity { paid, refund }


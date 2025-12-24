import '../../data/entities/transaction_entity.dart';
import 'transaction_models.dart';

TransactionLineEntity toLineEntity(TransactionLine line) {
  return TransactionLineEntity()
    ..name = line.name
    ..category = line.category
    ..price = line.price
    ..qty = line.qty;
}

TransactionCustomerEntity toCustomerEntity(TransactionCustomer customer) {
  return TransactionCustomerEntity()
    ..name = customer.name
    ..phone = customer.phone
    ..email = customer.email
    ..address = customer.address
    ..visits = customer.visits
    ..lastVisit = customer.lastVisit;
}

TransactionEntity toTransactionEntity(TransactionItem item) {
  final entity = TransactionEntity()
    ..code = item.id
    ..date = item.date
    ..time = item.time
    ..amount = item.amount
    ..paymentMethod = item.paymentMethod
    ..status = item.status == TransactionStatus.refund
        ? TransactionStatusEntity.refund
        : (item.status == TransactionStatus.pending ? TransactionStatusEntity.pending : TransactionStatusEntity.paid)
    ..refundedAt = item.refundedAt
    ..refundNote = item.refundNote ?? ''
    ..items = item.items.map(toLineEntity).toList()
    ..customer = toCustomerEntity(item.customer);
  return entity;
}

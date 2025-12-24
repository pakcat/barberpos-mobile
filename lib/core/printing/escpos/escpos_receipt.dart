import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

import '../../../modules/transactions/presentation/models/transaction_models.dart';

class EscPosReceipt {
  EscPosReceipt._();

  static Future<Uint8List> build(
    TransactionItem tx, {
    required String businessName,
    required String businessPhone,
    required String businessAddress,
    required String receiptFooter,
    required String paperSize,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(_paperSize(paperSize), profile);

    final bytes = <int>[];
    bytes.addAll(generator.reset());

    bytes.addAll(
      generator.text(
        businessName.isNotEmpty ? businessName : 'Barber POS',
        styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
      ),
    );
    if (businessAddress.trim().isNotEmpty) {
      bytes.addAll(generator.text(businessAddress.trim(), styles: const PosStyles(align: PosAlign.center)));
    }
    if (businessPhone.trim().isNotEmpty) {
      bytes.addAll(generator.text(businessPhone.trim(), styles: const PosStyles(align: PosAlign.center)));
    }
    bytes.addAll(generator.hr());

    bytes.addAll(generator.row([
      PosColumn(text: 'Kode', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(text: tx.id, width: 8, styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: 'Tanggal', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(text: _fmtDate(tx.date, tx.time), width: 8, styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: 'Metode', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(text: tx.paymentMethod, width: 8, styles: const PosStyles(align: PosAlign.right)),
    ]));
    if (tx.status == TransactionStatus.refund) {
      bytes.addAll(
        generator.text(
          'REFUND',
          styles: const PosStyles(align: PosAlign.center, bold: true),
          linesAfter: 1,
        ),
      );
    }
    bytes.addAll(generator.hr());

    for (final item in tx.items) {
      final qtyText = item.qty.toString();
      bytes.addAll(
        generator.row([
          PosColumn(text: item.name, width: 8),
          PosColumn(text: 'x$qtyText', width: 4, styles: const PosStyles(align: PosAlign.right)),
        ]),
      );
      bytes.addAll(
        generator.row([
          PosColumn(text: 'Rp${item.price}', width: 6),
          PosColumn(
            text: 'Rp${item.price * item.qty}',
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]),
      );
    }

    bytes.addAll(generator.hr());
    bytes.addAll(
      generator.row([
        PosColumn(text: 'TOTAL', width: 6, styles: const PosStyles(bold: true)),
        PosColumn(
          text: 'Rp${tx.amount}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]),
    );

    if (tx.customer.name.trim().isNotEmpty) {
      bytes.addAll(generator.feed(1));
      bytes.addAll(generator.text('Pelanggan: ${tx.customer.name.trim()}'));
    }
    if (tx.refundNote?.trim().isNotEmpty ?? false) {
      bytes.addAll(generator.feed(1));
      bytes.addAll(generator.text('Catatan refund: ${tx.refundNote!.trim()}'));
    }

    if (receiptFooter.trim().isNotEmpty) {
      bytes.addAll(generator.feed(1));
      bytes.addAll(generator.text(receiptFooter.trim(), styles: const PosStyles(align: PosAlign.center)));
    }

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return Uint8List.fromList(bytes);
  }

  static PaperSize _paperSize(String value) {
    switch (value) {
      case '58mm':
        return PaperSize.mm58;
      case '80mm':
        return PaperSize.mm80;
      default:
        return PaperSize.mm58;
    }
  }

  static String _two(int v) => v.toString().padLeft(2, '0');

  static String _fmtDate(DateTime date, String timeText) {
    final d = '${date.year}-${_two(date.month)}-${_two(date.day)}';
    final t = timeText.trim().isNotEmpty ? timeText.trim() : '${_two(date.hour)}:${_two(date.minute)}';
    return '$d $t';
  }
}

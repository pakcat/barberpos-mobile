import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart';

import '../utils/local_time.dart';
import '../../modules/transactions/presentation/models/transaction_models.dart';

class ReceiptPdf {
  static Future<Uint8List> build(TransactionItem tx) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Text(
                'BARBERPOS',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
              ),
              pw.SizedBox(height: 6),
              pw.Divider(),
              _row('Kode', tx.id),
              _row('Tanggal', '${_formatDate(tx.date)} ${tx.time}'),
              _row('Metode', tx.paymentMethod),
              _row('Status', tx.status.name),
              if (tx.status == TransactionStatus.refund && tx.refundedAt != null)
                _row('Refund', _formatDateTime(tx.refundedAt!)),
              if ((tx.refundNote ?? '').trim().isNotEmpty) _row('Catatan', tx.refundNote!.trim()),
              pw.Divider(),
              pw.Text(
                'ITEM',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              ...tx.items.map((line) {
                final subtotal = line.price * line.qty;
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Text('${line.name} x${line.qty}'),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('@ Rp${line.price}'),
                          pw.Text('Rp$subtotal'),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Rp${tx.amount}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 8),
              if (tx.customer.name.trim().isNotEmpty) _row('Pelanggan', tx.customer.name.trim()),
              pw.SizedBox(height: 8),
              pw.Text('Terima kasih', textAlign: pw.TextAlign.center),
            ],
          );
        },
      ),
    );

    final bytes = await doc.save();
    return Uint8List.fromList(bytes);
  }

  static pw.Widget _row(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 60, child: pw.Text(label)),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) {
    d = asLocalTime(d);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static String _formatDateTime(DateTime d) {
    d = asLocalTime(d);
    return '${_formatDate(d)} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}

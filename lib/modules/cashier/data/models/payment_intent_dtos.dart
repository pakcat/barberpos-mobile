class PaymentIntentDto {
  PaymentIntentDto({
    required this.id,
    required this.method,
    this.qrString,
    this.status = 'pending',
    this.expiresAt,
    this.reference,
    this.intentId,
  });

  final String id;
  final String method;
  final String? qrString;
  final String status;
  final DateTime? expiresAt;
  final String? reference;
  final String? intentId;

  factory PaymentIntentDto.fromJson(Map<String, dynamic> json) {
    return PaymentIntentDto(
      id: json['id']?.toString() ?? '',
      method: json['method']?.toString() ?? '',
      qrString: json['qrString']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      expiresAt: json['expiresAt'] != null ? DateTime.tryParse(json['expiresAt'].toString()) : null,
      reference: json['reference']?.toString(),
      intentId: json['intentId']?.toString(),
    );
  }
}

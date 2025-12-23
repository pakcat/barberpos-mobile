class DashboardSummaryDto {
  DashboardSummaryDto({
    this.transaksiHariIni = 0,
    this.omzetHariIni = 0,
    this.customerHariIni = 0,
    this.layananTerjual = 0,
  });

  final int transaksiHariIni;
  final int omzetHariIni;
  final int customerHariIni;
  final int layananTerjual;

  factory DashboardSummaryDto.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryDto(
      transaksiHariIni: int.tryParse(json['transaksiHariIni']?.toString() ?? '') ??
          int.tryParse(json['transactionToday']?.toString() ?? '') ??
          0,
      omzetHariIni: int.tryParse(json['omzetHariIni']?.toString() ?? '') ??
          int.tryParse(json['revenueToday']?.toString() ?? '') ??
          0,
      customerHariIni: int.tryParse(json['customerHariIni']?.toString() ?? '') ??
          int.tryParse(json['customersToday']?.toString() ?? '') ??
          0,
      layananTerjual: int.tryParse(json['layananTerjual']?.toString() ?? '') ??
          int.tryParse(json['servicesSold']?.toString() ?? '') ??
          0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transaksiHariIni': transaksiHariIni,
      'omzetHariIni': omzetHariIni,
      'customerHariIni': customerHariIni,
      'layananTerjual': layananTerjual,
    };
  }
}

class DashboardItemDto {
  DashboardItemDto({
    required this.name,
    this.qty = 0,
    this.amount = 0,
    this.role,
  });

  final String name;
  final int qty;
  final int amount;
  final String? role;

  factory DashboardItemDto.fromJson(Map<String, dynamic> json) {
    return DashboardItemDto(
      name: json['name']?.toString() ?? '',
      qty: int.tryParse(json['qty']?.toString() ?? '') ?? 0,
      amount: int.tryParse(json['amount']?.toString() ?? '') ?? 0,
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'qty': qty,
        'amount': amount,
        if (role != null) 'role': role,
      };
}

class SalesPointDto {
  SalesPointDto({required this.label, required this.value});

  final String label;
  final int value;

  factory SalesPointDto.fromJson(Map<String, dynamic> json) {
    return SalesPointDto(
      label: json['label']?.toString() ?? '',
      value: int.tryParse(json['value']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {'label': label, 'value': value};
}

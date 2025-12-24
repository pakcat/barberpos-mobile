enum CashierViewMode { grid, list }

class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
  });

  final String id;
  final String name;
  final String category;
  final String price;
  final String image;
}

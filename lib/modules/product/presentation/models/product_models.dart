enum ProductViewMode { grid, list }

class ProductItem {
  ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    this.trackStock = false,
    this.stock = 0,
    this.minStock = 0,
  });

  final String id;
  String name;
  String category;
  int price;
  String image;
  bool trackStock;
  int stock;
  int minStock;
}

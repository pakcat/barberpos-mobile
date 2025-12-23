class CategoryItem {
  CategoryItem({required this.id, required this.name});

  final String id;
  String name;
}

class CustomerItem {
  CustomerItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  final String id;
  String name;
  String phone;
  String email;
  String address;
}

class RegionDto {
  RegionDto({required this.name});

  final String name;

  factory RegionDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final value = json['name'] ?? json['title'] ?? json['label'];
      return RegionDto(name: value?.toString() ?? '');
    }
    return RegionDto(name: json?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {'name': name};
}

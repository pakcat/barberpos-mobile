import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import '../config/app_config.dart';
import '../database/entities/region_entity.dart';
import '../models/region_dto.dart';
import '../network/network_service.dart';

class RegionService extends GetxService {
  RegionService({
    NetworkService? client,
    required Isar isar,
    AppConfig? config,
  })  : _client = client != null
            ? client.dio
            : (Get.isRegistered<NetworkService>() ? Get.find<NetworkService>().dio : null),
        _isar = isar,
        _backend =
            config?.backend ??
            (Get.isRegistered<AppConfig>() ? Get.find<AppConfig>().backend : BackendMode.rest);

  final Dio? _client;
  final Isar _isar;
  final BackendMode _backend;
  final RxList<String> regions = <String>[].obs;

  Future<RegionService> init() async {
    await _loadFromDb();
    await load();
    return this;
  }

  Future<void> _loadFromDb() async {
    final stored = await _isar.regionEntitys.where().findAll();
    if (stored.isNotEmpty) {
      regions.assignAll(stored.map((e) => e.name));
    }
  }

  Future<void> load() async {
    if (_backend == BackendMode.rest && _client != null) {
      try {
        final client = _client;
        final response = await client.get<List<dynamic>>('/regions');
        final data = response.data ?? <dynamic>[];
        final parsed = data.map(RegionDto.fromJson).where((e) => e.name.isNotEmpty).toList();
        if (parsed.isNotEmpty) {
          regions.assignAll(parsed.map((e) => e.name));
          await _persist(parsed);
          return;
        }
      } catch (_) {
        // ignore and fallback
      }
    }
    if (regions.isEmpty) {
      final fallbackDtos = _fallbackRegions.map((e) => RegionDto(name: e)).toList();
      regions.assignAll(fallbackDtos.map((e) => e.name));
      await _persist(fallbackDtos);
    }
  }

  Future<void> _persist(List<RegionDto> regionsDto) async {
    await _isar.writeTxn(() async {
      await _isar.regionEntitys.clear();
      final entities = regionsDto.map((dto) => RegionEntity()..name = dto.name).toList();
      await _isar.regionEntitys.putAll(entities);
    });
  }

  List<String> get _fallbackRegions => const [
        'Jakarta',
        'Bandung',
        'Surabaya',
        'Semarang',
        'Yogyakarta',
        'Medan',
        'Denpasar',
        'Makassar',
      ];
}

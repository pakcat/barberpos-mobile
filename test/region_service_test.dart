import 'dart:ffi';
import 'dart:io';

import 'package:barberpos_mobile/core/config/app_config.dart';
import 'package:barberpos_mobile/core/database/entities/region_entity.dart';
import 'package:barberpos_mobile/core/services/region_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'fakes/fake_network_service.dart';

class _FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getApplicationSupportPath() async {
    final dir = await Directory.systemTemp.createTemp();
    return dir.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Isar isar;
  late RegionService service;
  late Dio mockDio;

  setUpAll(() async {
    if (Platform.isWindows) {
      final isarLibPath = [
        Platform.environment['LOCALAPPDATA'],
        'Pub',
        'Cache',
        'hosted',
        'pub.dev',
        'isar_flutter_libs-${Isar.version}',
        'windows',
        'isar.dll'
      ].whereType<String>().join(Platform.pathSeparator);
      await Isar.initializeIsarCore(
        libraries: {
          Abi.windowsX64: isarLibPath,
          Abi.windowsArm64: isarLibPath,
        },
      );
    }
  });

  setUp(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    final dir = await Directory.systemTemp.createTemp();
    isar = await Isar.open([RegionEntitySchema], directory: dir.path);
    mockDio = _MockDio();
    service = RegionService(
      client: _NetworkWithMockDio(mockDio),
      isar: isar,
      config: const AppConfig(backend: BackendMode.rest, baseUrl: 'http://localhost'),
    );
  });

  tearDown(() async {
    await isar.close();
  });

  test('loads fallback when API fails', () async {
    when(() => mockDio.get<List<dynamic>>('/regions')).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/regions')),
    );

    await service.load();
    expect(service.regions.isNotEmpty, isTrue);
    final stored = await isar.regionEntitys.where().findAll();
    expect(stored.length, service.regions.length);
  });

  test('persists regions from API response', () async {
    when(() => mockDio.get<List<dynamic>>('/regions')).thenAnswer(
      (_) async => Response<List<dynamic>>(
        data: const [
          {'name': 'Jakarta'},
          {'name': 'Bandung'},
          {'title': 'Custom Label'}, // ensures parser handles alternate keys
        ],
        statusCode: 200,
        requestOptions: RequestOptions(path: '/regions'),
      ),
    );

    await service.load();

    expect(service.regions, ['Jakarta', 'Bandung', 'Custom Label']);
    final stored = await isar.regionEntitys.where().findAll();
    expect(stored.map((e) => e.name), ['Jakarta', 'Bandung', 'Custom Label']);
  });

  test('uses cached regions when network unavailable during init', () async {
    // Seed local database
    await isar.writeTxn(() async {
      await isar.regionEntitys.putAll([RegionEntity()..name = 'Stored Region']);
    });
    when(() => mockDio.get<List<dynamic>>('/regions')).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/regions')),
    );

    await service.init();

    expect(service.regions, ['Stored Region']);
  });
}

class _MockDio extends Mock implements Dio {}

class _NetworkWithMockDio extends FakeNetworkService {
  _NetworkWithMockDio(this._dio);

  final Dio _dio;

  @override
  Dio get dio => _dio;
}

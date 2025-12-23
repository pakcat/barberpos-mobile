import '../../../../core/network/network_service.dart';
import '../models/attendance_dto.dart';

class AttendanceRemoteDataSource {
  AttendanceRemoteDataSource(this._network);

  final NetworkService _network;

  Future<void> checkIn(String name, {int? employeeId}) async {
    await _network.dio.post('/attendance/checkin', data: {
      'employeeId': employeeId,
      'employeeName': name,
    });
  }

  Future<void> checkOut(String name, {int? employeeId}) async {
    await _network.dio.post('/attendance/checkout', data: {
      'employeeId': employeeId,
      'employeeName': name,
    });
  }

  Future<List<AttendanceDto>> getMonth(String name, DateTime month) async {
    final res = await _network.dio.get<List<dynamic>>(
      '/attendance',
      queryParameters: {
        'employeeName': name,
        'month': '${month.year}-${month.month.toString().padLeft(2, '0')}',
      },
    );
    final data = res.data ?? <dynamic>[];
    return data.whereType<Map>().map((e) => AttendanceDto.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}

import '../../domain/entities/welcome_message.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<WelcomeMessage> getWelcomeMessage() async {
    return _remoteDataSource.fetchWelcomeMessage();
  }
}

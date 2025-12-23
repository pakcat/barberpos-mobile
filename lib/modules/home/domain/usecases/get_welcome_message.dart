import '../entities/welcome_message.dart';
import '../repositories/home_repository.dart';

class GetWelcomeMessageUseCase {
  GetWelcomeMessageUseCase(this._repository);

  final HomeRepository _repository;

  Future<WelcomeMessage> call() => _repository.getWelcomeMessage();
}

import '../entities/welcome_message.dart';

abstract class HomeRepository {
  Future<WelcomeMessage> getWelcomeMessage();
}

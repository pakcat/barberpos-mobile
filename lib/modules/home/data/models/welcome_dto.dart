import '../../domain/entities/welcome_message.dart';

class WelcomeDto extends WelcomeMessage {
  const WelcomeDto({
    required super.title,
    required super.subtitle,
  });

  factory WelcomeDto.fromJson(Map<String, dynamic> json) {
    return WelcomeDto(
      title: json['title']?.toString() ?? 'Hello',
      subtitle: json['body']?.toString() ?? 'Welcome to Barber POS',
    );
  }
}

import 'package:get/get.dart';

import '../../../../core/network/network_exception.dart';
import '../../../../core/utils/app_state.dart';
import '../../domain/entities/welcome_message.dart';
import '../../domain/usecases/get_welcome_message.dart';

class HomeController extends GetxController {
  HomeController({required GetWelcomeMessageUseCase getWelcomeMessage})
      : _getWelcomeMessage = getWelcomeMessage;

  final GetWelcomeMessageUseCase _getWelcomeMessage;

  final Rx<WelcomeMessage?> message = Rx<WelcomeMessage?>(null);
  final Rx<ViewState> state = ViewState.idle.obs;
  final RxString error = ''.obs;
  final RxMap<String, dynamic> summary = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadWelcome();
  }

  Future<void> loadWelcome() async {
    state.value = ViewState.loading;
    error.value = '';
    try {
      message.value = await _getWelcomeMessage();
      state.value = ViewState.success;
    } catch (e) {
      if (e is NetworkException) {
        error.value = e.message;
      } else {
        error.value = 'Something went wrong.';
      }
      state.value = ViewState.error;
    }
  }
}

import 'package:get/get.dart';

handleLoaddingState({
  required Future Function() tryLogic,
  required Rx<bool> isLoading,
}) async {
  try {
    isLoading.value = true;
    await tryLogic();
  } catch (e) {
    rethrow;
  } finally {
    isLoading.value = false;
  }
}

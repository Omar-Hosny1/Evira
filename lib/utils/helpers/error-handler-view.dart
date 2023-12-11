import 'package:evira/utils/helpers/error-handler.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
 
Future<void> errorHandlerInView({
  required Future Function() tryLogic,
  void Function()? finallyLogic,
}) async {
  try {
    await tryLogic();
  } catch (e) {
    showSnackbar(
      SnackbarState.danger,
      'Something Went Wrong',
      formatErrorMessage(
        e.toString(),
      ),
    );
  } finally {
    if (finallyLogic != null) {
      finallyLogic();
    }
  }
}

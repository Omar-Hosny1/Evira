import 'package:evira/utils/helpers/snack-bar.dart';

errorHandlerInView({
  required Future Function() tryLogic,
  void Function()? finallyLogic,
}) async {
  try {
    await tryLogic();
  } catch (e) {
    showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
  } finally {
    if (finallyLogic != null) {
      finallyLogic();
    }
  }
}

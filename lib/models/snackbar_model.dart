import 'package:get/get.dart';
import 'package:manga_nih/ui/widgets/snackbar.dart';

class SnackbarModel {
  static void noConnection() {
    showSnackbar(
      Get.context!,
      'Oops... check your internet connection',
      isError: true,
    );
  }

  static void globalError() {
    showSnackbar(
      Get.context!,
      'Oops... something wrong',
      isError: true,
    );
  }

  static void custom(bool isError, String message) {
    showSnackbar(Get.context!, message, isError: isError);
  }
}

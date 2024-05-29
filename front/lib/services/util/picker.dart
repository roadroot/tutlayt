import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

abstract class Picker {
  // pick image from gallery using image_picker package
  static Future<XFile?> pickImage() async {
    final ImagePicker picker = Get.find<ImagePicker>();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }
}

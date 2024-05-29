import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final Rx<XFile?> image = Rx<XFile?>(null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Pick an image'),
        ElevatedButton(
          onPressed: () async {
            image.value = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
          },
          child: const Text('Pick'),
        ),
        Obx(
          () => image.value == null
              ? const Text('No image selected')
              : Image.network(
                  image.value!.path,
                  width: 100,
                  height: 100,
                ),
        ),
      ],
    );
  }
}

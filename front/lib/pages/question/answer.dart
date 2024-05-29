import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tutlayt/widget/card.dart';
import 'package:tutlayt/widget/imported_image.dart';

class AnswerField extends StatefulWidget {
  final answerController = TextEditingController();
  final List<XFile> images = <XFile>[];

  final void Function(String value, List<MultipartFile> files)? onSubmitted;

  AnswerField({super.key, this.onSubmitted});

  @override
  State<AnswerField> createState() => _AnswerFieldState();
}

class _AnswerFieldState extends State<AnswerField> {
  _AnswerFieldState();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.answerController,
            maxLines: null,
            onChanged: (value) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Answer',
            ),
          ),
          MarkdownWidget(
            data: widget.answerController.text,
            shrinkWrap: true,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  final file = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (file != null) {
                    setState(() {
                      widget.images.add(file);
                    });
                  }
                },
                icon: const Icon(Icons.image),
              ),
              IconButton(
                onPressed: () async {
                  final file = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (file != null) {
                    setState(() {
                      widget.images.add(file);
                    });
                  }
                },
                icon: const Icon(Icons.camera_alt),
              ),
            ],
          ),
          for (final image in widget.images)
            ImpportedImage(
              image: image,
              onDeleted: (_) {
                setState(() {
                  widget.images.remove(image);
                });
              },
            ),
          TextButton(
            onPressed: () async {
              final files = <MultipartFile>[];
              for (final image in widget.images) {
                final bytes = await image.readAsBytes();
                files.add(MultipartFile.fromBytes(
                  'file',
                  bytes,
                  filename: image.name,
                ));
              }

              widget.onSubmitted?.call(widget.answerController.text, files);
            },
            child: const Text('Answer'),
          ),
        ],
      ),
    );
  }
}

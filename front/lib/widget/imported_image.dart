import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutlayt/services/util/util.dart';

class ImpportedImage extends StatefulWidget {
  final XFile image;
  final void Function(XFile image)? onDeleted;
  final void Function(XFile image)? onUploaded;
  final void Function(double progress)? setProgress;

  const ImpportedImage({
    super.key,
    required this.image,
    this.onDeleted,
    this.onUploaded,
    this.setProgress,
  });

  @override
  State<ImpportedImage> createState() => _ImpportedImageState();
}

class _ImpportedImageState extends State<ImpportedImage> {
  double progress = 1;

  @override
  void initState() {
    super.initState();
    if (widget.setProgress != null) {
      widget.setProgress!(progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Image.network(
              widget.image.path,
              width: 24,
              height: 24,
            ),
          ),
          Text(widget.image.name),
          const Spacer(),
          FutureBuilder(
            future: widget.image.length(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(fileSize(snapshot.data!));
              } else {
                return const SizedBox();
              }
            },
          ),
          if (widget.onDeleted != null)
            IconButton(
              onPressed: () {
                widget.onDeleted!(widget.image);
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
    );
  }
}

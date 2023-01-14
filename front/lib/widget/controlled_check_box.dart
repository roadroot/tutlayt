import 'package:flutter/material.dart';

class ControlledCheckBox extends StatefulWidget {
  const ControlledCheckBox({Key? key, required this.controller})
      : super(key: key);
  final BoolController controller;

  @override
  createState() => _ControlledCheckBoxState();
}

class _ControlledCheckBoxState extends State<ControlledCheckBox> {
  @override
  Widget build(BuildContext context) {
    widget.controller.addListener(() => setState(() => {}));
    return Checkbox(
      value: widget.controller.value,
      onChanged: (value) =>
          setState(() => widget.controller.value = value ?? false),
    );
  }
}

class BoolController extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  set value(bool value) {
    _value = value;
    notifyListeners();
  }
}

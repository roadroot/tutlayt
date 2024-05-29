import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required TextEditingController controller,
    required this.title,
    this.hintText,
    this.validator,
  })  : _password = controller;

  final TextEditingController _password;
  final String title;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget._password,
      validator: widget.validator,
      obscureText: _obscured,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(widget.title),
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: Container(
          margin: const EdgeInsets.only(right: 10),
          child: IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscured = !_obscured),
          ),
        ),
      ),
    );
  }
}

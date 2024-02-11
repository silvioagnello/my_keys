import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;

  const InputField(
      {super.key,
      required this.icon,
      required this.hint,
      required this.obscure,
      required this.stream,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: StreamBuilder<String>(
          stream: stream,
          builder: (context, snapshot) {
            return TextField(
              onChanged: onChanged,
              obscureText: obscure,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                errorText: snapshot.hasError ? snapshot.error as String : null,
                icon: Icon(icon),
                hintText: hint,
                focusedBorder:
                    const UnderlineInputBorder(borderSide: BorderSide()),
              ),
            );
          }),
    );
  }
}

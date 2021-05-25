import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final String? errorText;

  const InputField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.errorText,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPassword;

    super.initState();
  }

  void _obscureAction() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return 'fill this field';
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.only(top: 15.0),
        errorText: widget.errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        prefixIcon: Icon(
          widget.icon,
          color: Colors.grey.shade500,
        ),
        suffixIcon: widget.isPassword
            ? MaterialButton(
                onPressed: _obscureAction,
                padding: const EdgeInsets.all(10.0),
                minWidth: 0.0,
                shape: CircleBorder(),
                child: Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey.shade500,
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}

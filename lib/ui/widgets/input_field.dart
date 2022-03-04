import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String hintText;
  final String? tag;
  final String? errorText;
  final IconData? icon;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final bool isPassword;
  final int maxLines;

  const InputField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.tag,
    this.errorText,
    this.icon,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.isPassword = false,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.tag != null) ...[
          Text(widget.tag!),
          const SizedBox(height: 10.0),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          validator: (value) {
            if (value!.isEmpty) {
              return 'fill this field';
            }

            return null;
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: EdgeInsets.only(
              top: 15.0,
              left: (widget.icon != null ? 0.0 : 13.0),
            ),
            errorText: widget.errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade500),
            ),
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: Colors.grey.shade500)
                : null,
            suffixIcon: widget.isPassword
                ? MaterialButton(
                    onPressed: _obscureAction,
                    padding: const EdgeInsets.all(10.0),
                    minWidth: 0.0,
                    shape: const CircleBorder(),
                    child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade500,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

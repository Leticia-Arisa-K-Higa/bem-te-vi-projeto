import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Color? textColor;
  final Color? labelColor;
  final Color? cursorColor;
  final Color? borderColor;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.maxLines = 1,
    this.textColor,
    this.labelColor,
    this.cursorColor,
    this.borderColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController =
        widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor =
        widget.textColor ?? Theme.of(context).textTheme.bodyLarge?.color;
    final effectiveLabelColor = widget.labelColor ?? Colors.grey[600];
    final effectiveBorderColor = widget.borderColor ?? Colors.grey;

    return TextField(
      controller: _internalController,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,

      style: TextStyle(color: effectiveTextColor),
      cursorColor: widget.cursorColor,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: effectiveLabelColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}

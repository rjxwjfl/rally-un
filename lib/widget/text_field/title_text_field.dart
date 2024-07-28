import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class TitleTextField extends StatefulWidget {
  const TitleTextField(
      {required this.controller,
        required this.focusNode,
        this.icon,
        required this.hintText,
        this.minLines,
        this.maxLines,
        this.style,
        this.padding,
        super.key});

  final TextEditingController controller;
  final FocusNode focusNode;
  final IconData? icon;
  final String hintText;
  final int? minLines;
  final int? maxLines;
  final TextStyle? style;
  final EdgeInsets? padding;

  @override
  State<TitleTextField> createState() => _TitleTextFieldState();
}

class _TitleTextFieldState extends State<TitleTextField> {
  String? validator(String? text) {
    if (text == null || text.isEmpty) {
      return '내용을 입력해주세요.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24.0,
            height: 48.0,
            child: widget.icon != null ? Icon(widget.icon, size: 18.0) : null,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: TextFormField(
              autofocus: false,
              controller: widget.controller,
              focusNode: widget.focusNode,
              minLines: widget.minLines ?? 1,
              maxLines: widget.maxLines,
              validator: validator,
              style: widget.style ?? StyleConfigs.bodyNormal,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                hintText: widget.hintText,
                hintStyle: StyleConfigs.bodyNormal.copyWith(color: scheme.outline),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
        ],
      ),
    );
  }
}

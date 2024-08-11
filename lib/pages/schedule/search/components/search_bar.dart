import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class SearchBarUI extends StatefulWidget {
  const SearchBarUI(
      {required this.controller,
      required this.focusNode,
      required this.hintText,
      this.onChanged,
      this.onSubmit,
      this.onRemove,
      this.height = 40.0,
      this.backgroundColor,
      this.padding,
      super.key});

  final FocusNode focusNode;
  final TextEditingController controller;
  final String hintText;
  final double height;
  final void Function(String)? onSubmit;
  final void Function(String)? onChanged;
  final void Function()? onRemove;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  @override
  State<SearchBarUI> createState() => _SearchBarUIState();
}

class _SearchBarUIState extends State<SearchBarUI> {
  void _updateSuffixIcon() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateSuffixIcon);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateSuffixIcon);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: SizedBox(
        height: widget.height,
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmit,
          style: StyleConfigs.bodyNormal,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: widget.backgroundColor ?? Colors.transparent,
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            prefixIcon: const Icon(Icons.search_rounded, size: 18),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
            suffixIcon: widget.controller.value.text.isNotEmpty
                ? IconButton(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: widget.onRemove,
                    icon: const Icon(CupertinoIcons.xmark, size: 14),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

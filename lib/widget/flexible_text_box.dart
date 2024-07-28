import 'package:flutter/material.dart';
import 'package:rally/configs/style_config.dart';

class FlexibleTextBox extends StatefulWidget {
  const FlexibleTextBox({required this.text, this.icon, this.style, this.padding, super.key});

  final String text;
  final IconData? icon;
  final TextStyle? style;
  final EdgeInsets? padding;

  @override
  State<FlexibleTextBox> createState() => _FlexibleTextBoxState();
}

class _FlexibleTextBoxState extends State<FlexibleTextBox> {
  bool _isExpanded = false;
  late bool _textExceedsLimit;

  bool _doesTextExceedLimit(String text) {
    final span = TextSpan(text: text, style: StyleConfigs.bodyNormal);
    final tp = TextPainter(text: span, maxLines: 3, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: MediaQuery.of(context).size.width);
    return tp.didExceedMaxLines;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textExceedsLimit = _doesTextExceedLimit(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: InkWell(
        onTap: _textExceedsLimit ? () => setState(() => _isExpanded = !_isExpanded) : null,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.text,
                    maxLines: _isExpanded ? 10 : 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: widget.style ?? StyleConfigs.bodyNormal,
                  ),
                  if (_textExceedsLimit)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_isExpanded ? '접기' : '펼치기', style: StyleConfigs.captionNormal.copyWith(color: scheme.outline)),
                            const SizedBox(width: 4.0),
                            Icon(_isExpanded ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined, size: 14.0, color: scheme.outline,)
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

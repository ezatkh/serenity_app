import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/local/LocalizationService.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final bool expanded;
  final VoidCallback onToggle;
  final TextStyle textStyle;
  final TextStyle seeMoreStyle;
  final int maxLines;

  const ExpandableText({
    Key? key,
    required this.text,
    required this.expanded,
    required this.onToggle,
    required this.textStyle,
    required this.seeMoreStyle,
    this.maxLines = 8,
  }) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isOverflowing = false;

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationService>(context, listen: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: widget.textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        _isOverflowing = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: widget.textStyle,
              maxLines: widget.expanded ? null : widget.maxLines,
              overflow: widget.expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (_isOverflowing)
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: widget.onToggle,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      widget.expanded
                          ? localization.getLocalizedString('seeLess') ?? 'See less'
                          : localization.getLocalizedString('seeMore') ?? 'See more',
                      style: widget.seeMoreStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}

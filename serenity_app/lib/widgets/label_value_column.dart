import 'package:flutter/material.dart';

class LabelValueColumn extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final double width;

  const LabelValueColumn({
    Key? key,
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
    this.width = 140, // default width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 4),
        SizedBox(
          width: width,
          child: Text(
            value,
            style: valueStyle,
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}

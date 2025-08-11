import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

class ClickableLabelValue extends StatelessWidget {
  final String value;
  final VoidCallback? onValueTap;

  const ClickableLabelValue({
    Key? key,
    required this.value,
    this.onValueTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      value,
      style: const TextStyle(
        color: AppColors.primaryBoldColor,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );

    return onValueTap != null
        ? InkWell(
      onTap: onValueTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: textWidget,
      ),
    )
        : textWidget;
  }
}

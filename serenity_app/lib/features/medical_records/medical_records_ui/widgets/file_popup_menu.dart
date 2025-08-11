import 'package:flutter/material.dart';
import '../../../../core/enums/enums.dart';

class CustomPopupMenu extends StatelessWidget {
  final void Function(FileMenuOption) onSelected;

  const CustomPopupMenu({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FileMenuOption>(
      icon: const Icon(Icons.more_vert, color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      offset: const Offset(0, 30),
      onSelected: onSelected,
      itemBuilder: (context) {
        return FileMenuOption.values.map((option) {
          return PopupMenuItem<FileMenuOption>(
            value: option,
            child: Text(
              option.label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          );
        }).toList();
      },
    );
  }
}
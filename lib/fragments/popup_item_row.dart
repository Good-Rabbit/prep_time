import 'package:flutter/material.dart';

class PopupItemRow extends StatelessWidget {
  const PopupItemRow({
    super.key,
    required this.icon,
    required this.label,
  });

  final Icon icon;
  final Text label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 5,
        ),
        label,
      ],
    );
  }
}
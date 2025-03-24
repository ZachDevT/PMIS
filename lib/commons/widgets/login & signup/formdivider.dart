import 'package:pmis/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Tdivider extends StatelessWidget {
  const Tdivider({
    super.key,
    required this.dark,
    required this.label,
  });

  final bool dark;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Divider(
            color: dark ? Tcolors.darkGrey : Tcolors.grey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Flexible(
          child: Divider(
            color: dark ? Tcolors.darkGrey : Tcolors.grey,
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        ),
      ],
    );
  }
}

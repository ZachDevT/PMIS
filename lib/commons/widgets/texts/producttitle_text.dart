import 'package:flutter/material.dart';

class TProductTitletext extends StatelessWidget {
  const TProductTitletext({
    super.key,
    required this.title,
    this.smallsize = false,
    this.maxlines = 2,
    this.align,
  });

  final String title;
  final bool smallsize;
  final int maxlines;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: smallsize
          ? Theme.of(context).textTheme.labelLarge
          : Theme.of(context).textTheme.titleSmall,
      maxLines: maxlines,
      textAlign: align,
      overflow: TextOverflow.ellipsis,
    );
  }
}

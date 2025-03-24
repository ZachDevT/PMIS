import 'package:pmis/utils/constants/enums.dart';
import 'package:flutter/material.dart';

class TbrandTitleText extends StatelessWidget {
  const TbrandTitleText({
    super.key,
    required this.title,
    this.maxlines = 1,
    this.align = TextAlign.center,
    this.textcolor,
    this.brandtextsize = Textsizes.small,
  });

  final String title;

  final int maxlines;
  final Color? textcolor;
  final TextAlign? align;
  final Textsizes? brandtextsize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: brandtextsize == Textsizes.small
          ? Theme.of(context).textTheme.labelMedium!.apply(color: textcolor)
          : brandtextsize == Textsizes.medium
              ? Theme.of(context).textTheme.bodyLarge!.apply(color: textcolor)
              : brandtextsize == Textsizes.large
                  ? Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .apply(color: textcolor)
                  : Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: textcolor),
      maxLines: maxlines,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
    );
  }
}

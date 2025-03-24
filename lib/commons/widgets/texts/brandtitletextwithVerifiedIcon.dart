import 'package:pmis/commons/widgets/texts/brandtitletext.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/enums.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TbrandTitleTextwithverifiedIcon extends StatelessWidget {
  const TbrandTitleTextwithverifiedIcon({
    super.key,
    required this.title,
    this.maxlines = 1,
    this.align = TextAlign.center,
    this.textcolor,
    this.iconcolor = Tcolors.primary,
    this.brandtextsize = Textsizes.small,
  });

  final String title;

  final int maxlines;
  final Color? textcolor, iconcolor;
  final TextAlign? align;
  final Textsizes? brandtextsize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: TbrandTitleText(
            title: title,
            textcolor: textcolor,
            maxlines: maxlines,
            align: align,
            brandtextsize: brandtextsize,
          ),
        ),
        const SizedBox(
          width: Tsizes.xs,
        ),
        Icon(
          Iconsax.verify5,
          color: iconcolor,
          size: Tsizes.icons,
        ),
      ],
    );
  }
}

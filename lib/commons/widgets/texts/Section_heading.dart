import 'package:pmis/commons/widgets/icons/circular_icon.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TsectionHeading extends StatelessWidget {
  const TsectionHeading({
    super.key,
    this.buttontext = "Voir tout",
    required this.headingtitle,
    this.onPressed,
    this.showactionbtn = false,
    this.titlecolor,
  });

  final String buttontext;
  final String headingtitle;
  final VoidCallback? onPressed;
  final bool showactionbtn;
  final Color? titlecolor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headingtitle,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: titlecolor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showactionbtn)
          Row(
            children: [
              TextButton(
                onPressed: onPressed,
                child: Text(buttontext,
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              const TcircularIcon(
                icon: Iconsax.arrow_right_34,
                size: Tsizes.md / 1.5,
                width: 15,
                height: 15,
              )
            ],
          ),
      ],
    );
  }
}

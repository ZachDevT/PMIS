import 'package:pmis/commons/widgets/customs_shapes/containers/roundedcontainer.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:flutter/material.dart';

class TsettingMenutile extends StatelessWidget {
  const TsettingMenutile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.ontap,
    this.trailing,
    this.showsubtitle = true,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? ontap;
  final Widget? trailing;
  final bool showsubtitle;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      backgroundColor: dark ? Tcolors.dark : Tcolors.primary.withOpacity(0.08),
      radius: 5,
      margin: const EdgeInsets.only(bottom: Tsizes.sm / 1.5),
      child: ListTile(
        leading: Icon(
          icon,
          size: 28,
          color: Tcolors.primary,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: showsubtitle
            ? Text(
                subtitle!,
                style: Theme.of(context).textTheme.labelLarge,
              )
            : null,
        onTap: ontap,
        trailing: trailing,
      ),
    );
  }
}

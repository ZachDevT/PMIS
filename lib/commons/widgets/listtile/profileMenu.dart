import 'package:pmis/commons/widgets/customs_shapes/containers/roundedcontainer.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:flutter/material.dart';

class TprofileMenu extends StatelessWidget {
  const TprofileMenu(
      {super.key,
      required this.iconData,
      required this.value,
      required this.ontap});

  final IconData iconData;
  final String value;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
        backgroundColor: dark ? Tcolors.dark : Tcolors.lightContainer,
        showborder: true,
        radius: 5,
        margin: const EdgeInsets.only(bottom: Tsizes.sm / 2),
        child: ListTile(
          leading: Icon(
            iconData,
            color: Tcolors.primary,
          ),
          title: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: Tsizes.md,
          ),
          onTap: ontap,
        ));
  }
}

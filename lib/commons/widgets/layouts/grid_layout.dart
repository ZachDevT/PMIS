import 'package:pmis/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class Tgridlayout extends StatelessWidget {
  const Tgridlayout(
      {super.key,
      required this.itemNumber,
      required this.crossaxiscount,
      this.mainaxisextent = 288,
      required this.itemBuilder,
      this.reverse = false});

  final int itemNumber;
  final int crossaxiscount;
  final double mainaxisextent;
  final bool reverse;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemNumber,
      reverse: reverse,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossaxiscount,
          mainAxisSpacing: Tsizes.gridViewSpacing,
          crossAxisSpacing: Tsizes.gridViewSpacing,
          mainAxisExtent: mainaxisextent),
      itemBuilder: itemBuilder,
    );
  }
}

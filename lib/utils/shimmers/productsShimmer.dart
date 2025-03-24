import 'package:pmis/commons/widgets/layouts/grid_layout.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/shimmers/shimmer.dart';
import 'package:flutter/material.dart';

class TproductsShimmer extends StatelessWidget {
  const TproductsShimmer(
      {super.key,
      this.itemcount = 6,
      required this.width,
      required this.height});

  final int itemcount;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Tgridlayout(
      mainaxisextent: height + 20,
      itemNumber: 8,
      crossaxiscount: 2,
      itemBuilder: (_, index) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image
        ShimmerEffect(
          height: height / 1.4,
          width: width,
          radius: 10,
        ),
        const SizedBox(
          height: Tsizes.sm,
        ),
        ShimmerEffect(
          height: 30,
          width: width,
          radius: 5,
        ),
        const SizedBox(
          height: Tsizes.sm,
        ),
        Row(
          children: [
            Expanded(
              child: ShimmerEffect(
                height: 40,
                width: width,
                radius: 5,
              ),
            ),
            const SizedBox(
              width: Tsizes.sm,
            ),
            const ShimmerEffect(
              height: 40,
              width: 40,
              radius: 40,
            ),
          ],
        ),
      ]),
    ));
  }
}

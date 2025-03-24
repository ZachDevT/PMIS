import 'package:pmis/commons/widgets/layouts/grid_layout.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/shimmers/shimmer.dart';
import 'package:flutter/material.dart';

class TcategoriesScreenShimmer extends StatelessWidget {
  const TcategoriesScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 110,
        child: Tgridlayout(
          mainaxisextent: 210,
          itemNumber: 8,
          crossaxiscount: 4,
          itemBuilder: (_, index) => const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ShimmerEffect(
                  height: 80,
                  width: 80,
                  radius: 80,
                ),
                SizedBox(width: Tsizes.spaceBtwItems / 2),
                ShimmerEffect(
                  height: 8,
                  width: 80,
                ),
              ]),
        ));
  }
}

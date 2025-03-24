import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/shimmers/shimmer.dart';
import 'package:flutter/material.dart';

class TBannersShimmer extends StatelessWidget {
  const TBannersShimmer({super.key, this.itemcount = 3});

  final int itemcount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        separatorBuilder: (_, __) =>
            const SizedBox(width: Tsizes.spaceBtwItems),
        itemCount: itemcount,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ShimmerEffect(
                height: 55,
                width: 55,
                radius: 55,
              ),
              SizedBox(width: Tsizes.spaceBtwItems / 2),
              ShimmerEffect(
                height: 8,
                width: 55,
              ),
            ]),
      ),
    );
  }
}

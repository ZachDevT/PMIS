import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/shimmers/shimmer.dart';
import 'package:flutter/material.dart';

class WishlistShimmer extends StatelessWidget {
  const WishlistShimmer(
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
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(
          height: Tsizes.spaceBtwItems,
        ),
        itemCount: 7,
        itemBuilder: (_, index) {
          return const ShimmerEffect(height: 120, width: double.infinity);
        },
      ),
    );
  }
}

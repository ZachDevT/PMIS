import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/shimmers/shimmer.dart';
import 'package:flutter/material.dart';

class OrderListShimmer extends StatelessWidget {
  const OrderListShimmer({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(
        height: Tsizes.spaceBtwItems,
      ),
      itemCount: 6,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, index) =>
          const ShimmerEffect(radius: 15, height: 130, width: double.infinity),
    );
  }
}

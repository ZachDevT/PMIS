import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:pmis/utils/shimmers/shimmer.dart';
import 'package:flutter/material.dart';

class TprofileShimmerEffect extends StatelessWidget {
  const TprofileShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const ShimmerEffect(
        width: 50,
        height: 50,
        radius: 50,
      ),
      title: ShimmerEffect(
        width: THelperFunctions.screenWidth() / 1.5,
        height: 25,
      ),
      trailing: const ShimmerEffect(
        width: 40,
        height: 40,
        radius: 40,
      ),
    );
  }
}

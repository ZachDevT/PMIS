import 'package:cached_network_image/cached_network_image.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:pmis/utils/shimmers/shimmer.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TverticalImageText extends StatelessWidget {
  const TverticalImageText({
    super.key,
    required this.imagepath,
    required this.label,
    this.backgroundcolor = Tcolors.white,
    this.ontap,
    this.isnetworkImage = false,
    this.width = 80,
    this.height = 80,
    this.radius = 80,
  });
  final String imagepath;
  final String label;
  final Color? backgroundcolor;
  final void Function()? ontap;
  final bool isnetworkImage;
  final double width, height, radius;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.only(right: Tsizes.spaceBtwItems),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width,
              height: height,
              padding: const EdgeInsets.all(Tsizes.sm * 1.5),
              decoration: BoxDecoration(
                color: dark ? Tcolors.dark : Tcolors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: isnetworkImage
                    ? CachedNetworkImage(
                        imageUrl: imagepath,
                        progressIndicatorBuilder: (context, url, progress) =>
                            ShimmerEffect(
                          height: height,
                          width: width,
                          radius: width,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Iconsax.image),
                      )
                    : Image(
                        image: AssetImage(
                          imagepath,
                        ),
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // Text
            const SizedBox(
              height: Tsizes.spaceBtwItems / 3,
            ),
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

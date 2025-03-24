import 'package:pmis/commons/widgets/icons/circular_icon.dart';
import 'package:pmis/utils/constants/colors.dart';

import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class TappBar extends StatelessWidget implements PreferredSizeWidget {
  const TappBar(
      {super.key,
      this.leadingOnpressed,
      this.showbackarrow = false,
      this.actions,
      this.title,
      this.leadingContent,
      this.showleadingContent = false,
      this.backarrowcolor});

  final VoidCallback? leadingOnpressed;
  final bool showbackarrow;
  final List<Widget>? actions;
  final Widget? title;
  final Widget? leadingContent;
  final bool showleadingContent;
  final Color? backarrowcolor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Tsizes.defaultSpace,
        right: Tsizes.defaultSpace,
      ),
      child: AppBar(
        centerTitle: false,
        elevation: 10,
        automaticallyImplyLeading: false,
        leading: showbackarrow
            ? Padding(
                padding: const EdgeInsets.all(6),
                child: InkWell(
                  onHover: (value) => {},
                  onTap: () => Get.back(),
                  child: TcircularIcon(
                    onpressed: () => Get.back(),
                    icon: Icons.arrow_back_ios_rounded,
                    size: Tsizes.md,
                    width: 30,
                    height: 30,
                    backgroundcolor: Tcolors.primarygreen,
                  ),
                ),
              )
            : leadingContent ?? leadingContent,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}

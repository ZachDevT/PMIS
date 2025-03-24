import 'package:pmis/commons/widgets/customs_shapes/containers/circularshape.dart';
import 'package:pmis/commons/widgets/customs_shapes/curved/Curved_edges_widget.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class THeaderContainer extends StatelessWidget {
  const THeaderContainer({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return TcurvedWidget(
      child: Container(
        color: Tcolors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: Tcircularcontainer(
                backgroundColor: Tcolors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: Tcircularcontainer(
                backgroundColor: Tcolors.textWhite.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

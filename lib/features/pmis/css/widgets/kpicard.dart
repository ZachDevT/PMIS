import 'package:flutter/material.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:hugeicons/hugeicons.dart';

class KpiCard extends StatelessWidget {
  final IconData icon;
  final int number;
  final String label;
  final Color color;

  const KpiCard(
      {super.key,
      required this.icon,
      required this.number,
      required this.label,
      this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return IntrinsicHeight(
      child: Row(
        children: [
          // Left border with primary color and rounded left corners.
          Container(
            width: 8,
            decoration: BoxDecoration(
              color: Tcolors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          // Main card content with white background, blackish borders and rounded right corners.
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  // color:
                  //     dark ? Tcolors.darkerGrey : Tcolors.grey.withOpacity(0.2),
                  border: Border(
                    top: BorderSide(
                        color: dark
                            ? Tcolors.darkerGrey
                            : Tcolors.grey.withOpacity(0.8)),
                    right: BorderSide(
                        color: dark
                            ? Tcolors.darkerGrey
                            : Tcolors.grey.withOpacity(0.8)),
                    bottom: BorderSide(
                        color: dark
                            ? Tcolors.darkerGrey
                            : Tcolors.grey.withOpacity(0.8)),
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  gradient: LinearGradient(
                    begin: const Alignment(0.0, 0.0),
                    end: const Alignment(0.307, 0.907),
                    colors: [
                      Tcolors.grey.withOpacity(0.1),
                      const Color.fromARGB(255, 1, 205, 100).withOpacity(0.1),
                    ],
                  )),
              child: Stack(
                children: [
                  // Card content.
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row with icon and label.
                        Row(
                          children: [
                            Icon(
                              icon,
                              color: Tcolors.primary,
                              size: 23,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: dark
                                      ? Tcolors.darkerGrey
                                      : Tcolors.darkerGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Text(
                          number.toString(),
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color:
                                dark ? Tcolors.darkerGrey : Tcolors.darkerGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

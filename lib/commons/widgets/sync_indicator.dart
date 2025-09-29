import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/utils/helpers/sync_manager.dart';
import 'package:pmis/utils/constants/colors.dart';

class SyncIndicator extends StatelessWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SyncManager>(
      builder: (syncManager) {
        if (syncManager.totalPendingItems > 0) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Tcolors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Tcolors.primary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 16,
                  color: Tcolors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${syncManager.totalPendingItems} items pending sync',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Tcolors.primary,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

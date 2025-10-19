import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/rts/controllers/RtsController.dart';
import 'package:pmis/features/pmis/rts/widgets/RtsForm.dart';
import 'package:pmis/features/pmis/rts/widgets/RtsActivityCard.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:iconsax/iconsax.dart';

class RtsScreen extends StatelessWidget {
  final RtsController controller = Get.find<RtsController>();

  RtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _QuickActionsSection(context),
            const SizedBox(height: 16),
            _ActivityListSection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Tcolors.primary,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Tcolors.primary,
              Tcolors.primary.withOpacity(0.8),
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "R",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Tcolors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const Spacer(),
          _UserProfileWidget(),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _SearchBarWidget(),
      ),
    );
  }

  void _showCreateNewModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24))),
        child: const RtsForm(),
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  final BuildContext context;

  const _QuickActionsSection(this.context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _ActionButton(
              icon: Iconsax.add,
              label: "Create new RTS",
              onTap: () => RtsScreen()._showCreateNewModal(context),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: _ActionButton(
              icon: Iconsax.refresh,
              label: "Refresh",
              onTap: () {
                final controller = Get.find<RtsController>();
                controller.loadActivities();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityListSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RtsController>();
    final dark = THelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Radio Talk Show Activities",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredActivities.isEmpty) {
              return _buildEmptyState(dark);
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredActivities.length,
              itemBuilder: (context, index) {
                final activity = controller.filteredActivities[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RtsActivityCard(
                    activity: activity,
                    onTap: () => _showActivityDetails(context, activity),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool dark) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Iconsax.radio,
            size: 64,
            color: dark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            "No Radio Talk Show Activities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Start by adding your first radio talk show activity",
            style: TextStyle(
              fontSize: 14,
              color: dark ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(BuildContext context, activity) {
    // TODO: Implement activity details view
    Get.snackbar(
      "Activity Details",
      "Details for ${activity.topicOfDiscussion}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Tcolors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/user-menu'),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Iconsax.user,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _SearchBarWidget extends StatelessWidget {
  final RtsController controller = Get.find<RtsController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() => TextField(
            onChanged: (value) => controller.updateSearchQuery(value),
            decoration: InputDecoration(
              hintText: "Search activities...",
              prefixIcon: const Icon(Iconsax.search_normal, size: 20),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.searchQuery.value.isNotEmpty)
                    IconButton(
                      icon: const Icon(Iconsax.close_circle, size: 20),
                      onPressed: () => controller.updateSearchQuery(''),
                    ),
                  IconButton(
                    icon: const Icon(Iconsax.filter, size: 20),
                    onPressed: () => _showFilterModal(context),
                  ),
                ],
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          )),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Filter Activities",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.filterRegion.value.isEmpty
                      ? null
                      : controller.filterRegion.value,
                  decoration: const InputDecoration(
                    labelText: "Filter by Region",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                        value: '', child: Text("All Regions")),
                    ...RegionDistrictConstants.regions.map((region) =>
                        DropdownMenuItem(value: region, child: Text(region))),
                  ],
                  onChanged: (value) {
                    controller.filterRegion.value = value ?? '';
                    controller.filterActivities();
                  },
                )),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.filterDistrict.value.isEmpty
                      ? null
                      : controller.filterDistrict.value,
                  decoration: const InputDecoration(
                    labelText: "Filter by District",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                        value: '', child: Text("All Districts")),
                    ...RegionDistrictConstants.districts.map((district) =>
                        DropdownMenuItem(
                            value: district, child: Text(district))),
                  ],
                  onChanged: (value) {
                    controller.filterDistrict.value = value ?? '';
                    controller.filterActivities();
                  },
                )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.filterRegion.value = '';
                      controller.filterDistrict.value = '';
                      controller.filterActivities();
                      Navigator.pop(context);
                    },
                    child: const Text("Clear Filters"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

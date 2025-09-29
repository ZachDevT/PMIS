import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/commons/widgets/cards/GppActivityCard.dart';
import 'package:pmis/features/pmis/gpp/Widgets/GppForm.dart';
import 'package:pmis/features/pmis/gpp/controllers/GppController.dart';
import 'package:pmis/features/pmis/gpp/models/GppModel.dart';
import 'package:pmis/utils/constants/colors.dart';

class GppScreen extends StatelessWidget {
  final GppController controller = Get.find<GppController>();

  GppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _DashboardSection(),
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
                "P",
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
        child: GppForm(),
      ),
    );
  }
}

// Reusable Components Section
class _DashboardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final GppController gppController = Get.find<GppController>();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: dark ? Tcolors.darkerGrey : Tcolors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dark ? Tcolors.darkerGrey : Tcolors.grey.withOpacity(0.8),
          )),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Activities Overview",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 15),
          Obx(() {
            final activities = gppController.activities;
            final chartData = _generateChartData(activities);

            return SizedBox(
              height: 170,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun'
                          ][value.toInt()],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Tcolors.primary, Tcolors.primaryDark],
                      ),
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Tcolors.primary.withOpacity(0.3),
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  List<FlSpot> _generateChartData(List<GppActivity> activities) {
    if (activities.isEmpty) {
      return [
        const FlSpot(0, 0),
        const FlSpot(1, 0),
        const FlSpot(2, 0),
        const FlSpot(3, 0),
        const FlSpot(4, 0),
        const FlSpot(5, 0),
      ];
    }

    // Group activities by month
    Map<int, int> monthlyCount = {};
    for (var activity in activities) {
      final month = activity.inspectionDate.month;
      monthlyCount[month] = (monthlyCount[month] ?? 0) + 1;
    }

    // Generate chart data for last 6 months
    List<FlSpot> spots = [];
    for (int i = 0; i < 6; i++) {
      final month = DateTime.now().month - 5 + i;
      final count = monthlyCount[month] ?? 0;
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }

    return spots;
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
              label: "Create new Gpp",
              onTap: () => GppScreen()._showCreateNewModal(context),
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
                final controller = Get.find<GppController>();
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
    final GppController gppController = Get.find<GppController>();
    return Obx(() {
      final activities = gppController.filteredActivities;
      if (activities.isEmpty && gppController.searchQuery.value.isNotEmpty) {
        return Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Iconsax.search_normal,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                "No activities found",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Try adjusting your search or filters",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: activities.length,
        itemBuilder: (context, index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12),
          child: GppActivityCard(activity: activities[index]),
        ),
      );
    });
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
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Tcolors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Tcolors.white),
              const SizedBox(width: 8),
              Text(label,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Tcolors.white,
                        fontWeight: FontWeight.w500,
                      )),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBarWidget extends StatelessWidget {
  final GppController controller = Get.find<GppController>();

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
                    onPressed: () => _showFilterDialog(context),
                  ),
                ],
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          )),
    );
  }

  void _showFilterDialog(BuildContext context) {
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _FilterDialog(),
      ),
    );
  }
}

class _FilterDialog extends StatelessWidget {
  final GppController controller = Get.find<GppController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Text(
              "Filter Activities",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Iconsax.close_circle),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Filter options
        Obx(() => Column(
              children: [
                _FilterDropdown(
                  label: "Region",
                  value: controller.filterRegion.value,
                  items: [
                    "Central Region",
                    "Eastern Region",
                    "Northern Region",
                    "Western Region"
                  ],
                  onChanged: (value) =>
                      controller.filterRegion.value = value ?? '',
                ),
                const SizedBox(height: 16),
                _FilterDropdown(
                  label: "Facility Status",
                  value: controller.filterFacilityStatus.value,
                  items: ["Open", "Closed"],
                  onChanged: (value) =>
                      controller.filterFacilityStatus.value = value ?? '',
                ),
                const SizedBox(height: 16),
                _FilterDropdown(
                  label: "License Status",
                  value: controller.filterLicenseStatus.value,
                  items: ["Licensed", "Un-Licensed", "Not-Applicable"],
                  onChanged: (value) =>
                      controller.filterLicenseStatus.value = value ?? '',
                ),
                const SizedBox(height: 16),
                _FilterDropdown(
                  label: "Category of Drugs",
                  value: controller.filterCategoryOfDrugs.value,
                  items: [
                    "Medical Device",
                    "Veterinary drugs",
                    "Human drugs",
                    "Public Healthcare products",
                    "Herbal drugs"
                  ],
                  onChanged: (value) =>
                      controller.filterCategoryOfDrugs.value = value ?? '',
                ),
              ],
            )),

        const SizedBox(height: 24),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  controller.clearFilters();
                  Navigator.pop(context);
                },
                child: const Text("Clear All"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Apply Filters"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          decoration: InputDecoration(
            hintText: "Select $label",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: [
            DropdownMenuItem<String>(
              value: '',
              child: Text("All $label"),
            ),
            ...items.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                )),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _UserProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/user-menu'),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Welcome ", style: Theme.of(context).textTheme.bodyMedium),
                Text("Admin",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Tcolors.white,
                          fontWeight: FontWeight.w700,
                        )),
              ],
            ),
            const SizedBox(width: 8),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: const Icon(HugeIcons.strokeRoundedUser, size: 30),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
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

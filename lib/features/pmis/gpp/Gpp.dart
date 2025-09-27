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
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
                      gradient: const LinearGradient(
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
              icon: Iconsax.filter,
              label: "Filters",
              onTap: () {},
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
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: gppController.activities.length,
          itemBuilder: (context, index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            child: GppActivityCard(activity: gppController.activities[index]),
          ),
        ));
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search activities...",
          prefixIcon: const Icon(Iconsax.search_normal, size: 20),
          suffixIcon: IconButton(
            icon: const Icon(Iconsax.filter, size: 20),
            onPressed: () {},
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

class _UserProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
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
    );
  }
}

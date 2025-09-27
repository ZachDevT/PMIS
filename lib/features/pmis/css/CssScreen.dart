import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/commons/widgets/cards/CssActivityCard.dart';
import 'package:pmis/features/pmis/Css/Widgets/CssForm.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/features/pmis/css/widgets/CssDashboard.dart';
import 'package:pmis/utils/constants/colors.dart';

class CssScreen extends StatelessWidget {
  final CssController controller = Get.find<CssController>();

  CssScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CssDashboardSection(),
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
        child: CssForm(),
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
              label: "Create new Css",
              onTap: () => CssScreen()._showCreateNewModal(context),
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
    final CssController cssController = Get.find<CssController>();
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: cssController.activities.length,
          itemBuilder: (context, index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            child: CssActivityCard(activity: cssController.activities[index]),
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
              child: Icon(HugeIcons.strokeRoundedUser, size: 30),
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

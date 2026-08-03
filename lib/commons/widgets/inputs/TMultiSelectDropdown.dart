import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pmis/utils/constants/colors.dart';

class TMultiSelectDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final RxList<String> selectedItems;
  final IconData prefixIcon;

  const TMultiSelectDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Tcolors.grey),
            ),
            child: Obx(() => MultiSelectDialogField<String>(
                  items: items.map((e) => MultiSelectItem(e, e)).toList(),
                  title: Text("Select $label"),
                  selectedColor: Tcolors.primary,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  buttonText: Text(
                    selectedItems.isEmpty
                        ? "Select $label"
                        : selectedItems.join(', '),
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  onConfirm: (results) {
                    selectedItems.assignAll(results);
                  },
                  initialValue: selectedItems.toList(),
                )),
          ),
        ],
      ),
    );
  }
}

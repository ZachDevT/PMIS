import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A cached-data district selector that remains usable while offline.
class TSearchableDistrictField extends StatelessWidget {
  const TSearchableDistrictField({
    super.key,
    required this.items,
    required this.selectedItem,
    this.label = 'District',
    this.prefixIcon = Icons.location_city_outlined,
    this.validator,
  });

  final List<String> items;
  final RxString selectedItem;
  final String label;
  final IconData prefixIcon;
  final String? Function(String?)? validator;

  Future<void> _pick(BuildContext context) async {
    final searchController = TextEditingController();
    var matchingItems = List<String>.from(items);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .65,
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Search district',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) => setState(() {
                      final normalized = query.trim().toLowerCase();
                      matchingItems = items
                          .where(
                              (item) => item.toLowerCase().contains(normalized))
                          .toList();
                    }),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: matchingItems.length,
                      itemBuilder: (_, index) {
                        final district = matchingItems[index];
                        return ListTile(
                          title: Text(district),
                          trailing: district == selectedItem.value
                              ? const Icon(Icons.check)
                              : null,
                          onTap: () {
                            selectedItem.value = district;
                            Navigator.pop(sheetContext);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => FormField<String>(
          initialValue: selectedItem.value,
          validator: (_) => validator?.call(selectedItem.value),
          builder: (field) => InkWell(
            onTap: () => _pick(context),
            child: InputDecorator(
              isEmpty: selectedItem.value.isEmpty,
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(prefixIcon),
                suffixIcon: const Icon(Icons.search),
                errorText: field.errorText,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(selectedItem.value.isEmpty
                  ? 'Search district'
                  : selectedItem.value),
            ),
          ),
        ));
  }
}

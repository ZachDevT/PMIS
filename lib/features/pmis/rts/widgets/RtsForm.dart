import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/rts/controllers/RtsController.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/features/pmis/location/controllers/LocationController.dart'
    as pmis_location;

import 'package:pmis/commons/widgets/icons/circular_icon.dart';

class RtsForm extends StatelessWidget {
  const RtsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RtsController>();
    final dark = THelperFunctions.isDarkMode(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Radio Talk Shows",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              TcircularIcon(
                width: 40,
                height: 40,
                icon: Icons.close,
                onpressed: () => Get.back(),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Section
                    _buildSectionHeader("Basic Information", dark),
                    const SizedBox(height: Tsizes.spaceBtwItems / 2),

                    // Inspection Date
                    _buildTextField(
                      controller: controller.inspectionDateController,
                      label: "Inspection Date",
                      prefixIcon: Iconsax.calendar,
                      readOnly: true,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: Tsizes.spaceBtwInputFields),

                    // Inspector Name
                    _buildTextField(
                      controller: controller.inspectorNameController,
                      readOnly: true,
                      label: "Inspector Name",
                      prefixIcon: Iconsax.user,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: Tsizes.spaceBtwInputFields),

                    // GPS Location
                    _buildTextField(
                      controller: controller.gpsLocationController,
                      label: "GPS Location",
                      prefixIcon: Iconsax.gps,
                      readOnly: true,
                      suffix: Obx(() => controller.isGettingLocation.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Iconsax.location),
                              onPressed: () => controller.getCurrentLocation(),
                            )),
                    ),
                    const SizedBox(height: Tsizes.spaceBtwSections / 2),

                    // Location Details Section
                    _buildSectionHeader("Location Details", dark),
                    const SizedBox(height: Tsizes.spaceBtwItems / 2),

                    // District Dropdown
                    Obx(() {
                      final locController =
                          Get.isRegistered<pmis_location.LocationController>()
                              ? pmis_location.LocationController.instance
                              : null;
                      return _buildDropdown(
                        label: "District",
                        items: locController?.districts
                                .map((d) => d.name)
                                .toList() ??
                            RegionDistrictConstants.allDistricts,
                        selectedItem: controller.selectedDistrict,
                        prefixIcon: Iconsax.location,
                        validator: (value) =>
                            value!.isEmpty ? "Required" : null,
                        onChanged: (district) {
                          controller.selectedRegion.value = locController
                                  ?.getRegionForDistrict(district ?? '') ??
                              RegionDistrictConstants
                                  .districtToRegion[district ?? ''] ??
                              '';
                        },
                      );
                    }),
                    const SizedBox(height: Tsizes.spaceBtwInputFields),

                    Obx(() {
                      final locController =
                          Get.isRegistered<pmis_location.LocationController>()
                              ? pmis_location.LocationController.instance
                              : null;
                      return _buildDropdown(
                        label: "Region",
                        items: locController?.regionNames ??
                            RegionDistrictConstants.regions,
                        selectedItem: controller.selectedRegion,
                        prefixIcon: Iconsax.map,
                        validator: (value) =>
                            value!.isEmpty ? "Required" : null,
                        enabled: false,
                      );
                    }),
                    const SizedBox(height: Tsizes.spaceBtwInputFields),

                    // Venue/Location
                    _buildTextField(
                      controller: controller.venueLocationController,
                      label: "Venue/Location",
                      prefixIcon: Iconsax.location,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: Tsizes.spaceBtwSections / 2),

                    // RTS Specific Information Section
                    _buildSectionHeader("Radio Talk Show Details", dark),
                    const SizedBox(height: Tsizes.spaceBtwItems / 2),

                    // Radio Company Name
                    _buildTextField(
                      controller: controller.radioCompanyNameController,
                      label: "Name of Radio Company",
                      prefixIcon: Iconsax.radio,
                    ),
                    const SizedBox(height: Tsizes.spaceBtwInputFields),

                    // Topic of Discussion
                    _buildTextField(
                      controller: controller.topicOfDiscussionController,
                      label: "Topic of Discussion",
                      prefixIcon: Iconsax.message,
                      maxLines: 3,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: Tsizes.spaceBtwInputFields),

                    // Number of Participants
                    _buildTextField(
                      controller: controller.numberOfParticipantsController,
                      label: "Number of Participants",
                      prefixIcon: Iconsax.people,
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: Tsizes.spaceBtwSections * 2),

                    // Submit Button
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() => controller.isSubmitting.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton.icon(
                              onPressed: () => controller.submitActivity(),
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.white),
                              label: const Text("Submit"),
                            )),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool dark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: dark ? Tcolors.white : Tcolors.dark,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    IconData? suffixIcon,
    Widget? suffix,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final dark = THelperFunctions.isDarkMode(Get.context!);

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffix ?? (suffixIcon != null ? Icon(suffixIcon) : null),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
        ),
        filled: true,
        fillColor: dark ? Tcolors.darkGrey : Colors.white,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required RxString selectedItem,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    void Function(String?)? onChanged,
    bool enabled = true,
  }) {
    final dark = THelperFunctions.isDarkMode(Get.context!);

    return Obx(() => DropdownButtonFormField<String>(
          initialValue: selectedItem.value.isEmpty ? null : selectedItem.value,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(prefixIcon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Tsizes.borderRadiusLg),
            ),
            filled: true,
            fillColor: dark ? Tcolors.darkGrey : Colors.white,
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: enabled
              ? (value) {
                  selectedItem.value = value ?? '';
                  onChanged?.call(value);
                }
              : null,
          validator: validator,
        ));
  }
}

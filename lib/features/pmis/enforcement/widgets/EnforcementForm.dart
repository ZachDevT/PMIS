import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/enforcement/controllers/EnforcementController.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:pmis/features/pmis/qualification/controllers/QualificationController.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/features/pmis/location/controllers/LocationController.dart'
    as pmis_location;

import 'package:pmis/commons/widgets/icons/circular_icon.dart';

class EnforcementForm extends StatelessWidget {
  const EnforcementForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnforcementController>();
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
              const Text("Enforcement Details",
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

                    // Inspection Time
                    _buildTextField(
                      controller: controller.inspectionTimeController,
                      label: "Inspection Time",
                      prefixIcon: Iconsax.clock,
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

                    // GPS
                    _buildTextField(
                      controller: controller.gpsController,
                      label: "GPS",
                      prefixIcon: Iconsax.gps,
                      validator: (value) => value!.isEmpty ? "Required" : null,
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

                    // Facility Name
                    _buildTextField(
                      controller: controller.facilityNameController,
                      label: "Facility Name",
                      prefixIcon: Iconsax.home,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: Tsizes.spaceBtwSections / 2),

                    // Facility Details Section
                    _buildSectionHeader("Facility Details", dark),
                    const SizedBox(height: Tsizes.spaceBtwItems / 2),

                    // Facility Status
                    _buildDropdown(
                      label: "Facility Status",
                      items: ["Open", "Closed"],
                      selectedItem: controller.selectedFacilityStatus,
                      prefixIcon: Iconsax.info_circle,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: Tsizes.spaceBtwInputFields),

                    // Conditionally show fields only when facility is Open
                    Obx(() => controller.selectedFacilityStatus.value !=
                            "Closed"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Person Found at Facility
                              _buildDropdown(
                                label: "Person Found at Facility",
                                items: ["In-charge", "Attendant/Operator"],
                                selectedItem:
                                    controller.selectedPersonFoundAtFacility,
                                prefixIcon: Iconsax.user,
                              ),
                              const SizedBox(
                                  height: Tsizes.spaceBtwInputFields),

                              // Person Name
                              _buildTextField(
                                controller: controller.personNameController,
                                label: "Person Name",
                                prefixIcon: Iconsax.user,
                              ),
                              const SizedBox(
                                  height: Tsizes.spaceBtwInputFields),

                              // Contact
                              _buildTextField(
                                controller: controller.contactController,
                                label: "Contact",
                                prefixIcon: Iconsax.call,
                              ),
                              const SizedBox(
                                  height: Tsizes.spaceBtwInputFields),

                              // Qualifications
                              Obx(() => _buildDropdown(
                                    label: "Qualification",
                                    items:
                                        QualificationController.instance.names,
                                    selectedItem:
                                        controller.selectedQualification,
                                    onChanged: (name) => controller
                                            .selectedQualificationId.value =
                                        QualificationController.instance
                                            .idForName(name ?? ''),
                                    prefixIcon: Icons.school,
                                  )),
                              const SizedBox(
                                  height: Tsizes.spaceBtwSections / 2),

                              // Category and Licensing Section
                              _buildSectionHeader(
                                  "Category and Licensing", dark),
                              const SizedBox(height: Tsizes.spaceBtwItems / 2),

                              // Category of Premises
                              _buildDropdown(
                                label: "Category of Premises",
                                items: controller.categoryOfPremisesOptions,
                                selectedItem:
                                    controller.selectedCategoryOfPremises,
                                prefixIcon: Icons.category,
                                validator: (value) =>
                                    value!.isEmpty ? "Required" : null,
                              ),
                              Obx(() => controller
                                          .selectedCategoryOfPremises.value ==
                                      "Other"
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: _buildTextField(
                                        controller:
                                            controller.otherCategoryController,
                                        label: "Please specify other category",
                                        prefixIcon: Iconsax.edit,
                                        validator: (value) =>
                                            value!.isEmpty ? "Required" : null,
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                              const SizedBox(
                                  height: Tsizes.spaceBtwInputFields),

                              // License Status
                              _buildDropdown(
                                label: "License Status",
                                items: [
                                  "Licensed",
                                  "Un-Licensed",
                                  "Not-Applicable"
                                ],
                                selectedItem: controller.selectedLicenseStatus,
                                prefixIcon: Iconsax.shield_tick,
                                validator: (value) =>
                                    value!.isEmpty ? "Required" : null,
                              ),
                              const SizedBox(
                                  height: Tsizes.spaceBtwInputFields),

                              // Show License No & Expiry when Licensed
                              Obx(() {
                                if (controller.selectedLicenseStatus.value ==
                                    'Licensed') {
                                  return Column(
                                    children: [
                                      _buildTextField(
                                        controller:
                                            controller.licenseNoController,
                                        label: "License No.",
                                        prefixIcon: Iconsax.crown,
                                        validator: (value) =>
                                            value!.isEmpty ? "Required" : null,
                                      ),
                                      const SizedBox(
                                          height: Tsizes.spaceBtwInputFields),
                                      TextFormField(
                                        controller:
                                            controller.licenseExpiryController,
                                        readOnly: true,
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? "Required"
                                                : null,
                                        decoration: InputDecoration(
                                          labelText: 'License Expiry Date',
                                          prefixIcon:
                                              const Icon(Iconsax.calendar),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                Tsizes.borderRadiusLg),
                                          ),
                                          filled: true,
                                          fillColor:
                                              THelperFunctions.isDarkMode(
                                                      Get.context!)
                                                  ? Tcolors.darkGrey
                                                  : Colors.white,
                                        ),
                                        onTap: () async {
                                          DateTime? picked =
                                              await showDatePicker(
                                            context: Get.context!,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (picked != null) {
                                            controller.licenseExpiryController
                                                    .text =
                                                picked
                                                    .toIso8601String()
                                                    .split('T')
                                                    .first;
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                          height: Tsizes.spaceBtwInputFields),
                                    ],
                                  );
                                }

                                return const SizedBox.shrink();
                              }),
                              const SizedBox(
                                  height: Tsizes.spaceBtwInputFields),

                              // Previously Licensed or Illegal Outlet (shown when Un-Licensed)
                              Obx(() => controller
                                              .selectedLicenseStatus.value ==
                                          "Un-Licensed" ||
                                      controller.selectedLicenseStatus.value ==
                                          "Unlicensed"
                                  ? Column(
                                      children: [
                                        _buildDropdown(
                                          label:
                                              "Previously Licensed or Illegal Outlet",
                                          items: [
                                            "Previously Licensed",
                                            "Illegal Outlet"
                                          ],
                                          selectedItem: controller
                                              .selectedPreviouslyLicensed,
                                          prefixIcon: Icons.warning,
                                        ),
                                        const SizedBox(
                                            height: Tsizes.spaceBtwInputFields),
                                      ],
                                    )
                                  : const SizedBox.shrink()),

                              const SizedBox(
                                  height: Tsizes.spaceBtwInputFields),

                              // Category of Drugs
                              _buildDropdown(
                                label: "Category of Drugs",
                                items: [
                                  "Medical Device",
                                  "Veterinary drugs",
                                  "Human drugs",
                                  "Public Healthcare products",
                                  "Herbal drugs"
                                ],
                                selectedItem: controller.selectedCategoryStatus,
                                prefixIcon: Iconsax.tag,
                                validator: (value) =>
                                    value!.isEmpty ? "Required" : null,
                              ),
                              const SizedBox(
                                  height: Tsizes.spaceBtwSections / 2),
                            ],
                          )
                        : const SizedBox.shrink()),

                    // Enforcement Actions Section
                    _buildSectionHeader("Enforcement Actions", dark),
                    const SizedBox(height: Tsizes.spaceBtwSections / 2),

                    // Actions Taken (Multi-select)
                    const Text("Actions Taken",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Obx(() => Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children:
                              controller.enforcementActionOptions.map((action) {
                            final isSelected = controller
                                .selectedEnforcementActions
                                .contains(action);
                            return FilterChip(
                              label: Text(action),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  controller.selectedEnforcementActions
                                      .add(action);
                                } else {
                                  controller.selectedEnforcementActions
                                      .remove(action);
                                }
                              },
                            );
                          }).toList(),
                        )),
                    const SizedBox(height: Tsizes.spaceBtwInputFields),

                    // Comments
                    _buildTextField(
                      controller: controller.commentsController,
                      label: "Comments",
                      prefixIcon: Iconsax.message,
                      maxLines: 3,
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
        suffixIcon: suffix != null
            ? null
            : (suffixIcon != null ? Icon(suffixIcon) : null),
        suffix: suffix,
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

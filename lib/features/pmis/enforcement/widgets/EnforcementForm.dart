import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/enforcement/controllers/EnforcementController.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/sizes.dart';
import 'package:pmis/utils/helpers/helpers_functions.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:iconsax/iconsax.dart';

class EnforcementForm extends StatelessWidget {
  const EnforcementForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnforcementController>();
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? Tcolors.dark : Colors.white,
      appBar: AppBar(
        backgroundColor: Tcolors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Enforcement',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Tsizes.defaultSpace),
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
                label: "Inspector Name",
                prefixIcon: Iconsax.user,
                readOnly: true,
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

              // Region Dropdown
              _buildDropdown(
                label: "Region",
                items: RegionDistrictConstants.regions,
                selectedItem: controller.selectedRegion,
                prefixIcon: Iconsax.map,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: Tsizes.spaceBtwInputFields),

              // District Dropdown
              _buildDropdown(
                label: "District",
                items: RegionDistrictConstants.districts,
                selectedItem: controller.selectedDistrict,
                prefixIcon: Iconsax.location,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
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
              if (controller.selectedFacilityStatus.value != "Closed") ...[
                // Person Found at Facility
                _buildDropdown(
                  label: "Person Found at Facility",
                  items: ["In-charge", "Attendant/Operator"],
                  selectedItem: controller.selectedPersonFoundAtFacility,
                  prefixIcon: Iconsax.user,
                  validator: (value) => value!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: Tsizes.spaceBtwInputFields),

                // Person Name
                _buildTextField(
                  controller: controller.personNameController,
                  label: "Person Name",
                  prefixIcon: Iconsax.user,
                  validator: (value) => value!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: Tsizes.spaceBtwInputFields),

                // Contact
                _buildTextField(
                  controller: controller.contactController,
                  label: "Contact",
                  prefixIcon: Iconsax.call,
                  validator: (value) => value!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: Tsizes.spaceBtwInputFields),

                // Qualifications
                _buildTextField(
                  controller: controller.qualificationsController,
                  label: "Qualifications",
                  prefixIcon: Icons.school,
                  validator: (value) => value!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: Tsizes.spaceBtwSections / 2),

                // Category and Licensing Section
                _buildSectionHeader("Category and Licensing", dark),
                const SizedBox(height: Tsizes.spaceBtwItems / 2),

                // Category of Premises
                _buildDropdown(
                  label: "Category of Premises",
                  items: controller.categoryOfPremisesOptions,
                  selectedItem: controller.selectedCategoryOfPremises,
                  prefixIcon: Iconsax.category,
                  validator: (value) => value!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: Tsizes.spaceBtwInputFields),

                // License Status
                _buildDropdown(
                  label: "License Status",
                  items: ["Licensed", "Un-Licensed", "Not-Applicable"],
                  selectedItem: controller.selectedLicenseStatus,
                  prefixIcon: Iconsax.shield_tick,
                  validator: (value) => value!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: Tsizes.spaceBtwInputFields),

                // Show License No & Expiry when Licensed
                Obx(() {
                  if (controller.selectedLicenseStatus.value == 'Licensed') {
                    return Column(
                      children: [
                        _buildTextField(
                          controller: controller.licenseNoController,
                          label: "License No.",
                          prefixIcon: Iconsax.crown,
                          validator: (value) =>
                              value!.isEmpty ? "Required" : null,
                        ),
                        const SizedBox(height: Tsizes.spaceBtwInputFields),
                        TextFormField(
                          controller: controller.licenseExpiryController,
                          readOnly: true,
                          validator: (value) => value == null || value.isEmpty
                              ? "Required"
                              : null,
                          decoration: InputDecoration(
                            labelText: 'License Expiry Date',
                            prefixIcon: const Icon(Iconsax.calendar),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Tsizes.borderRadiusLg),
                            ),
                            filled: true,
                            fillColor: THelperFunctions.isDarkMode(Get.context!)
                                ? Tcolors.darkGrey
                                : Colors.white,
                          ),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: Get.context!,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              controller.licenseExpiryController.text =
                                  picked.toIso8601String().split('T').first;
                            }
                          },
                        ),
                        const SizedBox(height: Tsizes.spaceBtwInputFields),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                }),
                const SizedBox(height: Tsizes.spaceBtwInputFields),

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
                  validator: (value) => value!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: Tsizes.spaceBtwSections / 2),
              ],

              // Enforcement Actions Section
              _buildSectionHeader("Enforcement Actions", dark),
              const SizedBox(height: Tsizes.spaceBtwItems / 2),

              // Enforcement Action Taken
              _buildDropdown(
                label: "Enforcement Action Taken",
                items: controller.enforcementActionOptions,
                selectedItem: controller.selectedEnforcementActionTaken,
                prefixIcon: Iconsax.shield_security,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
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
                        icon:
                            const Icon(Icons.check_circle, color: Colors.white),
                        label: const Text("Submit"),
                      )),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
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
          onChanged: (value) => selectedItem.value = value ?? '',
          validator: validator,
        ));
  }
}

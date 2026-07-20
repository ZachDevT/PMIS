import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pmis/commons/widgets/icons/circular_icon.dart';
import 'package:pmis/features/pmis/sensitizationmeeting/controllers/SensitizationMeetingController.dart';
import 'package:pmis/features/pmis/location/controllers/LocationController.dart'
    as pmis_location;
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class SensitizationMeetingForm extends StatelessWidget {
  final SensitizationMeetingController controller =
      Get.find<SensitizationMeetingController>();

  SensitizationMeetingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sensitization Meeting",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              TcircularIcon(
                width: 40,
                height: 40,
                icon: Icons.close,
                onpressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Inspection Date
                    _buildDateField(context),

                    // Inspector Name
                    _buildTextField(
                      controller: controller.inspectorNameController,
                      readOnly: true,
                      label: "Inspector Name",
                      prefixIcon: Iconsax.user,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter inspector name";
                        }
                        return null;
                      },
                    ),

                    // Location fields
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: controller.latitudeController,
                            label: "Latitude",
                            prefixIcon: Iconsax.location,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: controller.longitudeController,
                            label: "Longitude",
                            prefixIcon: Iconsax.location,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Obx(() => ElevatedButton.icon(
                              onPressed: controller.isGettingLocation.value
                                  ? null
                                  : () => controller.getCurrentLocation(),
                              icon: controller.isGettingLocation.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Icon(Iconsax.location, size: 18),
                              label: const Text("Location"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Tcolors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                            )),
                      ],
                    ),

                    // District
                    Obx(() => _buildDropdown(
                          label: "District",
                          items: pmis_location
                              .LocationController.instance.districts
                              .map((district) => district.name)
                              .toList(),
                          selectedItem: controller.selectedDistrict,
                          prefixIcon: Iconsax.map_1,
                          onChanged: (district) {
                            controller.selectedDistrict.value = district ?? '';
                            controller.selectedRegion.value = pmis_location
                                .LocationController.instance
                                .getRegionForDistrict(district ?? '');
                          },
                          validator: (value) {
                            if (controller.selectedDistrict.value.isEmpty) {
                              return "Please select a district";
                            }
                            return null;
                          },
                        )),

                    // Region is derived from the selected district.
                    _buildDropdown(
                      label: "Region",
                      items: RegionDistrictConstants.regions,
                      selectedItem: controller.selectedRegion,
                      prefixIcon: Iconsax.map,
                      enabled: false,
                      validator: (value) {
                        if (controller.selectedRegion.value.isEmpty) {
                          return "Please select a district with a region";
                        }
                        return null;
                      },
                    ),

                    // Venue/Location
                    _buildTextField(
                      controller: controller.venueLocationController,
                      label: "Venue/Location",
                      prefixIcon: Iconsax.location,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter venue location";
                        }
                        return null;
                      },
                    ),

                    // Topic of Discussion
                    _buildTextField(
                      controller: controller.topicOfDiscussionController,
                      label: "Topic of Discussion",
                      prefixIcon: Iconsax.document_text,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter topic of discussion";
                        }
                        return null;
                      },
                    ),

                    // Number of Participants
                    _buildTextField(
                      controller: controller.numberOfParticipantsController,
                      label: "Number of Participants",
                      prefixIcon: Iconsax.people,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter number of participants";
                        }
                        final num = int.tryParse(value);
                        if (num == null || num < 0) {
                          return "Please enter a valid number";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.createActivity(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Tcolors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Back to List
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Back to List"),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required RxString selectedItem,
    required IconData prefixIcon,
    Function(String?)? onChanged,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Obx(() => DropdownButtonFormField<String>(
            value: selectedItem.value.isEmpty ? null : selectedItem.value,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(prefixIcon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            hint: Text("Select $label"),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: enabled
                ? onChanged ??
                    ((value) {
                      selectedItem.value = value ?? '';
                    })
                : null,
            validator: validator,
          )),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller.inspectionDateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Inspection Date",
          prefixIcon: const Icon(Iconsax.calendar),
          suffixIcon: const Icon(Iconsax.calendar_1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select inspection date";
          }
          return null;
        },
      ),
    );
  }
}

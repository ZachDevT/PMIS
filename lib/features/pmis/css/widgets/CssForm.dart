// widgets/CssForm.dart
import 'package:flutter/material.dart';
import 'package:pmis/commons/widgets/inputs/TMultiSelectDropdown.dart';
import 'package:get/get.dart';
import 'package:pmis/commons/widgets/icons/circular_icon.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/regions_districts.dart';

class CssForm extends StatelessWidget {
  final CssController controller = Get.find<CssController>();

  CssForm({super.key});

  // Reusable dropdown widget
  Widget buildDropdown({
    required String label,
    required List<String> items,
    required RxString selectedItem,
    required IconData prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            value: selectedItem.value.isEmpty ? null : selectedItem.value,
            hint: Text(
              "Select $label",
              style: Theme.of(Get.context!).textTheme.labelMedium,
            ),
            isExpanded: true,
            items: items
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        style: Theme.of(Get.context!).textTheme.labelMedium,
                      ),
                    ))
                .toList(),
            onChanged: (val) {
              selectedItem.value = val ?? "";
            },
          ),
        ),
      ),
    );
  }

  // Reusable text field widget
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("CSS Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              TcircularIcon(
                width: 40,
                height: 40,
                icon: Icons.close,
                onpressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
          Flexible(
            child: SingleChildScrollView(
              child: Obx(
                () => Form(
              key: controller.formKey,
              child: Column(
                children: [
                  // Inspection Details
                  buildTextField(
                    controller: controller.inspectionDateController,
                    label: "Inspection Date",
                    prefixIcon: Icons.date_range,
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (picked != null) {
                        controller.inspectionDateController.text =
                            picked.toLocal().toString().split(' ')[0];
                      }
                    },
                    validator: (value) => value!.isEmpty ? "Required" : null,
                  ),
                  buildTextField(
                    controller: controller.inspectorNameController,
                    readOnly: true,
                    label: "Inspector Name",
                    prefixIcon: Icons.person,
                    validator: (value) => value!.isEmpty ? "Required" : null,
                  ),
                  buildTextField(
                    controller: controller.inspectionTimeController,
                    label: "Inspection Time",
                    prefixIcon: Icons.access_time,
                    
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (picked != null) {
                        controller.inspectionTimeController.text =
                            picked.format(context);
                      }
                    },
                    validator: (value) => value!.isEmpty ? "Required" : null,
                  ),
                  buildTextField(
                    controller: controller.gpsLocationController,
                    label: "GPS Location",
                    prefixIcon: Icons.gps_fixed,
                    readOnly: true,
                  ),

                  // Location Details
                  buildDropdown(
                    label: "Region",
                    items: RegionDistrictConstants.regions,
                    selectedItem: controller.selectedRegion,
                    prefixIcon: Icons.map,
                  ),
                  buildDropdown(
                    label: "District",
                    items: RegionDistrictConstants.districts,
                    selectedItem: controller.selectedDistrict,
                    prefixIcon: Icons.location_city,
                  ),

                  // Facility Details
                  buildTextField(
                    controller: controller.facilityNameController,
                    label: "Facility Name",
                    prefixIcon: Icons.home,
                    validator: (value) => value!.isEmpty ? "Required" : null,
                  ),
                  buildDropdown(
                    label: "Facility Status",
                    items: ["Open", "Closed"],
                    selectedItem: controller.selectedFacilityStatus,
                    prefixIcon: Icons.info,
                  ),
                  if (controller.selectedFacilityStatus.value != "Closed") ...[
                    buildDropdown(
                      label: "Person Found",
                      items: ["In-charge", "Attendant/Operator"],
                      selectedItem: controller.selectedPersonFound,
                      prefixIcon: Icons.person,
                    ),
                    buildTextField(
                      controller: controller.nameController,
                      label: "Name",
                      prefixIcon: Icons.person,
                      
                    ),
                    buildTextField(
                      controller: controller.contactController,
                      label: "Contact",
                      prefixIcon: Icons.phone,
                      
                    ),
                    buildTextField(
                      controller: controller.qualificationsController,
                      label: "Qualifications",
                      prefixIcon: Icons.school,
                      
                    ),
                    // Compliance Details
                    buildDropdown(
                      label: "Category of Facility",
                      items: [
                        "Wholesale Pharmacy",
                        "Retail Pharmacy",
                        "Drug Shop",
                        "External Stores",
                        "Hospital",
                        "HCIV",
                        "HCIII",
                        "Clinic",
                        "Herbal Selling Outlet",
                        "Shift Market",
                        "Pharmaceutical/Medical Device Manufacturing Premise",
                        "Others"
                      ],
                      selectedItem: controller.selectedCategoryOfFacility,
                      prefixIcon: Icons.category,
                    ),
                    if (controller.selectedCategoryOfFacility.value ==
                        "Others") ...[
                      buildTextField(
                        controller: controller.otherCategoryPremiseController,
                        label: "State the other type of facility",
                        prefixIcon: Icons.edit,
                        
                      ),
                    ],
                    buildDropdown(
                      label: "Licensed Status",
                      items: ["Licensed", "Un-Licensed", "Not-Applicable"],
                      selectedItem: controller.selectedLicensedStatus,
                      prefixIcon: Icons.verified_user,
                    ),
                    if (controller.selectedLicensedStatus.value ==
                        "Licensed") ...[
                      buildTextField(
                        controller: controller.licenseNoController,
                        label: "License No.",
                        prefixIcon: Icons.badge,
                        validator: (value) =>
                            value!.isEmpty ? "Required" : null,
                      ),
                      buildTextField(
                        controller: controller.licenseExpiryDateController,
                        label: "License Expiry Date",
                        prefixIcon: Icons.date_range,
                        readOnly: true,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.licenseExpiryDateController.text =
                                picked.toLocal().toString().split(' ')[0];
                          }
                        },
                        validator: (value) =>
                            value!.isEmpty ? "Required" : null,
                      ),
                    ],
                    if (controller.selectedLicensedStatus.value ==
                            "Un-Licensed" ||
                        controller.selectedLicensedStatus.value ==
                            "Unlicensed") ...[
                      buildDropdown(
                        label: "Previously Licensed or Illegal Outlet",
                        items: ["Previously Licensed", "Illegal Outlet"],
                        selectedItem: controller.selectedPreviouslyLicensed,
                        prefixIcon: Icons.warning,
                      ),
                    ],
                    buildDropdown(
                      label: "Category of Drugs",
                      items: [
                        "Medical Device",
                        "Veterinary Drugs",
                        "Human Drugs",
                        "Public Healthcare Products",
                        "Herbal Drugs"
                      ],
                      selectedItem: controller.selectedCategoryOfDrugs,
                      prefixIcon: Icons.medical_services,
                    ),
                    buildDropdown(
                      label: "Class of Drugs",
                      items: ["A", "B", "C"],
                      selectedItem: controller.selectedClassOfDrugs,
                      prefixIcon: Icons.class_,
                    ),
                    buildDropdown(
                      label: "Unregistered Drugs",
                      items: ["Present", "Not Present"],
                      selectedItem: controller.selectedUnregisteredDrugs,
                      prefixIcon: Icons.warning,
                    ),
                    if (controller.selectedUnregisteredDrugs.value ==
                        "Present") ...[
                      buildTextField(
                        controller: controller.unRegDrugQtyController,
                        label:
                            "State the name and quantities of unregistered drug",
                        prefixIcon: Icons.medication,
                        validator: (value) =>
                            value!.isEmpty ? "Required" : null,
                      ),
                    ],
                    buildDropdown(
                      label: "Condition of Premises",
                      items: ["Poor", "Fair", "Good", "Excellent"],
                      selectedItem: controller.selectedConditionOfPremises,
                      prefixIcon: Icons.home,
                    ),
                    buildDropdown(
                      label: "Record Keeping",
                      items: ["Poor", "Fair", "Good", "Excellent"],
                      selectedItem: controller.selectedRecordKeeping,
                      prefixIcon: Icons.notes,
                    ),
                  ],

                  // Action Taken - only show if facility is Open
                  if (controller.selectedFacilityStatus.value == "Open")
                    TMultiSelectDropdown(
                      label: "Action Taken",
                      items: const [
                        "Warning Letter",
                        "NDA Form 43",
                        "Impounded",
                        "Suspect arrested",
                        "No action taken"
                      ],
                      selectedItems: controller.selectedActionTaken,
                      prefixIcon: Icons.assignment_turned_in,
                    ),

                  // Submit Button
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => controller.createNewActivity(context),
                      icon:
                          const Icon(Icons.check_circle, color: Tcolors.white),
                      label: const Text("Submit"),
                    ),
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
}

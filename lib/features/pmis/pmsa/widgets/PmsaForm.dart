import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pmis/commons/widgets/icons/circular_icon.dart';
import 'package:pmis/features/pmis/pmsa/controllers/PmsaController.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/regions_districts.dart';

class PmsaForm extends StatelessWidget {
  final PmsaController controller = Get.find<PmsaController>();

  PmsaForm({super.key});

  // Reusable dropdown with icon and label.
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
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

  // Reusable text field with prefix icon.
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        maxLines: maxLines,
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
              const Text("PMSA Details",
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
          const SizedBox(height: 5),
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Obx(
                  () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION: Inspection Details
                  const Text("Inspection Details",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  buildTextField(
                    controller: controller.inspectionDateController,
                    label: "Inspection Date",
                    prefixIcon: Icons.date_range,
                    readOnly: true,
                    validator: (value) =>
                        value!.isEmpty ? "Required" : null,
                  ),
                  buildTextField(
                    controller: controller.inspectionTimeController,
                    label: "Inspection Time",
                    prefixIcon: Icons.access_time,
                    readOnly: true,
                    validator: (value) =>
                        value!.isEmpty ? "Required" : null,
                  ),
                  buildTextField(
                    controller: controller.inspectorNameController,
                    readOnly: true,
                    label: "Inspector Name",
                    prefixIcon: Icons.person,
                    validator: (value) =>
                        value!.isEmpty ? "Required" : null,
                  ),
                  buildTextField(
                    controller: controller.gpsLocationController,
                    label: "GPS Location",
                    prefixIcon: Icons.gps_fixed,
                    
                  ),
                  // SECTION: Location Details
                  const Text("Location Details",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
                  // SECTION: Facility Details
                  const Text("Facility Details",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  buildTextField(
                    controller: controller.facilityNameController,
                    label: "Name of Facility",
                    prefixIcon: Icons.home,
                    validator: (value) =>
                        value!.isEmpty ? "Required" : null,
                  ),
                  buildDropdown(
                    label: "Facility Status",
                    items: ["Open", "Closed"],
                    selectedItem: controller.selectedFacilityStatus,
                    prefixIcon: Icons.info,
                  ),
                  // If facility is not closed, collect additional details.
                  if (controller.selectedFacilityStatus.value != "Closed")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDropdown(
                          label: "Person Found at Facility",
                          items: ["In-charge", "Attendant/Operator"],
                          selectedItem: controller.personFoundAtFacility,
                          prefixIcon: Icons.info_outline,
                        ),
                        buildTextField(
                          controller: controller.nameController,
                          label: "Contact Name",
                          prefixIcon: HugeIcons.strokeRoundedUser,
                          
                        ),
                        buildTextField(
                          controller: controller.contactController,
                          label: "Contact",
                          prefixIcon: Icons.contact_phone,
                          
                        ),
                        buildTextField(
                          controller: controller.qualificationsController,
                          label: "Qualifications",
                          prefixIcon: Icons.school,
                          
                        ),
                        // SECTION: Facility Category & Licensing
                        const Text("Facility Category",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        buildDropdown(
                          label: "Category of Facility",
                          items: [
                            "Wholesale Pharmacy - Human",
                            "Wholesale Pharmacy - Vet",
                            "Retail Pharmacy - Human",
                            "Retail Pharmacy - Vet",
                            "Drug Shop",
                            "External Stores",
                            "Hospital",
                            "HCIV",
                            "HCIII",
                            "Clinic",
                            "Herbal Selling Outlet",
                            "Shift Market",
                            "Pharmaceutical/Medical Device Manufacturing Premise",
                            "Other"
                          ],
                          selectedItem: controller.selectedCategoryOfFacility,
                          prefixIcon: Icons.category,
                        ),
                        buildDropdown(
                          label: "Licensed/Unlicensed",
                          items: [
                            "Licensed",
                            "Un-Licensed",
                            "Not-Applicable"
                          ],
                          selectedItem: controller.licensedStatus,
                          prefixIcon: Icons.verified_user,
                        ),
                        if (controller.licensedStatus.value == "Licensed") ...[
                          buildTextField(
                            controller: controller.licenseNoController,
                            label: "License No.",
                            prefixIcon: Icons.badge,
                            validator: (value) => value!.isEmpty ? "Required" : null,
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
                            validator: (value) => value!.isEmpty ? "Required" : null,
                          ),
                        ],
                        // Previously Licensed or Illegal Outlet (shown when Un-Licensed)
                        if (controller.licensedStatus.value == "Un-Licensed" ||
                            controller.licensedStatus.value == "Unlicensed") ...[
                          buildDropdown(
                            label: "Previously Licensed or Illegal Outlet",
                            items: ["Previously Licensed", "Illegal Outlet"],
                            selectedItem: controller.selectedPreviouslyLicensed,
                            prefixIcon: Icons.warning,
                          ),
                        ],
                        // SECTION: PMSA Activity Carried Out
                        const Text("PMSA Activity Carried Out",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        buildDropdown(
                          label: "Activity",
                          items: [
                            "Sampling",
                            "Follow-up on Recall",
                            "Complaint investigation",
                            "Others",
                            "None"
                          ],
                          selectedItem: controller.pmsaActivityCarriesOut,
                          prefixIcon: Icons.build,
                        ),
                        // Conditional fields based on selected activity
                        if (controller.pmsaActivityCarriesOut.value == "Sampling" ||
                            controller.pmsaActivityCarriesOut.value == "Complaint investigation" ||
                            controller.pmsaActivityCarriesOut.value == "Follow-up on Recall") ...[
                          buildTextField(
                            controller: controller.productSampledNameController,
                            label: "Name of Product",
                            prefixIcon: Icons.production_quantity_limits,
                            validator: (value) =>
                                value!.isEmpty ? "Required" : null,
                          ),
                          buildTextField(
                            controller: controller.numberOfSamplesCollectedController,
                            label: "Quantity",
                            prefixIcon: Icons.numbers,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                (value!.isEmpty || value == "0") ? "Required" : null,
                          ),
                          buildTextField(
                            controller: controller.batchNumberOfSampleController,
                            label: "Batch Number",
                            prefixIcon: Icons.confirmation_number,
                            validator: (value) =>
                                value!.isEmpty ? "Required" : null,
                          ),
                        ],
                        // Specific field for Complaint investigation
                        if (controller.pmsaActivityCarriesOut.value == "Complaint investigation") ...[
                          buildTextField(
                            controller: controller.postMarketComplaintNotedController,
                            label: "State any post market complaint noted",
                            prefixIcon: Icons.note,
                            maxLines: 3,
                            validator: (value) =>
                                value!.isEmpty ? "Required" : null,
                          ),
                        ],
                        // Specific field for Follow-up on Recall
                        if (controller.pmsaActivityCarriesOut.value == "Follow-up on Recall") ...[
                          buildTextField(
                            controller: controller.commentOnOverallFollowUpController,
                            label: "Comment on Over all Follow up",
                            prefixIcon: Icons.comment,
                            maxLines: 3,
                            validator: (value) =>
                                value!.isEmpty ? "Required" : null,
                          ),
                        ],
                        // Specific field for Others
                        if (controller.pmsaActivityCarriesOut.value == "Others") ...[
                          buildTextField(
                            controller: controller.specifyActivityController,
                            label: "Specify Activity",
                            prefixIcon: Icons.edit,
                            validator: (value) =>
                                value!.isEmpty ? "Required" : null,
                          ),
                        ],
                      ],
                    ),
                  // Submit Button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await controller.createNewActivity(context);
                        },
                        icon: const Icon(
                          Icons.check_circle,
                          color: Tcolors.white,
                        ),
                        label: const Text("Submit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Tcolors.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

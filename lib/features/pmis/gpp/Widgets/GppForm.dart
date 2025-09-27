// ------------------ GPP Form Widget ------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pmis/commons/widgets/icons/circular_icon.dart';
import 'package:pmis/features/pmis/gpp/controllers/GppController.dart';
import 'package:pmis/utils/constants/colors.dart';

class GppForm extends StatelessWidget {
  final GppController controller = Get.find<GppController>();

  GppForm({super.key});

  // Reusable drop down component with icon and label.
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

  // Reusable text field with prefix icon.
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("GPP Details",
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
          Form(
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
                    controller: controller.inspectionTimeController,
                    label: "Inspection Time",
                    prefixIcon: Icons.access_time,
                    readOnly: true,
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
                    controller: controller.inspectorNameController,
                    label: "Name of Inspector",
                    prefixIcon: Icons.person,
                    validator: (value) => value!.isEmpty ? "Required" : null,
                  ),
                  buildTextField(
                    controller: controller.gpsLocationController,
                    label: "GPS Location",
                    prefixIcon: Icons.gps_fixed,
                    readOnly: true,
                  ),
                  // SECTION: Region & District
                  const Text("Location Details",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  buildDropdown(
                    label: "Region",
                    items: ["Region 1", "Region 2", "Region 3"],
                    selectedItem: controller.selectedRegion,
                    prefixIcon: Icons.map,
                  ),
                  buildDropdown(
                    label: "District",
                    items: ["District A", "District B", "District C"],
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
                    validator: (value) => value!.isEmpty ? "Required" : null,
                  ),
                  buildDropdown(
                    label: "Status",
                    items: ["Open", "Closed"],
                    selectedItem: controller.selectedFacilityStatus,
                    prefixIcon: Icons.info,
                  ),
                  if (controller.selectedFacilityStatus.value != "Closed")

                    // Facility nullable values
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDropdown(
                          label: "Person found at facility",
                          items: ["In-charge", "(Attendant/Operator)"],
                          selectedItem: controller.personFoundController,
                          prefixIcon: Icons.info,
                        ),
                        buildTextField(
                          controller: controller.nameController,
                          label: "Name ",
                          prefixIcon: HugeIcons.strokeRoundedUser,
                          validator: (value) =>
                              value!.isEmpty ? "Required" : null,
                        ),
                        buildTextField(
                          controller: controller.contactController,
                          label: "Contact ",
                          prefixIcon: Icons.contact_phone,
                          validator: (value) =>
                              value!.isEmpty ? "Required" : null,
                        ),
                        buildTextField(
                          controller: controller.QualificationsController,
                          label: "Qualifications ",
                          prefixIcon: HugeIcons.strokeRoundedGraduateMale,
                          validator: (value) =>
                              value!.isEmpty ? "Required" : null,
                        ),

                        // SECTION: Category & Licensed Status
                        const Text("Facility Category",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        buildDropdown(
                          label: "Category of Facility",
                          items: [
                            "Retail Pharmacy",
                            "Drug Shop",
                            "Hospital",
                            "HCIV",
                            "HCIII",
                            "Clinic"
                          ],
                          selectedItem: controller.selectedCategoryOfFacility,
                          prefixIcon: Icons.category,
                        ),
                        buildDropdown(
                          label: "Licensed/Unlicensed",
                          items: ["Licensed", "Un-Licensed", "Not-Applicable"],
                          selectedItem: controller.selectedLicensedStatus,
                          prefixIcon: Icons.verified_user,
                        ),
                        // SECTION: Drugs & GPP Details
                        const Text("Drugs & GPP Details",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        buildDropdown(
                          label: "Category of Drugs",
                          items: [
                            "Medical Device",
                            "Veterinary drugs",
                            "Human drugs",
                            "Public Healthcare products",
                            "Herbal drugs"
                          ],
                          selectedItem: controller.selectedCategoryOfDrugs,
                          prefixIcon: Icons.medical_services,
                        ),
                        buildDropdown(
                          label: "Facility Type",
                          items: ["Public Facility", "Private Facility"],
                          selectedItem: controller.selectedFacilityType,
                          prefixIcon: Icons.apartment,
                        ),
                        buildDropdown(
                          label: "Certification Status",
                          items: ["Certified", "Not certified"],
                          selectedItem: controller.selectedCertificationStatus,
                          prefixIcon: Icons.verified,
                        ),
                        buildDropdown(
                          label: "Recommended for GPP",
                          items: [
                            "GPP certification",
                            "Not recommended for GPP certification"
                          ],
                          selectedItem: controller.recommendedForGpp,
                          prefixIcon: Icons.recommend,
                        ),
                      ],
                    ),

                  const SizedBox(height: 14),
                  // Submit Button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await controller.createNewActivity(context);
                          // Navigator.pop(context);
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
        ],
      ),
    );
  }
}

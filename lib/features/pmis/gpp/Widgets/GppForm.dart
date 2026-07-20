// ------------------ GPP Form Widget ------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pmis/commons/widgets/icons/circular_icon.dart';
import 'package:pmis/features/pmis/gpp/controllers/GppController.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/utils/constants/regions_districts.dart';
import 'package:pmis/features/pmis/location/controllers/LocationController.dart' as pmis_location;

class GppForm extends StatelessWidget {
  final GppController controller = Get.find<GppController>();

  GppForm({super.key});

  Widget buildDropdown({
    required String label,
    required List<String> items,
    required RxString selectedItem,
    required IconData prefixIcon,
    void Function(String?)? onChanged,
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
              onChanged?.call(val);
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
                    validator: (value) => value!.isEmpty ? "Required" : null,
                  ),
                  buildTextField(
                    controller: controller.inspectionTimeController,
                    label: "Inspection Time",
                    prefixIcon: Icons.access_time,
                    readOnly: true,
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
                    controller: controller.gpsLocationController,
                    label: "GPS Location",
                    prefixIcon: Icons.gps_fixed,
                    
                  ),
                  // SECTION: Region & District
                  const Text("Location Details",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  Obx(() {
                    final locController = Get.isRegistered<pmis_location.LocationController>()
                        ? pmis_location.LocationController.instance
                        : null;
                    return buildDropdown(
                      label: "Region",
                      items: locController?.regionNames ?? RegionDistrictConstants.regions,
                      selectedItem: controller.selectedRegion,
                      prefixIcon: Icons.map,
                      onChanged: (_) { controller.selectedDistrict.value = ''; },
                    );
                  }),
                  Obx(() {
                    final locController = Get.isRegistered<pmis_location.LocationController>()
                        ? pmis_location.LocationController.instance
                        : null;
                    return buildDropdown(
                      label: "District",
                      items: locController?.getDistrictsForRegion(controller.selectedRegion.value)
                          ?? RegionDistrictConstants.districts,
                      selectedItem: controller.selectedDistrict,
                      prefixIcon: Icons.location_city,
                    );
                  }),
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
                  Obx(() => controller.selectedFacilityStatus.value != "Closed" ?
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
                          
                        ),
                        buildTextField(
                          controller: controller.contactController,
                          label: "Contact ",
                          prefixIcon: Icons.contact_phone,
                          
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
                         if (controller.selectedCategoryOfFacility.value == "Other") ...[
                          buildTextField(
                            controller: controller.otherCategoryPremiseController,
                            label: "Specify Category of Premises",
                            prefixIcon: Icons.edit,
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ],
                        buildDropdown(
                          label: "Licensed/Unlicensed",
                          items: ["Licensed", "Un-Licensed", "Not-Applicable"],
                          selectedItem: controller.selectedLicensedStatus,
                          prefixIcon: Icons.verified_user,
                        ),
                        if (controller.selectedLicensedStatus.value == "Licensed") ...[
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
                        if (controller.selectedLicensedStatus.value == "Un-Licensed" || controller.selectedLicensedStatus.value == "Unlicensed") ...[
                          buildDropdown(
                            label: "Previously Licensed or Illegal Outlet",
                            items: ["Previously Licensed", "Illegal Outlet"],
                            selectedItem: controller.selectedPreviouslyLicensed,
                            prefixIcon: Icons.history,
                          ),
                        ],
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
                            "Recommended for GPP",
                            "Not Recommended for GPP"
                          ],
                          selectedItem: controller.recommendedForGpp,
                          prefixIcon: Icons.recommend,
                        ),
                      ],
                    ) : const SizedBox.shrink()),

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
            ),
          ),
        ],
      ),
    );
  }
}

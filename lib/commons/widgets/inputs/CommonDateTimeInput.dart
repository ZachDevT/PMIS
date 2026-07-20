import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CommonDateTimeInput extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;

  const CommonDateTimeInput({
    Key? key,
    required this.dateController,
    required this.timeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AbsorbPointer(
            child: TextFormField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: "Date",
                prefixIcon: Icon(Iconsax.calendar_1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Required" : null,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AbsorbPointer(
            child: TextFormField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: "Time",
                prefixIcon: Icon(Iconsax.clock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Required" : null,
            ),
          ),
        ),
      ],
    );
  }
}

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
          child: TextFormField(
            controller: dateController,
            readOnly: true,
            onTap: () async {
              final now = DateTime.now();
              final initialDate = DateTime.tryParse(dateController.text) ?? now;
              final selected = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(now.year + 5),
              );
              if (selected != null) {
                dateController.text =
                    '${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}';
              }
            },
            decoration: InputDecoration(
              labelText: "Date",
              prefixIcon: const Icon(Iconsax.calendar_1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: timeController,
            readOnly: true,
            onTap: () async {
              final parts = timeController.text.split(':');
              final initialTime = parts.length >= 2
                  ? TimeOfDay(
                      hour: int.tryParse(parts[0]) ?? TimeOfDay.now().hour,
                      minute: int.tryParse(parts[1]) ?? TimeOfDay.now().minute,
                    )
                  : TimeOfDay.now();
              final selected = await showTimePicker(
                context: context,
                initialTime: initialTime,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                ),
              );
              if (selected != null) {
                timeController.text =
                    '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}:00';
              }
            },
            decoration: InputDecoration(
              labelText: "Time",
              prefixIcon: const Icon(Iconsax.clock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
          ),
        ),
      ],
    );
  }
}

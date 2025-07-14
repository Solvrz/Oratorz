import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/setup.dart';
import '/tools/functions.dart';
import '/ui/widgets/rounded_button.dart';

class DateCard extends StatefulWidget {
  const DateCard({super.key});

  @override
  State<DateCard> createState() => _DateCardState();
}

class _DateCardState extends State<DateCard> {
  @override
  Widget build(BuildContext context) {
    final SetupController controller = Get.find<SetupController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Set Days",
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: GetBuilder<SetupController>(
                  builder: (controller) {
                    final List<DateTime?> days = controller.committee.days;

                    return Column(
                      children: List.generate(
                        controller.committee.days.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Day ${index + 1}",
                                style: context.textTheme.titleLarge,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  if (days
                                      .sublist(0, index)
                                      .any((date) => date == null)) {
                                    snackbar(
                                      context,
                                      Center(
                                        child: Text(
                                          "Please select dates for all days preceding Day ${index + 1}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  } else {
                                    final DateTime minDate = index == 0
                                        ? DateTime.now()
                                            .add(const Duration(days: 1))
                                        : days[index - 1]!
                                            .add(const Duration(days: 1));

                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: days[index] ?? minDate,
                                      firstDate: minDate,
                                      lastDate: minDate
                                          .add(const Duration(days: 180)),
                                    );

                                    if (picked != null) {
                                      controller.committee.days[index] = picked;
                                      controller.committee.days.fillRange(
                                        index + 1,
                                        days.length,
                                        null,
                                      );

                                      controller.update();
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    days[index] == null
                                        ? "Select Date"
                                        : "${days[index]!.day}/${days[index]!.month}/${days[index]!.year}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              RoundedButton(
                                onPressed: () {
                                  controller.committee.days.removeAt(index);
                                  controller.update();
                                },
                                padding: EdgeInsets.zero,
                                tooltip: "Remove Day",
                                color: Colors.red.shade400,
                                child: const Icon(Icons.remove),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            RoundedButton(
              style: RoundedButtonStyle.border,
              color: Colors.amber.shade400,
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 8,
              ),
              onPressed: () {
                controller.committee.days.add(null);
                controller.update();
              },
              child: Text(
                "+ Add another Day",
                style: context.textTheme.bodyLarge?.copyWith(
                  color: Colors.amber.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

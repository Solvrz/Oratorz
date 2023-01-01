import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/controllers/comittee/committee.dart';
import '/ui/widgets/delegate_tile.dart';

class SubmittedByButton extends StatelessWidget {
  final void Function(String?) onChanged;

  final String? delegate;

  const SubmittedByButton({
    super.key,
    required this.onChanged,
    this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Submitted By",
          style: context.textTheme.headline5,
        ),
        const SizedBox(height: 10),
        DropdownSearch<String>(
          onChanged: onChanged,
          selectedItem: delegate,
          items: Get.find<CommitteeController>().committee.presentDelegates,
          itemAsString: (delegate) => DELEGATES[delegate] ?? "",
          dropdownButtonProps: DropdownButtonProps(
            color: context.theme.colorScheme.secondary,
          ),
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: "Select a delegate",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          popupProps: PopupProps.dialog(
            showSearchBox: true,
            dialogProps: DialogProps(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.all(8),
            ),
            searchFieldProps: TextFieldProps(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
              ),
            ),
            itemBuilder: (_, delegate, __) => Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: DelegateTile(delegate: delegate),
            ),
            emptyBuilder: (_, __) => Center(
              child: Text(
                "Delegate Not Found",
                style: context.textTheme.headline6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

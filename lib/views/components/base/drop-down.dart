import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropDown extends StatelessWidget {
  DropDown({super.key, required this.dropDownItems, required this.onChange});
  final List<String> dropDownItems;
  final Function(String value) onChange;

  @override
  Widget build(BuildContext context) {
    var selectedItem = dropDownItems[0].obs;

    return Obx(
      () => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(50)
        ),
        child: DropdownButton(
                isExpanded: true,

            value: selectedItem.value,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: dropDownItems.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              selectedItem.value = newValue ?? selectedItem.value;
              onChange(selectedItem.value);
            }),
      ),
    );
  }
}

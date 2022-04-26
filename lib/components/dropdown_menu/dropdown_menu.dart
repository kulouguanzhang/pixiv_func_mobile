import 'package:flutter/material.dart';
import 'package:pixiv_func_mobile/models/dropdown_item.dart';

class DropdownMenu<T> extends StatelessWidget {
  final List<DropdownItem> menuItems;
  final T currentValue;
  final ValueChanged<T?> onChanged;

  const DropdownMenu({
    Key? key,
    required this.menuItems,
    required this.currentValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: [
        for (final item in menuItems)
          DropdownMenuItem<T>(
            child: Text(
              item.label,
              style: currentValue == item.value ? TextStyle(color: Theme.of(context).colorScheme.primary) : null,
            ),
            value: item.value,
          )
      ],
      value: currentValue,
      onChanged: onChanged,
      isDense: true,
    );
  }
}

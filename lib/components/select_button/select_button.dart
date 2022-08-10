import 'package:flutter/material.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/widgets/dropdown/dropdown.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class SelectButtonWidget<V> extends StatelessWidget {
  final Map<String, V> items;
  final V value;
  final void Function(V? value) onChanged;
  final double width;
  final double height;

  const SelectButtonWidget({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 35,
        width: 70,
        child: DropdownButtonWidgetHideUnderline(
          child: DropdownButtonWidget<V>(
            isDense: true,
            elevation: 0,
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            items: [
              for (final item in items.entries)
                DropdownMenuItemWidget<V>(
                  value: item.value,
                  child: Container(
                    height: 35,
                    width: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      border: value == item.value ? Border.all(color: Theme.of(context).colorScheme.primary) : null,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Row(
                      children: [
                        const Spacer(),
                        const Icon(AppIcons.toggle, size: 12),
                        const SizedBox(width: 7),
                        TextWidget(
                          item.key,
                          fontSize: 14,
                          forceStrutHeight: true,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
            ],
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

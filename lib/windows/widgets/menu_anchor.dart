import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/custom/menu_achor_theme.dart';

class SMenuAchor<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) getItemText;
  final void Function(T)? onPressed;
  final T? currentItem;

  const SMenuAchor({
    super.key,
    required this.items,
    required this.getItemText,
    this.onPressed,
    this.currentItem,
  });

  @override
  State<SMenuAchor> createState() => _SMenuAchorState<T>();
}

class _SMenuAchorState<T> extends State<SMenuAchor<T>> {
  late T selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.currentItem ?? (widget.items.isNotEmpty ? widget.items[0] : null as T);
  }

  @override
  Widget build(BuildContext context) {
    final theme = MenuAchorTheme(context);
    return MenuAnchor(
      builder: _buildMenuButton,
      alignmentOffset: MenuAchorTheme.alignmentOffset,
      style: theme.menuStyle,
      menuChildren: _buildMenuList(theme),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, MenuController controller, Widget? child) {
    final theme = MenuAchorTheme(context);
    return FilledButton(
      onPressed: () {
        if (controller.isOpen) {
          controller.close();
        } else {
          controller.open();
        }
      },
      style: theme.getButtonStyle(borderRadius: MenuAchorTheme.borderRadius),
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.getItemText(selectedItem),
                style: theme.textStyle,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: theme.textColor,
            ),
          ],
        ),
      ),
    );
  }

  List<MenuItemButton> _buildMenuList(MenuAchorTheme theme) {
    return widget.items.map((
      T item,
    ) {
      return MenuItemButton(
        onPressed: () {
          setState(() {
            selectedItem = item;
          });
          widget.onPressed?.call(item);
        },
        style: theme.getButtonStyle(
          isSelected: selectedItem == item,
        ),
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          alignment: Alignment.centerLeft,
          child: Text(
            item.toString(),
            style: theme.textStyle,
          ),
        ),
      );
    }).toList();
  }
}

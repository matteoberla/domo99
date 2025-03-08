import 'package:flutter/material.dart';

class PalladioAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PalladioAppBar(
      {key,
      required this.title,
      this.leading,
      this.actions,
      this.automaticallyImplyLeading = true});

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

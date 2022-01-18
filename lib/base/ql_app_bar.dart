import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QlAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? backCall;
  final bool canBack;
  final Widget? backWidget;

  QlAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.backCall,
    this.canBack = true,
    this.backWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget back = backWidget ??
        GestureDetector(
          onTap: () {
            if (backCall != null) {
              backCall!();
            }
          },
          child: const Center(
            child: Icon(
              CupertinoIcons.left_chevron,
              color: Colors.white,
            ),
          ),
        );

    return AppBar(
      elevation: 0,
      leading: canBack ? back : null,
      automaticallyImplyLeading: canBack,
      title: Text(title),
      centerTitle: true,
      actions: [...?actions],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

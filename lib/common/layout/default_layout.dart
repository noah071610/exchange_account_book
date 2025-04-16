import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultLayout extends ConsumerWidget {
  final String? title;
  final String? bg;
  final Color? color;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? leading;
  final List<Widget>? actions;
  final void Function()? onClickTitle;
  final bool centerTitle;
  final bool? showAppbar;
  final bool bottomSafe;

  const DefaultLayout({
    required this.child,
    this.title,
    this.bg,
    this.color,
    this.bottomNavigationBar,
    this.actions,
    this.leading,
    this.onClickTitle,
    this.floatingActionButton,
    this.centerTitle = false,
    this.showAppbar = true,
    this.bottomSafe = true,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: bg != null
              ? DecorationImage(
                  image: AssetImage(bg!),
                  fit: BoxFit.cover,
                  opacity: 0.7,
                )
              : null,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
        ),
        child: SafeArea(
          top: true,
          bottom: bottomSafe,
          child: child,
        ),
      ),
      appBar: showAppbar == true ? renderAppbar(context) : null,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? renderAppbar(BuildContext context) {
    if (title == null) return null;

    return AppBar(
      elevation: 0,
      title: Text(
        title!,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
      actions: actions,
      centerTitle: centerTitle,
      leading: leading,
    );
  }
}

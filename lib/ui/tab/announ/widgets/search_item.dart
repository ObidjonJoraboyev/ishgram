import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/ui/tab/announ/widgets/zoom_tap.dart';

class SearchItem extends StatefulWidget {
  const SearchItem({
    super.key,
    required this.controller,
    required this.focus,
    required this.valueChanged,
  });

  final ValueChanged valueChanged;
  final TextEditingController controller;
  final FocusNode focus;

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );

    animation = Tween<double>(begin: 0, end: 16).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
        reverseCurve: Curves.linear,
      ),
    )
      ..addListener(() {
        if (widget.focus.hasFocus == false) {
          animationController.reverse();
          setState(() {});
        }
        setState(() {});
      })
      ..addStatusListener((status) {});
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.focus.hasFocus == false) {
      animationController.reverse();
      setState(() {});
    } else {
      animationController.forward();
      setState(() {});
    }
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 14, left: 12, bottom: 8, right: 12),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 16,
                    color: CupertinoColors.systemGrey4.withOpacity(.5),
                  )
                ],
              ),
              child: CupertinoTextField(
                controller: widget.controller,
                onChanged: widget.valueChanged,
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    CupertinoIcons.search,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                onTap: () {
                  animationController.forward();
                  animationController.isCompleted
                      ? animationController.stop()
                      : null;
                  widget.focus.requestFocus();
                  setState(() {});
                },
                cursorColor: Colors.blue,
                focusNode: widget.focus,
                clearButtonMode: OverlayVisibilityMode.editing,
                placeholder: "search".tr(),
                placeholderStyle: TextStyle(
                    color: CupertinoColors.systemGrey,
                    shadows: [
                      Shadow(blurRadius: 2, color: Colors.black.withAlpha(20))
                    ]),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: CupertinoColors.systemGrey4,
                ),
              ),
            ),
          ),
        ),
        ScaleOnPress(
          onTap: () {
            widget.controller.clear();
            widget.valueChanged("");
            setState(() {});

            animationController.reverse();
            widget.focus.unfocus();
          },
          child: Text(
            "cancel".tr(),
            style: TextStyle(color: Colors.blue, fontSize: animation.value),
          ),
        ),
        Padding(padding: EdgeInsets.only(right: widget.focus.hasFocus ? 12 : 0))
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/user_bloc.dart';
import 'package:ish_top/blocs/user_event.dart';
import 'package:ish_top/blocs/user_state.dart';

class ListTileItem extends StatefulWidget {
  const ListTileItem({
    super.key,
    required this.voidCallback,
    required this.title,
    required this.icon,
    required this.color,
    this.isSwitch,
    this.isPhoto,
  });

  final VoidCallback voidCallback;
  final String title;
  final Icon icon;
  final Color color;
  final bool? isSwitch;
  final bool? isPhoto;

  @override
  State<ListTileItem> createState() => _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  bool check = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: CupertinoListTile(
          trailing: widget.isSwitch == null
              ? Icon(
                  CupertinoIcons.right_chevron,
                  size: 14.sp,
                  color: Colors.grey,
                )
              : BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return SizedBox(
                      width: 30.w,
                      child: CupertinoSwitch(
                        value: state.userModel.isPrivate,
                        onChanged: (v) {
                          check = v;
                          context.read<UserBloc>().add(
                                UpdateUser(
                                  userModel:
                                      state.userModel.copyWith(isPrivate: v),
                                ),
                              );

                          context.read<UserBloc>().add(GetCurrentUser());
                        },
                      ),
                    );
                  },
                ),
          onTap: () {
            widget.voidCallback.call();
            widget.isSwitch != null ? check = !check : null;
            if (widget.isSwitch != null) {
              if (check) {
                context.read<UserBloc>().add(UpdateUser(
                      userModel: context
                          .read<UserBloc>()
                          .state
                          .userModel
                          .copyWith(isPrivate: true),
                    ));
              } else {
                context.read<UserBloc>().add(
                      UpdateUser(
                        userModel: context
                            .read<UserBloc>()
                            .state
                            .userModel
                            .copyWith(isPrivate: false),
                      ),
                    );
              }
              context.read<UserBloc>().add(GetCurrentUser());
            }
            setState(() {});
          },
          backgroundColorActivated: CupertinoColors.systemGrey6,
          backgroundColor: Colors.white,
          leadingSize: 35,
          leading: Container(
            width: 28.sp,
            height: 28.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: widget.color,
            ),
            child: widget.icon,
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 14.sp,
                color: widget.isPhoto == null
                    ? CupertinoColors.black
                    : CupertinoColors.activeBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

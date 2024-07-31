import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ish_top/blocs/user/user_bloc.dart';
import 'package:ish_top/blocs/user/user_event.dart';
import 'package:ish_top/blocs/user/user_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/ui/start_chat/start_chat_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, required this.barcode});

  final ValueChanged<Barcode> barcode;

  @override
  State<StatefulWidget> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  double zoom = 1;

  CameraFacing cameraFacing = CameraFacing.back;

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state.qrUserModel.phone != "" &&
            state.formStatus == FormStatus.successQr) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return StartChatScreen(
                  userModel: state.qrUserModel,
                );
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CupertinoColors.systemGrey6,
          body: Stack(
            children: [
              QRView(
                key: qrKey,
                overlay: QrScannerOverlayShape(
                    borderColor: CupertinoColors.activeBlue,
                    overlayColor: CupertinoColors.systemGrey6.withOpacity(.0),
                    borderRadius: 14.r,
                    borderLength: 0,
                    cutOutBottomOffset: 10.h,
                    cutOutSize: MediaQuery.of(context).size.width - 32.w),
                cameraFacing: cameraFacing,
                onQRViewCreated: (QRViewController controller) {
                  setState(() {
                    this.controller = controller;
                  });
                  controller.scannedDataStream.listen((scanData) async {
                    String decodedPhoneNumber =
                        utf8.decode(base64Decode(scanData.code ?? ""));

                    if (validPhone(phoneNumber: decodedPhoneNumber)) {
                      controller.pauseCamera();
                      context.read<UserBloc>().add(UserGetWithQr(
                          phoneNumber: decodedPhoneNumber, string: ""));
                      widget.barcode.call(scanData);
                    } else {
                      Fluttertoast.showToast(
                        msg: "invalid".tr(),
                        fontSize: 14.sp,
                        backgroundColor: Colors.red,
                        gravity: ToastGravity.TOP,
                      );
                    }
                  });
                },
              ),
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.r),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.w,
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).padding.top,
                  child: CupertinoButton(
                    padding: EdgeInsets.only(left: 5.w),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: CupertinoColors.systemGrey6,
                            spreadRadius: 1.sp,
                            offset: Offset(3.w, 0))
                      ]),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new,
                            color: CupertinoColors.activeBlue,
                          ),
                          Text(
                            "cancel".tr(),
                            style: TextStyle(
                                color: CupertinoColors.activeBlue,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom * 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.3),
                          shape: BoxShape.circle,
                        ),
                        child: CupertinoButton(
                          child: Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          onPressed: () async {
                            if (controller != null) {
                              await controller!.flipCamera();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      20.getW(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.3),
                          shape: BoxShape.circle,
                        ),
                        child: CupertinoButton(
                          child: Icon(
                            Icons.flashlight_on_rounded,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          onPressed: () async {
                            if (controller != null) {
                              await controller!.toggleFlash();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.formStatus == FormStatus.loadingQrGet)
                Stack(
                  children: [
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 30.sp,
                              height: 30.sp,
                              child: const CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                backgroundColor: Colors.grey,
                                color: Colors.white,
                              )),
                          15.getH(),
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              "searching".tr(),
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  shadows: [
                                    BoxShadow(
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(.3),
                                    )
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

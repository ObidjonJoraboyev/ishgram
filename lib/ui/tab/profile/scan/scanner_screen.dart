import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  double zoom = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: QRView(
      key: qrKey,
      overlay: QrScannerOverlayShape(
        borderColor: CupertinoColors.activeBlue,
        borderRadius: 16 / zoom,
        borderLength: 40 / zoom,
        borderWidth: 10 / zoom,
        cutOutSize: MediaQuery.of(context).size.width / zoom - 32 / zoom,
      ),
      onQRViewCreated: (controller) {
        setState(
          () {
            this.controller = controller;
          },
        );
        controller.scannedDataStream.listen(
          (scanData) {
            controller.pauseCamera();
            widget.barcode.call(scanData);
            Navigator.pop(context);
          },
        );
      },
    ));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

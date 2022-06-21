library qrcode_scanner;

import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrManager {
  /// Creates and goes to the default QR Code Scanner page.
  /// Returns the string of the read code.
  ///
  /// * See an example @: www.github.com/kobe-rodrigoperozzo/qrcode_scanner
  Future<String> defaultNavigateAndScan({
    required BuildContext context,
    String title = '',
    String subtitle = '',
    String actionText = '',
    VoidCallback? actionFunction,
  }) async {
    final qrCodeResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QrPage(
          title: title,
          subtitle: subtitle,
          actionText: actionText,
          actionFunction: actionFunction,
        ),
      ),
    );
    return qrCodeResult;
  }

  /// Creates and goes to a generic QR Code Scanner page.
  /// Returns the string of the read code.
  ///
  /// Receives a widget as parameter, that is stacked under the QR code view.
  /// The passed widget will be placed as such:
  /// 1. SafeArea
  /// 2. Scaffold
  /// 3. Stack
  /// 4. __Widget__
  ///
  /// * See an example @: www.github.com/kobe-rodrigoperozzo/qrcode_scanner
  Future<String> genericNavigateAndScan({
    required BuildContext context,
    required Widget overlayWidget,
  }) async {
    final qrCodeResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QrPage(
          overlayWidget: overlayWidget,
        ),
      ),
    );
    return qrCodeResult;
  }
}

/// QR Code Scanner page widget.
// ignore: must_be_immutable
class QrPage extends StatefulWidget {
  String title;
  String subtitle;
  String actionText;
  VoidCallback? actionFunction;
  Widget? overlayWidget;
  QrPage({
    Key? key,
    this.title = '',
    this.subtitle = '',
    this.actionText = '',
    this.actionFunction,
    this.overlayWidget,
  }) : super(key: key);

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final textController = TextEditingController();
  final qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? qrViewController;
  Barcode? scannedCode;

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrViewController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrViewController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              onPressed: () => Future.delayed(
                Duration.zero,
                () => Navigator.of(context).pop(),
              ),
              icon: const Icon(Icons.close),
            )
          ],
          leading: Container(),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildQrView(context),
            if (widget.overlayWidget != null) widget.overlayWidget!,
            if (widget.title.isNotEmpty) _buildQrTitle(widget.title, widget.subtitle),
            if (widget.actionText.isNotEmpty) _buildQrCallToAction(widget.actionFunction, widget.actionText),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderWidth: 5.0,
        borderLength: 24.0,
      ),
    );
  }

  Widget _buildQrTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCallToAction(VoidCallback? actionFunction, String actionText) {
    return Positioned(
      bottom: 32,
      child: TextButton(
        onPressed: actionFunction,
        child: Text(
          actionText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrViewController = controller;
    });

    qrViewController?.scannedDataStream.listen((scannedCode) async {
      setState(() {
        this.scannedCode = scannedCode;
      });
      await controller.pauseCamera();
      Navigator.of(context).pop(scannedCode.code);
    });
  }
}

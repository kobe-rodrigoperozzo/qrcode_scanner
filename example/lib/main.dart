import 'package:flutter/material.dart';
import 'package:qrcode_scanner/qrcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Qr Code Scanner Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Center(
          child: QrExample(),
        ),
      ),
    );
  }
}

class QrExample extends StatelessWidget {
  const QrExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            String qrCode = await QrManager().defaultNavigateAndScan(
              context: context,
              title: 'Title',
              subtitle: 'Subtitle',
              actionText: 'Action Text',
              actionFunction: () => debugPrint('Action Function'),
            );
            debugPrint(qrCode);
          },
          child: const Text('Default Page Scanner'),
        ),
        ElevatedButton(
          onPressed: () async {
            String qrCode = await QrManager().genericNavigateAndScan(
              context: context,
              overlayWidget: const Text(
                'Overlay Widget',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 32,
                ),
              ),
            );
            debugPrint(qrCode);
          },
          child: const Text('Generic Page Scanner'),
        ),
      ],
    );
  }
}

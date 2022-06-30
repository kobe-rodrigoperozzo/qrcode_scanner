<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A Flutter QR Code package that makes it simpler for developers to use.

## Features

Essentially, this package implements methods and widgets using the [qr_code_scanner](https://pub.dev/packages/qr_code_scanner) package, making it easier for developers to approach, simply returning a String with the read code.

- Navigate to a customizable default or generic QR Code Scanner page, using the ```[...]NavigateAndScan``` methods.
- Render your own QR Code Scanner page with the ```QrPage``` widget.


## Getting started

### Android Integration

Depending on the Android SDK or Gradle version your project is running, you might need to add permission for the app to open the camera. 
On that case, ddd the following to your ```AndroidManifest.xml``` file:

```<uses-permission android:name="android.permission.CAMERA" />```


### iOS Integration

In order to use the camera, add the following to your ```Info.plist``` file:

```
<key>io.flutter.embedded_views_preview</key>
<true/>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>
```

### Adding the package to your Flutter project

Add the following to your ```pubspec.yaml``` file:

```yaml
qrcode_scanner:
    git:
      url: https://github.com/kobe-rodrigoperozzo/qrcode_scanner.git
```

Now, in your Dart code, import it:

```dart
import 'package:qrcode_scanner/qrcode_scanner.dart';
```

And run:

```flutter pub get```

## Usage

### defaultNavigateAndScan

Example:

```dart
onPressed: () async {
            String qrCode = await QrManager().defaultNavigateAndScan(
              context: context,
              title: 'Title',
              subtitle: 'Subtitle',
              actionText: 'Action Text',
              actionFunction: () => debugPrint('Action Function'),
            );
```
![Captura de Tela 2022-06-30 às 13 05 31](https://user-images.githubusercontent.com/102180624/176725310-6fa1d86b-f3fc-4615-b54c-49e453c52e28.png)

### genericNavigateAndScan

The fundamental idea behind this method is for the developer to be able to pass any widget, as it is stacked on top of the Qr Code Scanner page.
The passed widget will be placed as such:
 1. SafeArea
 2. Scaffold
 3. Stack
 4. __Widget__

Example:

```dart
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
```
![Captura de Tela 2022-06-30 às 13 08 41](https://user-images.githubusercontent.com/102180624/176725908-2609487f-c2b3-4a99-85a0-5dbf565ecdec.png)

## TODO
There is still a lot of work to be done, and tons of room for improvement.
Some of them are:
- Make the GenericPage even more flexible and customizable.
- Add the QR "square" scanner style options as parameters.
- Extensively test.

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.

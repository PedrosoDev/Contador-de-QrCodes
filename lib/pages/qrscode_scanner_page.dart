import 'dart:async';

import 'package:contador_de_qrcode/components/qrcode_scanner.dart';
import 'package:contador_de_qrcode/pages/qrcode_form_page.dart';
import 'package:contador_de_qrcode/repositories/qrcode_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class QrCodeScannerPage extends StatefulWidget {
  @override
  _QrCodeScannerPageState createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  Timer? timer;

  bool isCooldown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QrCodeScanner(
        callback: (barcode) {
          if (this.isCooldown) return;

          startCooldown();
          final provider =
              Provider.of<QrCodesListRepository>(context, listen: false);
          final qrCode = provider.getQrCode(barcode.code);

          Vibrate.vibrate();

          if (qrCode != null) {
            Get.snackbar(
              'Qr Code Escaneado Com Sucesso!',
              'Adicionando mais 1 em ${qrCode.name}',
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.only(bottom: 10),
            );
            provider.incrementCounter(index: provider.list.indexOf(qrCode));
          } else {
            Get.snackbar(
              'Qr Code Não Encontrado!',
              'Por Favor Cadastre esse Qr Code!',
              /*onTap: (snack) {
                Get.to(QrCodeFormPage(code: barcode.code));
              },*/
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.only(bottom: 10),
            );
          }
        },
      ),
    );
  }

  startCooldown() {
    int counter = 0;
    this.isCooldown = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (counter == 2) {
        timer.cancel();
        this.isCooldown = false;
      }
      counter++;
    });
  }
}

import 'package:contador_de_qrcode/constante.dart';
import 'package:contador_de_qrcode/pages/home_page.dart';
import 'package:contador_de_qrcode/repositories/qrcode_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'config/hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();

  runApp(ChangeNotifierProvider(
    create: (context) => QrCodesListRepository(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: false,
      title: 'Contador de Qr Code',
      theme: ThemeData(
          primaryColor: AppColors.green,
          textTheme: GoogleFonts.robotoTextTheme()),
      home: HomePage(),
    );
  }
}

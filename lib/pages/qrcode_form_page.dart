import 'package:contador_de_qrcode/components/qrcode_scanner.dart';
import 'package:contador_de_qrcode/constante.dart';
import 'package:contador_de_qrcode/models/qrcode_list_model.dart';
import 'package:contador_de_qrcode/repositories/qrcode_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class QrCodeFormPage extends StatefulWidget {
  final QrcodeListModel? qrCode;
  final String? code;

  QrCodeFormPage({Key? key, this.qrCode, this.code}) : super(key: key);

  @override
  _QrCodeFormPageState createState() => _QrCodeFormPageState();
}

class _QrCodeFormPageState extends State<QrCodeFormPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  String _qrCode = "";
  late final _editable;
  String menssageError = "";

  @override
  void initState() {
    super.initState();
    _name.text = (widget.qrCode == null ? "" : widget.qrCode!.name);
    _qrCode =
        (widget.qrCode == null ? (widget.code ?? "") : widget.qrCode!.value);
    _editable = (widget.qrCode == null ? false : true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              children: [
                Text(
                  '${_editable ? 'Editar' : 'Adicionar'} Qr Code',
                  style: TextStyle(fontSize: 32, color: AppColors.grey),
                ),
                SizedBox(height: 70),
                Form(
                  key: _form,
                  child: TextFormField(
                    controller: _name,
                    style: TextStyle(fontSize: 18, color: AppColors.grey),
                    cursorColor: AppColors.green,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Nome do Qr Code',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: AppColors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.green)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o nome do QrCode';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 70,
                  width: 215,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        menssageError = "";
                      });
                      Get.to(QrCodeScanner(
                        callback: (barcode) {
                          _qrCode = barcode.code;
                          Get.back();

                          Vibrate.vibrate();

                          Get.snackbar(
                            'Sucesso!',
                            'Qr Code escaneado com sucesso.',
                            snackPosition: SnackPosition.BOTTOM,
                            margin: EdgeInsets.only(bottom: 10),
                          );
                        },
                      ));
                    },
                    style: TextButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: AppColors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/qr_code.svg',
                          color: Colors.white,
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Escanear',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Text(
                    '$menssageError',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(height: 90),
                Container(
                  height: 70,
                  width: 215,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_editable) {
                        editQrCode(context);
                      } else {
                        addQrCode(context);
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: AppColors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _editable ? 'Editar' : 'Adicionar',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addQrCode(BuildContext context) {
    final provider = Provider.of<QrCodesListRepository>(context, listen: false);
    if (_form.currentState!.validate()) {
      if (_qrCode.isEmpty) {
        setState(() {
          menssageError = 'Escaneie um Qr Code!';
        });
        return;
      }

      if (provider.getQrCode(_qrCode) != null) {
        setState(() {
          menssageError = 'Esse Qr Code já foi cadastrado!';
        });
        return;
      }

      provider.addQrCode(QrcodeListModel(_name.text, _qrCode));
      if (Get.isSnackbarOpen!) Navigator.pop(context, false);
      Navigator.pop(context, false);
    }
  }

  void editQrCode(BuildContext context) {
    final provider = Provider.of<QrCodesListRepository>(context, listen: false);
    if (_form.currentState!.validate()) {
      if (_qrCode.isEmpty) {
        setState(() {
          menssageError = 'Escaneie um Qr Code!';
        });
        return;
      }

      if (provider.getQrCode(_qrCode) != null) {
        if (provider.getQrCode(_qrCode) != widget.qrCode) {
          setState(() {
            menssageError = 'Esse Qr Code já foi cadastrado!';
          });
          return;
        }
      }

      provider.editQrCode(widget.qrCode!, QrcodeListModel(_name.text, _qrCode));
      if (Get.isSnackbarOpen!) Navigator.pop(context, false);
      Navigator.pop(context, false);
    }
  }
}

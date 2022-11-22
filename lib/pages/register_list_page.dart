import 'package:contador_de_qrcode/components/content_list.dart';
import 'package:contador_de_qrcode/constante.dart';
import 'package:contador_de_qrcode/models/qrcode_list_model.dart';
import 'package:contador_de_qrcode/pages/qrcode_form_page.dart';
import 'package:contador_de_qrcode/repositories/qrcode_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RegisterListPage extends StatelessWidget {
  RegisterListPage({Key? key}) : super(key: key);

  void addQrCode() {
    Get.to(QrCodeFormPage());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Qr Code Cadastrados',
                style: TextStyle(fontSize: 32, color: AppColors.grey),
              ),
              SizedBox(
                height: 65,
              ),
              Expanded(
                child: Consumer<QrCodesListRepository>(
                  builder: (context, repository, child) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: repository.list.isEmpty
                            ? [
                                SvgPicture.asset(
                                  'assets/images/ghost.svg',
                                  color: AppColors.grey.withOpacity(0.6),
                                  height: 100,
                                  width: 100,
                                ),
                                Text(
                                  'Não há nada aqui!',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.grey.withOpacity(0.6)),
                                ),
                              ]
                            : repository.list
                                .map((e) => _buildListView(e, context))
                                .toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FittedBox(
          child: FloatingActionButton(
            child: Icon(
              Icons.add,
            ),
            backgroundColor: AppColors.green,
            onPressed: () => addQrCode(),
          ),
        ),
      ),
    );
  }

  openAlertDialog(BuildContext context, QrcodeListModel qrCode) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Você realmente deseja apagar esse Qr Code?'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: TextButton.styleFrom(
                  primary: AppColors.red,
                ),
                child: Text(
                  'Não',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 20,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<QrCodesListRepository>(context, listen: false)
                      .removeQrCode(qrCode);
                  Navigator.pop(context, false);
                },
                style: TextButton.styleFrom(
                  primary: AppColors.green,
                ),
                child: Text(
                  'Sim',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        });
  }

  ContentList _buildListView(QrcodeListModel list, BuildContext context) {
    return ContentList(
      margin: EdgeInsets.only(bottom: 10),
      leftWidget: Expanded(
        child: Text(
          list.name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      rightWidget: Row(
        children: [
          TextButton(
            onPressed: () {
              Get.to(QrCodeFormPage(qrCode: list));
            },
            style: TextButton.styleFrom(
              primary: AppColors.green,
            ),
            child: SvgPicture.asset(
              'assets/images/edit.svg',
              height: 23,
              width: 18,
            ),
          ),
          TextButton(
            onPressed: () {
              openAlertDialog(context, list);
            },
            style: TextButton.styleFrom(
              primary: AppColors.red,
            ),
            child: SvgPicture.asset(
              'assets/images/trash.svg',
              height: 23,
              width: 20,
            ),
          ),
        ],
      ),
    );
  }
}

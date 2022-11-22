import 'package:contador_de_qrcode/components/content_list.dart';
import 'package:contador_de_qrcode/models/qrcode_list_model.dart';
import 'package:contador_de_qrcode/repositories/qrcode_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../constante.dart';

class ListPage extends StatelessWidget {
  ListPage({Key? key}) : super(key: key);

  final logic = Get.put(QrCodesListRepository());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 50, left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Contagens',
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
                                .map((e) => _buildListView(e))
                                .toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ContentList _buildListView(QrcodeListModel list) {
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
      rightWidget: Text(
        '${list.counter}',
        style: TextStyle(
          fontSize: 25,
        ),
      ),
    );
  }
}

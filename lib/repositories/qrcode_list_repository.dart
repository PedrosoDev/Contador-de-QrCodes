import 'dart:collection';
import 'dart:convert';

import 'package:contador_de_qrcode/models/qrcode_list_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class QrCodesListRepository extends ChangeNotifier {
  late Box box;
  List<QrcodeListModel> _list = [];
  final HashMap<String, QrcodeListModel> _qrCodeMap = HashMap();

  UnmodifiableListView<QrcodeListModel> get list => UnmodifiableListView(_list);

  QrCodesListRepository() {
    _start();
  }

  void incrementCounter({required int index}) async {
    _list[index].counter++;

    await _saveList();

    notifyListeners();
  }

  QrcodeListModel? getQrCode(String code) {
    return (_qrCodeMap.containsKey(code) ? _qrCodeMap[code] : null);
  }

  void addQrCode(QrcodeListModel qrCode) async {
    _list.add(qrCode);
    _qrCodeMap.putIfAbsent(qrCode.value, () => qrCode);

    await _saveList();

    notifyListeners();
  }

  void editQrCode(QrcodeListModel qrCode, QrcodeListModel qrCodeEdit) async {
    int index = _list.indexOf(qrCode);
    _list.removeAt(index);
    _list.insert(index, qrCodeEdit);

    _qrCodeMap.remove(qrCode.value);
    _qrCodeMap.putIfAbsent(qrCodeEdit.value, () => qrCodeEdit);

    await _saveList();

    notifyListeners();
  }

  Future<void> removeQrCode(QrcodeListModel qrCode) async {
    int index = _list.indexOf(qrCode);
    _list.removeAt(index);

    _qrCodeMap.remove(qrCode.value);

    await _saveList();

    notifyListeners();
  }

  _start() async {
    await _openBox();
    await _readList();
  }

  _openBox() async {
    box = await Hive.openBox('QrCodeList');
  }

  _saveList() {
    box.clear();
    _list.forEach((qrCode) {
      if (_list.any((atual) => atual.value == qrCode.value)) {
        box.put(qrCode.value, json.encode(qrCode.toJson()));
      }
    });
  }

  _readList() async {
    box.keys.forEach((key) async {
      print('Read: ${box.get(key)}');
      QrcodeListModel qrCode =
          QrcodeListModel.fromMap(json.decode(box.get(key)))!;
      _list.add(qrCode);
      _qrCodeMap.putIfAbsent(qrCode.value, () => qrCode);
    });
    notifyListeners();
  }
}

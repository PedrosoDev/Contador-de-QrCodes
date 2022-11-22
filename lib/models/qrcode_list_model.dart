class QrcodeListModel {
  final String name;
  final String value;
  int counter = 0;

  QrcodeListModel(this.name, this.value);

  static QrcodeListModel? fromMap(Map<String, dynamic> map) {
    QrcodeListModel qrcodeListModelBean =
        QrcodeListModel(map['name'], map['value']);
    qrcodeListModelBean.counter = map['counter'];
    return qrcodeListModelBean;
  }

  Map toJson() => {
        "name": name,
        "value": value,
        "counter": counter,
      };
}

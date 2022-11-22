import 'package:flutter/material.dart';

class ContentList extends StatefulWidget {
  final Widget leftWidget;
  final Widget rightWidget;
  final EdgeInsetsGeometry? margin;
  ContentList(
      {Key? key,
      required this.leftWidget,
      required this.rightWidget,
      this.margin})
      : super(key: key);

  @override
  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 340,
      margin: widget.margin,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 6,
                offset: Offset(0, 3))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          this.widget.leftWidget,
          SizedBox(width: 5),
          this.widget.rightWidget
        ],
      ),
    );
  }
}

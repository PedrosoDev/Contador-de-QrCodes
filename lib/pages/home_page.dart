import 'package:contador_de_qrcode/constante.dart';
import 'package:contador_de_qrcode/pages/list_page.dart';
import 'package:contador_de_qrcode/pages/qrscode_scanner_page.dart';
import 'package:contador_de_qrcode/pages/register_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPage);
  }

  setCurrentPage(page) {
    setState(() {
      currentPage = page;
    });
  }

  final double sizeSvg = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          RegisterListPage(),
          QrCodeScannerPage(),
          ListPage(),
        ],
        onPageChanged: setCurrentPage,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 9,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentPage,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/create.svg',
                height: sizeSvg,
                width: sizeSvg,
                color: AppColors.grey,
              ),
              activeIcon: SvgPicture.asset(
                'assets/images/create.svg',
                height: sizeSvg,
                width: sizeSvg,
                color: AppColors.green,
              ),
              label: 'Cadastro',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/qr_code.svg',
                height: sizeSvg,
                width: sizeSvg,
                color: AppColors.grey,
              ),
              activeIcon: SvgPicture.asset(
                'assets/images/qr_code.svg',
                height: sizeSvg,
                width: sizeSvg,
                color: AppColors.green,
              ),
              label: 'Scanner',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/papers.svg',
                height: sizeSvg,
                width: sizeSvg,
                color: AppColors.grey,
              ),
              activeIcon: SvgPicture.asset(
                'assets/images/papers.svg',
                height: sizeSvg,
                width: sizeSvg,
                color: AppColors.green,
              ),
              label: 'Scanner',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: (indexPage) {
            pageController.animateToPage(
              indexPage,
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}

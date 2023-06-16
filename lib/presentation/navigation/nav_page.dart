import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparkle_mechanic/presentation/navigation/settings.dart';
import '../../business/constants/constant.dart';
import 'home_page.dart';

class BottomNavigationPages extends StatefulWidget {
  @override
  State<BottomNavigationPages> createState() => _BottomNavigationPagesState();
}

class _BottomNavigationPagesState extends State<BottomNavigationPages> {
  int _selectindex = 0;

  List navPage = [HomePage(),Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: navPage[_selectindex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectindex,
        onTap: (value) => setState(() {
          _selectindex = value;
        }),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset('assets/icons/home.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: Colors.grey,),
            activeIcon: Icon(Icons.settings,color: MyConstant.mainColor,),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

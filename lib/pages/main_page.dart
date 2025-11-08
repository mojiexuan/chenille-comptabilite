import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/pages/home/home_page.dart';
import 'package:chenille_comptabilite/pages/detail/detail_page.dart';
import 'package:chenille_comptabilite/pages/add/add_transaction_page.dart';
import 'package:chenille_comptabilite/pages/statistics/statistics_page.dart';
import 'package:chenille_comptabilite/pages/profile/profile_page.dart';

/// 主页面（底部导航栏）
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const DetailPage(),
    const SizedBox.shrink(), // 占位，实际是浮动按钮
    const StatisticsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            elevation: 0,
            backgroundColor: Colors.transparent,
            onTap: (index) {
              if (index == 2) {
                // 点击中间的加号，打开记账页面
                _openAddTransactionPage();
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: '首页',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: '明细',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle, size: 36),
                label: '记账',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                activeIcon: Icon(Icons.bar_chart),
                label: '统计',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: '我的',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 打开记账页面
  void _openAddTransactionPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddTransactionPage(),
        fullscreenDialog: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/pages/splash/widgets/splash_logo.dart';

/// 启动页内容组件
class SplashContent extends StatelessWidget {
  final String slogan;

  const SplashContent({
    super.key,
    required this.slogan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 应用Logo
        const SplashLogo(),
        const SizedBox(height: 30),
        // 应用名称
        const Text(
          '毛虫记账',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        // 随机文案
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            slogan,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 50),
        // 加载指示器
        SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
}

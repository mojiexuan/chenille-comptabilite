import 'package:flutter/material.dart';

/// 应用主题配置
class AppTheme {
  // 主色调 - 暖色系
  static const Color primaryColor = Color(0xFFFF8A65); // 温暖的橙色
  static const Color secondaryColor = Color(0xFFFFB74D); // 柔和的黄橙色
  static const Color accentColor = Color(0xFFFFD54F); // 明亮的黄色

  // 功能色
  static const Color incomeColor = Color(0xFF66BB6A); // 收入绿色
  static const Color expenseColor = Color(0xFFEF5350); // 支出红色

  // 背景色
  static const Color backgroundColor = Color(0xFFFFFAF3); // 温暖的米白色（更浅）
  static const Color cardColor = Color(0xFFFFFFFF);

  // 文字颜色
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);

  // UI常量
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  /// 获取主题数据
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: const CardThemeData(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textHint,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

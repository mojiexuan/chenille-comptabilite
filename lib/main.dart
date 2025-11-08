import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/services/storage_service.dart';
import 'package:chenille_comptabilite/pages/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  await StorageService.init();

  // 设置全面屏沉浸式模式
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge, // 边到边显示
  );

  // 设置系统UI样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏透明
      statusBarIconBrightness: Brightness.dark, // 状态栏图标深色
      systemNavigationBarColor: Colors.transparent, // 底部导航栏透明
      systemNavigationBarIconBrightness: Brightness.dark, // 底部导航栏图标深色
      systemNavigationBarDividerColor: Colors.transparent, // 分割线透明
    ),
  );

  runApp(const MyApp());
}

/// 应用根组件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        title: '毛虫记账',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh', 'CN'), // 简体中文
        ],
        locale: const Locale('zh', 'CN'),
        home: const SplashPage(), // 启动页作为初始页面
      ),
    );
  }
}

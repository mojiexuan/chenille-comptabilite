import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/config/splash_slogans.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/services/version_service.dart';
import 'package:chenille_comptabilite/pages/main_page.dart';
import 'package:chenille_comptabilite/pages/splash/widgets/splash_content.dart';

/// 启动页
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late String _slogan;

  @override
  void initState() {
    super.initState();
    _initializeSystemUI();
    _initializeAnimations();
    _loadDataAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    // 确保退出时恢复系统UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: _buildGradientDecoration(),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: SplashContent(slogan: _slogan),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// 初始化系统UI
  void _initializeSystemUI() {
    // 隐藏状态栏和导航栏，实现真全面屏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  /// 初始化动画
  void _initializeAnimations() {
    // 获取随机文案
    _slogan = SplashSlogans.getRandom();

    // 初始化动画控制器
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 淡入动画
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // 缩放动画
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // 启动动画
    _controller.forward();
  }

  /// 构建渐变装饰
  BoxDecoration _buildGradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryColor.withOpacity(0.1),
          Colors.white,
          AppTheme.secondaryColor.withOpacity(0.1),
        ],
      ),
    );
  }

  /// 加载数据并跳转到主页
  Future<void> _loadDataAndNavigate() async {
    // 预加载数据
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.init();

    // 初始化版本服务
    await _initVersionService();

    // 等待至少2秒，确保用户能看到启动页
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      _restoreSystemUI();
      _navigateToMainPage();
    }
  }

  /// 初始化版本服务并自动检测更新
  Future<void> _initVersionService() async {
    try {
      final versionService = VersionService();
      await versionService.init();

      // 自动检测更新（每天只检测一次）
      if (versionService.shouldAutoCheck()) {
        versionService.checkUpdate(manual: false);
      }
    } catch (e) {
      debugPrint('[SplashPage] 初始化版本服务失败：$e');
    }
  }

  /// 恢复系统UI
  void _restoreSystemUI() {
    // 恢复系统UI显示（边到边模式）
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // 恢复系统UI样式
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  /// 导航到主页
  void _navigateToMainPage() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}

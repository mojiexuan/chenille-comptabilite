import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';

/// 启动页Logo组件
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: _buildLogoImage(),
      ),
    );
  }

  /// 构建Logo图片（支持png和jpg，带降级处理）
  Widget _buildLogoImage() {
    return Image.asset(
      'assets/images/logo.png',
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // png加载失败，尝试jpg
        return Image.asset(
          'assets/images/logo.jpg',
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error2, stackTrace2) {
            // jpg也失败，显示默认图标
            return Container(
              color: AppTheme.primaryColor,
              child: const Icon(
                Icons.pets,
                size: 60,
                color: Colors.white,
              ),
            );
          },
        );
      },
    );
  }
}

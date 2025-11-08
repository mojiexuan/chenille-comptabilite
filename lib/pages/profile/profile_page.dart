import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/widgets/custom_app_bar.dart';
import 'package:chenille_comptabilite/pages/profile/handlers/profile_action_handler.dart';
import 'package:chenille_comptabilite/pages/profile/widgets/user_info_card.dart';
import 'package:chenille_comptabilite/pages/profile/widgets/profile_section.dart';
import 'package:chenille_comptabilite/pages/profile/widgets/profile_menu_item.dart';

/// 我的页面
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    return Container(
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          const CustomAppBar(title: '我的'),
          Expanded(
            child: ListView(
              children: [
                // 用户信息卡片
                const UserInfoCard(),
                const SizedBox(height: 16),

                // 数据管理
                ProfileSection(
                  title: '数据管理',
                  children: [
                    ProfileMenuItem(
                      icon: Icons.file_download_outlined,
                      title: '导出数据',
                      subtitle: '备份到本地存储',
                      onTap: () => ProfileActionHandler.exportData(
                          context, dataProvider),
                    ),
                    ProfileMenuItem(
                      icon: Icons.file_upload_outlined,
                      title: '导入数据',
                      subtitle: '从备份文件恢复',
                      onTap: () => ProfileActionHandler.importData(
                          context, dataProvider),
                    ),
                    ProfileMenuItem(
                      icon: Icons.delete_outline,
                      title: '清空数据',
                      subtitle: '删除所有记账数据',
                      textColor: Colors.red,
                      onTap: () =>
                          ProfileActionHandler.clearData(context, dataProvider),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 关于应用
                ProfileSection(
                  title: '关于',
                  children: [
                    ProfileMenuItem(
                      icon: Icons.info_outline,
                      title: '关于毛虫记账',
                      subtitle: 'v1.0.0',
                      onTap: () => ProfileActionHandler.showAbout(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

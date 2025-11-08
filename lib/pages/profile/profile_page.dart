import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/services/backup_service.dart';
import 'package:chenille_comptabilite/widgets/common_dialog.dart';
import 'package:chenille_comptabilite/widgets/toast.dart';
import 'package:chenille_comptabilite/widgets/custom_app_bar.dart';
import 'package:chenille_comptabilite/widgets/backup_export_dialog.dart';
import 'package:chenille_comptabilite/widgets/backup_import_dialog.dart';

/// 我的页面
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          const CustomAppBar(title: '我的'),
          Expanded(
            child: ListView(
              children: [
                // 用户信息卡片
                _buildUserCard(context),
                const SizedBox(height: 16),
                // 数据管理
                _buildSection(
                  title: '数据管理',
                  children: [
                    _buildMenuItem(
                      icon: Icons.file_download_outlined,
                      title: '导出数据',
                      subtitle: '备份到本地存储',
                      onTap: () => _exportData(context),
                    ),
                    _buildMenuItem(
                      icon: Icons.file_upload_outlined,
                      title: '导入数据',
                      subtitle: '从备份文件恢复',
                      onTap: () => _importData(context),
                    ),
                    _buildMenuItem(
                      icon: Icons.delete_outline,
                      title: '清空数据',
                      subtitle: '删除所有记账数据',
                      textColor: Colors.red,
                      onTap: () => _clearData(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 关于应用
                _buildSection(
                  title: '关于',
                  children: [
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: '关于毛虫记账',
                      subtitle: 'v1.0.0',
                      onTap: () => _showAbout(context),
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

  /// 构建用户卡片
  Widget _buildUserCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              size: 36,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '记账用户',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '坚持记账，理性消费',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建分组
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? AppTheme.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  /// 导出数据到文件
  Future<void> _exportData(BuildContext context) async {
    try {
      // 获取数据
      final dataProvider = Provider.of<DataProvider>(context, listen: false);

      // 判断是否有数据
      if (dataProvider.transactions.isEmpty) {
        Toast.warning(context, '暂无数据，无需导出');
        return;
      }

      // 显示加载提示
      CommonDialog.showLoading(context, message: '正在导出...');

      final data = dataProvider.exportData();

      // 导出到文件
      final result = await BackupService.exportToFile(data);

      if (context.mounted) {
        CommonDialog.hideLoading(context);

        if (result.success && result.file != null) {
          // 获取显示路径
          final displayPath =
              await BackupService.getChenilleDirectoryForDisplay();

          // 显示成功对话框
          await showDialog(
            context: context,
            builder: (context) => BackupExportDialog(
              exportedFile: result.file!,
              displayPath: displayPath,
            ),
          );
        } else if (result.permanentlyDenied) {
          // 权限被永久拒绝，引导用户去设置
          _showPermissionDeniedDialog(context);
        } else if (result.needsPermission) {
          // 权限被拒绝
          Toast.error(context, result.error ?? '需要存储权限');
        } else {
          // 其他错误
          Toast.error(context, result.error ?? '导出失败');
        }
      }
    } catch (e) {
      if (context.mounted) {
        CommonDialog.hideLoading(context);
        Toast.error(context, '导出失败：$e');
      }
    }
  }

  /// 显示权限被拒绝对话框
  Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    final goToSettings = await CommonDialog.showConfirm(
      context,
      title: '需要存储权限',
      content: '导出数据需要访问存储空间。\n'
          '您已拒绝该权限，请在设置中手动开启。',
      confirmText: '去设置',
      cancelText: '取消',
    );

    if (goToSettings == true) {
      await openAppSettings();
    }
  }

  /// 导入数据从文件
  Future<void> _importData(BuildContext context) async {
    try {
      // 显示文件选择对话框
      final file = await showDialog<File>(
        context: context,
        builder: (context) => const BackupImportDialog(),
      );

      if (file == null) return;

      // 读取文件数据
      final data = await BackupService.importFromFile(file);

      if (data == null) {
        if (context.mounted) {
          Toast.error(context, '文件格式错误，请选择有效的备份文件');
        }
        return;
      }

      // 获取数据提供者
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      final hasOldData = dataProvider.transactions.isNotEmpty ||
          dataProvider.categories.isNotEmpty;

      // 确认导入
      if (context.mounted) {
        final confirm = await CommonDialog.showConfirm(
          context,
          title: '确认导入',
          content:
              hasOldData ? '导入数据会覆盖现有数据。\n系统会先自动备份当前数据，是否继续？' : '是否导入该备份文件？',
        );

        if (confirm != true) return;

        CommonDialog.showLoading(context, message: '导入中...');
      }

      // 先备份当前数据（如果有）
      if (hasOldData) {
        try {
          await BackupService.exportToFile(dataProvider.exportData());
        } catch (e) {
          print('自动备份失败: $e');
          // 继续导入流程
        }
      }

      // 导入数据
      if (context.mounted) {
        await dataProvider.importData(data);

        if (context.mounted) {
          CommonDialog.hideLoading(context);
          Toast.success(context, hasOldData ? '导入成功，旧数据已自动备份' : '导入成功');
        }
      }
    } catch (e) {
      if (context.mounted) {
        CommonDialog.hideLoading(context);
        Toast.error(context, '导入失败：$e');
      }
    }
  }

  /// 清空数据
  Future<void> _clearData(BuildContext context) async {
    final confirm = await CommonDialog.showConfirm(
      context,
      title: '清空数据',
      content: '确定要清空所有数据吗？\n\n将会清空：\n• 所有交易记录\n• 自定义分类\n\n保留：\n• 默认分类',
      confirmText: '清空',
    );

    if (confirm != true) return;

    try {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      await dataProvider.clearData();

      if (context.mounted) {
        Toast.success(context, '数据已清空');
      }
    } catch (e) {
      if (context.mounted) {
        Toast.error(context, '清空失败：$e');
      }
    }
  }

  /// 显示关于
  Future<void> _showAbout(BuildContext context) async {
    await CommonDialog.showAlert(
      context,
      title: '关于毛虫记账',
      content: '版本：v1.0.0\n\n'
          '「毛虫记账」——不是理财专家，只是想帮你少掉几根头发。\n'
          '它不联网、不偷看你的钱包，不催你买理财。\n'
          '数据都在你怀里（准确说，是在你设备里），\n'
          '就像养在桌角的小毛虫，默默吃着数字，\n'
          '等有一天，你看着账本，\n'
          '才发现——哎呀，这小东西把你的生活都织成了一张漂亮的叶子。',
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/services/backup_service.dart';
import 'package:chenille_comptabilite/widgets/common_dialog.dart';
import 'package:chenille_comptabilite/widgets/toast.dart';
import 'package:chenille_comptabilite/widgets/backup_export_dialog.dart';
import 'package:chenille_comptabilite/widgets/backup_import_dialog.dart';

/// Profile页面操作处理器
/// 负责处理数据导入导出、清空等业务逻辑
class ProfileActionHandler {
  /// 导出数据到文件
  static Future<void> exportData(
    BuildContext context,
    DataProvider dataProvider,
  ) async {
    try {
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
          await _showPermissionDeniedDialog(context);
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
  static Future<void> _showPermissionDeniedDialog(BuildContext context) async {
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
  static Future<void> importData(
    BuildContext context,
    DataProvider dataProvider,
  ) async {
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
          debugPrint('自动备份失败: $e');
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
  static Future<void> clearData(
    BuildContext context,
    DataProvider dataProvider,
  ) async {
    final confirm = await CommonDialog.showConfirm(
      context,
      title: '清空数据',
      content: '确定要清空所有数据吗？\n\n将会清空：\n• 所有交易记录\n• 自定义分类\n\n保留：\n• 默认分类',
      confirmText: '清空',
    );

    if (confirm != true) return;

    try {
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

  /// 显示关于对话框
  static Future<void> showAbout(BuildContext context) async {
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

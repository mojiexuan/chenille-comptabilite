import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/services/version_service.dart';
import 'package:chenille_comptabilite/widgets/toast.dart';

/// 更新检测按钮组件
class UpdateCheckerButton extends StatefulWidget {
  const UpdateCheckerButton({super.key});

  @override
  State<UpdateCheckerButton> createState() => _UpdateCheckerButtonState();
}

class _UpdateCheckerButtonState extends State<UpdateCheckerButton> {
  final VersionService _versionService = VersionService();
  bool _checking = false;

  @override
  Widget build(BuildContext context) {
    final hasNewVersion = _versionService.hasNewVersion;

    return GestureDetector(
      onTap: _checkUpdate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        child: Row(
          children: [
            // 图标
            Icon(
              Icons.system_update_outlined,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            // 文本
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '检查更新',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '当前版本 ${_versionService.currentVersion}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textHint,
                    ),
                  ),
                ],
              ),
            ),
            // 右侧提示
            if (_checking)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (hasNewVersion)
              Row(
                children: [
                  // 新版本提示文字
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.expenseColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '有新版本',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 红点
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.expenseColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              )
            else
              Icon(
                Icons.chevron_right,
                color: AppTheme.textHint,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  /// 检查更新
  Future<void> _checkUpdate() async {
    if (_checking) return;

    setState(() {
      _checking = true;
    });

    try {
      final hasNewVersion = await _versionService.checkUpdate(manual: true);

      if (!mounted) return;

      if (hasNewVersion) {
        // 有新版本，显示更新详情对话框
        _showUpdateDialog();
      } else {
        // 已是最新版本
        Toast.show(context, '已是最新版本');
      }
    } catch (e) {
      if (!mounted) return;
      Toast.show(context, '检查更新失败，请稍后重试');
    } finally {
      if (mounted) {
        setState(() {
          _checking = false;
        });
      }
    }
  }

  /// 显示更新详情对话框
  void _showUpdateDialog() {
    final latestVersion = _versionService.latestVersionInfo;
    if (latestVersion == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('发现新版本'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 版本号
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '最新版本：',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  latestVersion.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 更新内容
            Text(
              '更新内容：',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              ),
              child: Text(
                latestVersion.content,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 清除新版本标记
              _versionService.clearNewVersionFlag();
              if (mounted) {
                setState(() {});
              }
            },
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }
}

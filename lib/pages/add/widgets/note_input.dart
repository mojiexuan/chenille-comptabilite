import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';

/// 备注输入组件
class NoteInput extends StatelessWidget {
  final String note;
  final ValueChanged<String> onNoteChanged;

  const NoteInput({
    super.key,
    required this.note,
    required this.onNoteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '备注（可选）',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLength: 100,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '添加备注信息...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(12),
          ),
          onChanged: onNoteChanged,
        ),
      ],
    );
  }
}


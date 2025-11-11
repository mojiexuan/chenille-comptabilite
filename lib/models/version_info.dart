/// 版本信息模型
class VersionInfo {
  /// 版本号
  final String name;

  /// 版本代码
  final int code;

  /// 更新内容
  final String content;

  VersionInfo({
    required this.name,
    required this.code,
    required this.content,
  });

  /// 从JSON创建对象
  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      name: json['name'] as String,
      code: json['code'] as int,
      content: json['content'] as String,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'content': content,
    };
  }

  /// 比较版本号（是否有新版本）
  bool isNewerThan(int currentCode) {
    return code > currentCode;
  }

  @override
  String toString() {
    return 'VersionInfo{name: $name, code: $code, content: $content}';
  }
}


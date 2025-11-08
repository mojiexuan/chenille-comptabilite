/// 分类模型
class Category {
  /// 分类ID
  final String id;

  /// 分类名称
  final String name;

  /// 分类类型：income(收入) 或 expense(支出)
  final String type;

  /// 图标代码
  final int iconCode;

  /// 是否为自定义分类
  final bool isCustom;

  /// 使用次数（用于排序）
  final int usageCount;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCode,
    this.isCustom = false,
    this.usageCount = 0,
  });

  /// 从JSON创建对象
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      iconCode: json['iconCode'] as int,
      isCustom: json['isCustom'] as bool? ?? false,
      usageCount: json['usageCount'] as int? ?? 0, // 兼容旧数据
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'iconCode': iconCode,
      'isCustom': isCustom,
      'usageCount': usageCount,
    };
  }

  /// 复制对象
  Category copyWith({
    String? id,
    String? name,
    String? type,
    int? iconCode,
    bool? isCustom,
    int? usageCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iconCode: iconCode ?? this.iconCode,
      isCustom: isCustom ?? this.isCustom,
      usageCount: usageCount ?? this.usageCount,
    );
  }

  /// 增加使用次数
  Category incrementUsage() {
    return copyWith(usageCount: usageCount + 1);
  }
}

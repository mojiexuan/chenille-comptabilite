/// 交易记录模型
class TransactionRecord {
  /// 交易ID
  final String id;
  
  /// 金额
  final double amount;
  
  /// 分类ID
  final String categoryId;
  
  /// 交易类型：income(收入) 或 expense(支出)
  final String type;
  
  /// 备注
  final String note;
  
  /// 交易日期
  final DateTime date;

  TransactionRecord({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.type,
    this.note = '',
    required this.date,
  });

  /// 从JSON创建对象
  factory TransactionRecord.fromJson(Map<String, dynamic> json) {
    return TransactionRecord(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      type: json['type'] as String,
      note: json['note'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'categoryId': categoryId,
      'type': type,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  /// 复制对象
  TransactionRecord copyWith({
    String? id,
    double? amount,
    String? categoryId,
    String? type,
    String? note,
    DateTime? date,
  }) {
    return TransactionRecord(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }
}


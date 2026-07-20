class QualificationModel {
  final int id;
  final String code;
  final String name;

  const QualificationModel({
    required this.id,
    required this.code,
    required this.name,
  });

  factory QualificationModel.fromJson(Map<String, dynamic> json) {
    return QualificationModel(
      id: json['id'] ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

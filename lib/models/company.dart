class Company {
  final String id;
  final String name;
  final String description;
  final String? logo;
  final String userId;
  final double totalRevenue;
  final double withdrawableRevenue;
  final DateTime createdAt;
  final DateTime updatedAt;

  Company({
    required this.id,
    required this.name,
    required this.description,
    this.logo,
    required this.userId,
    required this.totalRevenue,
    required this.withdrawableRevenue,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String,
      logo: json['logo'] as String?,
      userId: json['userId'] as String,
      totalRevenue: double.parse(json['totalRevenue'].toString()),
      withdrawableRevenue: double.parse(json['withdrawableRevenue'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'logo': logo,
        'userId': userId,
        'totalRevenue': totalRevenue,
        'withdrawableRevenue': withdrawableRevenue,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}


class EnemyModel {
  final String name;
  final int totalLife;
  final int level;
  late int currentLife;
  EnemyModel({
    required this.name,
    required this.totalLife,
    required this.level,
  }) {
    currentLife = totalLife;
  }

  factory EnemyModel.fromJson(Map<String, dynamic> json) {
    return EnemyModel(
      name: json['name'] ?? "Name unknown",
      totalLife: json['totalLife'] ?? 'Total life unknown',
      level: json['level'] ?? 'level unknown',
    );
  }

  reduceLife(int damages) {
    if (damages > currentLife) {
      currentLife = 0;
    } else {
      currentLife -= damages;
    }
  }
}
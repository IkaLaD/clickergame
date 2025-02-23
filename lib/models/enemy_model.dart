
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
    final enemyData = json['data'][0];
    return EnemyModel(
      name: enemyData['name'] ?? "Name unknown",
      totalLife: enemyData['total_life'] ?? 'Total life unknown',
      level: enemyData['level'] ?? 'level unknown',
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
class PlayerModel {
  final String pseudo;
  late int totalexp;
  late int level;
  late List augments;
  late int coins;

  PlayerModel({
    required this.pseudo,
    required this.totalexp,
    required this.level,
    required this.augments,
    required this.coins

  });

  bool get canBuyAugment => totalexp >= 100;

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    final playerData = json['data'][0];
    return PlayerModel(
      pseudo: playerData['pseudo'] ?? "Pseudo unknown",
      totalexp: playerData['total_experience'] ?? 'Total exp unknown',
      level: playerData['level'] ?? 'level unknown',
      augments: json['augments'] ?? [],
      coins: playerData['coins'] ?? 0,
    );
  }

  void gainExp(int exp) {
    totalexp += exp;
  }

  void _levelUp() {
    level += 1;
  }

  bool buyAugment() {
    if (totalexp >= 100) {
      totalexp -= 100;
      if (augments.isEmpty) {
        augments.add(1);
      } else {
        augments.add(augments.last + augments.length);
      }
      _levelUp();
      return true;
    }
    return false;
  }

  int getDamages() {
    int damages = 1;
    for (int i = 0; i < augments.length; i++) {
      damages += augments[i] as int;
    }
    return damages;
  }

  void gainCoin() {
    coins += 1;
  }
}

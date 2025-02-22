

class PlayerModel {
  final String pseudo;
  late int totalexp;
  late int level;
  late List augments;
  PlayerModel({
    required this.pseudo,
    required this.totalexp,
    required this.level,
    required this.augments,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      pseudo: json['pseudo'] ?? "Pseudo unknown",
      totalexp: json['totalexp'] ?? 'Total exp unknown',
      level: json['level'] ?? 'level unknown',
      augments: json['augments'] ?? []
    );
  }

  gainExp(int exp) {
    totalexp += exp;
  }

  _levelUp() {
    level += 1;
  }

  bool buyAugment() {
    if (totalexp >= 100) {
      totalexp -= 100;
      augments.add(augments[augments.length-1]+augments.length);
      _levelUp();
      return true;
    } else {
      return false;
    }
  }

  getDamages() {
    int damages = 0;
    for (int i = 0; i < augments.length; i++) {
      damages += augments[i] as int;
    }
    return damages;
  }

}
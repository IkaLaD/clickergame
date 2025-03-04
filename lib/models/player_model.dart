

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
    final playerData = json['data'][0];
    print(playerData);
    return PlayerModel(
      pseudo: playerData['pseudo'] ?? "Pseudo unknown",
      totalexp: playerData['total_experience'] ?? 'Total exp unknown',
      level: playerData['level'] ?? 'level unknown',
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
      if (augments.isEmpty) {
        augments.add(1);
      }
      else {
        augments.add(augments[augments.length-1]+augments.length);
        }
      _levelUp();
      return true;
    } else {
      return false;
    }
  }

  getDamages() {
    int damages = 1;
    for (int i = 0; i < augments.length; i++) {
      damages += augments[i] as int;
    }
    return damages;
  }

}
class Player {
  final String userName;
  final int trophies;

  Player({required this.userName, required this.trophies});

  factory Player.fromJson(dynamic json) {
    return Player(
        userName: json['name'] as String, trophies: json['trophies'] as int);
  }

  static List<Player> playersFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Player.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'Recipe {userName: $userName, trophies: $trophies}';
  }
}

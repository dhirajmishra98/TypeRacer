class GameState {
  final String id;
  final List words;
  final List players;
  final bool isJoin;
  final bool isOver;
  GameState({
    required this.id,
    required this.words,
    required this.players,
    required this.isJoin,
    required this.isOver,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'words': words,
        'players': players,
        'isJoin': isJoin,
        'isOver': isOver,
      };
}

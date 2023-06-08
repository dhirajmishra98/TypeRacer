import 'package:flutter/material.dart';
import 'package:typeracer/models/game_state.dart';

class GameStateProvider extends ChangeNotifier {
  GameState _gameState = GameState(
    id: "",
    words: [],
    players: [],
    isJoin: true,
    isOver: false,
  );

  Map<String, dynamic> get gameState => _gameState.toJson();

  void updateGameState({
    required id,
    required words,
    required players,
    required isJoin,
    required isOver,
  }) {
    _gameState = GameState(
      id: id,
      words: words,
      players: players,
      isJoin: isJoin,
      isOver: isOver,
    );
    notifyListeners();
  }

  
}

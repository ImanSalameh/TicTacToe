class GameState {
  List<String> board = List.filled(9, ''); 

  static const List<List<int>> winningConditions = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], 
    [0, 3, 6], [1, 4, 7], [2, 5, 8], 
    [0, 4, 8], [2, 4, 6], 
  ];

  bool isGameOver() {
    return isBoardFull() || isPlayerWinner('X') || isPlayerWinner('O');
  }

  bool isBoardFull() {
    return !board.contains('');
  }

  bool isPlayerWinner(String player) {
    for (var condition in winningConditions) {
      if (board[condition[0]] == player &&
          board[condition[1]] == player &&
          board[condition[2]] == player) {
        return true;
      }
    }
    return false;
  }

  void updateBoard(int index, String player) {
    board[index] = player;
  }

  void resetBoard() {
    board = List.filled(9, '');
  }
}

class GameLogic {
  int getBestMove(GameState gameState) {
    int bestScore = -1000;
    int bestMove = -1;

    for (int i = 0; i < 9; i++) {
      if (gameState.board[i] == '') {
        gameState.board[i] = 'O';
        int score = minimax(gameState, 0, false);
        gameState.board[i] = ''; 

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    return bestMove;
  }

  int minimax(GameState gameState, int depth, bool isMaximizing) {
    if (gameState.isPlayerWinner('X')) {
      return -10;
    } else if (gameState.isPlayerWinner('O')) {
      return 10;
    } else if (gameState.isBoardFull()) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (gameState.board[i] == '') {
          gameState.board[i] = 'O';
          int score = minimax(gameState, depth + 1, false);
          gameState.board[i] = '';
          bestScore = score > bestScore ? score : bestScore;
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (gameState.board[i] == '') {
          gameState.board[i] = 'X';
          int score = minimax(gameState, depth + 1, true);
          gameState.board[i] = ''; 
          bestScore = score < bestScore ? score : bestScore;
        }
      }
      return bestScore;
    }
  }
}

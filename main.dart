import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictac/game_logic.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GameState gameState;
  late GameLogic gameLogic;
  String? winner;

  late String currentPlayer; 

  int totalGames = 0;
  int playerWins = 0;
  int aiWins = 0;

  @override
  void initState() {
    super.initState();
    gameState = GameState();
    gameLogic = GameLogic();
    // Randomly decide who starts 
    currentPlayer = Random().nextBool() ? 'X' : 'O';
    if (currentPlayer == 'O') {
      // If AI starts first make it start
      aiMove();
    }
  }

  void restartGame() {
    setState(() {
      gameState.resetBoard();
      winner = null;
      currentPlayer = Random().nextBool() ? 'X' : 'O'; 
      if (currentPlayer == 'O') {
        aiMove();
      }
    });
  }

  void checkWinner() {
    if (gameState.isPlayerWinner('X')) {
      setState(() {
        winner = 'x';
        playerWins++;
      });
    } else if (gameState.isPlayerWinner('O')) {
      setState(() {
        winner = 'o';
        aiWins++;
      });
    } else if (gameState.isBoardFull()) {
      setState(() {
        winner = 'Draw';
      });
    }
    totalGames++;

    if (playerWins >= 3 || aiWins >= 3) {
      if (playerWins >= 3) {
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('You winn!'),
              content: Text('Player wins 3 games out of 5!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    resetCounters();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('You loose!'),
              content: Text('AI wins 3 games out of 5!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    resetCounters();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
      
      resetCounters();
    }
  }

  void resetCounters() {
    totalGames = 0;
    playerWins = 0;
    aiWins = 0;
  }

  void aiMove() {
    Future.delayed(Duration(milliseconds: 500), () {
      int aiMoveIndex = gameLogic.getBestMove(gameState);
      setState(() {
        gameState.updateBoard(aiMoveIndex, 'O');
        checkWinner();
        currentPlayer = 'X';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      backgroundColor: Colors.blueGrey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
             winner != null ? 'Winner: ${winner == 'o' ? 'Ai' : (winner == 'x' ? 'You' : winner)}' : 'Current Player: ${currentPlayer == 'o' ? 'Ai' : 'You'}',

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (gameState.board[index] == '' && winner == null && currentPlayer == 'X') {
                      setState(() {
                        gameState.updateBoard(index, 'X');
                        checkWinner();
                        if (winner == null && !gameState.isBoardFull()) {
                          currentPlayer = 'O';
                          aiMove();
                        }
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        gameState.board[index],
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                restartGame();
              },
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
class GridCell extends StatelessWidget {
  final String value;
  final Function onTap;

  const GridCell({
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 112, 139, 96)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }
}

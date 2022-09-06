import 'package:flutter/material.dart';
import 'package:xo_game/game_logic.dart';

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String activePlayer = 'X';
  bool isgameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool multiplayer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00061a),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: MediaQuery.of(context).orientation == Orientation.portrait ? Column(
            children: [
              ...firstBlock(),
              buildExpanded(),
              ...secondBlock(),
            ],
          ) : Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ...firstBlock(),
                    ...secondBlock(),
                  ],
                ),
              ),
              buildExpanded(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildExpanded() {
    return Expanded(
              child: GridView.count(
                padding: EdgeInsets.all(16),
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1.0,
                children: List.generate(
                  9,
                  (index) => InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: isgameOver ? null : () => onTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          Player.playerX.contains(index)
                              ? 'X'
                              : Player.playerY.contains(index)
                                  ? 'O'
                                  : '',
                          style: TextStyle(
                            color: Player.playerX.contains(index)
                                ? Colors.blue
                                : Colors.pink,
                            fontSize: 52,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
  }

  List<Widget> firstBlock(){
    return [
      SwitchListTile.adaptive(
        value: multiplayer,
        onChanged: (newValue) {
          setState(() {
            multiplayer = newValue;
          });
        },
        title: const Text(
          'Multiplayer',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        'It\'s $activePlayer turn'.toUpperCase(),
        style: const TextStyle(
          fontSize: 52,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 20,
      ),
    ];
  }

  List<Widget> secondBlock(){
    return [
      Text(
        result,
        style: const TextStyle(
          fontSize: 52,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerY = [];
            activePlayer = 'x';
            isgameOver = false;
            turn = 0;
            result = '';
          });
        },
        icon: const Icon(Icons.repeat),
        label: const Text('REPEAT'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.cyan),
        ),
      )
    ];
  }

  onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerY.isEmpty || !Player.playerY.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();

      if (!multiplayer && !isgameOver && turn!=9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;

      String winnerPlayer = game.checkWinner();
      if(winnerPlayer != ''){
        result = '$winnerPlayer is the winer';
      }
      else if(!isgameOver && turn ==9){
        result = 'Draw';
      }
    });
  }
}

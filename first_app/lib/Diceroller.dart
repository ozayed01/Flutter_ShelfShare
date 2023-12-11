import 'package:flutter/material.dart';
import 'dart:math';

class Diceroller extends StatefulWidget {
  const Diceroller({super.key});

  @override
  State<Diceroller> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<Diceroller> {
  @override
  var diceimage = 'assets/images/dice-2.png';
  Widget build(context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Image.asset(
        diceimage,
        width: 220,
        height: 220,
      ),
      const SizedBox(height:55),
      OutlinedButton(
          onPressed: rolldice,
          style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 27,
              )),
          child: const Text('Roll Dice'))
    ]);
  }

  void rolldice() {
    setState(() {
      var rng = Random().nextInt(5) +1;
      print('random number picked number is : $rng');
       diceimage = 'assets/images/dice-$rng.png';
    });
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.russoOneTextTheme()),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final diceList = [
    'images/d1.jpeg',
    'images/d2.png',
    'images/d3.jpeg',
    'images/d4.png',
    'images/d5.png',
    'images/d6.png',
  ];
  String result = '';
  int index1 = 0, index2 = 0, dicesum = 0, target = 0;
  final random = Random.secure();
  bool hastarget = false, showboard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEGAROLL'),
      ),
      body: Center(
        child: showboard ?
        Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        diceList[index1],
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        diceList[index2],
                        width: 80,
                        height: 80,
                      ),
                    ],
                  ),
                  Text(
                    'Dice Sum= $dicesum',
                    style: const TextStyle(fontSize: 20),
                  ),
                  if (hastarget)
                    Text(
                      'Your Target: $target\n Keep rolling to match $target',
                      style: TextStyle(fontSize: 20),
                    ),
                  Text(
                    result,
                    style: const TextStyle(fontSize: 26),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ElevatedButton(
                      onPressed: rollthedice,
                      child: const Text('ROLL'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: reset,
                    child: const Text('RESET'),
                  )
                ],
              )
            : StartPage(
          onStart: startGame,
        ),
      ),
    );
  }

  void rollthedice() {
    setState(() {
      index1 = random.nextInt(6);
      index2 = random.nextInt(6);
      dicesum = index1 + index2 + 2;
      if (hastarget) {
        check_target();
      } else {
        check_first_roll();
      }
    });
  }

  void check_target() {
    if (dicesum == target) {
      result = 'YOU WIN!';
    } else if (dicesum == 7) {
      result = 'YOU LOST';
    }
  }

  void check_first_roll() {
    if (dicesum == 7 || dicesum == 11) {
      result = 'YOU WIN !';
    } else if (dicesum == 2 || dicesum == 3 || dicesum == 12) {
      result = 'YOU LOST!!';
    } else {
      hastarget = true;
      target = dicesum;
    }
  }

  void reset() {
    setState(() {
      index1 = 0;
      index2 = 0;
      dicesum = 0;
      target = 0;
      result = '';
      hastarget = false;
      showboard=false;
    });
  }

  void startGame() {
    setState(() {
      showboard=true;
    });
  }
}
class StartPage extends StatelessWidget {
  final VoidCallback onStart;
  const StartPage({super.key,required this.onStart});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
       Image.asset('images/th.jpeg',width: 150,height: 100,),
        RichText(
            text: TextSpan(
              text: 'MEGA',
              style: GoogleFonts.russoOne().copyWith(color: Colors.red,fontSize: 40),
              children: [
                TextSpan(
                  text: 'ROLL',
                  style: GoogleFonts.russoOne().copyWith(color: Colors.blue),
                ),
              ],

            ),
        ),
        Spacer(),
        DiceButton( onPressed: onStart,
          label: 'START',
        ),
        DiceButton( onPressed: (){
show(context);
        },
          label: 'How To Play',
        ),
      ],
    );
  }

  void show(BuildContext context) {
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: const Text('Instruction'),
      content: const Text(gameRules),
      actions: [
        TextButton(onPressed: ()=> Navigator.pop(context),
            child: const
        Text('Close'),),
      ],
    ));
  }
}

class DiceButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const DiceButton({super.key, required this.label,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        width: 200,
        height: 60,
        child:ElevatedButton(
          onPressed: onPressed,
          child: Text(label,style: const TextStyle( fontSize: 20,color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }
}


const gameRules = '''
* AT THE FIRST ROLL, IF THE DICE SUM IS 7 OR 11, YOU WIN!
* AT THE FIRST ROLL, IF THE DICE SUM IS 2, 3 OR 12, YOU LOST!!
* AT THE FIRST ROLL, IF THE DICE SUM IS 4, 5, 6, 8, 9, 10, THEN THIS DICE SUM WILL BE YOUR TARGET POINT, AND KEEP ROLLING
* IF THE DICE SUM MATCHES YOUR TARGET POINT, YOU WIN!
* IF THE DICE SUM IS 7, YOU LOST!!
''';

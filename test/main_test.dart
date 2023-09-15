import 'package:flutter/material.dart';
import 'package:flutter_event_cards_example/event_data.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int animationSeconds = 1;
  double extraTitleMove = 0;
  double animationTitleMove = 100;
  List<double> extraPositionLeft = [0, 0, 0];
  List<double> animationPositionLeft = [250, 125, 125];
  List<double> extraPositionTop = [0, 0, 0];
  List<double> animationPositionTop = [50, 50, 50];
  List<double> extraSize = [0, 0, 0];
  List<double> animationSize = [-100, 100, 100];
  List<double> extraOpacity = [0, 0, 0];
  List<double> animationOpcity = [-0.35, 0.35, 0.35];
  double animationPostionFirstCard = 0;
  double animationPostionFollowingCards = 0;

  cardAnimation(details) async {
    setState(() {
      extraPositionLeft = animationPositionLeft;
      extraPositionTop = animationPositionTop;
      extraSize = animationSize;
      extraOpacity = animationOpcity;
      extraTitleMove = animationTitleMove;
    });

    await Future.delayed(Duration(seconds: animationSeconds), () {
      setState(() {
        animationSeconds = 0;
        goForward();
        extraSize = [0, 0, 0];
        extraPositionLeft = [0, 0, 0];
        extraPositionTop = [0, 0, 0];
        extraOpacity = [0, 0, 0];
        extraTitleMove = 0;
      });
    });

    await Future.delayed(const Duration(milliseconds: 100), () {
      animationSeconds = 1;
    });
  }

  goForward() {
    setState(() {
      eventData.add(eventData[0]);
      eventData.removeAt(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> generateEventCards() {
      List<Widget> allCards = [];

      for (int i = 0; i < eventData.length; i++) {
        if (i == 3) break;

        allCards.add(AnimatedPositioned(
          left: 125.0 * i - extraPositionLeft[i],
          top: 50.0 * i - extraPositionTop[2],
          duration: Duration(seconds: animationSeconds),
          child: GestureDetector(
            onHorizontalDragEnd: i == 0 ? cardAnimation : null,
            child: AnimatedContainer(
              height: MediaQuery.of(context).size.height * 0.5 -
                  100 * i +
                  extraSize[i],
              width: MediaQuery.of(context).size.width * 0.7 -
                  100 * i +
                  extraSize[i],
              duration: Duration(seconds: animationSeconds),
              child: AnimatedOpacity(
                opacity: 1.0 - i * 0.35 + extraOpacity[i],
                duration: Duration(seconds: animationSeconds),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      eventData[i]["image"],
                      fit: BoxFit.fill,
                    )),
              ),
            ),
          ),
        ));
      }

      return allCards.reversed.toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Stack(
              children: [
                AnimatedPositioned(
                  top: 0 - extraTitleMove,
                  left: 0,
                  duration: Duration(seconds: animationSeconds),
                  child: Container(
                    width: 300,
                    margin: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              eventData.first["title"],
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text(DateFormat.yMMMd().format(DateTime.parse(
                                eventData.first["date"])))
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.map),
                            const SizedBox(width: 10),
                            Text(eventData.first["location"])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.all(30),
            child: Stack(
              clipBehavior: Clip.none,
              children: generateEventCards(),
            ),
          ))
        ],
      ),
    );
  }
}

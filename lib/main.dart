import 'package:flutter/material.dart';
import 'dart:async';
import 'package:function_tree/function_tree.dart';

StreamController<String> streamController = StreamController<String>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Calculator', stream: streamController.stream));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.stream})
      : super(key: key);

  final String title;
  final Stream<String> stream;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> buttons = [
    "M+",
    "MC",
    "MR",
    "%",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "AC",
    "0",
    ".",
    "="
  ];

  @override
  void initState() {
    super.initState();
    widget.stream.listen((event) {
      onButtonPressed(event);
    });
  }

  String text = '0';
  num memory = 0;

  void onButtonPressed(String event) {
    setState(() {
      if (text == '0' && int.tryParse(event) != null) {
        text = event;
      } else {
        if (int.tryParse(event) == null) {
          switch (event) {
            case 'AC':
              text = '0';
              break;
            case 'MC':
              memory = 0;
              break;
            case 'MR':
              text = memory.toString();
              break;
            case 'M+':
              text = calculateExpression();
              memory += num.parse(text);
              break;
            case '.':
              text += event;
              break;
            case '=':
              text = calculateExpression();
              break;
            default:
              if (int.tryParse(text[text.length - 1]) == null) {
                changeLastOpetator(event);
              } else if (text != text.interpret().toString()) {
                text = calculateExpression();
              }
              if (event != '=') {
                text += event;
              }
              break;
          }
        } else {
          text += event;
        }
      }
    });
  }

  void changeLastOpetator(String event) {
    List<String> characters = text.split('');
    characters.removeLast();
    text = characters.join('');
  }

  String calculateExpression() {
    num number = text.interpret();
    if (number.toInt() - number == 0) {
      return number.toStringAsFixed(0);
    } else {
      return number.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  text,
                  maxLines: 3,
                  style: const TextStyle(
                      fontSize: 60, fontWeight: FontWeight.w500),
                )
              ]),
              const Padding(padding: EdgeInsets.all(8.0)),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: List.generate(20, (index) {
                  var buttonColor = Colors.blue;
                  if ((index + 1) % 4 == 0) {
                    buttonColor = Colors.orange;
                  }
                  return Center(
                      child: CalculatorButton(
                          buttonText: buttons[index],
                          buttonColor: buttonColor));
                }),
              ),
            ]),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton(
      {super.key, required this.buttonText, required this.buttonColor});

  final String buttonText;
  final MaterialColor buttonColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () => streamController.add(buttonText),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0))),
              backgroundColor: MaterialStateProperty.all(buttonColor),
              alignment: Alignment.center,
              fixedSize: MaterialStateProperty.all(const Size(100.0, 100.0))),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 32),
          )),
    );
  }
}

import 'package:ai_assistant/colors.dart';
import 'package:ai_assistant/screens/chat_screen.dart';
import 'package:ai_assistant/screens/splash_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Ai Chat',
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          theme: ThemeData.light(useMaterial3: true).copyWith(
              scaffoldBackgroundColor: Color.fromARGB(22, 22, 34, 255),
              appBarTheme: AppBarTheme(
                  backgroundColor: Color.fromARGB(21, 0, 1, 7))),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BounceInDown(child: Image.asset('assets/images/bot.png')),
          FadeInLeft(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'How may I help',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera Pro'),
              ),
            ),
          ),
          FadeInLeft(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                'you today?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera Pro'),
              ),
            ),
          ),
          FadeInRight(
            child: Column(
              children: [
                Text(
                  'Using this software, you can ask your',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  'questions and receive articles using',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  'artificial intelligence assistant',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          ZoomIn(
            child: Container(
                width: 300,
                height: 60,
                margin: EdgeInsets.only(top: 35),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ChatScreen()));
                  },
                  child: Text(
                    'Start a new chat',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete().mainFontColor,
                      foregroundColor: Pallete().mainFontColor),
                )),
          )
        ],
      ),
    );
  }
}

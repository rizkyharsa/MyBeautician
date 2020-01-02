import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_beautician/mainscreen.dart';
import 'package:my_beautician/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String _email, _password;
String urlLogin = "http://michannael.com/mybeautician/php/login_user.php";

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.purple[300]));
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.purple[300],
        primarySwatch: Colors.purple,
        accentColor: Colors.purple[300],
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/myBeautician4.png',
                scale: 1,
              ),
              SizedBox(
                height: 20,
              ),
              new ProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            //print('Sucess Login');
            loadpref(this.context);
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      child: CircularProgressIndicator(),
    ));
  }
}

void loadpref(BuildContext ctx) async {
  print('Inside loadpref()');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _email = (prefs.getString('email') ?? '');
  _password = (prefs.getString('pass') ?? '');
  print("Splash:Preference");
  print(_email);
  print(_password);
  if (_isEmailValid(_email ?? "no email")) {
    //try to login if got email;
    _onLogin(_email, _password, ctx);
  } else {
    //login as unregistered user
    User user = new User(
        name: "not register",
        email: "user@noregister",
        phone: "not register",
        radius: "15",
        credit: "0");
    Navigator.push(
        ctx, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
  }
}

bool _isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

void _onLogin(String email, String pass, BuildContext ctx) {
  http.post(urlLogin, body: {
    "email": _email,
    "password": _password,
  }).then((res) {
    print(res.statusCode);
    var string = res.body;
    List dres = string.split(",");
    print("SPLASH:loading");
    print(dres);
    if (dres[0] == "success") {
      User user = new User(
          name: dres[1],
          email: dres[2],
          phone: dres[3],
          radius: dres[4],
          credit: dres[5]);
      Navigator.push(
          ctx, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
    } else {
      //allow login as unregistered user
      User user = new User(
          name: "not register",
          email: "user@noregister",
          phone: "not register",
          radius: "15",
          credit: "0");

      Navigator.push(
          ctx, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
    }
  }).catchError((err) {
    print(err);
  });
}

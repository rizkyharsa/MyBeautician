import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_beautician/loginscreen.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

void main() => runApp(ResetPassword());

final TextEditingController _securityCodeController = TextEditingController();
final TextEditingController _newPasswordController = TextEditingController();
final TextEditingController _newPasswordController2 = TextEditingController();

String _secureCode = "";
String _newPassword = "";
String _newPassword2 = "";

bool _isCodeMatch = false;
String urlResetPass =
    'http://michannael.com/mybeautician/php/forgot_password.php';

String _email = "";

class ResetPassword extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ResetPassword> {
  @override
  void initState() {
    _loadResetEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.purple[300]));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('Forgot Account'),
            elevation: 20,
          ),
          body: SingleChildScrollView(
            child: new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: AssetImage('assets/images/background2.png'),
                      fit: BoxFit.fill)),
              child: new Container(
                padding: EdgeInsets.all(30),
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
                    TextField(
                      controller: _securityCodeController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Security Code',
                        labelStyle: new TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        icon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          minWidth: 120,
                          height: 45,
                          color: Colors.purple[300],
                          textColor: Colors.white,
                          child: Text(
                            'Cancel',
                            style: new TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          elevation: 5,
                          onPressed: _cancel,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          minWidth: 120,
                          height: 45,
                          color: Colors.purple[300],
                          textColor: Colors.white,
                          child: Text(
                            'OK',
                            style: new TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          elevation: 5,
                          onPressed: _checkCode,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: TextField(
                          enabled: _isCodeMatch,
                          controller: _newPasswordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                            hintStyle: new TextStyle(color: Colors.black54),
                            hintText: "New Password",
                          ),
                          obscureText: true),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: TextField(
                          enabled: _isCodeMatch,
                          controller: _newPasswordController2,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                            hintStyle: new TextStyle(color: Colors.black54),
                            hintText: "Re-type Password",
                          ),
                          obscureText: true),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      minWidth: 350,
                      height: 55,
                      color: Colors.purple[300],
                      textColor: Colors.white,
                      child: Text(
                        'Save',
                        style: new TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      elevation: 5,
                      onPressed: _updatePassword,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _loadResetEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = prefs.getString('resetPassEmail');

    print('Reset Password Email : $_email');
  }

  void _updatePassword() {
    _newPassword = _newPasswordController.text;
    _newPassword2 = _newPasswordController2.text;

    if (_isCodeMatch) {
      if (_newPassword == _newPassword2) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);
        pr.style(message: "Updating Password");
        pr.show();
        http.post(urlResetPass, body: {
          "email": _email,
          "password": _newPassword,
        }).then((res) {
          print("Password update : " + res.body);
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          if (res.body == "success") {
            pr.dismiss();
            _securityCodeController.text = "";
            _newPasswordController.text = "";
            _newPasswordController2.text = "";

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          } else {
            pr.dismiss();
          }
        }).catchError((err) {
          pr.dismiss();
          print(err);
        });
      } else {
        Toast.show('Password doesn\'t match', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      Toast.show('Enter Security Code', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _cancel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('secureCode');
    prefs.remove('resetPassEmail');

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  void _checkCode() {
    _secureCode = _securityCodeController.text;

    print("user input secure code : $_secureCode");

    _loadCode().then((onValue) {
      if (_secureCode == onValue) {
        _isCodeMatch = true;

        Toast.show('Correct Code', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {});
      } else {
        _isCodeMatch = false;
        Toast.show('Wrong Code', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });
  }

  Future<String> _loadCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = prefs.getString('secureCode');
    print('Reset Pass : saved secure code : ' + code);
    return code;
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

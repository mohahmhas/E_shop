// ignore_for_file: missing_return

import 'dart:math';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';

import 'package:flutter/material.dart';
import 'package:shop_app_ec/models/http_exception.dart';

import '../providers/auth.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1]),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2))
                        ]),
                    child: Text(
                      'My Shope',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          fontFamily: 'Anton'),
                    ),
                  ),
                ),
                Flexible(
                  child: AuthCard(),
                  flex: deviceSize.width > 600 ? 2 : 1,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'email': '', 'password': ''};
  var _isLoading = false;
  final _paswordController = TextEditingController();
  AnimationController? _controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.15), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future _submit() async {
    if (!_formKey.currentState!.validate()) {
      return null;
    } else {
      FocusScope.of(context).unfocus();
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_authMode == AuthMode.Login) {
          await Provider.of<Auth>(context, listen: false)
              .login(_authData['email']!, _authData['password']!);
        } else {
          await Provider.of<Auth>(context, listen: false)
              .signUp(_authData['email']!, _authData['password']!);
        }
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'this email address is already in use';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'this is not a valid email address';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'this password is too weak';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'could not finf a user with that email';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invaild Password';
        }
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errormessage =
            'Could not authenticate you. please try again later.';
        _showErrorDialog(errormessage);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAouthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller!.reverse();
    }
    print(_authMode);
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred !'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay!'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        constraints:
            BoxConstraints(maxHeight: _authMode == AuthMode.SignUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E=mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty || !val.contains('@')) {
                        return 'Invaild E-mail';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _authData['email'] = val!;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _paswordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 5) {
                        return 'Invaild Passwored';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _authData['password'] = val!;
                    },
                  ),
                  AnimatedContainer(
                    duration: Duration(microseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation!,
                      child: SlideTransition(
                        position: _slideAnimation!,
                        child: TextFormField(
                          obscureText: true,
                          enabled: _authMode == AuthMode.SignUp,
                          decoration: InputDecoration(
                            labelText: 'ConFirm Password',
                          ),
                          validator: _authMode == AuthMode.SignUp
                              ? (val) {
                                  if (val != _paswordController.text) {
                                    return 'Invaild Do not  match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.SignUp ? 70 : 0,
                        maxHeight: _authMode == AuthMode.SignUp ? 120 : 0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isLoading) CircularProgressIndicator(),
                  ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.SignUp ? 'Signup' : 'LogIn'),
                    onPressed: _submit,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: _switchAouthMode,
                      child: Text(
                          '${_authMode == AuthMode.Login ? 'SignUp' : 'Login'} Instead'))
                ],
              ),
            )),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shle_share/BottomBar/Profile/edit_profile.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isSignIn = true;

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredConfPassword = '';

  final _passwordController = TextEditingController();
  final _ConfPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _ConfPasswordController.dispose();

    super.dispose();
  }

  void _submit() async {
    final _isValid = _formKey.currentState!.validate();

    if (!_isValid) {
      return;
    }

    _formKey.currentState!.save();
    try {
      if (_isSignIn) {
        final userInfo = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userInfo = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredConfPassword);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditProfile(isFirst: true),
        ));
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message ?? 'Authentication Failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 39, 56),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              margin: const EdgeInsets.only(
                top: 30,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              width: 200,
              child: Image.asset('assets/images/book.png'),
            ),
            Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          TextFormField(
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                              label: const Text(
                                'Email',
                                style: TextStyle(fontSize: 17),
                              ),
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please Enter a Valid Email address';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredEmail = newValue!;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              label: const Text(
                                'Password',
                                style: TextStyle(fontSize: 17),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              prefixIcon: const Icon(Icons.password),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Please Enter a Valid Password it has to be 6+ charchters long ';
                              }
                              return null;
                            },
                            obscureText: true,
                            onSaved: (newValue) {
                              _enteredPassword = newValue!;
                            },
                          ),
                          const SizedBox(height: 15),
                          if (!_isSignIn)
                            TextFormField(
                              controller: _ConfPasswordController,
                              decoration: InputDecoration(
                                label: const Text(
                                  'Confirm Password',
                                  style: TextStyle(fontSize: 17),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                prefixIcon: const Icon(Icons.password),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().length < 6 ||
                                    _passwordController.value !=
                                        _ConfPasswordController.value) {
                                  return 'Passwords Doesn\'t Match';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredConfPassword = newValue!;
                              },
                              obscureText: true,
                            ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _submit,
                            child: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isSignIn = !_isSignIn;
                              });
                            },
                            child: Text(_isSignIn
                                ? 'Create an account'
                                : 'I already have an account'),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

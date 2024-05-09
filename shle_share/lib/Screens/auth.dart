import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shle_share/BottomBar/Profile/edit_profile.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.onBoarding});
  final bool? onBoarding;
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isSignIn = true;
  bool _isPasswordHidden = true;
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(
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
      backgroundColor: const Color.fromARGB(255, 213, 184, 155),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              margin: const EdgeInsets.only(
                top: 30,
                bottom: 0,
                left: 20,
                right: 20,
              ),
              width: 300,
              child: Image.asset('assets/images/book.png'),
            ),
            Text(
              'SHELF SHARE',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
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
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordHidden = !_isPasswordHidden;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Please Enter a Valid Password it has to be 6+ characters long ';
                              }
                              return null;
                            },
                            obscureText: _isPasswordHidden,
                            onSaved: (newValue) {
                              _enteredPassword = newValue!;
                            },
                          ),
                          if (!_isSignIn) const SizedBox(height: 15),
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
                                    _passwordController.text !=
                                        _ConfPasswordController.text) {
                                  return 'Passwords Doesn\'t Match';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredConfPassword = newValue!;
                              },
                              obscureText: true,
                            ),
                          const SizedBox(height: 15),
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

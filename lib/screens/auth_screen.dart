import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  final _email = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final _username = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';

  var _isAuthenticating = false;

  File? _selectedImage;

  // @override
  // void initState() {
  //   super.initState();
  //   usernameFocus.addListener(() {
  //     print("Has focus: ${usernameFocus.hasFocus}");
  //   });
  // }

  void _submit() async {
    final _isValid = _form.currentState!.validate();

    if (!_isValid || (!_isLogin && _selectedImage == null)) {
      // show error message
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 35, 36, 40),
              Color.fromARGB(255, 15, 34, 43),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (_isAuthenticating)
                //   const CircularProgressIndicator(),
                Logo(),
                if (!_isLogin)
                  UserImagePicker(
                    onPickImage: (pickedImage) {
                      _selectedImage = pickedImage;
                    },
                  ),
                EmailAddress(),
                if (!_isLogin) Username(),
                Password(),
                LoginSignupButton(),
                if (_isLogin) ForgottenPasswordButton(),
                const Spacer(),
                if (!_isLogin) AlreadyHaveAccount(),
                if (_isLogin) CreateNewAccountButton(),
                if (_isLogin) Meta(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Logo() {
    return Expanded(
      child: SizedBox(
        width: 60,
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }

  Widget EmailAddress() {
    return Column(
      children: [
        const SizedBox(height: 12),
        TextFormField(
          focusNode: _emailFocus,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 30, 43, 51),
            labelText: 'Email address',
            labelStyle: TextStyle(
                color: _emailFocus.hasFocus
                    ? Colors.white.withOpacity(0.7)
                    : Colors.white.withOpacity(0.2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 1,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          validator: (value) {
            if (value == null || value.trim().isEmpty || !value.contains('@')) {
              return 'Please enter a valid email address.';
            }
            return null;
          },
          onSaved: (value) {
            _enteredEmail = value!;
          },
        ),
      ],
    );
  }

  Widget Username() {
    return Column(
      children: [
        const SizedBox(height: 12),
        TextFormField(
          focusNode: _usernameFocus,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 30, 43, 51),
            labelText: 'Username',
            labelStyle: TextStyle(
                color: _usernameFocus.hasFocus
                    ? Colors.white.withOpacity(0.7)
                    : Colors.white.withOpacity(0.2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 1,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          validator: (value) {
            if (value == null || value.isEmpty || value.trim().length < 4) {
              return 'Please enter at least 4 characters.';
            }
            return null;
          },
          onSaved: (value) {
            _enteredUsername = value!;
          },
        ),
      ],
    );
  }

  Widget Password() {
    return Column(
      children: [
        const SizedBox(height: 12),
        TextFormField(
          focusNode: _passwordFocus,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 30, 43, 51),
            labelText: 'Password',
            labelStyle: TextStyle(
                color: _passwordFocus.hasFocus
                    ? Colors.white.withOpacity(0.7)
                    : Colors.white.withOpacity(0.2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 1,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 1,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.trim().length < 6) {
              return 'Password must be as least 6 characters long.';
            }
            return null;
          },
          onSaved: (value) {
            _enteredPassword = value!;
          },
        ),
      ],
    );
  }

  Widget LoginSignupButton() {
    return Column(
      children: [
        const SizedBox(height: 12),
        InkWell(
          onTap: _submit,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 100, 224),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              _isLogin ? 'Login' : 'Signup',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ForgottenPasswordButton() {
    return Column(
      children: [
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Forgotten password?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget AlreadyHaveAccount() {
    return Column(
      children: [
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _isLogin = !_isLogin;
            });
          },
          child: const Text(
            'Already have an account',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 0, 100, 224),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget CreateNewAccountButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color.fromARGB(255, 66, 139, 227),
          ),
        ),
        child: const Text(
          'Create new account',
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 66, 139, 227),
          ),
        ),
      ),
    );
  }

  Widget Meta() {
    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          width: 60,
          child: Image.asset('assets/images/meta.png'),
        ),
      ],
    );
  }
}

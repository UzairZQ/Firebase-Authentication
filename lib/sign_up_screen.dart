import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/main.dart';
import 'package:firebase_authentication/sign_in_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  late final String email;
  late final String password;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Screen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: 'Please Enter Email'),
              controller: emailController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(hintText: 'Please Enter Password'),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                email = emailController.text.toString();
                password = passwordController.text.toString();
                try {
                  await firebaseAuth
                      .createUserWithEmailAndPassword(
                          email: email, password: password)
                      .then((UserCredential userCredential) {
                    print('User Email:${userCredential.user.toString()}');
                  }).onError((FirebaseAuthException error, stackTrace) {
                    if (error.code == "email-already-in-use") {
                      print(
                          'The email address is already in use by another account');
                    }
                  });
                } catch (e) {
                  print('SignUp Error: ${e.toString()}');
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => SignInScreen()),
                  ),
                );
              },
              child: Text('Sign-Up'))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Go To Sign-In',
        ),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => SignInScreen()),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

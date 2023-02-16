import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/homescreen.dart';
import 'package:firebase_authentication/sign_up_screen.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Sign-In Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Please Enter Email"),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "Please Enter Password"),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.toString();
                String password = passwordController.text.toString();
                try {
                  await firebaseAuth
                      .signInWithEmailAndPassword(
                          email: email, password: password)
                      .then((UserCredential userCredential) {
                    print('User Email:${userCredential.user.toString()}');
                  }).onError((FirebaseAuthException error, stackTrace) {
                    if (error.code == "wrong-password") {
                      print('Password is incorrect');
                    } else if (error.code == "too-many-requests") {
                      print(
                          "Account temporarily locked due to too many requests");
                    } else if (error.code == "user-not-found") {
                      print("User not found");
                    }
                  });
                } catch (e) {
                  print('SignIn Error: ${e.toString()}');
                  return;
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => HomeScreen()),
                  ),
                );
              },
              child: Text('Sign-In'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Go To Sign-Up',
        ),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => SignUpScreen()),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

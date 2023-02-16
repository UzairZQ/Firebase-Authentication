import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/homescreen.dart';
import 'package:firebase_authentication/sign_up_screen.dart';
import 'package:flutter/material.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String verificationId = "";

  var phoneNumController = TextEditingController();
  var codeController = TextEditingController();
  bool isCodeSent = false;

  PhoneAuthComplete(BuildContext context, String sms_code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: sms_code);

    firebaseAuth
        .signInWithCredential(credential)
        .then((UserCredential user_credential) {
      print(
          'Sign In Successfully with the following user credentials: ${user_credential.user.toString()}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  VerifyPhoneNo(BuildContext context) {
    String phoneNo = phoneNumController.text.toString();
    try {
      firebaseAuth.verifyPhoneNumber(
        phoneNumber: '$phoneNo',
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          this.verificationId = credential.verificationId!;
          setState(() {
            codeController.text = credential.smsCode!;
          });
          print('Hello Your code is: ${credential.smsCode}');
        },
        verificationFailed: (FirebaseAuthException exception) {
          print('Hello FirebaseAuth code verification failed');
        },
        codeSent: ((verificationId, forceResendingToken) {
          this.verificationId = verificationId;
          setState(() {
            isCodeSent = true;
          });
          print('Firebase Auth code send');
        }),
        codeAutoRetrievalTimeout: ((verificationId) {
          print('Code retrieval timeout called');
        }),
      );
    } on FirebaseAuthException catch (error, _) {
      print('Firebase Auth Exception Error: ${error}');
    } catch (e) {
      print('Other exception in PhoneNumAuth: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    onVerifyTap() {
      if (!isCodeSent) {
        VerifyPhoneNo(context);
      } else {
        String code_sms = codeController.text.toString();
        PhoneAuthComplete(context, code_sms);
      }
    }

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
                controller: phoneNumController,
                decoration:
                    InputDecoration(hintText: "Please Enter Phone Number"),
                keyboardType: TextInputType.phone,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextFormField(
                controller: codeController,
                decoration:
                    InputDecoration(hintText: "Please Enter Verification Code"),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.green])),
              child: ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(3),
                    alignment: Alignment.center,
                    padding: MaterialStateProperty.all(const EdgeInsets.only(
                        right: 75, left: 75, top: 15, bottom: 15)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    )),
                onPressed: () {
                  onVerifyTap();
                },
                child: Text(
                  isCodeSent ? 'Verify Code' : 'Verify Phone Number',
                  style: TextStyle(color: Color(0xffffffff), fontSize: 16),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () => onVerifyTap,
            //   child: Text(isCodeSent ? 'Verify Code' : 'Verify Phone Number'),
            // )
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

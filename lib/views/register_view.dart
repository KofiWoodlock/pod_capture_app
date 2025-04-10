import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:testapp/utils/utils.dart';
import 'package:testapp/database/user.dart' as app_user; // User data model 
import 'package:testapp/database/database.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Declare controllers for the email and password text fields.
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/logo_fca1.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text("Register"),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Enter email here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                  hintText: 'Enter new password here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            onPressed: () async {
              _createAccount(email: _email, password: _password);
            },
            child: const Text(
              'Create Account',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              'Return to login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createAccount({required email, password}) async {
    final email = _email.text;
    final password = _password.text;

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      devtools.log(userCredential.toString());
      // Create record of user in account auth database if user does not already exists
      try {
        // Hash user password and get current date time to datestamp account creation
        final String passwordHash = SHA256.hash(password);
        devtools.log("Created hashed user password: $passwordHash");
        final DateTime createdAt = DateTime.now();

        // Create user data model object and insert arguments
        final app_user.User newUser = app_user.User(
          email: email,
          passwordHash: passwordHash,
          createdAt: createdAt.toString(),
        );
        // Insert user into the database if their account does not already exists
        final int? userId =
            await DatabaseService.instance.insertUserIfNotExists(newUser);
        // Check if user already exists depending on whether a new userId is generated
        if (userId != null) {
          devtools.log('Successfully added user to database, userId: $userId');
          DatabaseService.instance.logAllUsers();
        } else {
          devtools.log('User already exists in database');
        }
      } catch (dbError) {
        devtools.log('Database error: $dbError');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully created account!'),
          duration: Duration(milliseconds: 1000),
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
    } on FirebaseAuthException catch (e) {
      devtools.log(e.toString());
      if (e.code == 'weak-password') {
        devtools.log('Weak Password');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password must at least 6 characters'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        devtools.log('Email already in use');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email already in use'),
            duration: Duration(milliseconds: 800),
          ),
        );
      } else if (e.code == 'invalid-email') {
        devtools.log('Invalid Email');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email'),
            duration: Duration(milliseconds: 800),
          ),
        );
      } else if (e.code == 'channel-error') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error! Blank credentials"),
            duration: Duration(milliseconds: 800),
          ),
        );
      } else {
        devtools.log(e.toString());
      }
    }
  }
}

// Import the necessary packages for Firebase authentication and Flutter's Material Design widgets.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Frontend widgets package 
import 'package:testapp/database/database.dart';
import 'dart:developer' as devtools show log; // logging framework for debugging

import 'package:testapp/utils/utils.dart';

// Define a stateful widget for the login view.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

// Define the state class for the LoginView.
class _LoginViewState extends State<LoginView> {
  // Declare controllers for the email and password text fields.
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // Initialise the text controllers when the state is first created.
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the text controllers when the state is destroyed to free up resources.
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

// Main Code for page design (frontend)
  @override
  Widget build(BuildContext context) {
    // Build the UI for the login screen.
    return Scaffold(
      // App bar with the title 'Log in'.
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
              child: const Text("Login"),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // Column to arrange the UI elements vertically.
          children: [
            const SizedBox(
              height: 105,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      "Use a local account to log in",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Text field for the user to enter their email.
            TextField(
              controller: _email, // Bind the controller to this text field.
              enableSuggestions:
                  false, // Disable suggestions and autocorrect for email.
              autocorrect: false,
              keyboardType:
                  TextInputType.emailAddress, // Set keyboard type to email.
              decoration: const InputDecoration(
                hintText: 'Enter Email', // Placeholder text in the text field.
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all((Radius.circular(10))),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Text field for the user to enter their password.
            TextField(
              controller: _password, // Bind the controller to this text field.
              obscureText: true, // Obscure the text for password input.
              enableSuggestions:
                  false, // Disable suggestions and autocorrect for password.
              autocorrect: false,
              decoration: const InputDecoration(
                hintText:
                    'Enter Password', // Placeholder text in the text field.
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all((Radius.circular(10))),
                ),
              ),
            ),
            // Button to trigger the login process.
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: () async {
                  _login(email: _email, password: _password);
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ), // Text displayed on the button.
              ),
            ),
            // Button to navigate to the registration page.
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: () {
                  // When pressed, navigate to the registration page.
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/register', // Named route to RegistrationView.
                    (route) => false, // Remove all previous routes.
                  );
                },
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ), // Button text.
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/forgotPassword',
                    (route) => false,
                  );
                },
                child: const Text("Forgot Password?"))
          ],
        ),
      ),
    );
  }

  Future<void> _login({required email, password}) async {
    // When the button is pressed, retrieve the email and password from the text fields.
    final email = _email.text;
    final password = _password.text;
    // Authenticate user with database
    try {
      final passwordHash =
          await DatabaseService.instance.getUserPasswordHash(email);
      if (passwordHash != SHA256.hash(password)) {
        devtools.log("Incorrect password entered");
      } else {
        devtools.log("Correct password entered");
      }
    } catch (dbError) {
      devtools.log("Database error: $dbError");
    }
    try {
      // Attempt to sign in to firebase to allow access to cloud services.
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the currently signed-in user.
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if the user's email is verified.
        if (user.emailVerified) {
          // If email is verified, navigate to the home page.
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/homePage', // Named route to HomePageView.
            (route) => false, // Remove all previous routes.
          );
        } else {
          // If email is not verified, show a material banner message.
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: const Text('Please verify your email'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                  },
                  child: const Text('Send verification email'),
                ),
                TextButton(
                  onPressed:
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner,
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
      }
      devtools.log(
          userCredential.toString()); // Print user credentials for debugging.
    } on FirebaseAuthException catch (e) {
      // Handle errors during the login process.
      if (e.code == 'invalid-credential') {
        devtools.log('Incorrect email or password');
        devtools.log(e.code); // Print the error code for debugging.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect email or password.'),
          ),
        );
      }
      // Show a general error message if login fails.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Email/Password'),
          // Display the error message.
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }
}

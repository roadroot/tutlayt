import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: SizedBox(
          width: 350, // TODO place this in a yaml file
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Username'), // TODO i18n
                        prefixIcon: Icon(Icons.person)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Password'), // TODO i18n
                        prefixIcon: Icon(Icons.lock)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        visualDensity: VisualDensity.standard),
                    onPressed: () => null,
                    child: const Text('Login'), // TODO i18n
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You don't yet have an account?"), // TODO i18n
                    TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, 'registration'),
                        child: const Text('Sign Up')) // TODO i18n
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Forgot your password?"), // TODO i18n
                    TextButton(
                        onPressed: () => null,
                        child: const Text('Reset it')) // TODO i18n
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}

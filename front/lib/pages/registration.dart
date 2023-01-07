import 'package:flutter/material.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

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
                      label: Text('Email'), // TODO i18n
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.lock)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Password'), // TODO i18n
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (bool? value) {},
                    ),
                    const Flexible(
                      child: Text(
                        'By checking this box, you agree to our terms of service, privacy policy and cookie policy',
                      ),
                    ), // TODO i18n
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                child: ElevatedButton(
                  style:
                      const ButtonStyle(visualDensity: VisualDensity.standard),
                  onPressed: () => null, 
                  child: const Text('Signup'), // TODO i18n
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("You already have an account?"), // TODO i18n
                  TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, 'login'),// TODO
                      child: const Text('Login')) // TODO i18n
                ],
              ),
            ]),
      ),
    ));
  }
}

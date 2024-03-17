import 'package:formcapture/imports.dart';
import 'dart:developer' as devtools show log;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  bool showPassword = false;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        // Firebase.initializeApp(
        //   options: DefaultFirebaseOptions.currentPlatform,
        // ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      key: _formKey,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 230,
                        ),
                        const Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: TextFormField(
                            controller: _username,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Username*',
                              prefixIcon: Icon(
                                Icons.person_outline,
                              ),
                            ),
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                  return "Please enter your username";
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: TextFormField(
                            controller: _email,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email*',
                              prefixIcon: Icon(
                                Icons.email_outlined,
                              ),
                            ),
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                  return "Please enter your email";
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: TextFormField(
                            controller: _password,
                            obscureText: !showPassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                  return "Please enter your password";
                                }
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password*',
                              prefixIcon: const Icon(
                                Icons.lock_outlined,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                child: showPassword
                                    ? const Icon(
                                        Icons.visibility_off,
                                      )
                                    : const Icon(
                                        Icons.visibility,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 31, 31, 31),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () async {
                                final username = _username.text;
                                final email = _email.text;
                                final password = _password.text;
                                try {
                                  if (username.isNotEmpty &&
                                      email.isNotEmpty &&
                                      password.isNotEmpty) {
                                    final userCredential =
                                        await AuthService.firebase().createUser(
                                            email: email,
                                            password: password,
                                            username: username);

                                    await AuthService.firebase()
                                        .sendEmailVerification();
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const VerifyEmailPage(
                                          message:
                                              "We've sent you an email verification. Please check to verify your account.",
                                        );
                                      },
                                    );
                                  } else {
                                    await showErrorDialog(context,
                                        'Please fill in all the required fields.');
                                  }
                                } on EmailAlreadyInUseAuthException {
                                  await showErrorDialog(
                                      context, 'Email already in use.');
                                } on WeakPasswordAuthException {
                                  await showErrorDialog(context,
                                      'Weak password. Password should be at least 6 characters.');
                                } on InvalidEmailAuthException {
                                  await showErrorDialog(
                                      context, 'Invalid email entered.');
                                } on GenericAuthException {
                                  await showErrorDialog(
                                      context, 'Fail to register');
                                }
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 160,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogInPage()));
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 16),
                              children: const <TextSpan>[
                                TextSpan(
                                  text: 'Already have an account? ',
                                ),
                                TextSpan(
                                    text: 'Log in',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

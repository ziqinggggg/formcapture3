// login_page.dart

import 'package:formcapture/imports.dart';
import 'dart:developer' as devtools show log;

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // final _formKey = GlobalKey<FormState>();

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  bool showPassword = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool lightTheme = Theme.of(context).brightness == Brightness.light;
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
                      // key: _formKey,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 230,
                        ),
                        const Text(
                          'Welcome',
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
                            controller: _email,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
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
                              hintText: 'Password',
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
                                final email = _email.text;
                                final password = _password.text;
                                try {
                                  await AuthService.firebase()
                                      .logIn(email: email, password: password);

                                  final user =
                                      AuthService.firebase().currentUser;
                                  if (user?.isEmailVerified ?? false) {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           const NotesPage()),
                                    // );
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      '/notes/',
                                      (route) => false,
                                    );
                                  } else {
                                    await AuthService.firebase()
                                        .sendEmailVerification();
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const VerifyEmailPage(
                                            message:
                                                "Your email is not verified. We've sent you an email verification. Please check to verify your account.");
                                      },
                                    );
                                  }
                                  // }
                                } on UserNotFoundAuthException {
                                  await showErrorDialog(
                                      context, 'User not found.');
                                } on WrongPasswordAuthException {
                                  await showErrorDialog(
                                      context, 'Wrong password');
                                } on GenericAuthException {
                                  await showErrorDialog(
                                      context, 'Authentication error');
                                }
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: lightTheme
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade700,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: lightTheme
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: lightTheme
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade700,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              leading: Image.asset(
                                'assets/images/google.png',
                                height: 25,
                              ),
                              title: const Text('Continue with Google',
                                  style: TextStyle(fontSize: 16)),
                            )),
                        const SizedBox(
                          height: 105,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()));
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color:
                                      lightTheme ? Colors.black : Colors.white,
                                  fontSize: 16),
                              children: const <TextSpan>[
                                TextSpan(
                                  text: 'Don\'t have an account? ',
                                ),
                                TextSpan(
                                    text: 'Sign up',
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

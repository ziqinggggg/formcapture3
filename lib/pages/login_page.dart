import 'package:formcapture/pages.dart';
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
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () async {
                                final email = _email.text;
                                final password = _password.text;
                                try {
                                  final userCredential =
                                      await AuthService.firebase().logIn(
                                          email: email, password: password);
                                  // await FirebaseAuth
                                  //     .instance
                                  //     .signInWithEmailAndPassword(
                                  //         email: email, password: password);
                                  devtools.log(userCredential.toString());

                                  // final User? user = userCredential.user;
                                  final user =
                                      AuthService.firebase().currentUser;
                                  // if (user != null) {
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
                                    // await user.sendEmailVerification();
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
                                // on FirebaseAuthException catch (e) {
                                //   String errorMessage = 'An error occurred.';

                                //   if (e.code == 'user-not-found') {
                                //     errorMessage = 'User not found.';
                                //   } else if (e.code == 'wrong-password') {
                                //     errorMessage = 'Wrong password';
                                //   } else if (e.code == 'invalid-credential') {
                                //     errorMessage = 'Invalid credentials';
                                //   } else {
                                //     errorMessage = 'Error: ${e.code}';
                                //   }
                                //   await showErrorDialog(context, errorMessage);
                                // } catch (e) {
                                //   await showErrorDialog(context, e.toString());
                                // }
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black26,
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
                            text: const TextSpan(
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              children: <TextSpan>[
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

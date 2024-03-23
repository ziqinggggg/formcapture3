import 'package:formcapture/imports.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();

    super.initState();
  }

  bool showPassword = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _email.clear();
            await showResetPasswordSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              'Unable to reset password',
            );
          }
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 230,
                  ),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Enter your email address and we'll send you a password reset link.",
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 16),
                    textAlign: TextAlign.center,
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
                      autofocus: true,
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
                  const SizedBox(
                    height: 15,
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
                        context.read<AuthBloc>().add(
                              AuthEventForgotPassword(email: _email.text),
                            );
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventSignOut(),
                          );
                    },
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
